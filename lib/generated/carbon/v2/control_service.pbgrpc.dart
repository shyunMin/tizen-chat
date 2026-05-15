// This is a generated file - do not edit.
//
// Generated from carbon/v2/control_service.proto.

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

import 'control_service.pb.dart' as $0;

export 'control_service.pb.dart';

@$pb.GrpcServiceName('carbon.v2.ControlService')
class ControlServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ControlServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CompactSessionResponse> compactSession(
    $0.CompactSessionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$compactSession, request, options: options);
  }

  $grpc.ResponseFuture<$0.ClearSessionResponse> clearSession(
    $0.ClearSessionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$clearSession, request, options: options);
  }

  $grpc.ResponseFuture<$0.Status> getStatus(
    $0.GetStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getStatus, request, options: options);
  }

  // method descriptors

  static final _$compactSession =
      $grpc.ClientMethod<$0.CompactSessionRequest, $0.CompactSessionResponse>(
          '/carbon.v2.ControlService/CompactSession',
          ($0.CompactSessionRequest value) => value.writeToBuffer(),
          $0.CompactSessionResponse.fromBuffer);
  static final _$clearSession =
      $grpc.ClientMethod<$0.ClearSessionRequest, $0.ClearSessionResponse>(
          '/carbon.v2.ControlService/ClearSession',
          ($0.ClearSessionRequest value) => value.writeToBuffer(),
          $0.ClearSessionResponse.fromBuffer);
  static final _$getStatus = $grpc.ClientMethod<$0.GetStatusRequest, $0.Status>(
      '/carbon.v2.ControlService/GetStatus',
      ($0.GetStatusRequest value) => value.writeToBuffer(),
      $0.Status.fromBuffer);
}

@$pb.GrpcServiceName('carbon.v2.ControlService')
abstract class ControlServiceBase extends $grpc.Service {
  $core.String get $name => 'carbon.v2.ControlService';

  ControlServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CompactSessionRequest,
            $0.CompactSessionResponse>(
        'CompactSession',
        compactSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CompactSessionRequest.fromBuffer(value),
        ($0.CompactSessionResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ClearSessionRequest, $0.ClearSessionResponse>(
            'ClearSession',
            clearSession_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ClearSessionRequest.fromBuffer(value),
            ($0.ClearSessionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetStatusRequest, $0.Status>(
        'GetStatus',
        getStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetStatusRequest.fromBuffer(value),
        ($0.Status value) => value.writeToBuffer()));
  }

  $async.Future<$0.CompactSessionResponse> compactSession_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CompactSessionRequest> $request) async {
    return compactSession($call, await $request);
  }

  $async.Future<$0.CompactSessionResponse> compactSession(
      $grpc.ServiceCall call, $0.CompactSessionRequest request);

  $async.Future<$0.ClearSessionResponse> clearSession_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ClearSessionRequest> $request) async {
    return clearSession($call, await $request);
  }

  $async.Future<$0.ClearSessionResponse> clearSession(
      $grpc.ServiceCall call, $0.ClearSessionRequest request);

  $async.Future<$0.Status> getStatus_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetStatusRequest> $request) async {
    return getStatus($call, await $request);
  }

  $async.Future<$0.Status> getStatus(
      $grpc.ServiceCall call, $0.GetStatusRequest request);
}
