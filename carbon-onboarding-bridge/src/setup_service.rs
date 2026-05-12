use std::net::{IpAddr, SocketAddr};
use std::sync::{Arc, Mutex};
use tokio::net::TcpListener;
use tokio::sync::{broadcast, oneshot};
use tokio_stream::wrappers::ReceiverStream;
use tonic::{Request, Response, Status};

use crate::config_io;
use crate::proto::{
    setup_service_server::SetupService, setup_event::Kind as EventKind, SetupEvent,
    StartSetupRequest, StartSetupResponse, StopSetupRequest, StopSetupResponse, WatchSetupRequest,
};

const DEFAULT_PORT: u16 = 18181;
const MAX_PORT: u16 = 18200;
const BROADCAST_CAPACITY: usize = 16;

struct SetupState {
    abort_tx: Option<oneshot::Sender<()>>,
    url: Option<String>,
    last_event: Option<EventKind>,
    event_tx: broadcast::Sender<SetupEvent>,
}

pub struct SetupServiceImpl {
    state: Arc<Mutex<SetupState>>,
}

impl SetupServiceImpl {
    pub fn new() -> Self {
        let (event_tx, _) = broadcast::channel(BROADCAST_CAPACITY);
        Self {
            state: Arc::new(Mutex::new(SetupState {
                abort_tx: None,
                url: None,
                last_event: None,
                event_tx,
            })),
        }
    }
}

#[tonic::async_trait]
impl SetupService for SetupServiceImpl {
    type WatchSetupStream = ReceiverStream<Result<SetupEvent, Status>>;

    async fn start_setup(
        &self,
        request: Request<StartSetupRequest>,
    ) -> Result<Response<StartSetupResponse>, Status> {
        let preferred_port = {
            let p = request.into_inner().preferred_port;
            if p > 0 { p as u16 } else { DEFAULT_PORT }
        };

        // Return existing URL if already running
        {
            let state = self.state.lock().unwrap();
            if let Some(url) = &state.url {
                return Ok(Response::new(StartSetupResponse { url: url.clone() }));
            }
        }

        let listener = bind_port(preferred_port, MAX_PORT).await.map_err(|e| {
            Status::resource_exhausted(format!("no available port in {preferred_port}..{MAX_PORT}: {e}"))
        })?;

        let local_addr = listener.local_addr().map_err(|e| {
            Status::internal(format!("failed to get listener address: {e}"))
        })?;

        let lan_ip = detect_lan_ip().unwrap_or_else(|| "127.0.0.1".to_string());
        let url = format!("http://{}:{}/setup", lan_ip, local_addr.port());

        let (abort_tx, abort_rx) = oneshot::channel::<()>();
        let state_clone = self.state.clone();
        let url_clone = url.clone();

        tokio::spawn(async move {
            run_http_server(listener, state_clone, url_clone, abort_rx).await;
        });

        {
            let mut state = self.state.lock().unwrap();
            state.abort_tx = Some(abort_tx);
            state.url = Some(url.clone());
            state.last_event = None;
        }

        Ok(Response::new(StartSetupResponse { url }))
    }

    async fn stop_setup(
        &self,
        _request: Request<StopSetupRequest>,
    ) -> Result<Response<StopSetupResponse>, Status> {
        let event_tx = {
            let mut state = self.state.lock().unwrap();
            if let Some(tx) = state.abort_tx.take() {
                let _ = tx.send(());
            }
            state.url = None;
            state.last_event = Some(EventKind::Stopped);
            state.event_tx.clone()
        };

        let _ = event_tx.send(SetupEvent {
            kind: EventKind::Stopped as i32,
            url: String::new(),
        });

        Ok(Response::new(StopSetupResponse {}))
    }

    async fn watch_setup(
        &self,
        _request: Request<WatchSetupRequest>,
    ) -> Result<Response<Self::WatchSetupStream>, Status> {
        let (tx, rx) = tokio::sync::mpsc::channel(8);

        let mut event_rx = {
            let state = self.state.lock().unwrap();

            // Replay last event if already completed/stopped before subscription
            if let Some(kind) = state.last_event {
                let url = state.url.clone().unwrap_or_default();
                let tx_clone = tx.clone();
                let event = SetupEvent {
                    kind: kind as i32,
                    url,
                };
                tokio::spawn(async move {
                    let _ = tx_clone.send(Ok(event)).await;
                });
            }

            state.event_tx.subscribe()
        };

        tokio::spawn(async move {
            loop {
                match event_rx.recv().await {
                    Ok(event) => {
                        if tx.send(Ok(event)).await.is_err() {
                            break;
                        }
                    }
                    Err(broadcast::error::RecvError::Closed) => break,
                    Err(broadcast::error::RecvError::Lagged(_)) => continue,
                }
            }
        });

        Ok(Response::new(ReceiverStream::new(rx)))
    }
}

async fn bind_port(start: u16, end: u16) -> anyhow::Result<TcpListener> {
    for port in start..=end {
        let addr = SocketAddr::from(([0, 0, 0, 0], port));
        if let Ok(listener) = TcpListener::bind(addr).await {
            return Ok(listener);
        }
    }
    anyhow::bail!("all ports from {start} to {end} are in use")
}

fn detect_lan_ip() -> Option<String> {
    // Connect to a public address (no packet sent) to discover the local IP
    let socket = std::net::UdpSocket::bind("0.0.0.0:0").ok()?;
    socket.connect("8.8.8.8:80").ok()?;
    let addr = socket.local_addr().ok()?;
    let ip = addr.ip();
    if ip.is_loopback() || is_link_local(&ip) {
        return None;
    }
    Some(ip.to_string())
}

fn is_link_local(ip: &IpAddr) -> bool {
    match ip {
        IpAddr::V4(v4) => v4.octets()[0] == 169 && v4.octets()[1] == 254,
        IpAddr::V6(v6) => (v6.segments()[0] & 0xffc0) == 0xfe80,
    }
}

// ─── HTTP server ─────────────────────────────────────────────────────────────

async fn run_http_server(
    listener: TcpListener,
    state: Arc<Mutex<SetupState>>,
    url: String,
    mut abort_rx: oneshot::Receiver<()>,
) {
    loop {
        tokio::select! {
            _ = &mut abort_rx => break,
            result = listener.accept() => {
                match result {
                    Ok((stream, _)) => {
                        let state = state.clone();
                        let url = url.clone();
                        tokio::spawn(handle_connection(stream, state, url));
                    }
                    Err(_) => break,
                }
            }
        }
    }
}

async fn handle_connection(
    mut stream: tokio::net::TcpStream,
    state: Arc<Mutex<SetupState>>,
    url: String,
) {
    use tokio::io::{AsyncReadExt, AsyncWriteExt};

    let mut buf = vec![0u8; 32 * 1024];
    let n = match stream.read(&mut buf).await {
        Ok(n) if n > 0 => n,
        _ => return,
    };
    let request = String::from_utf8_lossy(&buf[..n]);
    let first_line = request.lines().next().unwrap_or("");

    // Parse method and path from "METHOD /path HTTP/1.x"
    let mut parts = first_line.splitn(3, ' ');
    let method = parts.next().unwrap_or("");
    let path   = parts.next().unwrap_or("/");

    let response = match (method, path) {
        ("GET", "/setup") => {
            let body = build_setup_page();
            http_response("200 OK", "text/html; charset=utf-8", &body)
        }
        ("GET", "/setup/saved") => {
            let body = build_result_page();
            http_response("200 OK", "text/html; charset=utf-8", &body)
        }
        ("POST", "/setup") => {
            let body_str = extract_body(&request);
            let fields = parse_form(body_str);

            let base_yaml = config_io::read_yaml()
                .unwrap_or_else(|_| config_io::default_config_template());

            match config_io::merge_fields(&base_yaml, &fields) {
                Ok(new_yaml) => match config_io::write_yaml(&new_yaml) {
                    Ok(()) => {
                        let event_tx = {
                            let mut st = state.lock().unwrap();
                            st.last_event = Some(EventKind::Completed);
                            st.event_tx.clone()
                        };
                        let _ = event_tx.send(SetupEvent {
                            kind: EventKind::Completed as i32,
                            url: url.clone(),
                        });
                        http_redirect("/setup/saved")
                    }
                    Err(e) => http_response(
                        "500 Internal Server Error",
                        "text/html; charset=utf-8",
                        &format!("<html><body><h2>Error saving config</h2><p>{e}</p></body></html>"),
                    ),
                },
                Err(e) => http_response(
                    "400 Bad Request",
                    "text/html; charset=utf-8",
                    &format!("<html><body><h2>Error merging config</h2><p>{e}</p></body></html>"),
                ),
            }
        }
        _ => http_response("405 Method Not Allowed", "text/plain", "Method Not Allowed"),
    };

    let _ = stream.write_all(response.as_bytes()).await;
}

fn http_response(status: &str, content_type: &str, body: &str) -> String {
    format!(
        "HTTP/1.1 {status}\r\nContent-Type: {content_type}\r\nContent-Length: {}\r\nConnection: close\r\nCache-Control: no-store\r\n\r\n{body}",
        body.len()
    )
}

fn http_redirect(location: &str) -> String {
    format!(
        "HTTP/1.1 303 See Other\r\nLocation: {location}\r\nContent-Length: 0\r\nConnection: close\r\n\r\n"
    )
}

fn extract_body(request: &str) -> &str {
    request.split_once("\r\n\r\n").map(|(_, b)| b).unwrap_or("")
}

fn parse_form(body: &str) -> Vec<(String, String)> {
    body.split('&')
        .filter_map(|pair| {
            let (k, v) = pair.split_once('=')?;
            Some((url_decode(k), url_decode(v)))
        })
        .collect()
}

fn url_decode(s: &str) -> String {
    let s = s.replace('+', " ");
    let mut out = String::new();
    let mut chars = s.chars().peekable();
    while let Some(c) = chars.next() {
        if c == '%' {
            let h1 = chars.next().and_then(|c| c.to_digit(16));
            let h2 = chars.next().and_then(|c| c.to_digit(16));
            if let (Some(h1), Some(h2)) = (h1, h2) {
                out.push(char::from(((h1 << 4) | h2) as u8));
            }
        } else {
            out.push(c);
        }
    }
    out
}

fn build_setup_page() -> String {
    let cfg = config_io::read_yaml()
        .ok()
        .and_then(|y| config_io::parse_config(&y).ok())
        .unwrap_or_default();

    let skill_dirs = cfg.extra_skill_dirs.join("\n");
    let a = &cfg.providers.anthropic;
    let g = &cfg.providers.gemini;
    let ws = &cfg.web_search;
    let o = &cfg.orchestration;

    let prov_gemini    = if cfg.defaults.provider == "gemini"    { "selected" } else { "" };
    let prov_anthropic = if cfg.defaults.provider == "anthropic" { "selected" } else { "" };
    let ws_brave       = if ws.backend == "brave"      { "selected" } else { "" };
    let ws_duckduckgo  = if ws.backend == "duckduckgo" { "selected" } else { "" };
    let cont_yes = if  o.continuation.enabled { "selected" } else { "" };
    let cont_no  = if !o.continuation.enabled { "selected" } else { "" };
    let narr_yes = if  o.narration.enabled    { "selected" } else { "" };
    let narr_no  = if !o.narration.enabled    { "selected" } else { "" };

    let page_title = "Carbon Setup";
    let page_desc  = "Set the Carbon agent defaults on the TV. The common path is Gemini API key and Brave API key only, but every value from the current config template is editable if needed.";

    format!(
        r#"<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Carbon Setup</title>
  <style>
    :root {{
      --bg0: #071319;
      --bg1: #10242b;
      --card: rgba(7, 21, 28, 0.84);
      --line: rgba(255,255,255,0.12);
      --text: #f4f7f8;
      --muted: rgba(244,247,248,0.68);
      --accent: #f5c15b;
      --accent-ink: #1e180b;
      --field: rgba(255,255,255,0.08);
    }}
    * {{ box-sizing: border-box; }}
    html, body {{ margin: 0; min-height: 100%; }}
    body {{
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      color: var(--text);
      background:
        radial-gradient(circle at top left, rgba(71,127,137,0.28), transparent 32%),
        linear-gradient(180deg, var(--bg1), var(--bg0));
    }}
    main {{ padding: 20px; }}
    .shell {{
      width: min(960px, 100%);
      margin: 0 auto;
      padding: 20px 0 36px;
    }}
    .hero {{
      padding: 24px;
      border-radius: 28px;
      background: linear-gradient(145deg, rgba(45,74,82,.95), rgba(10,23,29,.96));
      box-shadow: 0 24px 72px rgba(0,0,0,.32);
    }}
    h1 {{ margin: 0; font-size: clamp(32px, 9vw, 56px); letter-spacing: -.06em; }}
    .lead {{ margin: 10px 0 0; color: var(--muted); line-height: 1.6; }}
    form {{ margin-top: 18px; }}
    details {{
      margin-top: 14px;
      border: 1px solid var(--line);
      border-radius: 22px;
      background: var(--card);
      overflow: hidden;
    }}
    summary {{
      cursor: pointer;
      list-style: none;
      padding: 18px 20px;
      font-size: 18px;
      font-weight: 700;
    }}
    summary::-webkit-details-marker {{ display: none; }}
    .detail-body {{
      padding: 0 20px 20px;
      border-top: 1px solid var(--line);
    }}
    .grid {{
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
      gap: 16px;
      margin-top: 16px;
    }}
    .field {{ display: grid; gap: 8px; }}
    .field.full {{ grid-column: 1 / -1; }}
    label {{ font-size: 14px; font-weight: 700; color: rgba(255,255,255,.82); }}
    .hint {{ font-size: 12px; color: var(--muted); }}
    input, select, textarea, button {{
      width: 100%;
      border: 0;
      border-radius: 14px;
      font: inherit;
    }}
    input, select, textarea {{
      padding: 14px 15px;
      color: var(--text);
      background: var(--field);
      outline: 1px solid transparent;
    }}
    textarea {{ min-height: 120px; resize: vertical; }}
    input:focus, select:focus, textarea:focus {{ outline-color: rgba(245,193,91,.68); }}
    .sub-details {{
      margin-top: 16px;
      border-radius: 18px;
      background: rgba(255,255,255,.04);
    }}
    .compact-grid {{
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
      gap: 14px;
      margin-top: 16px;
    }}
    .actions {{
      position: sticky;
      bottom: 0;
      margin-top: 18px;
      padding-top: 16px;
      background: linear-gradient(180deg, rgba(7,19,25,0), rgba(7,19,25,1) 28%);
    }}
    button {{
      padding: 17px 18px;
      font-weight: 800;
      background: var(--accent);
      color: var(--accent-ink);
    }}
  </style>
</head>
<body>
  <main>
    <section class="shell">
      <section class="hero">
        <h1>{page_title}</h1>
        <p class="lead">{page_desc}</p>
        <form method="post" action="/setup">

          <details>
            <summary>General</summary>
            <div class="detail-body">
              <div class="grid">
                <div class="field">
                  <label>defaults.provider</label>
                  <select name="defaults.provider">
                    <option value="gemini" {prov_gemini}>gemini</option>
                    <option value="anthropic" {prov_anthropic}>anthropic</option>
                  </select>
                  <span class="hint">Carbon default provider.</span>
                </div>
                <div class="field">
                  <label>defaults.model</label>
                  <input name="defaults.model" value="{model}">
                  <span class="hint">heavy, light, tiny, or an explicit model id.</span>
                </div>
                <div class="field full">
                  <label>extra_skill_dirs</label>
                  <textarea name="extra_skill_dirs" placeholder="one path per line">{skill_dirs}</textarea>
                  <span class="hint">One path per line. Leave empty to keep [].</span>
                </div>
              </div>
            </div>
          </details>

          <details open>
            <summary>providers</summary>
            <div class="detail-body">
              <details class="sub-details">
                <summary>providers.anthropic</summary>
                <div class="detail-body">
                  <div class="grid">
                    <div class="field">
                      <label>providers.anthropic.api_key</label>
                      <input name="providers.anthropic.api_key" type="password" value="{ant_key}" autocomplete="off" spellcheck="false">
                      <span class="hint">Optional. Leave empty unless Anthropic is used.</span>
                    </div>
                    <div class="field">
                      <label>providers.anthropic.oauth_token</label>
                      <input name="providers.anthropic.oauth_token" type="password" value="{ant_oauth}" autocomplete="off" spellcheck="false">
                      <span class="hint">Optional Claude OAuth token.</span>
                    </div>
                    <div class="field">
                      <label>providers.anthropic.base_url</label>
                      <input name="providers.anthropic.base_url" value="{ant_base}">
                      <span class="hint">Kept from the template by default.</span>
                    </div>
                  </div>
                </div>
              </details>
              <details class="sub-details" open>
                <summary>providers.gemini</summary>
                <div class="detail-body">
                  <div class="grid">
                    <div class="field">
                      <label>providers.gemini.api_key</label>
                      <input name="providers.gemini.api_key" type="password" value="{gem_key}" autocomplete="off" spellcheck="false">
                      <span class="hint">Primary user input in the common flow.</span>
                    </div>
                    <div class="field">
                      <label>providers.gemini.base_url</label>
                      <input name="providers.gemini.base_url" value="{gem_base}">
                      <span class="hint">Template default kept unless a proxy or alternate endpoint is required.</span>
                    </div>
                    <div class="field">
                      <label>providers.gemini.min_output_tokens</label>
                      <input name="providers.gemini.min_output_tokens" type="number" value="{gem_min_tok}">
                      <span class="hint">Template default is usually fine.</span>
                    </div>
                  </div>
                </div>
              </details>
            </div>
          </details>

          <details open>
            <summary>web_search</summary>
            <div class="detail-body">
              <div class="grid">
                <div class="field">
                  <label>web_search.backend</label>
                  <select name="web_search.backend">
                    <option value="brave" {ws_brave}>brave</option>
                    <option value="duckduckgo" {ws_duckduckgo}>duckduckgo</option>
                  </select>
                  <span class="hint">Current template uses brave.</span>
                </div>
                <div class="field">
                  <label>web_search.brave.api_key</label>
                  <input name="web_search.brave.api_key" type="password" value="{brave_key}" autocomplete="off" spellcheck="false">
                  <span class="hint">Primary user input in the common flow.</span>
                </div>
              </div>
            </div>
          </details>

          <details>
            <summary>orchestration</summary>
            <div class="detail-body">
              <div class="compact-grid">
                <div class="field">
                  <label>session.max_session_turns</label>
                  <input name="orchestration.session.max_session_turns" type="number" value="{sess_turns}">
                </div>
                <div class="field">
                  <label>session.max_thread_turns</label>
                  <input name="orchestration.session.max_thread_turns" type="number" value="{thread_turns}">
                </div>
                <div class="field">
                  <label>spawn.max_turns</label>
                  <input name="orchestration.spawn.max_turns" type="number" value="{spawn_turns}">
                </div>
                <div class="field">
                  <label>spawn.max_depth</label>
                  <input name="orchestration.spawn.max_depth" type="number" value="{spawn_depth}">
                </div>
                <div class="field">
                  <label>spawn.max_children</label>
                  <input name="orchestration.spawn.max_children" type="number" value="{spawn_children}">
                </div>
                <div class="field">
                  <label>sub_agent.max_turns</label>
                  <input name="orchestration.sub_agent.max_turns" type="number" value="{sub_turns}">
                </div>
                <div class="field">
                  <label>daemon.max_depth</label>
                  <input name="orchestration.daemon.max_depth" type="number" value="{daemon_depth}">
                </div>
                <div class="field">
                  <label>daemon.max_children</label>
                  <input name="orchestration.daemon.max_children" type="number" value="{daemon_children}">
                </div>
                <div class="field">
                  <label>daemon.max_total_agents</label>
                  <input name="orchestration.daemon.max_total_agents" type="number" value="{daemon_agents}">
                </div>
                <div class="field">
                  <label>daemon.mailbox_policy</label>
                  <input name="orchestration.daemon.mailbox_policy" value="{mailbox}">
                </div>
                <div class="field">
                  <label>continuation.enabled</label>
                  <select name="orchestration.continuation.enabled">
                    <option value="true" {cont_yes}>true</option>
                    <option value="false" {cont_no}>false</option>
                  </select>
                </div>
                <div class="field">
                  <label>narration.enabled</label>
                  <select name="orchestration.narration.enabled">
                    <option value="true" {narr_yes}>true</option>
                    <option value="false" {narr_no}>false</option>
                  </select>
                </div>
                <div class="field">
                  <label>controller.max_model_rounds</label>
                  <input name="orchestration.controller.max_model_rounds" type="number" value="{ctrl_rounds}">
                </div>
                <div class="field">
                  <label>controller.max_continuation_depth</label>
                  <input name="orchestration.controller.max_continuation_depth" type="number" value="{ctrl_cont_depth}">
                </div>
                <div class="field">
                  <label>controller.max_unresolved_retries</label>
                  <input name="orchestration.controller.max_unresolved_retries" type="number" value="{ctrl_retries}">
                </div>
                <div class="field">
                  <label>compaction.threshold</label>
                  <input name="orchestration.compaction.threshold" type="number" step="0.01" value="{compact_thresh}">
                </div>
                <div class="field">
                  <label>compaction.keep_recent_messages</label>
                  <input name="orchestration.compaction.keep_recent_messages" type="number" value="{compact_keep}">
                </div>
                <div class="field">
                  <label>compaction.max_summary_input_chars</label>
                  <input name="orchestration.compaction.max_summary_input_chars" type="number" value="{compact_chars}">
                </div>
                <div class="field">
                  <label>compaction.summary_max_tokens</label>
                  <input name="orchestration.compaction.summary_max_tokens" type="number" value="{compact_tokens}">
                </div>
              </div>
            </div>
          </details>

          <div class="actions">
            <button type="submit">Save Config And Restart Carbon</button>
          </div>

        </form>
      </section>
    </section>
  </main>
</body>
</html>"#,
        model = cfg.defaults.model,
        skill_dirs = skill_dirs,
        prov_gemini = prov_gemini,
        prov_anthropic = prov_anthropic,
        ant_key = a.api_key,
        ant_oauth = a.oauth_token,
        ant_base = a.base_url,
        gem_key = g.api_key,
        gem_base = g.base_url,
        gem_min_tok = g.min_output_tokens,
        ws_brave = ws_brave,
        ws_duckduckgo = ws_duckduckgo,
        brave_key = ws.brave.api_key,
        sess_turns = o.session.max_session_turns,
        thread_turns = o.session.max_thread_turns,
        spawn_turns = o.spawn.max_turns,
        spawn_depth = o.spawn.max_depth,
        spawn_children = o.spawn.max_children,
        sub_turns = o.sub_agent.max_turns,
        daemon_depth = o.daemon.max_depth,
        daemon_children = o.daemon.max_children,
        daemon_agents = o.daemon.max_total_agents,
        mailbox = o.daemon.mailbox_policy,
        cont_yes = cont_yes,
        cont_no = cont_no,
        narr_yes = narr_yes,
        narr_no = narr_no,
        ctrl_rounds = o.controller.max_model_rounds,
        ctrl_cont_depth = o.controller.max_continuation_depth,
        ctrl_retries = o.controller.max_unresolved_retries,
        compact_thresh = o.compaction.threshold,
        compact_keep = o.compaction.keep_recent_messages,
        compact_chars = o.compaction.max_summary_input_chars,
        compact_tokens = o.compaction.summary_max_tokens,
        page_title = page_title,
        page_desc  = page_desc,
    )
}

fn build_result_page() -> String {
    r#"<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Carbon Setup — Saved</title>
  <style>
    body { font-family: sans-serif; max-width: 480px; margin: 40px auto; padding: 0 16px; color: #f4f7f8; background: #071319; }
    h1 { color: #f5c15b; }
    a { color: #f5c15b; }
  </style>
</head>
<body>
  <h1>설정이 저장되었습니다</h1>
  <p><a href="/setup">돌아가기</a></p>
</body>
</html>"#.to_string()
}
