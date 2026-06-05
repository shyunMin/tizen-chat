// This is a generated file - do not edit.
//
// Generated from argot/v1/conversation.proto.

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

import 'conversation.pb.dart' as $0;

export 'conversation.pb.dart';

/// ConversationService — conversation management + history replay. Named for the
/// durable artifact it manages: the conversation (state/argot.db transcript row),
/// distinct from the internal host.db live-session pool. All RPCs read AppState
/// stores directly and bypass the gateway kernel.
@$pb.GrpcServiceName('argot.v1.ConversationService')
class ConversationServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ConversationServiceClient(super.channel, {super.options, super.interceptors});

  /// Enumerate conversations, newest first. Routine-fired conversations are
  /// excluded unless include_routines is set.
  $grpc.ResponseFuture<$0.ListConversationsResponse> listConversations(
    $0.ListConversationsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listConversations, request, options: options);
  }

  /// Metadata for one conversation (deeplink header) without paging history.
  $grpc.ResponseFuture<$0.ConversationInfo> getConversation(
    $0.GetConversationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getConversation, request, options: options);
  }

  /// Page a conversation's messages, oldest->newest within the page.
  $grpc.ResponseFuture<$0.GetHistoryResponse> getHistory(
    $0.GetHistoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getHistory, request, options: options);
  }

  /// Archive (reversible) or purge (irreversible) a conversation.
  $grpc.ResponseFuture<$0.DeleteConversationResponse> deleteConversation(
    $0.DeleteConversationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteConversation, request, options: options);
  }

  // method descriptors

  static final _$listConversations = $grpc.ClientMethod<
          $0.ListConversationsRequest, $0.ListConversationsResponse>(
      '/argot.v1.ConversationService/ListConversations',
      ($0.ListConversationsRequest value) => value.writeToBuffer(),
      $0.ListConversationsResponse.fromBuffer);
  static final _$getConversation =
      $grpc.ClientMethod<$0.GetConversationRequest, $0.ConversationInfo>(
          '/argot.v1.ConversationService/GetConversation',
          ($0.GetConversationRequest value) => value.writeToBuffer(),
          $0.ConversationInfo.fromBuffer);
  static final _$getHistory =
      $grpc.ClientMethod<$0.GetHistoryRequest, $0.GetHistoryResponse>(
          '/argot.v1.ConversationService/GetHistory',
          ($0.GetHistoryRequest value) => value.writeToBuffer(),
          $0.GetHistoryResponse.fromBuffer);
  static final _$deleteConversation = $grpc.ClientMethod<
          $0.DeleteConversationRequest, $0.DeleteConversationResponse>(
      '/argot.v1.ConversationService/DeleteConversation',
      ($0.DeleteConversationRequest value) => value.writeToBuffer(),
      $0.DeleteConversationResponse.fromBuffer);
}

@$pb.GrpcServiceName('argot.v1.ConversationService')
abstract class ConversationServiceBase extends $grpc.Service {
  $core.String get $name => 'argot.v1.ConversationService';

  ConversationServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ListConversationsRequest,
            $0.ListConversationsResponse>(
        'ListConversations',
        listConversations_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListConversationsRequest.fromBuffer(value),
        ($0.ListConversationsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetConversationRequest, $0.ConversationInfo>(
            'GetConversation',
            getConversation_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetConversationRequest.fromBuffer(value),
            ($0.ConversationInfo value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetHistoryRequest, $0.GetHistoryResponse>(
        'GetHistory',
        getHistory_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetHistoryRequest.fromBuffer(value),
        ($0.GetHistoryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteConversationRequest,
            $0.DeleteConversationResponse>(
        'DeleteConversation',
        deleteConversation_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteConversationRequest.fromBuffer(value),
        ($0.DeleteConversationResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListConversationsResponse> listConversations_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListConversationsRequest> $request) async {
    return listConversations($call, await $request);
  }

  $async.Future<$0.ListConversationsResponse> listConversations(
      $grpc.ServiceCall call, $0.ListConversationsRequest request);

  $async.Future<$0.ConversationInfo> getConversation_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetConversationRequest> $request) async {
    return getConversation($call, await $request);
  }

  $async.Future<$0.ConversationInfo> getConversation(
      $grpc.ServiceCall call, $0.GetConversationRequest request);

  $async.Future<$0.GetHistoryResponse> getHistory_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetHistoryRequest> $request) async {
    return getHistory($call, await $request);
  }

  $async.Future<$0.GetHistoryResponse> getHistory(
      $grpc.ServiceCall call, $0.GetHistoryRequest request);

  $async.Future<$0.DeleteConversationResponse> deleteConversation_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteConversationRequest> $request) async {
    return deleteConversation($call, await $request);
  }

  $async.Future<$0.DeleteConversationResponse> deleteConversation(
      $grpc.ServiceCall call, $0.DeleteConversationRequest request);
}
