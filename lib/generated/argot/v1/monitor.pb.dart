// This is a generated file - do not edit.
//
// Generated from argot/v1/monitor.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'monitor.pbenum.dart';
import 'types.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'monitor.pbenum.dart';

class GetStatusRequest extends $pb.GeneratedMessage {
  factory GetStatusRequest() => create();

  GetStatusRequest._();

  factory GetStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatusRequest copyWith(void Function(GetStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GetStatusRequest))
          as GetStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStatusRequest create() => GetStatusRequest._();
  @$core.override
  GetStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetStatusRequest>(create);
  static GetStatusRequest? _defaultInstance;
}

class GetStatusResponse extends $pb.GeneratedMessage {
  factory GetStatusResponse({
    $core.bool? ready,
    $core.String? provider,
    $core.String? model,
    $core.String? version,
    $fixnum.Int64? uptimeMs,
    $core.bool? schedulerRunning,
  }) {
    final result = create();
    if (ready != null) result.ready = ready;
    if (provider != null) result.provider = provider;
    if (model != null) result.model = model;
    if (version != null) result.version = version;
    if (uptimeMs != null) result.uptimeMs = uptimeMs;
    if (schedulerRunning != null) result.schedulerRunning = schedulerRunning;
    return result;
  }

  GetStatusResponse._();

  factory GetStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStatusResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'ready')
    ..aOS(2, _omitFieldNames ? '' : 'provider')
    ..aOS(3, _omitFieldNames ? '' : 'model')
    ..aOS(4, _omitFieldNames ? '' : 'version')
    ..aInt64(5, _omitFieldNames ? '' : 'uptimeMs')
    ..aOB(6, _omitFieldNames ? '' : 'schedulerRunning')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatusResponse copyWith(void Function(GetStatusResponse) updates) =>
      super.copyWith((message) => updates(message as GetStatusResponse))
          as GetStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStatusResponse create() => GetStatusResponse._();
  @$core.override
  GetStatusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetStatusResponse>(create);
  static GetStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get ready => $_getBF(0);
  @$pb.TagNumber(1)
  set ready($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReady() => $_has(0);
  @$pb.TagNumber(1)
  void clearReady() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get provider => $_getSZ(1);
  @$pb.TagNumber(2)
  set provider($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProvider() => $_has(1);
  @$pb.TagNumber(2)
  void clearProvider() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get model => $_getSZ(2);
  @$pb.TagNumber(3)
  set model($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasModel() => $_has(2);
  @$pb.TagNumber(3)
  void clearModel() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get version => $_getSZ(3);
  @$pb.TagNumber(4)
  set version($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersion() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get uptimeMs => $_getI64(4);
  @$pb.TagNumber(5)
  set uptimeMs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUptimeMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearUptimeMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get schedulerRunning => $_getBF(5);
  @$pb.TagNumber(6)
  set schedulerRunning($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSchedulerRunning() => $_has(5);
  @$pb.TagNumber(6)
  void clearSchedulerRunning() => $_clearField(6);
}

class WatchRequest extends $pb.GeneratedMessage {
  factory WatchRequest({
    $core.String? conversationId,
    $core.Iterable<EventCategory>? categories,
    $1.ToolDetail? toolDetail,
  }) {
    final result = create();
    if (conversationId != null) result.conversationId = conversationId;
    if (categories != null) result.categories.addAll(categories);
    if (toolDetail != null) result.toolDetail = toolDetail;
    return result;
  }

  WatchRequest._();

  factory WatchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'conversationId')
    ..pc<EventCategory>(
        2, _omitFieldNames ? '' : 'categories', $pb.PbFieldType.KE,
        valueOf: EventCategory.valueOf,
        enumValues: EventCategory.values,
        defaultEnumValue: EventCategory.EVENT_CATEGORY_UNSPECIFIED)
    ..aE<$1.ToolDetail>(3, _omitFieldNames ? '' : 'toolDetail',
        enumValues: $1.ToolDetail.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchRequest copyWith(void Function(WatchRequest) updates) =>
      super.copyWith((message) => updates(message as WatchRequest))
          as WatchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchRequest create() => WatchRequest._();
  @$core.override
  WatchRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchRequest>(create);
  static WatchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get conversationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set conversationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConversationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConversationId() => $_clearField(1);

  /// Server-side filter: the daemon drops events whose category is not in
  /// this set before streaming (empty ⇒ all).
  @$pb.TagNumber(2)
  $pb.PbList<EventCategory> get categories => $_getList(1);

  /// How much tool-result output this subscriber receives. Unset
  /// (TOOL_DETAIL_UNSPECIFIED) means FULL; applied per subscriber — the
  /// observation bus itself keeps full-fidelity events. See types.proto.
  @$pb.TagNumber(3)
  $1.ToolDetail get toolDetail => $_getN(2);
  @$pb.TagNumber(3)
  set toolDetail($1.ToolDetail value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasToolDetail() => $_has(2);
  @$pb.TagNumber(3)
  void clearToolDetail() => $_clearField(3);
}

enum SystemEvent_Event {
  turnStarted,
  chatEvent,
  routineFired,
  status,
  gap,
  notSet
}

class SystemEvent extends $pb.GeneratedMessage {
  factory SystemEvent({
    $fixnum.Int64? seq,
    $fixnum.Int64? occurredAtMs,
    $core.String? conversationId,
    $core.String? origin,
    EventCategory? category,
    TurnStarted? turnStarted,
    $1.ChatEvent? chatEvent,
    RoutineFired? routineFired,
    StatusChanged? status,
    Gap? gap,
  }) {
    final result = create();
    if (seq != null) result.seq = seq;
    if (occurredAtMs != null) result.occurredAtMs = occurredAtMs;
    if (conversationId != null) result.conversationId = conversationId;
    if (origin != null) result.origin = origin;
    if (category != null) result.category = category;
    if (turnStarted != null) result.turnStarted = turnStarted;
    if (chatEvent != null) result.chatEvent = chatEvent;
    if (routineFired != null) result.routineFired = routineFired;
    if (status != null) result.status = status;
    if (gap != null) result.gap = gap;
    return result;
  }

  SystemEvent._();

  factory SystemEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SystemEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SystemEvent_Event> _SystemEvent_EventByTag =
      {
    10: SystemEvent_Event.turnStarted,
    11: SystemEvent_Event.chatEvent,
    12: SystemEvent_Event.routineFired,
    13: SystemEvent_Event.status,
    14: SystemEvent_Event.gap,
    0: SystemEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SystemEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..oo(0, [10, 11, 12, 13, 14])
    ..aInt64(1, _omitFieldNames ? '' : 'seq')
    ..aInt64(2, _omitFieldNames ? '' : 'occurredAtMs')
    ..aOS(3, _omitFieldNames ? '' : 'conversationId')
    ..aOS(4, _omitFieldNames ? '' : 'origin')
    ..aE<EventCategory>(5, _omitFieldNames ? '' : 'category',
        enumValues: EventCategory.values)
    ..aOM<TurnStarted>(10, _omitFieldNames ? '' : 'turnStarted',
        subBuilder: TurnStarted.create)
    ..aOM<$1.ChatEvent>(11, _omitFieldNames ? '' : 'chatEvent',
        subBuilder: $1.ChatEvent.create)
    ..aOM<RoutineFired>(12, _omitFieldNames ? '' : 'routineFired',
        subBuilder: RoutineFired.create)
    ..aOM<StatusChanged>(13, _omitFieldNames ? '' : 'status',
        subBuilder: StatusChanged.create)
    ..aOM<Gap>(14, _omitFieldNames ? '' : 'gap', subBuilder: Gap.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SystemEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SystemEvent copyWith(void Function(SystemEvent) updates) =>
      super.copyWith((message) => updates(message as SystemEvent))
          as SystemEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SystemEvent create() => SystemEvent._();
  @$core.override
  SystemEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SystemEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SystemEvent>(create);
  static SystemEvent? _defaultInstance;

  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  SystemEvent_Event whichEvent() => _SystemEvent_EventByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  void clearEvent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get seq => $_getI64(0);
  @$pb.TagNumber(1)
  set seq($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeq() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeq() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get occurredAtMs => $_getI64(1);
  @$pb.TagNumber(2)
  set occurredAtMs($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOccurredAtMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearOccurredAtMs() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get conversationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set conversationId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConversationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearConversationId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get origin => $_getSZ(3);
  @$pb.TagNumber(4)
  set origin($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOrigin() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrigin() => $_clearField(4);

  @$pb.TagNumber(5)
  EventCategory get category => $_getN(4);
  @$pb.TagNumber(5)
  set category(EventCategory value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCategory() => $_has(4);
  @$pb.TagNumber(5)
  void clearCategory() => $_clearField(5);

  @$pb.TagNumber(10)
  TurnStarted get turnStarted => $_getN(5);
  @$pb.TagNumber(10)
  set turnStarted(TurnStarted value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasTurnStarted() => $_has(5);
  @$pb.TagNumber(10)
  void clearTurnStarted() => $_clearField(10);
  @$pb.TagNumber(10)
  TurnStarted ensureTurnStarted() => $_ensure(5);

  /// The same ChatEvent shape carried on ChatService.Chat, re-emitted on
  /// the observation bus: MessageDelta / ToolCall / ToolResult /
  /// AgentProgress plus the terminal Completed / Failed. (Stopped exists
  /// in the schema but is not emitted today.)
  @$pb.TagNumber(11)
  $1.ChatEvent get chatEvent => $_getN(6);
  @$pb.TagNumber(11)
  set chatEvent($1.ChatEvent value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasChatEvent() => $_has(6);
  @$pb.TagNumber(11)
  void clearChatEvent() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.ChatEvent ensureChatEvent() => $_ensure(6);

  @$pb.TagNumber(12)
  RoutineFired get routineFired => $_getN(7);
  @$pb.TagNumber(12)
  set routineFired(RoutineFired value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasRoutineFired() => $_has(7);
  @$pb.TagNumber(12)
  void clearRoutineFired() => $_clearField(12);
  @$pb.TagNumber(12)
  RoutineFired ensureRoutineFired() => $_ensure(7);

  @$pb.TagNumber(13)
  StatusChanged get status => $_getN(8);
  @$pb.TagNumber(13)
  set status(StatusChanged value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasStatus() => $_has(8);
  @$pb.TagNumber(13)
  void clearStatus() => $_clearField(13);
  @$pb.TagNumber(13)
  StatusChanged ensureStatus() => $_ensure(8);

  /// Best-effort gap marker: the daemon's per-subscriber broadcast buffer
  /// overflowed and `missed` events were dropped before this point. The
  /// stream continues; a dashboard reconciles via GetHistory. Synthesised
  /// per-subscriber on overflow, never published to the bus.
  @$pb.TagNumber(14)
  Gap get gap => $_getN(9);
  @$pb.TagNumber(14)
  set gap(Gap value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasGap() => $_has(9);
  @$pb.TagNumber(14)
  void clearGap() => $_clearField(14);
  @$pb.TagNumber(14)
  Gap ensureGap() => $_ensure(9);
}

/// A single agent turn began on `conversation_id` — a turn-lifecycle marker
/// for observers (a dashboard tail). `turn` is the operational unit of agent
/// activity here; it is not the user-facing conversation surface.
class TurnStarted extends $pb.GeneratedMessage {
  factory TurnStarted({
    $core.String? conversationId,
    $core.bool? ephemeral,
  }) {
    final result = create();
    if (conversationId != null) result.conversationId = conversationId;
    if (ephemeral != null) result.ephemeral = ephemeral;
    return result;
  }

  TurnStarted._();

  factory TurnStarted.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TurnStarted.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TurnStarted',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'conversationId')
    ..aOB(2, _omitFieldNames ? '' : 'ephemeral')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnStarted clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnStarted copyWith(void Function(TurnStarted) updates) =>
      super.copyWith((message) => updates(message as TurnStarted))
          as TurnStarted;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TurnStarted create() => TurnStarted._();
  @$core.override
  TurnStarted createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TurnStarted getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TurnStarted>(create);
  static TurnStarted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get conversationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set conversationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConversationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConversationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get ephemeral => $_getBF(1);
  @$pb.TagNumber(2)
  set ephemeral($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEphemeral() => $_has(1);
  @$pb.TagNumber(2)
  void clearEphemeral() => $_clearField(2);
}

class RoutineFired extends $pb.GeneratedMessage {
  factory RoutineFired({
    $core.String? routineId,
    $core.String? name,
    $core.String? action,
    $core.bool? ok,
    $core.String? detail,
  }) {
    final result = create();
    if (routineId != null) result.routineId = routineId;
    if (name != null) result.name = name;
    if (action != null) result.action = action;
    if (ok != null) result.ok = ok;
    if (detail != null) result.detail = detail;
    return result;
  }

  RoutineFired._();

  factory RoutineFired.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoutineFired.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoutineFired',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'routineId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'action')
    ..aOB(4, _omitFieldNames ? '' : 'ok')
    ..aOS(5, _omitFieldNames ? '' : 'detail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoutineFired clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoutineFired copyWith(void Function(RoutineFired) updates) =>
      super.copyWith((message) => updates(message as RoutineFired))
          as RoutineFired;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoutineFired create() => RoutineFired._();
  @$core.override
  RoutineFired createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoutineFired getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoutineFired>(create);
  static RoutineFired? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get routineId => $_getSZ(0);
  @$pb.TagNumber(1)
  set routineId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoutineId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoutineId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get action => $_getSZ(2);
  @$pb.TagNumber(3)
  set action($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAction() => $_has(2);
  @$pb.TagNumber(3)
  void clearAction() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get ok => $_getBF(3);
  @$pb.TagNumber(4)
  set ok($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOk() => $_has(3);
  @$pb.TagNumber(4)
  void clearOk() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get detail => $_getSZ(4);
  @$pb.TagNumber(5)
  set detail($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDetail() => $_has(4);
  @$pb.TagNumber(5)
  void clearDetail() => $_clearField(5);
}

class StatusChanged extends $pb.GeneratedMessage {
  factory StatusChanged({
    $core.bool? ready,
    $core.bool? schedulerRunning,
    $core.String? provider,
    $core.String? model,
  }) {
    final result = create();
    if (ready != null) result.ready = ready;
    if (schedulerRunning != null) result.schedulerRunning = schedulerRunning;
    if (provider != null) result.provider = provider;
    if (model != null) result.model = model;
    return result;
  }

  StatusChanged._();

  factory StatusChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StatusChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StatusChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'ready')
    ..aOB(2, _omitFieldNames ? '' : 'schedulerRunning')
    ..aOS(3, _omitFieldNames ? '' : 'provider')
    ..aOS(4, _omitFieldNames ? '' : 'model')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatusChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatusChanged copyWith(void Function(StatusChanged) updates) =>
      super.copyWith((message) => updates(message as StatusChanged))
          as StatusChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StatusChanged create() => StatusChanged._();
  @$core.override
  StatusChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StatusChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StatusChanged>(create);
  static StatusChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get ready => $_getBF(0);
  @$pb.TagNumber(1)
  set ready($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReady() => $_has(0);
  @$pb.TagNumber(1)
  void clearReady() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get schedulerRunning => $_getBF(1);
  @$pb.TagNumber(2)
  set schedulerRunning($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSchedulerRunning() => $_has(1);
  @$pb.TagNumber(2)
  void clearSchedulerRunning() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get provider => $_getSZ(2);
  @$pb.TagNumber(3)
  set provider($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProvider() => $_has(2);
  @$pb.TagNumber(3)
  void clearProvider() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get model => $_getSZ(3);
  @$pb.TagNumber(4)
  set model($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasModel() => $_has(3);
  @$pb.TagNumber(4)
  void clearModel() => $_clearField(4);
}

/// Best-effort overflow marker (see SystemEvent.gap): `missed` events were
/// dropped for this subscriber before the next delivered event.
class Gap extends $pb.GeneratedMessage {
  factory Gap({
    $fixnum.Int64? missed,
  }) {
    final result = create();
    if (missed != null) result.missed = missed;
    return result;
  }

  Gap._();

  factory Gap.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Gap.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Gap',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'missed', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Gap clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Gap copyWith(void Function(Gap) updates) =>
      super.copyWith((message) => updates(message as Gap)) as Gap;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Gap create() => Gap._();
  @$core.override
  Gap createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Gap getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Gap>(create);
  static Gap? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get missed => $_getI64(0);
  @$pb.TagNumber(1)
  set missed($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMissed() => $_has(0);
  @$pb.TagNumber(1)
  void clearMissed() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
