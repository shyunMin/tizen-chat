import 'argot_onboarding_service.dart' as argot;
import 'agent_runtime_service.dart';
import 'onboarding_grpc_service.dart' as carbon;

class AgentConfigStatus {
  final bool ready;
  final String hint;
  final String yaml;

  const AgentConfigStatus({
    required this.ready,
    this.hint = '',
    this.yaml = '',
  });
}

class AgentConfigWriteResult {
  final bool success;
  final bool restartSuccess;
  final String message;

  const AgentConfigWriteResult({
    required this.success,
    this.restartSuccess = false,
    this.message = '',
  });
}

class AgentOnboardingService {
  final AgentRuntimeBackend backend;
  late final argot.ArgotOnboardingService? _argot;
  late final carbon.OnboardingGrpcService? _carbon;

  AgentOnboardingService({AgentRuntimeBackend? backend})
    : backend = backend ?? selectedAgentRuntimeBackend {
    switch (this.backend) {
      case AgentRuntimeBackend.argot:
        _argot = argot.ArgotOnboardingService();
        _carbon = null;
        break;
      case AgentRuntimeBackend.carbon:
        _argot = null;
        _carbon = carbon.OnboardingGrpcService();
        break;
    }
  }

  String get backendLabel => agentRuntimeBackendLabel(backend);

  Future<void> connect() async {
    switch (backend) {
      case AgentRuntimeBackend.argot:
        return _argot!.connect();
      case AgentRuntimeBackend.carbon:
        return _carbon!.connect();
    }
  }

  Future<AgentConfigStatus> getConfig() async {
    switch (backend) {
      case AgentRuntimeBackend.argot:
        final config = await _argot!.getConfig();
        return AgentConfigStatus(
          ready: config.ready,
          hint: config.hint,
          yaml: config.yaml,
        );
      case AgentRuntimeBackend.carbon:
        final config = await _carbon!.getConfig();
        return AgentConfigStatus(
          ready: config.ready,
          hint: config.hint,
          yaml: config.yaml,
        );
    }
  }

  Future<String> getConfigYaml() async {
    switch (backend) {
      case AgentRuntimeBackend.argot:
        return _argot!.getConfigYaml();
      case AgentRuntimeBackend.carbon:
        return _carbon!.getConfigYaml();
    }
  }

  Future<AgentConfigWriteResult> setConfig(String yaml) async {
    switch (backend) {
      case AgentRuntimeBackend.argot:
        final result = await _argot!.setConfig(yaml);
        return AgentConfigWriteResult(
          success: result.success,
          restartSuccess: result.restartSuccess,
          message: result.message,
        );
      case AgentRuntimeBackend.carbon:
        final result = await _carbon!.setConfig(yaml);
        return AgentConfigWriteResult(
          success: result.success,
          restartSuccess: result.restartSuccess,
          message: result.message,
        );
    }
  }

  Future<void> disconnect() async {
    switch (backend) {
      case AgentRuntimeBackend.argot:
        return _argot!.disconnect();
      case AgentRuntimeBackend.carbon:
        return _carbon!.disconnect();
    }
  }
}
