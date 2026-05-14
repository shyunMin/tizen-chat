import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'onboarding_grpc_service.dart';

class SetupHttpServer {
  static const _defaultPort = 18181;
  static const _maxPort = 18200;
  static const idleTimeout = Duration(minutes: 10);
  static const _closeDelay = Duration(seconds: 10);

  HttpServer? _server;
  String? _url;
  void Function()? _onCompleted;
  void Function()? _onTimeout;
  Timer? _idleTimer;
  Timer? _closeTimer;

  String? get url => _url;

  Future<String> start(
    OnboardingGrpcService grpc, {
    int preferredPort = _defaultPort,
    required void Function() onCompleted,
    required void Function() onTimeout,
  }) async {
    _onCompleted = onCompleted;
    _onTimeout = onTimeout;

    if (_server != null) {
      // Restarted while server is alive (e.g. close delay pending after save,
      // or new QR screen opened). Cancel the close timer to extend the lifetime,
      // then reset the idle countdown.
      _closeTimer?.cancel();
      _closeTimer = null;
      _resetIdleTimer();
      return _url!;
    }

    HttpServer? server;
    int boundPort = preferredPort;
    for (int port = preferredPort; port <= _maxPort; port++) {
      try {
        server = await HttpServer.bind(InternetAddress.anyIPv4, port);
        boundPort = port;
        break;
      } catch (_) {}
    }
    if (server == null) {
      throw Exception('no available port in $preferredPort..$_maxPort');
    }

    final lanIp = await _detectLanIp() ?? '127.0.0.1';
    _url = 'http://$lanIp:$boundPort/setup';
    _server = server;

    debugPrint('[SetupHttpServer] listening on $_url');
    server.listen((req) => _handleRequest(req, grpc));
    _resetIdleTimer();
    return _url!;
  }

  void _resetIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(idleTimeout, () {
      _idleTimer = null;
      final cb = _onTimeout;
      if (cb != null) Future(cb);
    });
  }

  Future<void> stop() async {
    _idleTimer?.cancel();
    _idleTimer = null;
    _closeTimer?.cancel();
    _closeTimer = null;
    await _server?.close(force: true);
    _server = null;
    _url = null;
    _onCompleted = null;
    _onTimeout = null;
    debugPrint('[SetupHttpServer] stopped');
  }

  Future<void> _handleRequest(HttpRequest req, OnboardingGrpcService grpc) async {
    final path = req.uri.path;
    final method = req.method;

    try {
      if (method == 'GET' && path == '/setup') {
        final saved = req.uri.queryParameters['status'] == 'saved';
        final yaml = await grpc.getConfigYaml();
        _respond(req, 200, 'text/html; charset=utf-8', buildSetupPage(yaml, saved: saved));
      } else if (method == 'POST' && path == '/setup') {
        final body = await _readBody(req);
        final fields = _parseForm(body);
        final currentYaml = await grpc.getConfigYaml();
        final newYaml = mergeFields(currentYaml, fields);
        final result = await grpc.setConfig(newYaml);
        if (result.success) {
          // Cancel idle timer — user interaction done.
          _idleTimer?.cancel();
          _idleTimer = null;
          req.response
            ..statusCode = 303
            ..headers.set('Location', '/setup?status=saved')
            ..headers.set('Content-Length', '0')
            ..headers.set('Connection', 'close');
          await req.response.close();
          // Schedule on Flutter's event loop — calling Navigator.pop() directly
          // from an HTTP handler callback won't reach the widget tree.
          final cb = _onCompleted;
          if (cb != null) Future(cb);
          // The server stays alive for _closeDelay so the browser can load
          // /setup/saved. A new start() call during this window cancels the
          // timer and extends the server lifetime.
          _closeTimer?.cancel();
          _closeTimer = Timer(_closeDelay, () async {
            _closeTimer = null;
            await _server?.close(force: true);
            _server = null;
            _url = null;
            debugPrint('[SetupHttpServer] auto-closed after save');
          });
        } else {
          _respond(req, 500, 'text/plain', 'Error: ${result.message}');
        }
      } else {
        _respond(req, 405, 'text/plain', 'Method Not Allowed');
      }
    } catch (e) {
      debugPrint('[SetupHttpServer] request error: $e');
      try {
        _respond(req, 500, 'text/plain', 'Internal server error');
      } catch (_) {}
    }
  }

  void _respond(HttpRequest req, int status, String contentType, String body) {
    final bytes = utf8.encode(body);
    req.response
      ..statusCode = status
      ..headers.set('Content-Type', contentType)
      ..headers.set('Content-Length', bytes.length.toString())
      ..headers.set('Connection', 'close')
      ..headers.set('Cache-Control', 'no-store')
      ..add(bytes);
    req.response.close();
  }

  Future<String> _readBody(HttpRequest req) async {
    final bytes = await req.fold<List<int>>([], (acc, chunk) => acc..addAll(chunk));
    return utf8.decode(bytes);
  }

  Map<String, String> _parseForm(String body) {
    final result = <String, String>{};
    for (final pair in body.split('&')) {
      final idx = pair.indexOf('=');
      if (idx < 0) continue;
      result[Uri.decodeQueryComponent(pair.substring(0, idx))] =
          Uri.decodeQueryComponent(pair.substring(idx + 1));
    }
    return result;
  }

  static Future<String?> _detectLanIp() async {
    try {
      final interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          if (!addr.isLoopback && !addr.address.startsWith('169.254')) {
            return addr.address;
          }
        }
      }
    } catch (_) {}
    return null;
  }
}

// ─── YAML merge ──────────────────────────────────────────────────────────────

String mergeFields(String baseYaml, Map<String, String> fields) {
  var text = baseYaml;
  final serdeNeeded = <String, String>{};

  fields.forEach((key, value) {
    if (key == 'extra_skill_dirs') {
      final dirs = value.split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
      text = _replaceSkillDirsInline(text, dirs);
    } else if (_pathExists(text, key)) {
      text = _replaceScalar(text, key, value);
    } else if (!_isBlankDefault(value)) {
      serdeNeeded[key] = value;
    }
  });

  // New keys not in the file: insert via simple append into mapping
  if (serdeNeeded.isNotEmpty) {
    text = _insertNewKeys(text, serdeNeeded);
  }
  return text;
}

bool _isBlankDefault(String v) {
  final t = v.trim();
  return t.isEmpty || t == '0' || t == '0.0' || t == 'false';
}

bool _pathExists(String yaml, String dotPath) {
  final keyStack = <String>[];
  for (final line in yaml.split('\n')) {
    final trimmed = line.trimLeft();
    if (trimmed.isEmpty || trimmed.startsWith('#') || trimmed.startsWith('- ')) continue;
    final indent = line.length - trimmed.length;
    final depth = indent ~/ 2;
    final colonIdx = trimmed.indexOf(':');
    if (colonIdx < 0) continue;
    final key = trimmed.substring(0, colonIdx).trim();
    final after = trimmed.substring(colonIdx + 1).trim();
    if (keyStack.length > depth) keyStack.removeRange(depth, keyStack.length);
    if ([...keyStack, key].join('.') == dotPath) return true;
    if (after.isEmpty || after.startsWith('#')) {
      if (keyStack.length == depth) keyStack.add(key);
    }
  }
  return false;
}

String _replaceScalar(String yaml, String dotPath, String newValue) {
  final lines = yaml.split('\n');
  final result = <String>[];
  final keyStack = <String>[];
  var replaced = false;

  for (final line in lines) {
    if (replaced) {
      result.add(line);
      continue;
    }
    final trimmed = line.trimLeft();
    if (trimmed.isEmpty || trimmed.startsWith('#') || trimmed.startsWith('- ')) {
      result.add(line);
      continue;
    }
    final indent = line.length - trimmed.length;
    final depth = indent ~/ 2;
    final colonIdx = trimmed.indexOf(':');
    if (colonIdx < 0) {
      result.add(line);
      continue;
    }
    final key = trimmed.substring(0, colonIdx).trim();
    final after = trimmed.substring(colonIdx + 1).trim();
    if (keyStack.length > depth) keyStack.removeRange(depth, keyStack.length);
    if ([...keyStack, key].join('.') == dotPath) {
      result.add('${' ' * indent}$key: ${_formatScalar(newValue)}');
      replaced = true;
      continue;
    }
    if (after.isEmpty || after.startsWith('#')) {
      if (keyStack.length == depth) keyStack.add(key);
    }
    result.add(line);
  }
  return result.join('\n');
}

String _formatScalar(String value) {
  if (value == 'true' || value == 'false') return value;
  final asInt = int.tryParse(value);
  if (asInt != null) return asInt.toString();
  final asDouble = double.tryParse(value);
  if (asDouble != null) return value;
  if (value.isEmpty) return '""';
  return value;
}

String _replaceSkillDirsInline(String yaml, List<String> dirs) {
  final inline = dirs.isEmpty ? '[]' : '[${dirs.join(', ')}]';
  final lines = yaml.split('\n');
  final result = <String>[];
  var skipBlock = false;

  for (final line in lines) {
    final trimmed = line.trimLeft();
    if (skipBlock) {
      if (trimmed.startsWith('- ') || trimmed == '-') continue;
      skipBlock = false;
    }
    if (line.trimLeft() == line && trimmed.startsWith('extra_skill_dirs:')) {
      final after = trimmed.substring('extra_skill_dirs:'.length).trim();
      if (after.isEmpty) skipBlock = true;
      result.add('extra_skill_dirs: $inline');
      continue;
    }
    result.add(line);
  }
  return result.join('\n');
}

String _insertNewKeys(String yaml, Map<String, String> fields) {
  // For new keys, find the parent section and append the leaf key.
  // Fallback: just append to end of file.
  var text = yaml;
  fields.forEach((dotPath, value) {
    final parts = dotPath.split('.');
    if (parts.length == 1) {
      text = '${text.trimRight()}\n$dotPath: ${_formatScalar(value)}\n';
      return;
    }
    // Find last occurrence of parent section and append after it
    final parent = parts.sublist(0, parts.length - 1).join('.');
    final leaf = parts.last;
    final indent = '  ' * (parts.length - 1);
    if (_pathExists(text, parent)) {
      // Insert after the parent's last child
      text = _insertAfterSection(text, parent, '$indent$leaf: ${_formatScalar(value)}');
    } else {
      text = '${text.trimRight()}\n$dotPath: ${_formatScalar(value)}\n';
    }
  });
  return text;
}

String _insertAfterSection(String yaml, String parentPath, String newLine) {
  final parts = parentPath.split('.');
  final lines = yaml.split('\n');
  final result = <String>[];
  final keyStack = <String>[];
  var insertIdx = -1;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final trimmed = line.trimLeft();
    if (trimmed.isEmpty || trimmed.startsWith('#') || trimmed.startsWith('- ')) {
      result.add(line);
      continue;
    }
    final indent = line.length - trimmed.length;
    final depth = indent ~/ 2;
    final colonIdx = trimmed.indexOf(':');
    if (colonIdx < 0) {
      result.add(line);
      continue;
    }
    final key = trimmed.substring(0, colonIdx).trim();
    final after = trimmed.substring(colonIdx + 1).trim();
    if (keyStack.length > depth) keyStack.removeRange(depth, keyStack.length);
    if ([...keyStack, key].join('.') == parentPath) {
      insertIdx = i;
    }
    if (after.isEmpty || after.startsWith('#')) {
      if (keyStack.length == depth) keyStack.add(key);
    }
    result.add(line);
  }

  if (insertIdx >= 0) {
    // Insert after the last line belonging to this section
    var end = insertIdx + 1;
    final parentDepth = parts.length;
    while (end < result.length) {
      final l = result[end];
      final t = l.trimLeft();
      if (t.isEmpty || t.startsWith('#')) {
        end++;
        continue;
      }
      final d = (l.length - t.length) ~/ 2;
      if (d <= parentDepth) break;
      end++;
    }
    result.insert(end, newLine);
  } else {
    result.add(newLine);
  }
  return result.join('\n');
}

// ─── YAML value reader ───────────────────────────────────────────────────────

String getYamlValue(String yaml, String dotPath) {
  final keyStack = <String>[];
  for (final line in yaml.split('\n')) {
    final trimmed = line.trimLeft();
    if (trimmed.isEmpty || trimmed.startsWith('#') || trimmed.startsWith('- ')) continue;
    final indent = line.length - trimmed.length;
    final depth = indent ~/ 2;
    final colonIdx = trimmed.indexOf(':');
    if (colonIdx < 0) continue;
    final key = trimmed.substring(0, colonIdx).trim();
    final after = trimmed.substring(colonIdx + 1).trim();
    if (keyStack.length > depth) keyStack.removeRange(depth, keyStack.length);
    if ([...keyStack, key].join('.') == dotPath) {
      if (after.isNotEmpty && !after.startsWith('#')) {
        return after.replaceAll('"', '').replaceAll("'", '');
      }
      return '';
    }
    if (after.isEmpty || after.startsWith('#')) {
      if (keyStack.length == depth) keyStack.add(key);
    }
  }
  return '';
}

// ─── HTML pages ──────────────────────────────────────────────────────────────

String buildSetupPage(String yaml, {bool saved = false}) {
  String v(String path) => getYamlValue(yaml, path);

  final provGemini    = v('defaults.provider') == 'gemini'    ? 'selected' : '';
  final provAnthropic = v('defaults.provider') == 'anthropic' ? 'selected' : '';
  final wsBrave       = v('web_search.backend') == 'brave'      ? 'selected' : '';
  final wsDuckduckgo  = v('web_search.backend') == 'duckduckgo' ? 'selected' : '';
  final contYes = v('orchestration.continuation.enabled') == 'true'  ? 'selected' : '';
  final contNo  = v('orchestration.continuation.enabled') != 'true'  ? 'selected' : '';
  final narrYes = v('orchestration.narration.enabled') == 'true'     ? 'selected' : '';
  final narrNo  = v('orchestration.narration.enabled') != 'true'     ? 'selected' : '';

  final skillDirs = yaml
      .split('\n')
      .skipWhile((l) => !l.startsWith('extra_skill_dirs:'))
      .skip(1)
      .takeWhile((l) => l.trimLeft().startsWith('- '))
      .map((l) => l.trimLeft().replaceFirst('- ', ''))
      .join('\n');

  return '''<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Carbon Setup</title>
  <style>
    :root {
      --bg0: #071319; --bg1: #10242b; --card: rgba(7,21,28,.84);
      --line: rgba(255,255,255,.12); --text: #f4f7f8;
      --muted: rgba(244,247,248,.68); --accent: #f5c15b;
      --accent-ink: #1e180b; --field: rgba(255,255,255,.08);
    }
    * { box-sizing: border-box; }
    html,body { margin: 0; min-height: 100%; }
    body {
      font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;
      color: var(--text);
      background: radial-gradient(circle at top left,rgba(71,127,137,.28),transparent 32%),
                  linear-gradient(180deg,var(--bg1),var(--bg0));
    }
    main { padding: 20px; }
    .shell { width: min(960px,100%); margin: 0 auto; padding: 20px 0 36px; }
    .hero {
      padding: 24px; border-radius: 28px;
      background: linear-gradient(145deg,rgba(45,74,82,.95),rgba(10,23,29,.96));
      box-shadow: 0 24px 72px rgba(0,0,0,.32);
    }
    h1 { margin: 0; font-size: clamp(32px,9vw,56px); letter-spacing: -.06em; }
    .lead { margin: 10px 0 0; color: var(--muted); line-height: 1.6; }
    form { margin-top: 18px; }
    details { margin-top: 14px; border: 1px solid var(--line); border-radius: 22px; background: var(--card); overflow: hidden; }
    summary { cursor: pointer; list-style: none; padding: 18px 20px; font-size: 18px; font-weight: 700; }
    summary::-webkit-details-marker { display: none; }
    .detail-body { padding: 0 20px 20px; border-top: 1px solid var(--line); }
    .grid { display: grid; grid-template-columns: repeat(auto-fit,minmax(220px,1fr)); gap: 16px; margin-top: 16px; }
    .field { display: grid; gap: 8px; }
    .field.full { grid-column: 1/-1; }
    label { font-size: 14px; font-weight: 700; color: rgba(255,255,255,.82); }
    .hint { font-size: 12px; color: var(--muted); }
    input,select,textarea,button { width: 100%; border: 0; border-radius: 14px; font: inherit; }
    input,select,textarea { padding: 14px 15px; color: var(--text); background: var(--field); outline: 1px solid transparent; }
    textarea { min-height: 120px; resize: vertical; }
    input:focus,select:focus,textarea:focus { outline-color: rgba(245,193,91,.68); }
    .sub-details { margin-top: 16px; border-radius: 18px; background: rgba(255,255,255,.04); }
    .compact-grid { display: grid; grid-template-columns: repeat(auto-fit,minmax(180px,1fr)); gap: 14px; margin-top: 16px; }
    .actions { position: sticky; bottom: 0; margin-top: 18px; padding-top: 16px; background: linear-gradient(180deg,rgba(7,19,25,0),rgba(7,19,25,1) 28%); }
    button { padding: 17px 18px; font-weight: 800; background: var(--accent); color: var(--accent-ink); }
    .saved-msg { margin: 12px 0 0; color: #4caf50; font-weight: 600; text-align: center; font-size: 15px; }
  </style>
</head>
<body>
  <main><section class="shell"><section class="hero">
    <h1>Carbon Setup</h1>
    <p class="lead">Set the Carbon agent defaults on the TV.</p>
    <form method="post" action="/setup">

      <details>
        <summary>General</summary>
        <div class="detail-body"><div class="grid">
          <div class="field">
            <label>defaults.provider</label>
            <select name="defaults.provider">
              <option value="gemini" $provGemini>gemini</option>
              <option value="anthropic" $provAnthropic>anthropic</option>
            </select>
          </div>
          <div class="field">
            <label>defaults.model</label>
            <input name="defaults.model" value="${v('defaults.model')}">
            <span class="hint">heavy, light, tiny, or an explicit model id.</span>
          </div>
          <div class="field full">
            <label>extra_skill_dirs</label>
            <textarea name="extra_skill_dirs" placeholder="one path per line">$skillDirs</textarea>
            <span class="hint">One path per line.</span>
          </div>
        </div></div>
      </details>

      <details open>
        <summary>providers</summary>
        <div class="detail-body">
          <details class="sub-details">
            <summary>providers.anthropic</summary>
            <div class="detail-body"><div class="grid">
              <div class="field">
                <label>providers.anthropic.api_key</label>
                <input name="providers.anthropic.api_key" type="password" value="${v('providers.anthropic.api_key')}" autocomplete="off" spellcheck="false">
              </div>
              <div class="field">
                <label>providers.anthropic.oauth_token</label>
                <input name="providers.anthropic.oauth_token" type="password" value="${v('providers.anthropic.oauth_token')}" autocomplete="off" spellcheck="false">
              </div>
              <div class="field">
                <label>providers.anthropic.base_url</label>
                <input name="providers.anthropic.base_url" value="${v('providers.anthropic.base_url')}">
              </div>
            </div></div>
          </details>
          <details class="sub-details" open>
            <summary>providers.gemini</summary>
            <div class="detail-body"><div class="grid">
              <div class="field">
                <label>providers.gemini.api_key</label>
                <input name="providers.gemini.api_key" type="password" value="${v('providers.gemini.api_key')}" autocomplete="off" spellcheck="false">
                <span class="hint">Primary input in the common flow.</span>
              </div>
              <div class="field">
                <label>providers.gemini.base_url</label>
                <input name="providers.gemini.base_url" value="${v('providers.gemini.base_url')}">
              </div>
              <div class="field">
                <label>providers.gemini.min_output_tokens</label>
                <input name="providers.gemini.min_output_tokens" type="number" value="${v('providers.gemini.min_output_tokens')}">
              </div>
            </div></div>
          </details>
        </div>
      </details>

      <details open>
        <summary>web_search</summary>
        <div class="detail-body"><div class="grid">
          <div class="field">
            <label>web_search.backend</label>
            <select name="web_search.backend">
              <option value="brave" $wsBrave>brave</option>
              <option value="duckduckgo" $wsDuckduckgo>duckduckgo</option>
            </select>
          </div>
          <div class="field">
            <label>web_search.brave.api_key</label>
            <input name="web_search.brave.api_key" type="password" value="${v('web_search.brave.api_key')}" autocomplete="off" spellcheck="false">
            <span class="hint">Primary input in the common flow.</span>
          </div>
        </div></div>
      </details>

      <details>
        <summary>orchestration</summary>
        <div class="detail-body"><div class="compact-grid">
          <div class="field"><label>session.max_session_turns</label><input name="orchestration.session.max_session_turns" type="number" value="${v('orchestration.session.max_session_turns')}"></div>
          <div class="field"><label>session.max_thread_turns</label><input name="orchestration.session.max_thread_turns" type="number" value="${v('orchestration.session.max_thread_turns')}"></div>
          <div class="field"><label>spawn.max_turns</label><input name="orchestration.spawn.max_turns" type="number" value="${v('orchestration.spawn.max_turns')}"></div>
          <div class="field"><label>spawn.max_depth</label><input name="orchestration.spawn.max_depth" type="number" value="${v('orchestration.spawn.max_depth')}"></div>
          <div class="field"><label>spawn.max_children</label><input name="orchestration.spawn.max_children" type="number" value="${v('orchestration.spawn.max_children')}"></div>
          <div class="field"><label>sub_agent.max_turns</label><input name="orchestration.sub_agent.max_turns" type="number" value="${v('orchestration.sub_agent.max_turns')}"></div>
          <div class="field"><label>daemon.max_depth</label><input name="orchestration.daemon.max_depth" type="number" value="${v('orchestration.daemon.max_depth')}"></div>
          <div class="field"><label>daemon.max_children</label><input name="orchestration.daemon.max_children" type="number" value="${v('orchestration.daemon.max_children')}"></div>
          <div class="field"><label>daemon.max_total_agents</label><input name="orchestration.daemon.max_total_agents" type="number" value="${v('orchestration.daemon.max_total_agents')}"></div>
          <div class="field"><label>daemon.mailbox_policy</label><input name="orchestration.daemon.mailbox_policy" value="${v('orchestration.daemon.mailbox_policy')}"></div>
          <div class="field"><label>continuation.enabled</label>
            <select name="orchestration.continuation.enabled">
              <option value="true" $contYes>true</option>
              <option value="false" $contNo>false</option>
            </select>
          </div>
          <div class="field"><label>narration.enabled</label>
            <select name="orchestration.narration.enabled">
              <option value="true" $narrYes>true</option>
              <option value="false" $narrNo>false</option>
            </select>
          </div>
          <div class="field"><label>controller.max_model_rounds</label><input name="orchestration.controller.max_model_rounds" type="number" value="${v('orchestration.controller.max_model_rounds')}"></div>
          <div class="field"><label>controller.max_continuation_depth</label><input name="orchestration.controller.max_continuation_depth" type="number" value="${v('orchestration.controller.max_continuation_depth')}"></div>
          <div class="field"><label>controller.max_unresolved_retries</label><input name="orchestration.controller.max_unresolved_retries" type="number" value="${v('orchestration.controller.max_unresolved_retries')}"></div>
          <div class="field"><label>compaction.threshold</label><input name="orchestration.compaction.threshold" type="number" step="0.01" value="${v('orchestration.compaction.threshold')}"></div>
          <div class="field"><label>compaction.keep_recent_messages</label><input name="orchestration.compaction.keep_recent_messages" type="number" value="${v('orchestration.compaction.keep_recent_messages')}"></div>
          <div class="field"><label>compaction.max_summary_input_chars</label><input name="orchestration.compaction.max_summary_input_chars" type="number" value="${v('orchestration.compaction.max_summary_input_chars')}"></div>
          <div class="field"><label>compaction.summary_max_tokens</label><input name="orchestration.compaction.summary_max_tokens" type="number" value="${v('orchestration.compaction.summary_max_tokens')}"></div>
        </div></div>
      </details>

      <div class="actions">
        <button type="submit">Save Config And Restart Carbon</button>
        ${saved ? '<p class="saved-msg">저장했습니다</p>' : ''}
      </div>
    </form>
  </section></section></main>
</body>
</html>''';
}

