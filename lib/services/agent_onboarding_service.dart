import 'argot_onboarding_service.dart' as argot;

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
  final argot.ArgotOnboardingService _argot = argot.ArgotOnboardingService();

  String get backendLabel => 'Argot';

  Future<void> connect() => _argot.connect();

  Future<AgentConfigStatus> getConfig() async {
    final config = await _argot.getConfig();
    return AgentConfigStatus(ready: config.ready, hint: config.hint, yaml: config.yaml);
  }

  Future<String> getConfigYaml() => _argot.getConfigYaml();

  Future<AgentConfigWriteResult> setConfig(String yaml) async {
    final result = await _argot.setConfig(yaml);
    return AgentConfigWriteResult(
      success: result.success,
      restartSuccess: result.restartSuccess,
      message: result.message,
    );
  }

  Future<void> disconnect() => _argot.disconnect();
}
