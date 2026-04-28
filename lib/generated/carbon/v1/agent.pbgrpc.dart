// This is a generated file - do not edit.
//
// Generated from carbon/v1/agent.proto.

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

import 'agent.pb.dart' as $0;

export 'agent.pb.dart';

/// AgentService is the core Carbon runtime API.
///
/// All interaction happens through a single bidirectional stream per connection.
/// The client sends ClientMessage (create session, send input, approve tools, manage schedules)
/// and the server sends ServerEvent (text output, tool calls, errors, session lifecycle).
///
/// Transport: Unix socket at $XDG_RUNTIME_DIR/carbon/carbon.sock
/// Auth (Phase 4+): per-app identity token in gRPC metadata
@$pb.GrpcServiceName('carbon.v1.AgentService')
class AgentServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AgentServiceClient(super.channel, {super.options, super.interceptors});

  /// Open a bidirectional session stream.
  /// Client must send CreateSessionRequest as the first message.
  /// The stream stays open for the lifetime of the session.
  $grpc.ResponseStream<$0.ServerEvent> session(
    $async.Stream<$0.ClientMessage> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$session, request, options: options);
  }

  // method descriptors

  static final _$session = $grpc.ClientMethod<$0.ClientMessage, $0.ServerEvent>(
      '/carbon.v1.AgentService/Session',
      ($0.ClientMessage value) => value.writeToBuffer(),
      $0.ServerEvent.fromBuffer);
}

@$pb.GrpcServiceName('carbon.v1.AgentService')
abstract class AgentServiceBase extends $grpc.Service {
  $core.String get $name => 'carbon.v1.AgentService';

  AgentServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ClientMessage, $0.ServerEvent>(
        'Session',
        session,
        true,
        true,
        ($core.List<$core.int> value) => $0.ClientMessage.fromBuffer(value),
        ($0.ServerEvent value) => value.writeToBuffer()));
  }

  $async.Stream<$0.ServerEvent> session(
      $grpc.ServiceCall call, $async.Stream<$0.ClientMessage> request);
}
