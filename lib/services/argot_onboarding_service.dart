import 'package:flutter/foundation.dart';

class ArgotConfigStatus {
  final bool ready;
  final String hint;
  final String yaml;

  const ArgotConfigStatus({
    required this.ready,
    this.hint = '',
    this.yaml = '',
  });
}

class ArgotConfigWriteResult {
  final bool success;
  final bool restartSuccess;
  final String message;

  const ArgotConfigWriteResult({
    required this.success,
    this.restartSuccess = false,
    this.message = '',
  });
}

class ArgotOnboardingService {
  Future<void> connect() async {
    debugPrint(
      '[ArgotOnboarding] gRPC setup is not available in argot.v1; skipping setup adapter',
    );
  }

  Future<ArgotConfigStatus> getConfig() async {
    debugPrint(
      '[ArgotOnboarding] getConfig ignored; use `argot onboard` to configure the daemon',
    );
    return const ArgotConfigStatus(ready: true);
  }

  Future<String> getConfigYaml() async {
    debugPrint(
      '[ArgotOnboarding] getConfigYaml ignored; argot.v1 exposes chat RPCs only',
    );
    return '';
  }

  Future<ArgotConfigWriteResult> setConfig(String yaml) async {
    debugPrint(
      '[ArgotOnboarding] setConfig ignored; argot.v1 exposes no config write RPC',
    );
    return const ArgotConfigWriteResult(
      success: false,
      message:
          'Argot setup over gRPC is not supported yet. Run `argot onboard` on the device.',
    );
  }

  Future<void> disconnect() async {
    debugPrint('[ArgotOnboarding] disconnected');
  }
}
