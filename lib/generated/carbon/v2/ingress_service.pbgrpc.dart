// This is a generated file - do not edit.
//
// Generated from carbon/v2/ingress_service.proto.

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

import 'ingress_service.pb.dart' as $0;

export 'ingress_service.pb.dart';

@$pb.GrpcServiceName('carbon.v2.IngressService')
class IngressServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  IngressServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.SubmitResponse> submit(
    $0.SubmitRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$submit, request, options: options);
  }

  $grpc.ResponseFuture<$0.InterruptTurnResponse> interruptTurn(
    $0.InterruptTurnRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$interruptTurn, request, options: options);
  }

  $grpc.ResponseFuture<$0.ApproveToolResponse> approveTool(
    $0.ApproveToolRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$approveTool, request, options: options);
  }

  // method descriptors

  static final _$submit =
      $grpc.ClientMethod<$0.SubmitRequest, $0.SubmitResponse>(
          '/carbon.v2.IngressService/Submit',
          ($0.SubmitRequest value) => value.writeToBuffer(),
          $0.SubmitResponse.fromBuffer);
  static final _$interruptTurn =
      $grpc.ClientMethod<$0.InterruptTurnRequest, $0.InterruptTurnResponse>(
          '/carbon.v2.IngressService/InterruptTurn',
          ($0.InterruptTurnRequest value) => value.writeToBuffer(),
          $0.InterruptTurnResponse.fromBuffer);
  static final _$approveTool =
      $grpc.ClientMethod<$0.ApproveToolRequest, $0.ApproveToolResponse>(
          '/carbon.v2.IngressService/ApproveTool',
          ($0.ApproveToolRequest value) => value.writeToBuffer(),
          $0.ApproveToolResponse.fromBuffer);
}

@$pb.GrpcServiceName('carbon.v2.IngressService')
abstract class IngressServiceBase extends $grpc.Service {
  $core.String get $name => 'carbon.v2.IngressService';

  IngressServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SubmitRequest, $0.SubmitResponse>(
        'Submit',
        submit_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SubmitRequest.fromBuffer(value),
        ($0.SubmitResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.InterruptTurnRequest, $0.InterruptTurnResponse>(
            'InterruptTurn',
            interruptTurn_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.InterruptTurnRequest.fromBuffer(value),
            ($0.InterruptTurnResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ApproveToolRequest, $0.ApproveToolResponse>(
            'ApproveTool',
            approveTool_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ApproveToolRequest.fromBuffer(value),
            ($0.ApproveToolResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SubmitResponse> submit_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.SubmitRequest> $request) async {
    return submit($call, await $request);
  }

  $async.Future<$0.SubmitResponse> submit(
      $grpc.ServiceCall call, $0.SubmitRequest request);

  $async.Future<$0.InterruptTurnResponse> interruptTurn_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.InterruptTurnRequest> $request) async {
    return interruptTurn($call, await $request);
  }

  $async.Future<$0.InterruptTurnResponse> interruptTurn(
      $grpc.ServiceCall call, $0.InterruptTurnRequest request);

  $async.Future<$0.ApproveToolResponse> approveTool_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ApproveToolRequest> $request) async {
    return approveTool($call, await $request);
  }

  $async.Future<$0.ApproveToolResponse> approveTool(
      $grpc.ServiceCall call, $0.ApproveToolRequest request);
}
