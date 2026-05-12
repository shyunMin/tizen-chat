// This is a generated file - do not edit.
//
// Generated from carbon/v1/setup.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'setup.pb.dart' as $0;

export 'setup.pb.dart';

@$pb.GrpcServiceName('carbon.v1.SetupService')
class SetupServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SetupServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.StartSetupResponse> startSetup(
    $0.StartSetupRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$startSetup, request, options: options);
  }

  $grpc.ResponseFuture<$0.StopSetupResponse> stopSetup(
    $0.StopSetupRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$stopSetup, request, options: options);
  }

  $grpc.ResponseStream<$0.SetupEvent> watchSetup(
    $0.WatchSetupRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$watchSetup, $async.Stream.fromIterable([request]),
        options: options);
  }

  // method descriptors

  static final _$startSetup =
      $grpc.ClientMethod<$0.StartSetupRequest, $0.StartSetupResponse>(
          '/carbon.v1.SetupService/StartSetup',
          ($0.StartSetupRequest value) => value.writeToBuffer(),
          $0.StartSetupResponse.fromBuffer);
  static final _$stopSetup =
      $grpc.ClientMethod<$0.StopSetupRequest, $0.StopSetupResponse>(
          '/carbon.v1.SetupService/StopSetup',
          ($0.StopSetupRequest value) => value.writeToBuffer(),
          $0.StopSetupResponse.fromBuffer);
  static final _$watchSetup =
      $grpc.ClientMethod<$0.WatchSetupRequest, $0.SetupEvent>(
          '/carbon.v1.SetupService/WatchSetup',
          ($0.WatchSetupRequest value) => value.writeToBuffer(),
          $0.SetupEvent.fromBuffer);
}

@$pb.GrpcServiceName('carbon.v1.SetupService')
abstract class SetupServiceBase extends $grpc.Service {
  $core.String get $name => 'carbon.v1.SetupService';

  SetupServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.StartSetupRequest, $0.StartSetupResponse>(
        'StartSetup',
        startSetup_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StartSetupRequest.fromBuffer(value),
        ($0.StartSetupResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StopSetupRequest, $0.StopSetupResponse>(
        'StopSetup',
        stopSetup_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StopSetupRequest.fromBuffer(value),
        ($0.StopSetupResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchSetupRequest, $0.SetupEvent>(
        'WatchSetup',
        watchSetup_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.WatchSetupRequest.fromBuffer(value),
        ($0.SetupEvent value) => value.writeToBuffer()));
  }

  $async.Future<$0.StartSetupResponse> startSetup_Pre($grpc.ServiceCall $call,
      $async.Future<$0.StartSetupRequest> $request) async {
    return startSetup($call, await $request);
  }

  $async.Future<$0.StartSetupResponse> startSetup(
      $grpc.ServiceCall call, $0.StartSetupRequest request);

  $async.Future<$0.StopSetupResponse> stopSetup_Pre($grpc.ServiceCall $call,
      $async.Future<$0.StopSetupRequest> $request) async {
    return stopSetup($call, await $request);
  }

  $async.Future<$0.StopSetupResponse> stopSetup(
      $grpc.ServiceCall call, $0.StopSetupRequest request);

  $async.Stream<$0.SetupEvent> watchSetup_Pre($grpc.ServiceCall $call,
      $async.Future<$0.WatchSetupRequest> $request) async* {
    yield* watchSetup($call, await $request);
  }

  $async.Stream<$0.SetupEvent> watchSetup(
      $grpc.ServiceCall call, $0.WatchSetupRequest request);
}
