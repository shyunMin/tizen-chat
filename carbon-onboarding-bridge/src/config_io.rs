use anyhow::{Context, Result};
use serde::{Deserialize, Serialize};
use std::path::Path;

const CONFIG_DIR: &str = "/opt/usr/home/owner/.carbon";
const CONFIG_PATH: &str = "/opt/usr/home/owner/.carbon/config.yaml";
const CONFIG_TMP: &str = "/opt/usr/home/owner/.carbon/config.yaml.tmp";
const CONFIG_BAK: &str = "/opt/usr/home/owner/.carbon/config.yaml.bak";

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(default)]
pub struct BridgeConfig {
    pub version: i32,
    pub extra_skill_dirs: Vec<String>,
    pub defaults: BridgeDefaults,
    pub providers: BridgeProviders,
    pub web_search: BridgeWebSearch,
    pub orchestration: BridgeOrchestration,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(default)]
pub struct BridgeDefaults {
    pub provider: String,
    pub model: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(default)]
pub struct BridgeProviders {
    pub anthropic: BridgeAnthropicConfig,
    pub gemini: BridgeGeminiConfig,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(default)]
pub struct BridgeAnthropicConfig {
    pub api_key: String,
    pub oauth_token: String,
    pub base_url: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(default)]
pub struct BridgeGeminiConfig {
    pub api_key: String,
    pub base_url: String,
    pub min_output_tokens: i32,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(default)]
pub struct BridgeWebSearch {
    pub backend: String,
    pub brave: BridgeBraveConfig,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(default)]
pub struct BridgeBraveConfig {
    pub api_key: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(default)]
pub struct BridgeOrchestration {
    pub session: BridgeSession,
    pub spawn: BridgeSpawn,
    pub sub_agent: BridgeSubAgent,
    pub daemon: BridgeDaemon,
    pub continuation: BridgeToggle,
    pub narration: BridgeToggle,
    pub controller: BridgeController,
    pub compaction: BridgeCompaction,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(default)]
pub struct BridgeSession {
    pub max_session_turns: i32,
    pub max_thread_turns: i32,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(default)]
pub struct BridgeSpawn {
    pub max_turns: i32,
    pub max_depth: i32,
    pub max_children: i32,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(default)]
pub struct BridgeSubAgent {
    pub max_turns: i32,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(default)]
pub struct BridgeDaemon {
    pub max_depth: i32,
    pub max_children: i32,
    pub max_total_agents: i32,
    pub mailbox_policy: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(default)]
pub struct BridgeToggle {
    pub enabled: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(default)]
pub struct BridgeController {
    pub max_model_rounds: i32,
    pub max_continuation_depth: i32,
    pub max_unresolved_retries: i32,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(default)]
pub struct BridgeCompaction {
    pub threshold: f64,
    pub keep_recent_messages: i32,
    pub max_summary_input_chars: i32,
    pub summary_max_tokens: i32,
}

pub fn read_yaml() -> Result<String> {
    std::fs::read_to_string(CONFIG_PATH)
        .with_context(|| format!("failed to read {CONFIG_PATH}"))
}

pub fn write_yaml(yaml: &str) -> Result<()> {
    std::fs::create_dir_all(CONFIG_DIR)
        .with_context(|| format!("failed to create {CONFIG_DIR}"))?;

    if Path::new(CONFIG_PATH).exists() {
        std::fs::copy(CONFIG_PATH, CONFIG_BAK)
            .with_context(|| "failed to create config backup")?;
    }

    std::fs::write(CONFIG_TMP, yaml)
        .with_context(|| format!("failed to write {CONFIG_TMP}"))?;

    std::fs::rename(CONFIG_TMP, CONFIG_PATH)
        .with_context(|| format!("failed to rename {CONFIG_TMP} -> {CONFIG_PATH}"))?;

    Ok(())
}


pub fn parse_config(yaml: &str) -> Result<BridgeConfig> {
    serde_yaml::from_str(yaml).with_context(|| "failed to parse config YAML")
}

pub fn is_ready(cfg: &BridgeConfig) -> bool {
    match cfg.defaults.provider.as_str() {
        "anthropic" => {
            !cfg.providers.anthropic.api_key.trim().is_empty()
                || !cfg.providers.anthropic.oauth_token.trim().is_empty()
        }
        "gemini" => !cfg.providers.gemini.api_key.trim().is_empty(),
        _ => false,
    }
}

pub fn onboarding_hint() -> String {
    format!(
        "no model providers are configured; set providers.anthropic.api_key or providers.gemini.api_key in {}",
        CONFIG_PATH
    )
}

/// 매 요청마다 파일 존재 → 읽기 → provider key 순으로 직접 확인한다.
pub fn check_ready() -> (bool, String) {
    if !Path::new(CONFIG_PATH).exists() {
        return (false, onboarding_hint());
    }
    match read_yaml().and_then(|y| parse_config(&y)) {
        Ok(cfg) if is_ready(&cfg) => (true, String::new()),
        _ => (false, onboarding_hint()),
    }
}

/// Default template when config.yaml does not exist yet.
pub fn default_config_template() -> String {
    r#"version: 1

defaults:
  provider: anthropic
  model: light

providers:
  anthropic:
    api_key: ""
    oauth_token: ""
  gemini:
    api_key: ""

web_search:
  brave:
    api_key: ""
"#
    .to_string()
}

/// Merge form fields into an existing YAML string, preserving comments and blank lines.
///
/// Strategy:
///   - Keys that already exist in the YAML → in-place text replacement (comments preserved).
///   - New non-blank keys → serde_yaml fallback (comment loss only for entirely new sections).
///   - "extra_skill_dirs" → inline YAML sequence `[a, b, c]` regardless of previous form.
///   - Blank/zero/false values are skipped unless the key already exists (prevents new sections).
pub fn merge_fields(base_yaml: &str, fields: &[(String, String)]) -> Result<String> {
    let mut text = base_yaml.to_string();
    let mut serde_needed: Vec<(&str, &str)> = Vec::new();

    for (key, value) in fields {
        if key == "extra_skill_dirs" {
            let dirs: Vec<&str> = value
                .lines()
                .map(str::trim)
                .filter(|s| !s.is_empty())
                .collect();
            text = replace_skill_dirs_inline(&text, &dirs);
        } else if text_path_exists(&text, key) {
            text = replace_scalar_in_text(&text, key, value);
        } else if !is_blank_default(value) {
            serde_needed.push((key, value));
        }
    }

    // New paths not yet in the file: fall back to serde_yaml.
    // Comments are preserved in the common case (all keys already present).
    if !serde_needed.is_empty() {
        let mut doc: serde_yaml::Value = serde_yaml::from_str(&text)
            .with_context(|| "failed to parse base config for merge")?;
        for (key, value) in serde_needed {
            set_yaml_path_value(&mut doc, key, coerce_value(value));
        }
        let raw = serde_yaml::to_string(&doc)
            .with_context(|| "failed to serialize merged config")?;
        text = post_process_yaml(&raw);
    }

    Ok(text)
}

fn is_blank_default(value: &str) -> bool {
    let v = value.trim();
    v.is_empty() || v == "0" || v == "0.0" || v == "false"
}

/// Returns true when `dot_path` exists as a key in the YAML text.
/// Tracks indent depth assuming 2-space indentation.
fn text_path_exists(yaml: &str, dot_path: &str) -> bool {
    let parts: Vec<&str> = dot_path.split('.').collect();
    let mut key_stack: Vec<String> = Vec::new();

    for line in yaml.lines() {
        let trimmed = line.trim_start();
        if trimmed.is_empty() || trimmed.starts_with('#') || trimmed.starts_with('-') {
            continue;
        }
        let indent = line.len() - trimmed.len();
        let depth = indent / 2;

        if let Some(colon_pos) = trimmed.find(':') {
            let key = trimmed[..colon_pos].trim();
            let after = trimmed[colon_pos + 1..].trim();
            key_stack.truncate(depth);

            let full: Vec<&str> = key_stack.iter().map(String::as_str).chain(std::iter::once(key)).collect();
            if full == parts {
                return true;
            }
            if after.is_empty() || after.starts_with('#') {
                key_stack.push(key.to_string());
            }
        }
    }
    false
}

/// Replace the scalar at `dot_path` in-place, preserving comments and blank lines.
fn replace_scalar_in_text(yaml: &str, dot_path: &str, new_value: &str) -> String {
    let parts: Vec<&str> = dot_path.split('.').collect();
    let mut result = String::with_capacity(yaml.len());
    let mut key_stack: Vec<String> = Vec::new();
    let mut replaced = false;

    for line in yaml.lines() {
        if replaced {
            result.push_str(line);
            result.push('\n');
            continue;
        }

        let trimmed = line.trim_start();
        if trimmed.is_empty() || trimmed.starts_with('#') || trimmed.starts_with('-') {
            result.push_str(line);
            result.push('\n');
            continue;
        }

        let indent = line.len() - trimmed.len();
        let depth = indent / 2;

        if let Some(colon_pos) = trimmed.find(':') {
            let key = trimmed[..colon_pos].trim();
            let after = trimmed[colon_pos + 1..].trim();
            key_stack.truncate(depth);

            let full: Vec<&str> = key_stack.iter().map(String::as_str).chain(std::iter::once(key)).collect();
            if full == parts {
                result.push_str(&" ".repeat(indent));
                result.push_str(key);
                result.push_str(": ");
                result.push_str(&format_scalar(new_value));
                result.push('\n');
                replaced = true;
                continue;
            }
            if after.is_empty() || after.starts_with('#') {
                key_stack.push(key.to_string());
            }
        }

        result.push_str(line);
        result.push('\n');
    }

    if !yaml.ends_with('\n') && result.ends_with('\n') {
        result.pop();
    }
    result
}

fn format_scalar(value: &str) -> String {
    match value {
        "true" | "false" => value.to_string(),
        _ => {
            if let Ok(i) = value.parse::<i64>() {
                i.to_string()
            } else if value.parse::<f64>().is_ok() {
                value.to_string()
            } else if value.is_empty() {
                "\"\"".to_string()
            } else {
                value.to_string()
            }
        }
    }
}

/// Replace `extra_skill_dirs` with an inline YAML sequence `[a, b]`.
/// Handles both `extra_skill_dirs: []` and block-sequence forms.
fn replace_skill_dirs_inline(yaml: &str, dirs: &[&str]) -> String {
    let inline = if dirs.is_empty() {
        "[]".to_string()
    } else {
        format!("[{}]", dirs.join(", "))
    };

    let mut result = String::with_capacity(yaml.len());
    let mut skip_block = false;

    for line in yaml.lines() {
        let trimmed = line.trim_start();

        if skip_block {
            if trimmed.starts_with("- ") || trimmed == "-" {
                continue;
            }
            skip_block = false;
        }

        let indent = line.len() - trimmed.len();
        if indent == 0 && trimmed.starts_with("extra_skill_dirs:") {
            let after = trimmed["extra_skill_dirs:".len()..].trim();
            if after.is_empty() {
                skip_block = true;
            }
            result.push_str("extra_skill_dirs: ");
            result.push_str(&inline);
            result.push('\n');
            continue;
        }

        result.push_str(line);
        result.push('\n');
    }

    if !yaml.ends_with('\n') && result.ends_with('\n') {
        result.pop();
    }
    result
}

/// Post-process serde_yaml output: add blank lines before top-level keys,
/// normalize single-quoted empty strings to double-quoted.
fn post_process_yaml(yaml: &str) -> String {
    let mut result = String::with_capacity(yaml.len() + 64);
    for line in yaml.lines() {
        let is_top_level_key = !line.is_empty()
            && !line.starts_with(' ')
            && !line.starts_with('\t')
            && !line.starts_with('#')
            && line.contains(':');
        if is_top_level_key && !result.is_empty() {
            result.push('\n');
        }
        if let Some(stripped) = line.strip_suffix(": ''") {
            result.push_str(stripped);
            result.push_str(": \"\"");
        } else {
            result.push_str(line);
        }
        result.push('\n');
    }
    result
}

fn coerce_value(s: &str) -> serde_yaml::Value {
    match s {
        "true" => serde_yaml::Value::Bool(true),
        "false" => serde_yaml::Value::Bool(false),
        _ => {
            if let Ok(i) = s.parse::<i64>() {
                serde_yaml::Value::Number(i.into())
            } else if let Ok(f) = s.parse::<f64>() {
                serde_yaml::Value::Number(serde_yaml::Number::from(f))
            } else {
                serde_yaml::Value::String(s.to_string())
            }
        }
    }
}

fn set_yaml_path_value(doc: &mut serde_yaml::Value, path: &str, value: serde_yaml::Value) {
    let parts: Vec<&str> = path.splitn(10, '.').collect();
    let mut current = doc;
    for (i, part) in parts.iter().enumerate() {
        if i == parts.len() - 1 {
            if let serde_yaml::Value::Mapping(map) = current {
                map.insert(serde_yaml::Value::String(part.to_string()), value);
                return;
            }
        } else if let serde_yaml::Value::Mapping(map) = current {
            let key = serde_yaml::Value::String(part.to_string());
            if !map.contains_key(&key) {
                map.insert(key.clone(), serde_yaml::Value::Mapping(Default::default()));
            }
            current = map.get_mut(&key).unwrap();
        } else {
            return;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const SAMPLE: &str = "version: 1\n\ndefaults:\n  provider: anthropic\n  model: light\n\nproviders:\n  anthropic:\n    api_key: \"\"\n    oauth_token: \"\"\n  gemini:\n    api_key: \"\"\n\nweb_search:\n  brave:\n    api_key: \"\"\n";

    #[test]
    fn blank_default_skips_new_keys() {
        let fields = vec![
            ("providers.gemini.api_key".to_string(), "AIzaTest123".to_string()),
            ("providers.anthropic.api_key".to_string(), "".to_string()),
            ("orchestration.session.max_session_turns".to_string(), "0".to_string()),
            ("orchestration.continuation.enabled".to_string(), "false".to_string()),
        ];
        let out = merge_fields(SAMPLE, &fields).unwrap();
        assert!(!out.contains("orchestration"), "orchestration section must not be added:\n{out}");
        assert!(out.contains("AIzaTest123"), "gemini key must be written");
        assert!(out.contains("api_key: \"\""), "existing empty key must stay as double-quoted");
    }

    #[test]
    fn blank_line_between_top_level_keys() {
        let fields: Vec<(String, String)> = vec![];
        let out = merge_fields(SAMPLE, &fields).unwrap();
        let top_level_keys = ["defaults:", "providers:", "web_search:"];
        for key in top_level_keys {
            let pos = out.find(key).unwrap();
            assert!(
                pos >= 2 && &out[pos - 2..pos] == "\n\n",
                "expected blank line before '{key}', context: {:?}",
                &out[pos.saturating_sub(20)..pos + key.len()]
            );
        }
    }

    #[test]
    fn existing_key_can_be_cleared() {
        let yaml_with_key = SAMPLE.replacen(
            "anthropic:\n    api_key: \"\"",
            "anthropic:\n    api_key: \"sk-ant-existing\"",
            1,
        );
        let fields = vec![
            ("providers.anthropic.api_key".to_string(), "".to_string()),
        ];
        let out = merge_fields(&yaml_with_key, &fields).unwrap();
        assert!(!out.contains("sk-ant-existing"), "anthropic key must be cleared:\n{out}");
    }

    #[test]
    fn orchestration_written_when_nonzero() {
        let fields = vec![
            ("orchestration.session.max_session_turns".to_string(), "50".to_string()),
        ];
        let out = merge_fields(SAMPLE, &fields).unwrap();
        assert!(out.contains("max_session_turns: 50"), "nonzero value must be written");
    }

    #[test]
    fn skill_dirs_inline_single() {
        let yaml = "version: 1\n\nextra_skill_dirs: []\n";
        let fields = vec![
            ("extra_skill_dirs".to_string(), "/opt/usr/share/tizen-tools/stable/skills".to_string()),
        ];
        let out = merge_fields(yaml, &fields).unwrap();
        assert_eq!(
            out.lines().find(|l| l.starts_with("extra_skill_dirs")).unwrap(),
            "extra_skill_dirs: [/opt/usr/share/tizen-tools/stable/skills]"
        );
    }

    #[test]
    fn skill_dirs_inline_empty() {
        let yaml = "version: 1\n\nextra_skill_dirs: [/some/path]\n";
        let fields = vec![("extra_skill_dirs".to_string(), "".to_string())];
        let out = merge_fields(yaml, &fields).unwrap();
        assert_eq!(
            out.lines().find(|l| l.starts_with("extra_skill_dirs")).unwrap(),
            "extra_skill_dirs: []"
        );
    }

    #[test]
    fn comments_preserved() {
        let yaml = "# top comment\nversion: 1\n\n# skill comment\nextra_skill_dirs: []\n";
        let fields = vec![("version".to_string(), "2".to_string())];
        let out = merge_fields(yaml, &fields).unwrap();
        assert!(out.contains("# top comment"), "top comment must be preserved");
        assert!(out.contains("# skill comment"), "skill comment must be preserved");
        assert!(out.contains("version: 2"), "version must be updated");
    }
}
