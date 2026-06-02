import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import '../generated/carbon/v1/config.pbgrpc.dart';

class OnboardingGrpcService {
  ClientChannel? _channel;
  ConfigServiceClient? _configClient;

  Future<void> connect() async {
    final sockPath = _resolveSocketPath();
    _channel = ClientChannel(
      InternetAddress(sockPath, type: InternetAddressType.unix),
      port: 0,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    _configClient = ConfigServiceClient(_channel!);
    debugPrint('[Onboarding] connected to $sockPath');
  }

  String _resolveSocketPath() {
    final explicit = Platform.environment['CARBON_ONBOARDING_SOCKET_PATH'];
    if (explicit != null && explicit.isNotEmpty) return explicit;

    final xdg = Platform.environment['XDG_RUNTIME_DIR'];
    if (xdg != null && xdg.isNotEmpty) {
      return '$xdg/carbon/onboarding.sock';
    }
    return '/run/user/5001/carbon/onboarding.sock';
  }

  Future<GetConfigResponse> getConfig() async {
    return _configClient!.getConfig(GetConfigRequest());
  }

  Future<String> getConfigYaml() async {
    final resp = await _configClient!.getConfig(GetConfigRequest());
    return resp.yaml;
  }

  Future<SetConfigResponse> setConfig(String yaml) async {
    return _configClient!.setConfig(SetConfigRequest(yaml: yaml));
  }

  Future<void> disconnect() async {
    await _channel?.terminate();
    _channel = null;
    _configClient = null;
    debugPrint('[Onboarding] disconnected');
  }
}
