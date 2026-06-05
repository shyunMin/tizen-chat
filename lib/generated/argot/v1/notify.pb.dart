// This is a generated file - do not edit.
//
// Generated from argot/v1/notify.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'notify.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'notify.pbenum.dart';

class SubscribeRequest extends $pb.GeneratedMessage {
  factory SubscribeRequest({
    $fixnum.Int64? cursor,
    $core.String? subscriberId,
  }) {
    final result = create();
    if (cursor != null) result.cursor = cursor;
    if (subscriberId != null) result.subscriberId = subscriberId;
    return result;
  }

  SubscribeRequest._();

  factory SubscribeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubscribeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscribeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'cursor', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'subscriberId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeRequest copyWith(void Function(SubscribeRequest) updates) =>
      super.copyWith((message) => updates(message as SubscribeRequest))
          as SubscribeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubscribeRequest create() => SubscribeRequest._();
  @$core.override
  SubscribeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubscribeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubscribeRequest>(create);
  static SubscribeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get cursor => $_getI64(0);
  @$pb.TagNumber(1)
  set cursor($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCursor() => $_has(0);
  @$pb.TagNumber(1)
  void clearCursor() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get subscriberId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subscriberId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubscriberId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubscriberId() => $_clearField(2);
}

/// One durable notification — a pointer to a conversation, not its content.
class Notification extends $pb.GeneratedMessage {
  factory Notification({
    $fixnum.Int64? seq,
    $core.String? notificationId,
    $core.String? conversationId,
    $core.String? deeplink,
    $core.String? title,
    $core.String? summary,
    $core.String? routineId,
    Severity? severity,
    $fixnum.Int64? createdAtMs,
  }) {
    final result = create();
    if (seq != null) result.seq = seq;
    if (notificationId != null) result.notificationId = notificationId;
    if (conversationId != null) result.conversationId = conversationId;
    if (deeplink != null) result.deeplink = deeplink;
    if (title != null) result.title = title;
    if (summary != null) result.summary = summary;
    if (routineId != null) result.routineId = routineId;
    if (severity != null) result.severity = severity;
    if (createdAtMs != null) result.createdAtMs = createdAtMs;
    return result;
  }

  Notification._();

  factory Notification.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Notification.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Notification',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'seq', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'notificationId')
    ..aOS(3, _omitFieldNames ? '' : 'conversationId')
    ..aOS(4, _omitFieldNames ? '' : 'deeplink')
    ..aOS(5, _omitFieldNames ? '' : 'title')
    ..aOS(6, _omitFieldNames ? '' : 'summary')
    ..aOS(7, _omitFieldNames ? '' : 'routineId')
    ..aE<Severity>(8, _omitFieldNames ? '' : 'severity',
        enumValues: Severity.values)
    ..aInt64(9, _omitFieldNames ? '' : 'createdAtMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notification clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notification copyWith(void Function(Notification) updates) =>
      super.copyWith((message) => updates(message as Notification))
          as Notification;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notification create() => Notification._();
  @$core.override
  Notification createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Notification getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Notification>(create);
  static Notification? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get seq => $_getI64(0);
  @$pb.TagNumber(1)
  set seq($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeq() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeq() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get notificationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set notificationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNotificationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNotificationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get conversationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set conversationId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConversationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearConversationId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get deeplink => $_getSZ(3);
  @$pb.TagNumber(4)
  set deeplink($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDeeplink() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeeplink() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(5)
  set title($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitle() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get summary => $_getSZ(5);
  @$pb.TagNumber(6)
  set summary($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSummary() => $_has(5);
  @$pb.TagNumber(6)
  void clearSummary() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get routineId => $_getSZ(6);
  @$pb.TagNumber(7)
  set routineId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRoutineId() => $_has(6);
  @$pb.TagNumber(7)
  void clearRoutineId() => $_clearField(7);

  @$pb.TagNumber(8)
  Severity get severity => $_getN(7);
  @$pb.TagNumber(8)
  set severity(Severity value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSeverity() => $_has(7);
  @$pb.TagNumber(8)
  void clearSeverity() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get createdAtMs => $_getI64(8);
  @$pb.TagNumber(9)
  set createdAtMs($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedAtMs() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAtMs() => $_clearField(9);
}

class AckRequest extends $pb.GeneratedMessage {
  factory AckRequest({
    $core.String? subscriberId,
    $fixnum.Int64? seq,
  }) {
    final result = create();
    if (subscriberId != null) result.subscriberId = subscriberId;
    if (seq != null) result.seq = seq;
    return result;
  }

  AckRequest._();

  factory AckRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AckRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AckRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'subscriberId')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'seq', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AckRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AckRequest copyWith(void Function(AckRequest) updates) =>
      super.copyWith((message) => updates(message as AckRequest)) as AckRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AckRequest create() => AckRequest._();
  @$core.override
  AckRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AckRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AckRequest>(create);
  static AckRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get subscriberId => $_getSZ(0);
  @$pb.TagNumber(1)
  set subscriberId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSubscriberId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubscriberId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get seq => $_getI64(1);
  @$pb.TagNumber(2)
  set seq($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSeq() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeq() => $_clearField(2);
}

class AckResponse extends $pb.GeneratedMessage {
  factory AckResponse() => create();

  AckResponse._();

  factory AckResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AckResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AckResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AckResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AckResponse copyWith(void Function(AckResponse) updates) =>
      super.copyWith((message) => updates(message as AckResponse))
          as AckResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AckResponse create() => AckResponse._();
  @$core.override
  AckResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AckResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AckResponse>(create);
  static AckResponse? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
