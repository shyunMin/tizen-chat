import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import '../generated/carbon/v1/config.pbgrpc.dart';

class OnboardingGrpcService {
  static const _sockPath = '/run/user/5001/carbon/onboarding.sock';

  ClientChannel? _channel;
  ConfigServiceClient? _configClient;

  Future<void> connect() async {
    _channel = ClientChannel(
      InternetAddress(_sockPath, type: InternetAddressType.unix),
      port: 0,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    _configClient = ConfigServiceClient(_channel!);
    debugPrint('[Onboarding] connected to $_sockPath');
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
