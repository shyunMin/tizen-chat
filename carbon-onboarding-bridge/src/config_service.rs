use tonic::{Request, Response, Status};

use crate::config_io;
use crate::proto::{
    config_service_server::ConfigService, GetConfigRequest, GetConfigResponse, SetConfigRequest,
    SetConfigResponse,
};

#[derive(Default)]
pub struct ConfigServiceImpl;

#[tonic::async_trait]
impl ConfigService for ConfigServiceImpl {
    async fn get_config(
        &self,
        _request: Request<GetConfigRequest>,
    ) -> Result<Response<GetConfigResponse>, Status> {
        let yaml = config_io::read_yaml()
            .unwrap_or_else(|_| config_io::default_config_template());

        let (ready, hint) = config_io::check_ready();

        Ok(Response::new(GetConfigResponse { yaml, ready, hint }))
    }

    async fn set_config(
        &self,
        request: Request<SetConfigRequest>,
    ) -> Result<Response<SetConfigResponse>, Status> {
        let yaml = request.into_inner().yaml;

        // Validate YAML before writing
        if let Err(e) = config_io::parse_config(&yaml) {
            return Ok(Response::new(SetConfigResponse {
                success: false,
                message: format!("invalid config YAML: {e}"),
                restart_success: false,
            }));
        }

        // Write to disk
        if let Err(e) = config_io::write_yaml(&yaml) {
            return Ok(Response::new(SetConfigResponse {
                success: false,
                message: format!("failed to save config: {e}"),
                restart_success: false,
            }));
        }

        Ok(Response::new(SetConfigResponse {
            success: true,
            message: "config saved.".into(),
            restart_success: false,
        }))
    }
}
