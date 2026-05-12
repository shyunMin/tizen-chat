mod config_io;
mod config_service;
mod setup_service;

mod proto {
    // Both config.proto and setup.proto declare package carbon.v1,
    // so they compile into the same module.
    tonic::include_proto!("carbon.v1");
}

use config_service::ConfigServiceImpl;
use proto::config_service_server::ConfigServiceServer;
use proto::setup_service_server::SetupServiceServer;
use setup_service::SetupServiceImpl;
use std::path::PathBuf;
use tokio::net::UnixListener;
use tonic::transport::Server;

const DEFAULT_SOCK: &str = "/run/user/5001/carbon/onboarding.sock";

fn socket_path() -> PathBuf {
    std::env::var("CARBON_ONBOARDING_SOCK")
        .unwrap_or_else(|_| DEFAULT_SOCK.to_string())
        .into()
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let path = socket_path();

    if let Some(parent) = path.parent() {
        std::fs::create_dir_all(parent)?;
    }
    if path.exists() {
        std::fs::remove_file(&path)?;
    }

    let uds = UnixListener::bind(&path)?;
    let uds_stream = tokio_stream::wrappers::UnixListenerStream::new(uds);

    eprintln!("[carbon-onboarding-bridge] listening on {}", path.display());

    Server::builder()
        .add_service(ConfigServiceServer::new(ConfigServiceImpl))
        .add_service(SetupServiceServer::new(SetupServiceImpl::new()))
        .serve_with_incoming(uds_stream)
        .await?;

    Ok(())
}
