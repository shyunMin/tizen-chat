// This is a generated file - do not edit.
//
// Generated from carbon/v2/session_service.proto.

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

import 'session_service.pb.dart' as $0;

export 'session_service.pb.dart';

@$pb.GrpcServiceName('carbon.v2.SessionService')
class SessionServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SessionServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.Session> createSession(
    $0.CreateSessionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createSession, request, options: options);
  }

  $grpc.ResponseFuture<$0.Session> getSession(
    $0.GetSessionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSession, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListSessionsResponse> listSessions(
    $0.ListSessionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listSessions, request, options: options);
  }

  $grpc.ResponseFuture<$0.ArchiveSessionResponse> archiveSession(
    $0.ArchiveSessionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$archiveSession, request, options: options);
  }

  $grpc.ResponseFuture<$0.CancelSessionResponse> cancelSession(
    $0.CancelSessionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cancelSession, request, options: options);
  }

  // method descriptors

  static final _$createSession =
      $grpc.ClientMethod<$0.CreateSessionRequest, $0.Session>(
          '/carbon.v2.SessionService/CreateSession',
          ($0.CreateSessionRequest value) => value.writeToBuffer(),
          $0.Session.fromBuffer);
  static final _$getSession =
      $grpc.ClientMethod<$0.GetSessionRequest, $0.Session>(
          '/carbon.v2.SessionService/GetSession',
          ($0.GetSessionRequest value) => value.writeToBuffer(),
          $0.Session.fromBuffer);
  static final _$listSessions =
      $grpc.ClientMethod<$0.ListSessionsRequest, $0.ListSessionsResponse>(
          '/carbon.v2.SessionService/ListSessions',
          ($0.ListSessionsRequest value) => value.writeToBuffer(),
          $0.ListSessionsResponse.fromBuffer);
  static final _$archiveSession =
      $grpc.ClientMethod<$0.ArchiveSessionRequest, $0.ArchiveSessionResponse>(
          '/carbon.v2.SessionService/ArchiveSession',
          ($0.ArchiveSessionRequest value) => value.writeToBuffer(),
          $0.ArchiveSessionResponse.fromBuffer);
  static final _$cancelSession =
      $grpc.ClientMethod<$0.CancelSessionRequest, $0.CancelSessionResponse>(
          '/carbon.v2.SessionService/CancelSession',
          ($0.CancelSessionRequest value) => value.writeToBuffer(),
          $0.CancelSessionResponse.fromBuffer);
}

@$pb.GrpcServiceName('carbon.v2.SessionService')
abstract class SessionServiceBase extends $grpc.Service {
  $core.String get $name => 'carbon.v2.SessionService';

  SessionServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateSessionRequest, $0.Session>(
        'CreateSession',
        createSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateSessionRequest.fromBuffer(value),
        ($0.Session value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetSessionRequest, $0.Session>(
        'GetSession',
        getSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetSessionRequest.fromBuffer(value),
        ($0.Session value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListSessionsRequest, $0.ListSessionsResponse>(
            'ListSessions',
            listSessions_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListSessionsRequest.fromBuffer(value),
            ($0.ListSessionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ArchiveSessionRequest,
            $0.ArchiveSessionResponse>(
        'ArchiveSession',
        archiveSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ArchiveSessionRequest.fromBuffer(value),
        ($0.ArchiveSessionResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.CancelSessionRequest, $0.CancelSessionResponse>(
            'CancelSession',
            cancelSession_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CancelSessionRequest.fromBuffer(value),
            ($0.CancelSessionResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.Session> createSession_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateSessionRequest> $request) async {
    return createSession($call, await $request);
  }

  $async.Future<$0.Session> createSession(
      $grpc.ServiceCall call, $0.CreateSessionRequest request);

  $async.Future<$0.Session> getSession_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetSessionRequest> $request) async {
    return getSession($call, await $request);
  }

  $async.Future<$0.Session> getSession(
      $grpc.ServiceCall call, $0.GetSessionRequest request);

  $async.Future<$0.ListSessionsResponse> listSessions_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListSessionsRequest> $request) async {
    return listSessions($call, await $request);
  }

  $async.Future<$0.ListSessionsResponse> listSessions(
      $grpc.ServiceCall call, $0.ListSessionsRequest request);

  $async.Future<$0.ArchiveSessionResponse> archiveSession_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ArchiveSessionRequest> $request) async {
    return archiveSession($call, await $request);
  }

  $async.Future<$0.ArchiveSessionResponse> archiveSession(
      $grpc.ServiceCall call, $0.ArchiveSessionRequest request);

  $async.Future<$0.CancelSessionResponse> cancelSession_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CancelSessionRequest> $request) async {
    return cancelSession($call, await $request);
  }

  $async.Future<$0.CancelSessionResponse> cancelSession(
      $grpc.ServiceCall call, $0.CancelSessionRequest request);
}
