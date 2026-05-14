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
