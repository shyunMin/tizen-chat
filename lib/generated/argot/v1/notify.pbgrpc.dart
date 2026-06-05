// This is a generated file - do not edit.
//
// Generated from argot/v1/notify.proto.

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

import 'notify.pb.dart' as $0;

export 'notify.pb.dart';

/// NotificationService — durable, at-least-once, user-facing notifications
/// backed by the Notify Bus: a host.db outbox written before a routine fire
/// returns success, replayed on (re)connect by sequence cursor with a live wake
/// on top. A Notification is a pointer (conversation_id, a deeplink, and a
/// capped summary); the content of record lives in state/argot.db. Delivery is
/// at-least-once; the client dedupes on the notification_id. Like every
/// management RPC these read the bus directly and bypass the gateway kernel.
@$pb.GrpcServiceName('argot.v1.NotificationService')
class NotificationServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  NotificationServiceClient(super.channel, {super.options, super.interceptors});

  /// Long-lived server stream: first replays durable outbox rows with
  /// seq > cursor (oldest-first, surviving daemon restart + client-down
  /// windows), then streams live fires.
  $grpc.ResponseStream<$0.Notification> subscribe(
    $0.SubscribeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$subscribe, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// Advances the per-subscriber_id durable high-watermark so acked rows
  /// aren't replayed and the outbox can be GC'd. Monotonic: a lower seq
  /// never regresses the cursor.
  $grpc.ResponseFuture<$0.AckResponse> ack(
    $0.AckRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$ack, request, options: options);
  }

  // method descriptors

  static final _$subscribe =
      $grpc.ClientMethod<$0.SubscribeRequest, $0.Notification>(
          '/argot.v1.NotificationService/Subscribe',
          ($0.SubscribeRequest value) => value.writeToBuffer(),
          $0.Notification.fromBuffer);
  static final _$ack = $grpc.ClientMethod<$0.AckRequest, $0.AckResponse>(
      '/argot.v1.NotificationService/Ack',
      ($0.AckRequest value) => value.writeToBuffer(),
      $0.AckResponse.fromBuffer);
}

@$pb.GrpcServiceName('argot.v1.NotificationService')
abstract class NotificationServiceBase extends $grpc.Service {
  $core.String get $name => 'argot.v1.NotificationService';

  NotificationServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SubscribeRequest, $0.Notification>(
        'Subscribe',
        subscribe_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.SubscribeRequest.fromBuffer(value),
        ($0.Notification value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AckRequest, $0.AckResponse>(
        'Ack',
        ack_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AckRequest.fromBuffer(value),
        ($0.AckResponse value) => value.writeToBuffer()));
  }

  $async.Stream<$0.Notification> subscribe_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SubscribeRequest> $request) async* {
    yield* subscribe($call, await $request);
  }

  $async.Stream<$0.Notification> subscribe(
      $grpc.ServiceCall call, $0.SubscribeRequest request);

  $async.Future<$0.AckResponse> ack_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.AckRequest> $request) async {
    return ack($call, await $request);
  }

  $async.Future<$0.AckResponse> ack(
      $grpc.ServiceCall call, $0.AckRequest request);
}
