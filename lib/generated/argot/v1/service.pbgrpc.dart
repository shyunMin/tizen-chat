// This is a generated file - do not edit.
//
// Generated from argot/v1/service.proto.

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

import 'service.pb.dart' as $0;
import 'types.pb.dart' as $1;

export 'service.pb.dart';

/// ArgotService — single-tenant single-agent daemon.
@$pb.GrpcServiceName('argot.v1.ArgotService')
class ArgotServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ArgotServiceClient(super.channel, {super.options, super.interceptors});

  /// Send a user message to a conversation; receive the final assistant
  /// reply. Conversation history is loaded, the new turn appended, and
  /// assistant output persisted before the response returns.
  $grpc.ResponseFuture<$0.ChatResponse> chat(
    $0.ChatRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$chat, request, options: options);
  }

  /// Same as Chat but yields events as they arrive: streaming token
  /// deltas, tool calls, tool results.
  ///
  /// Stream contract: one SessionOpened, then zero or more
  /// MessageDelta / ToolCall / ToolResult events, terminated by exactly
  /// one TurnDone, TurnTerminated, or TurnError, then end-of-stream.
  $grpc.ResponseStream<$1.ChatEvent> chatStream(
    $0.ChatRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$chatStream, $async.Stream.fromIterable([request]),
        options: options);
  }

  // method descriptors

  static final _$chat = $grpc.ClientMethod<$0.ChatRequest, $0.ChatResponse>(
      '/argot.v1.ArgotService/Chat',
      ($0.ChatRequest value) => value.writeToBuffer(),
      $0.ChatResponse.fromBuffer);
  static final _$chatStream = $grpc.ClientMethod<$0.ChatRequest, $1.ChatEvent>(
      '/argot.v1.ArgotService/ChatStream',
      ($0.ChatRequest value) => value.writeToBuffer(),
      $1.ChatEvent.fromBuffer);
}

@$pb.GrpcServiceName('argot.v1.ArgotService')
abstract class ArgotServiceBase extends $grpc.Service {
  $core.String get $name => 'argot.v1.ArgotService';

  ArgotServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ChatRequest, $0.ChatResponse>(
        'Chat',
        chat_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ChatRequest.fromBuffer(value),
        ($0.ChatResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ChatRequest, $1.ChatEvent>(
        'ChatStream',
        chatStream_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.ChatRequest.fromBuffer(value),
        ($1.ChatEvent value) => value.writeToBuffer()));
  }

  $async.Future<$0.ChatResponse> chat_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.ChatRequest> $request) async {
    return chat($call, await $request);
  }

  $async.Future<$0.ChatResponse> chat(
      $grpc.ServiceCall call, $0.ChatRequest request);

  $async.Stream<$1.ChatEvent> chatStream_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.ChatRequest> $request) async* {
    yield* chatStream($call, await $request);
  }

  $async.Stream<$1.ChatEvent> chatStream(
      $grpc.ServiceCall call, $0.ChatRequest request);
}
