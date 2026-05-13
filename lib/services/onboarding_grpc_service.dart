import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import '../generated/carbon/v1/config.pbgrpc.dart';
import '../generated/carbon/v1/setup.pbgrpc.dart';

class OnboardingGrpcService {
  static const _sockPath = '/run/user/5001/carbon/onboarding.sock';

  ClientChannel? _channel;
  ConfigServiceClient? _configClient;
  SetupServiceClient? _setupClient;

  Future<void> connect() async {
    _channel = ClientChannel(
      InternetAddress(_sockPath, type: InternetAddressType.unix),
      port: 0,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    _configClient = ConfigServiceClient(_channel!);
    _setupClient = SetupServiceClient(_channel!);
    debugPrint('[Onboarding] connected to $_sockPath');
  }

  Future<GetConfigResponse> getConfig() async {
    return _configClient!.getConfig(GetConfigRequest());
  }

  Future<String> startSetup({int preferredPort = 18181}) async {
    final resp = await _setupClient!.startSetup(
      StartSetupRequest()..preferredPort = preferredPort,
    );
    debugPrint('[Onboarding] StartSetup url: ${resp.url}');
    return resp.url;
  }

  Future<void> stopSetup() async {
    await _setupClient!.stopSetup(StopSetupRequest());
    debugPrint('[Onboarding] StopSetup called');
  }

  Stream<SetupEvent> watchSetup() {
    return _setupClient!.watchSetup(WatchSetupRequest());
  }

  Future<void> disconnect() async {
    await _channel?.terminate();
    _channel = null;
    _configClient = null;
    _setupClient = null;
    debugPrint('[Onboarding] disconnected');
  }
}
