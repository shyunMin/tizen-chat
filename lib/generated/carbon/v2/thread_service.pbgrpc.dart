// This is a generated file - do not edit.
//
// Generated from carbon/v2/thread_service.proto.

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

import 'thread_service.pb.dart' as $0;

export 'thread_service.pb.dart';

@$pb.GrpcServiceName('carbon.v2.ThreadService')
class ThreadServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ThreadServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ListThreadsResponse> listThreads(
    $0.ListThreadsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listThreads, request, options: options);
  }

  $grpc.ResponseFuture<$0.Thread> getThread(
    $0.GetThreadRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getThread, request, options: options);
  }

  $grpc.ResponseFuture<$0.Thread> renameThread(
    $0.RenameThreadRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$renameThread, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListTurnsResponse> listTurns(
    $0.ListTurnsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listTurns, request, options: options);
  }

  $grpc.ResponseFuture<$0.Turn> getTurn(
    $0.GetTurnRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTurn, request, options: options);
  }

  // method descriptors

  static final _$listThreads =
      $grpc.ClientMethod<$0.ListThreadsRequest, $0.ListThreadsResponse>(
          '/carbon.v2.ThreadService/ListThreads',
          ($0.ListThreadsRequest value) => value.writeToBuffer(),
          $0.ListThreadsResponse.fromBuffer);
  static final _$getThread = $grpc.ClientMethod<$0.GetThreadRequest, $0.Thread>(
      '/carbon.v2.ThreadService/GetThread',
      ($0.GetThreadRequest value) => value.writeToBuffer(),
      $0.Thread.fromBuffer);
  static final _$renameThread =
      $grpc.ClientMethod<$0.RenameThreadRequest, $0.Thread>(
          '/carbon.v2.ThreadService/RenameThread',
          ($0.RenameThreadRequest value) => value.writeToBuffer(),
          $0.Thread.fromBuffer);
  static final _$listTurns =
      $grpc.ClientMethod<$0.ListTurnsRequest, $0.ListTurnsResponse>(
          '/carbon.v2.ThreadService/ListTurns',
          ($0.ListTurnsRequest value) => value.writeToBuffer(),
          $0.ListTurnsResponse.fromBuffer);
  static final _$getTurn = $grpc.ClientMethod<$0.GetTurnRequest, $0.Turn>(
      '/carbon.v2.ThreadService/GetTurn',
      ($0.GetTurnRequest value) => value.writeToBuffer(),
      $0.Turn.fromBuffer);
}

@$pb.GrpcServiceName('carbon.v2.ThreadService')
abstract class ThreadServiceBase extends $grpc.Service {
  $core.String get $name => 'carbon.v2.ThreadService';

  ThreadServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.ListThreadsRequest, $0.ListThreadsResponse>(
            'ListThreads',
            listThreads_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListThreadsRequest.fromBuffer(value),
            ($0.ListThreadsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetThreadRequest, $0.Thread>(
        'GetThread',
        getThread_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetThreadRequest.fromBuffer(value),
        ($0.Thread value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RenameThreadRequest, $0.Thread>(
        'RenameThread',
        renameThread_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RenameThreadRequest.fromBuffer(value),
        ($0.Thread value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListTurnsRequest, $0.ListTurnsResponse>(
        'ListTurns',
        listTurns_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListTurnsRequest.fromBuffer(value),
        ($0.ListTurnsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetTurnRequest, $0.Turn>(
        'GetTurn',
        getTurn_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetTurnRequest.fromBuffer(value),
        ($0.Turn value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListThreadsResponse> listThreads_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListThreadsRequest> $request) async {
    return listThreads($call, await $request);
  }

  $async.Future<$0.ListThreadsResponse> listThreads(
      $grpc.ServiceCall call, $0.ListThreadsRequest request);

  $async.Future<$0.Thread> getThread_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetThreadRequest> $request) async {
    return getThread($call, await $request);
  }

  $async.Future<$0.Thread> getThread(
      $grpc.ServiceCall call, $0.GetThreadRequest request);

  $async.Future<$0.Thread> renameThread_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RenameThreadRequest> $request) async {
    return renameThread($call, await $request);
  }

  $async.Future<$0.Thread> renameThread(
      $grpc.ServiceCall call, $0.RenameThreadRequest request);

  $async.Future<$0.ListTurnsResponse> listTurns_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListTurnsRequest> $request) async {
    return listTurns($call, await $request);
  }

  $async.Future<$0.ListTurnsResponse> listTurns(
      $grpc.ServiceCall call, $0.ListTurnsRequest request);

  $async.Future<$0.Turn> getTurn_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetTurnRequest> $request) async {
    return getTurn($call, await $request);
  }

  $async.Future<$0.Turn> getTurn(
      $grpc.ServiceCall call, $0.GetTurnRequest request);
}
