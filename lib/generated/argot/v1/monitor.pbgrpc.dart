// This is a generated file - do not edit.
//
// Generated from argot/v1/monitor.proto.

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

import 'monitor.pb.dart' as $0;

export 'monitor.pb.dart';

/// MonitorService — system observation: current state (pull) + live activity
/// (push). Management RPCs read AppState directly and bypass the gateway kernel.
@$pb.GrpcServiceName('argot.v1.MonitorService')
class MonitorServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  MonitorServiceClient(super.channel, {super.options, super.interceptors});

  /// Snapshot (pull): daemon health/identity probe. Cheap unary — the
  /// right shape for `argot status` and liveness checks.
  $grpc.ResponseFuture<$0.GetStatusResponse> getStatus(
    $0.GetStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getStatus, request, options: options);
  }

  /// Live activity (push): long-lived observational stream of system-wide
  /// activity regardless of origin channel (gRPC / Telegram / scheduler).
  /// Backed by the daemon's ephemeral WatchBus; no history is replayed.
  $grpc.ResponseStream<$0.SystemEvent> watch(
    $0.WatchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$watch, $async.Stream.fromIterable([request]),
        options: options);
  }

  // method descriptors

  static final _$getStatus =
      $grpc.ClientMethod<$0.GetStatusRequest, $0.GetStatusResponse>(
          '/argot.v1.MonitorService/GetStatus',
          ($0.GetStatusRequest value) => value.writeToBuffer(),
          $0.GetStatusResponse.fromBuffer);
  static final _$watch = $grpc.ClientMethod<$0.WatchRequest, $0.SystemEvent>(
      '/argot.v1.MonitorService/Watch',
      ($0.WatchRequest value) => value.writeToBuffer(),
      $0.SystemEvent.fromBuffer);
}

@$pb.GrpcServiceName('argot.v1.MonitorService')
abstract class MonitorServiceBase extends $grpc.Service {
  $core.String get $name => 'argot.v1.MonitorService';

  MonitorServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetStatusRequest, $0.GetStatusResponse>(
        'GetStatus',
        getStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetStatusRequest.fromBuffer(value),
        ($0.GetStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchRequest, $0.SystemEvent>(
        'Watch',
        watch_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.WatchRequest.fromBuffer(value),
        ($0.SystemEvent value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetStatusResponse> getStatus_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetStatusRequest> $request) async {
    return getStatus($call, await $request);
  }

  $async.Future<$0.GetStatusResponse> getStatus(
      $grpc.ServiceCall call, $0.GetStatusRequest request);

  $async.Stream<$0.SystemEvent> watch_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.WatchRequest> $request) async* {
    yield* watch($call, await $request);
  }

  $async.Stream<$0.SystemEvent> watch(
      $grpc.ServiceCall call, $0.WatchRequest request);
}
