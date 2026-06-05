// This is a generated file - do not edit.
//
// Generated from argot/v1/chat.proto.

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

import 'chat.pb.dart' as $0;
import 'types.pb.dart' as $1;

export 'chat.pb.dart';

/// ChatService — turn traffic. Single-tenant single-agent daemon.
@$pb.GrpcServiceName('argot.v1.ChatService')
class ChatServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ChatServiceClient(super.channel, {super.options, super.interceptors});

  /// Stream contract: always one Opened first (the resolved/provisioned
  /// conversation id). If the request carries a user message, Opened is
  /// followed by zero or more MessageDelta / ToolCall / ToolResult events and
  /// exactly one terminal Completed / Stopped / Failed, then end-of-stream. A
  /// message-less request (empty `parts`) runs no turn: the stream is just
  /// Opened, then end-of-stream — it resolves/provisions the conversation and
  /// does nothing else.
  $grpc.ResponseStream<$1.ChatEvent> chat(
    $0.ChatRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$chat, $async.Stream.fromIterable([request]),
        options: options);
  }

  // method descriptors

  static final _$chat = $grpc.ClientMethod<$0.ChatRequest, $1.ChatEvent>(
      '/argot.v1.ChatService/Chat',
      ($0.ChatRequest value) => value.writeToBuffer(),
      $1.ChatEvent.fromBuffer);
}

@$pb.GrpcServiceName('argot.v1.ChatService')
abstract class ChatServiceBase extends $grpc.Service {
  $core.String get $name => 'argot.v1.ChatService';

  ChatServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ChatRequest, $1.ChatEvent>(
        'Chat',
        chat_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.ChatRequest.fromBuffer(value),
        ($1.ChatEvent value) => value.writeToBuffer()));
  }

  $async.Stream<$1.ChatEvent> chat_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.ChatRequest> $request) async* {
    yield* chat($call, await $request);
  }

  $async.Stream<$1.ChatEvent> chat(
      $grpc.ServiceCall call, $0.ChatRequest request);
}
