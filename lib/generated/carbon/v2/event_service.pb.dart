// This is a generated file - do not edit.
//
// Generated from carbon/v2/event_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $1;
import 'event_service.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'event_service.pbenum.dart';

class SubscribeRequest extends $pb.GeneratedMessage {
  factory SubscribeRequest({
    $core.Iterable<$core.String>? sessionIds,
    EventFilter? filter,
    $core.String? resumeFrom,
  }) {
    final result = create();
    if (sessionIds != null) result.sessionIds.addAll(sessionIds);
    if (filter != null) result.filter = filter;
    if (resumeFrom != null) result.resumeFrom = resumeFrom;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'sessionIds')
    ..aOM<EventFilter>(2, _omitFieldNames ? '' : 'filter',
        subBuilder: EventFilter.create)
    ..aOS(3, _omitFieldNames ? '' : 'resumeFrom')
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

  /// One or more sessions. Empty = all sessions visible to this caller.
  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get sessionIds => $_getList(0);

  @$pb.TagNumber(2)
  EventFilter get filter => $_getN(1);
  @$pb.TagNumber(2)
  set filter(EventFilter value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearFilter() => $_clearField(2);
  @$pb.TagNumber(2)
  EventFilter ensureFilter() => $_ensure(1);

  /// Cursor. Single-session subscribe only — must be empty when
  /// session_ids has 0 or ≥2 entries (see RFC 0007 §Cursor scope).
  ///   ""        = live tail
  ///   "begin"   = full session replay
  ///   "<id>"    = resume from this event_id (exclusive)
  @$pb.TagNumber(3)
  $core.String get resumeFrom => $_getSZ(2);
  @$pb.TagNumber(3)
  set resumeFrom($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasResumeFrom() => $_has(2);
  @$pb.TagNumber(3)
  void clearResumeFrom() => $_clearField(3);
}

class EventFilter extends $pb.GeneratedMessage {
  factory EventFilter({
    $core.Iterable<EventKind>? kinds,
    $core.Iterable<$core.String>? threadIds,
    $core.Iterable<$core.String>? turnIds,
  }) {
    final result = create();
    if (kinds != null) result.kinds.addAll(kinds);
    if (threadIds != null) result.threadIds.addAll(threadIds);
    if (turnIds != null) result.turnIds.addAll(turnIds);
    return result;
  }

  EventFilter._();

  factory EventFilter.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EventFilter.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EventFilter',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..pc<EventKind>(1, _omitFieldNames ? '' : 'kinds', $pb.PbFieldType.KE,
        valueOf: EventKind.valueOf,
        enumValues: EventKind.values,
        defaultEnumValue: EventKind.EVENT_KIND_UNSPECIFIED)
    ..pPS(2, _omitFieldNames ? '' : 'threadIds')
    ..pPS(3, _omitFieldNames ? '' : 'turnIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EventFilter clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EventFilter copyWith(void Function(EventFilter) updates) =>
      super.copyWith((message) => updates(message as EventFilter))
          as EventFilter;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EventFilter create() => EventFilter._();
  @$core.override
  EventFilter createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EventFilter getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EventFilter>(create);
  static EventFilter? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<EventKind> get kinds => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get threadIds => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get turnIds => $_getList(2);
}

class Event extends $pb.GeneratedMessage {
  factory Event({
    $core.String? sessionId,
    $core.String? eventId,
    EventBody? body,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (eventId != null) result.eventId = eventId;
    if (body != null) result.body = body;
    return result;
  }

  Event._();

  factory Event.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Event.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Event',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'eventId')
    ..aOM<EventBody>(3, _omitFieldNames ? '' : 'body',
        subBuilder: EventBody.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Event clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Event copyWith(void Function(Event) updates) =>
      super.copyWith((message) => updates(message as Event)) as Event;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Event create() => Event._();
  @$core.override
  Event createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Event getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Event>(create);
  static Event? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  /// Per-session monotonic. Durable across daemon restarts (JSONL-backed).
  @$pb.TagNumber(2)
  $core.String get eventId => $_getSZ(1);
  @$pb.TagNumber(2)
  set eventId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEventId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEventId() => $_clearField(2);

  @$pb.TagNumber(3)
  EventBody get body => $_getN(2);
  @$pb.TagNumber(3)
  set body(EventBody value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBody() => $_has(2);
  @$pb.TagNumber(3)
  void clearBody() => $_clearField(3);
  @$pb.TagNumber(3)
  EventBody ensureBody() => $_ensure(2);
}

enum EventBody_Body {
  turnStarted,
  turnCompleted,
  messageDelta,
  messageFinalized,
  toolUseStart,
  toolResult,
  toolApprovalRequest,
  threadStarted,
  threadCompleted,
  sessionEnded,
  scheduleChanged,
  subAgentSpawned,
  subAgentCompleted,
  steerApplied,
  steerFailed,
  error,
  notSet
}

class EventBody extends $pb.GeneratedMessage {
  factory EventBody({
    TurnStarted? turnStarted,
    TurnCompleted? turnCompleted,
    MessageDelta? messageDelta,
    MessageFinalized? messageFinalized,
    ToolUseStart? toolUseStart,
    ToolResult? toolResult,
    ToolApprovalRequest? toolApprovalRequest,
    ThreadStarted? threadStarted,
    ThreadCompleted? threadCompleted,
    SessionEnded? sessionEnded,
    ScheduleChanged? scheduleChanged,
    SubAgentSpawned? subAgentSpawned,
    SubAgentCompleted? subAgentCompleted,
    SteerApplied? steerApplied,
    SteerFailed? steerFailed,
    Error? error,
  }) {
    final result = create();
    if (turnStarted != null) result.turnStarted = turnStarted;
    if (turnCompleted != null) result.turnCompleted = turnCompleted;
    if (messageDelta != null) result.messageDelta = messageDelta;
    if (messageFinalized != null) result.messageFinalized = messageFinalized;
    if (toolUseStart != null) result.toolUseStart = toolUseStart;
    if (toolResult != null) result.toolResult = toolResult;
    if (toolApprovalRequest != null)
      result.toolApprovalRequest = toolApprovalRequest;
    if (threadStarted != null) result.threadStarted = threadStarted;
    if (threadCompleted != null) result.threadCompleted = threadCompleted;
    if (sessionEnded != null) result.sessionEnded = sessionEnded;
    if (scheduleChanged != null) result.scheduleChanged = scheduleChanged;
    if (subAgentSpawned != null) result.subAgentSpawned = subAgentSpawned;
    if (subAgentCompleted != null) result.subAgentCompleted = subAgentCompleted;
    if (steerApplied != null) result.steerApplied = steerApplied;
    if (steerFailed != null) result.steerFailed = steerFailed;
    if (error != null) result.error = error;
    return result;
  }

  EventBody._();

  factory EventBody.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EventBody.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, EventBody_Body> _EventBody_BodyByTag = {
    1: EventBody_Body.turnStarted,
    2: EventBody_Body.turnCompleted,
    3: EventBody_Body.messageDelta,
    4: EventBody_Body.messageFinalized,
    5: EventBody_Body.toolUseStart,
    6: EventBody_Body.toolResult,
    7: EventBody_Body.toolApprovalRequest,
    8: EventBody_Body.threadStarted,
    9: EventBody_Body.threadCompleted,
    10: EventBody_Body.sessionEnded,
    11: EventBody_Body.scheduleChanged,
    12: EventBody_Body.subAgentSpawned,
    13: EventBody_Body.subAgentCompleted,
    14: EventBody_Body.steerApplied,
    15: EventBody_Body.steerFailed,
    16: EventBody_Body.error,
    0: EventBody_Body.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EventBody',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16])
    ..aOM<TurnStarted>(1, _omitFieldNames ? '' : 'turnStarted',
        subBuilder: TurnStarted.create)
    ..aOM<TurnCompleted>(2, _omitFieldNames ? '' : 'turnCompleted',
        subBuilder: TurnCompleted.create)
    ..aOM<MessageDelta>(3, _omitFieldNames ? '' : 'messageDelta',
        subBuilder: MessageDelta.create)
    ..aOM<MessageFinalized>(4, _omitFieldNames ? '' : 'messageFinalized',
        subBuilder: MessageFinalized.create)
    ..aOM<ToolUseStart>(5, _omitFieldNames ? '' : 'toolUseStart',
        subBuilder: ToolUseStart.create)
    ..aOM<ToolResult>(6, _omitFieldNames ? '' : 'toolResult',
        subBuilder: ToolResult.create)
    ..aOM<ToolApprovalRequest>(7, _omitFieldNames ? '' : 'toolApprovalRequest',
        subBuilder: ToolApprovalRequest.create)
    ..aOM<ThreadStarted>(8, _omitFieldNames ? '' : 'threadStarted',
        subBuilder: ThreadStarted.create)
    ..aOM<ThreadCompleted>(9, _omitFieldNames ? '' : 'threadCompleted',
        subBuilder: ThreadCompleted.create)
    ..aOM<SessionEnded>(10, _omitFieldNames ? '' : 'sessionEnded',
        subBuilder: SessionEnded.create)
    ..aOM<ScheduleChanged>(11, _omitFieldNames ? '' : 'scheduleChanged',
        subBuilder: ScheduleChanged.create)
    ..aOM<SubAgentSpawned>(12, _omitFieldNames ? '' : 'subAgentSpawned',
        subBuilder: SubAgentSpawned.create)
    ..aOM<SubAgentCompleted>(13, _omitFieldNames ? '' : 'subAgentCompleted',
        subBuilder: SubAgentCompleted.create)
    ..aOM<SteerApplied>(14, _omitFieldNames ? '' : 'steerApplied',
        subBuilder: SteerApplied.create)
    ..aOM<SteerFailed>(15, _omitFieldNames ? '' : 'steerFailed',
        subBuilder: SteerFailed.create)
    ..aOM<Error>(16, _omitFieldNames ? '' : 'error', subBuilder: Error.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EventBody clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EventBody copyWith(void Function(EventBody) updates) =>
      super.copyWith((message) => updates(message as EventBody)) as EventBody;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EventBody create() => EventBody._();
  @$core.override
  EventBody createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EventBody getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventBody>(create);
  static EventBody? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  EventBody_Body whichBody() => _EventBody_BodyByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  void clearBody() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  TurnStarted get turnStarted => $_getN(0);
  @$pb.TagNumber(1)
  set turnStarted(TurnStarted value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTurnStarted() => $_has(0);
  @$pb.TagNumber(1)
  void clearTurnStarted() => $_clearField(1);
  @$pb.TagNumber(1)
  TurnStarted ensureTurnStarted() => $_ensure(0);

  @$pb.TagNumber(2)
  TurnCompleted get turnCompleted => $_getN(1);
  @$pb.TagNumber(2)
  set turnCompleted(TurnCompleted value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTurnCompleted() => $_has(1);
  @$pb.TagNumber(2)
  void clearTurnCompleted() => $_clearField(2);
  @$pb.TagNumber(2)
  TurnCompleted ensureTurnCompleted() => $_ensure(1);

  @$pb.TagNumber(3)
  MessageDelta get messageDelta => $_getN(2);
  @$pb.TagNumber(3)
  set messageDelta(MessageDelta value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMessageDelta() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessageDelta() => $_clearField(3);
  @$pb.TagNumber(3)
  MessageDelta ensureMessageDelta() => $_ensure(2);

  @$pb.TagNumber(4)
  MessageFinalized get messageFinalized => $_getN(3);
  @$pb.TagNumber(4)
  set messageFinalized(MessageFinalized value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMessageFinalized() => $_has(3);
  @$pb.TagNumber(4)
  void clearMessageFinalized() => $_clearField(4);
  @$pb.TagNumber(4)
  MessageFinalized ensureMessageFinalized() => $_ensure(3);

  @$pb.TagNumber(5)
  ToolUseStart get toolUseStart => $_getN(4);
  @$pb.TagNumber(5)
  set toolUseStart(ToolUseStart value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasToolUseStart() => $_has(4);
  @$pb.TagNumber(5)
  void clearToolUseStart() => $_clearField(5);
  @$pb.TagNumber(5)
  ToolUseStart ensureToolUseStart() => $_ensure(4);

  @$pb.TagNumber(6)
  ToolResult get toolResult => $_getN(5);
  @$pb.TagNumber(6)
  set toolResult(ToolResult value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasToolResult() => $_has(5);
  @$pb.TagNumber(6)
  void clearToolResult() => $_clearField(6);
  @$pb.TagNumber(6)
  ToolResult ensureToolResult() => $_ensure(5);

  @$pb.TagNumber(7)
  ToolApprovalRequest get toolApprovalRequest => $_getN(6);
  @$pb.TagNumber(7)
  set toolApprovalRequest(ToolApprovalRequest value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasToolApprovalRequest() => $_has(6);
  @$pb.TagNumber(7)
  void clearToolApprovalRequest() => $_clearField(7);
  @$pb.TagNumber(7)
  ToolApprovalRequest ensureToolApprovalRequest() => $_ensure(6);

  @$pb.TagNumber(8)
  ThreadStarted get threadStarted => $_getN(7);
  @$pb.TagNumber(8)
  set threadStarted(ThreadStarted value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasThreadStarted() => $_has(7);
  @$pb.TagNumber(8)
  void clearThreadStarted() => $_clearField(8);
  @$pb.TagNumber(8)
  ThreadStarted ensureThreadStarted() => $_ensure(7);

  @$pb.TagNumber(9)
  ThreadCompleted get threadCompleted => $_getN(8);
  @$pb.TagNumber(9)
  set threadCompleted(ThreadCompleted value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasThreadCompleted() => $_has(8);
  @$pb.TagNumber(9)
  void clearThreadCompleted() => $_clearField(9);
  @$pb.TagNumber(9)
  ThreadCompleted ensureThreadCompleted() => $_ensure(8);

  @$pb.TagNumber(10)
  SessionEnded get sessionEnded => $_getN(9);
  @$pb.TagNumber(10)
  set sessionEnded(SessionEnded value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasSessionEnded() => $_has(9);
  @$pb.TagNumber(10)
  void clearSessionEnded() => $_clearField(10);
  @$pb.TagNumber(10)
  SessionEnded ensureSessionEnded() => $_ensure(9);

  @$pb.TagNumber(11)
  ScheduleChanged get scheduleChanged => $_getN(10);
  @$pb.TagNumber(11)
  set scheduleChanged(ScheduleChanged value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasScheduleChanged() => $_has(10);
  @$pb.TagNumber(11)
  void clearScheduleChanged() => $_clearField(11);
  @$pb.TagNumber(11)
  ScheduleChanged ensureScheduleChanged() => $_ensure(10);

  @$pb.TagNumber(12)
  SubAgentSpawned get subAgentSpawned => $_getN(11);
  @$pb.TagNumber(12)
  set subAgentSpawned(SubAgentSpawned value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasSubAgentSpawned() => $_has(11);
  @$pb.TagNumber(12)
  void clearSubAgentSpawned() => $_clearField(12);
  @$pb.TagNumber(12)
  SubAgentSpawned ensureSubAgentSpawned() => $_ensure(11);

  @$pb.TagNumber(13)
  SubAgentCompleted get subAgentCompleted => $_getN(12);
  @$pb.TagNumber(13)
  set subAgentCompleted(SubAgentCompleted value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasSubAgentCompleted() => $_has(12);
  @$pb.TagNumber(13)
  void clearSubAgentCompleted() => $_clearField(13);
  @$pb.TagNumber(13)
  SubAgentCompleted ensureSubAgentCompleted() => $_ensure(12);

  @$pb.TagNumber(14)
  SteerApplied get steerApplied => $_getN(13);
  @$pb.TagNumber(14)
  set steerApplied(SteerApplied value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasSteerApplied() => $_has(13);
  @$pb.TagNumber(14)
  void clearSteerApplied() => $_clearField(14);
  @$pb.TagNumber(14)
  SteerApplied ensureSteerApplied() => $_ensure(13);

  @$pb.TagNumber(15)
  SteerFailed get steerFailed => $_getN(14);
  @$pb.TagNumber(15)
  set steerFailed(SteerFailed value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasSteerFailed() => $_has(14);
  @$pb.TagNumber(15)
  void clearSteerFailed() => $_clearField(15);
  @$pb.TagNumber(15)
  SteerFailed ensureSteerFailed() => $_ensure(14);

  @$pb.TagNumber(16)
  Error get error => $_getN(15);
  @$pb.TagNumber(16)
  set error(Error value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasError() => $_has(15);
  @$pb.TagNumber(16)
  void clearError() => $_clearField(16);
  @$pb.TagNumber(16)
  Error ensureError() => $_ensure(15);
}

class TurnStarted extends $pb.GeneratedMessage {
  factory TurnStarted({
    $core.String? turnId,
    $core.String? threadId,
    $core.String? source,
    $core.String? clientRequestId,
    $core.String? prompt,
  }) {
    final result = create();
    if (turnId != null) result.turnId = turnId;
    if (threadId != null) result.threadId = threadId;
    if (source != null) result.source = source;
    if (clientRequestId != null) result.clientRequestId = clientRequestId;
    if (prompt != null) result.prompt = prompt;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'turnId')
    ..aOS(2, _omitFieldNames ? '' : 'threadId')
    ..aOS(3, _omitFieldNames ? '' : 'source')
    ..aOS(4, _omitFieldNames ? '' : 'clientRequestId')
    ..aOS(5, _omitFieldNames ? '' : 'prompt')
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
  $core.String get turnId => $_getSZ(0);
  @$pb.TagNumber(1)
  set turnId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTurnId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTurnId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);

  /// Source label of the trigger (e.g. "grpc", "schedule:<id>", "telegram",
  /// "sub-agent-result").
  @$pb.TagNumber(3)
  $core.String get source => $_getSZ(2);
  @$pb.TagNumber(3)
  set source($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => $_clearField(3);

  /// Echoed for Submit correlation; empty for non-ingress-originated turns.
  @$pb.TagNumber(4)
  $core.String get clientRequestId => $_getSZ(3);
  @$pb.TagNumber(4)
  set clientRequestId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasClientRequestId() => $_has(3);
  @$pb.TagNumber(4)
  void clearClientRequestId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get prompt => $_getSZ(4);
  @$pb.TagNumber(5)
  set prompt($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPrompt() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrompt() => $_clearField(5);
}

class TurnCompleted extends $pb.GeneratedMessage {
  factory TurnCompleted({
    $core.String? turnId,
    $1.Usage? usage,
  }) {
    final result = create();
    if (turnId != null) result.turnId = turnId;
    if (usage != null) result.usage = usage;
    return result;
  }

  TurnCompleted._();

  factory TurnCompleted.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TurnCompleted.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TurnCompleted',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'turnId')
    ..aOM<$1.Usage>(2, _omitFieldNames ? '' : 'usage',
        subBuilder: $1.Usage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnCompleted clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnCompleted copyWith(void Function(TurnCompleted) updates) =>
      super.copyWith((message) => updates(message as TurnCompleted))
          as TurnCompleted;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TurnCompleted create() => TurnCompleted._();
  @$core.override
  TurnCompleted createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TurnCompleted getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TurnCompleted>(create);
  static TurnCompleted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get turnId => $_getSZ(0);
  @$pb.TagNumber(1)
  set turnId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTurnId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTurnId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Usage get usage => $_getN(1);
  @$pb.TagNumber(2)
  set usage($1.Usage value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUsage() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsage() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Usage ensureUsage() => $_ensure(1);
}

class MessageDelta extends $pb.GeneratedMessage {
  factory MessageDelta({
    $core.String? turnId,
    $core.String? itemId,
    $core.String? content,
  }) {
    final result = create();
    if (turnId != null) result.turnId = turnId;
    if (itemId != null) result.itemId = itemId;
    if (content != null) result.content = content;
    return result;
  }

  MessageDelta._();

  factory MessageDelta.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageDelta.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MessageDelta',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'turnId')
    ..aOS(2, _omitFieldNames ? '' : 'itemId')
    ..aOS(3, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageDelta clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageDelta copyWith(void Function(MessageDelta) updates) =>
      super.copyWith((message) => updates(message as MessageDelta))
          as MessageDelta;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageDelta create() => MessageDelta._();
  @$core.override
  MessageDelta createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageDelta getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MessageDelta>(create);
  static MessageDelta? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get turnId => $_getSZ(0);
  @$pb.TagNumber(1)
  set turnId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTurnId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTurnId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get content => $_getSZ(2);
  @$pb.TagNumber(3)
  set content($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => $_clearField(3);
}

class MessageFinalized extends $pb.GeneratedMessage {
  factory MessageFinalized({
    $core.String? turnId,
    $core.String? itemId,
    AssistantMessagePhase? phase,
  }) {
    final result = create();
    if (turnId != null) result.turnId = turnId;
    if (itemId != null) result.itemId = itemId;
    if (phase != null) result.phase = phase;
    return result;
  }

  MessageFinalized._();

  factory MessageFinalized.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageFinalized.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MessageFinalized',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'turnId')
    ..aOS(2, _omitFieldNames ? '' : 'itemId')
    ..aE<AssistantMessagePhase>(3, _omitFieldNames ? '' : 'phase',
        enumValues: AssistantMessagePhase.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageFinalized clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageFinalized copyWith(void Function(MessageFinalized) updates) =>
      super.copyWith((message) => updates(message as MessageFinalized))
          as MessageFinalized;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageFinalized create() => MessageFinalized._();
  @$core.override
  MessageFinalized createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageFinalized getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MessageFinalized>(create);
  static MessageFinalized? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get turnId => $_getSZ(0);
  @$pb.TagNumber(1)
  set turnId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTurnId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTurnId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  AssistantMessagePhase get phase => $_getN(2);
  @$pb.TagNumber(3)
  set phase(AssistantMessagePhase value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPhase() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhase() => $_clearField(3);
}

class ToolUseStart extends $pb.GeneratedMessage {
  factory ToolUseStart({
    $core.String? turnId,
    $core.String? toolCallId,
    $core.String? toolName,
    $core.String? argumentsJson,
  }) {
    final result = create();
    if (turnId != null) result.turnId = turnId;
    if (toolCallId != null) result.toolCallId = toolCallId;
    if (toolName != null) result.toolName = toolName;
    if (argumentsJson != null) result.argumentsJson = argumentsJson;
    return result;
  }

  ToolUseStart._();

  factory ToolUseStart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToolUseStart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToolUseStart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'turnId')
    ..aOS(2, _omitFieldNames ? '' : 'toolCallId')
    ..aOS(3, _omitFieldNames ? '' : 'toolName')
    ..aOS(4, _omitFieldNames ? '' : 'argumentsJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolUseStart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolUseStart copyWith(void Function(ToolUseStart) updates) =>
      super.copyWith((message) => updates(message as ToolUseStart))
          as ToolUseStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToolUseStart create() => ToolUseStart._();
  @$core.override
  ToolUseStart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ToolUseStart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToolUseStart>(create);
  static ToolUseStart? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get turnId => $_getSZ(0);
  @$pb.TagNumber(1)
  set turnId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTurnId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTurnId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toolCallId => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolCallId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolCallId() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolCallId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get toolName => $_getSZ(2);
  @$pb.TagNumber(3)
  set toolName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToolName() => $_has(2);
  @$pb.TagNumber(3)
  void clearToolName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get argumentsJson => $_getSZ(3);
  @$pb.TagNumber(4)
  set argumentsJson($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasArgumentsJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearArgumentsJson() => $_clearField(4);
}

class ToolResult extends $pb.GeneratedMessage {
  factory ToolResult({
    $core.String? turnId,
    $core.String? toolCallId,
    $core.String? output,
    $core.bool? isError,
    $core.String? metadataJson,
    $core.String? cursorJson,
  }) {
    final result = create();
    if (turnId != null) result.turnId = turnId;
    if (toolCallId != null) result.toolCallId = toolCallId;
    if (output != null) result.output = output;
    if (isError != null) result.isError = isError;
    if (metadataJson != null) result.metadataJson = metadataJson;
    if (cursorJson != null) result.cursorJson = cursorJson;
    return result;
  }

  ToolResult._();

  factory ToolResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToolResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToolResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'turnId')
    ..aOS(2, _omitFieldNames ? '' : 'toolCallId')
    ..aOS(3, _omitFieldNames ? '' : 'output')
    ..aOB(4, _omitFieldNames ? '' : 'isError')
    ..aOS(5, _omitFieldNames ? '' : 'metadataJson')
    ..aOS(6, _omitFieldNames ? '' : 'cursorJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolResult copyWith(void Function(ToolResult) updates) =>
      super.copyWith((message) => updates(message as ToolResult)) as ToolResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToolResult create() => ToolResult._();
  @$core.override
  ToolResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ToolResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToolResult>(create);
  static ToolResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get turnId => $_getSZ(0);
  @$pb.TagNumber(1)
  set turnId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTurnId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTurnId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toolCallId => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolCallId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolCallId() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolCallId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get output => $_getSZ(2);
  @$pb.TagNumber(3)
  set output($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOutput() => $_has(2);
  @$pb.TagNumber(3)
  void clearOutput() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isError => $_getBF(3);
  @$pb.TagNumber(4)
  set isError($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsError() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsError() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get metadataJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set metadataJson($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMetadataJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearMetadataJson() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get cursorJson => $_getSZ(5);
  @$pb.TagNumber(6)
  set cursorJson($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCursorJson() => $_has(5);
  @$pb.TagNumber(6)
  void clearCursorJson() => $_clearField(6);
}

/// Approval request: daemon-issued approval_id is the durable handle.
/// Client responds via IngressService.ApproveTool(approval_id, decision).
class ToolApprovalRequest extends $pb.GeneratedMessage {
  factory ToolApprovalRequest({
    $core.String? approvalId,
    $core.String? turnId,
    $core.String? toolCallId,
    $core.String? toolName,
    $core.String? argumentsJson,
    $core.String? reason,
    $core.int? timeoutSecs,
  }) {
    final result = create();
    if (approvalId != null) result.approvalId = approvalId;
    if (turnId != null) result.turnId = turnId;
    if (toolCallId != null) result.toolCallId = toolCallId;
    if (toolName != null) result.toolName = toolName;
    if (argumentsJson != null) result.argumentsJson = argumentsJson;
    if (reason != null) result.reason = reason;
    if (timeoutSecs != null) result.timeoutSecs = timeoutSecs;
    return result;
  }

  ToolApprovalRequest._();

  factory ToolApprovalRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToolApprovalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToolApprovalRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'approvalId')
    ..aOS(2, _omitFieldNames ? '' : 'turnId')
    ..aOS(3, _omitFieldNames ? '' : 'toolCallId')
    ..aOS(4, _omitFieldNames ? '' : 'toolName')
    ..aOS(5, _omitFieldNames ? '' : 'argumentsJson')
    ..aOS(6, _omitFieldNames ? '' : 'reason')
    ..aI(7, _omitFieldNames ? '' : 'timeoutSecs',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolApprovalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolApprovalRequest copyWith(void Function(ToolApprovalRequest) updates) =>
      super.copyWith((message) => updates(message as ToolApprovalRequest))
          as ToolApprovalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToolApprovalRequest create() => ToolApprovalRequest._();
  @$core.override
  ToolApprovalRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ToolApprovalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToolApprovalRequest>(create);
  static ToolApprovalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get approvalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set approvalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasApprovalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearApprovalId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get turnId => $_getSZ(1);
  @$pb.TagNumber(2)
  set turnId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTurnId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTurnId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get toolCallId => $_getSZ(2);
  @$pb.TagNumber(3)
  set toolCallId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToolCallId() => $_has(2);
  @$pb.TagNumber(3)
  void clearToolCallId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get toolName => $_getSZ(3);
  @$pb.TagNumber(4)
  set toolName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasToolName() => $_has(3);
  @$pb.TagNumber(4)
  void clearToolName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get argumentsJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set argumentsJson($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasArgumentsJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearArgumentsJson() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get reason => $_getSZ(5);
  @$pb.TagNumber(6)
  set reason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearReason() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get timeoutSecs => $_getIZ(6);
  @$pb.TagNumber(7)
  set timeoutSecs($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTimeoutSecs() => $_has(6);
  @$pb.TagNumber(7)
  void clearTimeoutSecs() => $_clearField(7);
}

class ThreadStarted extends $pb.GeneratedMessage {
  factory ThreadStarted({
    $core.String? threadId,
    $core.String? source,
  }) {
    final result = create();
    if (threadId != null) result.threadId = threadId;
    if (source != null) result.source = source;
    return result;
  }

  ThreadStarted._();

  factory ThreadStarted.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ThreadStarted.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadStarted',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'threadId')
    ..aOS(2, _omitFieldNames ? '' : 'source')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadStarted clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadStarted copyWith(void Function(ThreadStarted) updates) =>
      super.copyWith((message) => updates(message as ThreadStarted))
          as ThreadStarted;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThreadStarted create() => ThreadStarted._();
  @$core.override
  ThreadStarted createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ThreadStarted getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadStarted>(create);
  static ThreadStarted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get threadId => $_getSZ(0);
  @$pb.TagNumber(1)
  set threadId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasThreadId() => $_has(0);
  @$pb.TagNumber(1)
  void clearThreadId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get source => $_getSZ(1);
  @$pb.TagNumber(2)
  set source($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSource() => $_has(1);
  @$pb.TagNumber(2)
  void clearSource() => $_clearField(2);
}

class ThreadCompleted extends $pb.GeneratedMessage {
  factory ThreadCompleted({
    $core.String? threadId,
  }) {
    final result = create();
    if (threadId != null) result.threadId = threadId;
    return result;
  }

  ThreadCompleted._();

  factory ThreadCompleted.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ThreadCompleted.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadCompleted',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'threadId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadCompleted clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadCompleted copyWith(void Function(ThreadCompleted) updates) =>
      super.copyWith((message) => updates(message as ThreadCompleted))
          as ThreadCompleted;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThreadCompleted create() => ThreadCompleted._();
  @$core.override
  ThreadCompleted createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ThreadCompleted getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadCompleted>(create);
  static ThreadCompleted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get threadId => $_getSZ(0);
  @$pb.TagNumber(1)
  set threadId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasThreadId() => $_has(0);
  @$pb.TagNumber(1)
  void clearThreadId() => $_clearField(1);
}

class SessionEnded extends $pb.GeneratedMessage {
  factory SessionEnded({
    $core.String? reason,
  }) {
    final result = create();
    if (reason != null) result.reason = reason;
    return result;
  }

  SessionEnded._();

  factory SessionEnded.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SessionEnded.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionEnded',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionEnded clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionEnded copyWith(void Function(SessionEnded) updates) =>
      super.copyWith((message) => updates(message as SessionEnded))
          as SessionEnded;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SessionEnded create() => SessionEnded._();
  @$core.override
  SessionEnded createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SessionEnded getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionEnded>(create);
  static SessionEnded? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reason => $_getSZ(0);
  @$pb.TagNumber(1)
  set reason($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearReason() => $_clearField(1);
}

class ScheduleChanged extends $pb.GeneratedMessage {
  factory ScheduleChanged({
    $core.String? scheduleId,
    ScheduleChange? change,
  }) {
    final result = create();
    if (scheduleId != null) result.scheduleId = scheduleId;
    if (change != null) result.change = change;
    return result;
  }

  ScheduleChanged._();

  factory ScheduleChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScheduleChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScheduleChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'scheduleId')
    ..aE<ScheduleChange>(2, _omitFieldNames ? '' : 'change',
        enumValues: ScheduleChange.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleChanged copyWith(void Function(ScheduleChanged) updates) =>
      super.copyWith((message) => updates(message as ScheduleChanged))
          as ScheduleChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScheduleChanged create() => ScheduleChanged._();
  @$core.override
  ScheduleChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScheduleChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScheduleChanged>(create);
  static ScheduleChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get scheduleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set scheduleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasScheduleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearScheduleId() => $_clearField(1);

  @$pb.TagNumber(2)
  ScheduleChange get change => $_getN(1);
  @$pb.TagNumber(2)
  set change(ScheduleChange value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasChange() => $_has(1);
  @$pb.TagNumber(2)
  void clearChange() => $_clearField(2);
}

class SubAgentSpawned extends $pb.GeneratedMessage {
  factory SubAgentSpawned({
    $core.String? childSessionId,
    $core.String? product,
    $core.String? prompt,
    SpawnMode? mode,
  }) {
    final result = create();
    if (childSessionId != null) result.childSessionId = childSessionId;
    if (product != null) result.product = product;
    if (prompt != null) result.prompt = prompt;
    if (mode != null) result.mode = mode;
    return result;
  }

  SubAgentSpawned._();

  factory SubAgentSpawned.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubAgentSpawned.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubAgentSpawned',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'childSessionId')
    ..aOS(2, _omitFieldNames ? '' : 'product')
    ..aOS(3, _omitFieldNames ? '' : 'prompt')
    ..aE<SpawnMode>(4, _omitFieldNames ? '' : 'mode',
        enumValues: SpawnMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubAgentSpawned clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubAgentSpawned copyWith(void Function(SubAgentSpawned) updates) =>
      super.copyWith((message) => updates(message as SubAgentSpawned))
          as SubAgentSpawned;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubAgentSpawned create() => SubAgentSpawned._();
  @$core.override
  SubAgentSpawned createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubAgentSpawned getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubAgentSpawned>(create);
  static SubAgentSpawned? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get childSessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set childSessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChildSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChildSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get product => $_getSZ(1);
  @$pb.TagNumber(2)
  set product($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProduct() => $_has(1);
  @$pb.TagNumber(2)
  void clearProduct() => $_clearField(2);

  /// May contain sensitive context — redaction policy is a slice 7 design
  /// item (see RFC 0007 §Deferred concerns).
  @$pb.TagNumber(3)
  $core.String get prompt => $_getSZ(2);
  @$pb.TagNumber(3)
  set prompt($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrompt() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrompt() => $_clearField(3);

  @$pb.TagNumber(4)
  SpawnMode get mode => $_getN(3);
  @$pb.TagNumber(4)
  set mode(SpawnMode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearMode() => $_clearField(4);
}

class SubAgentCompleted extends $pb.GeneratedMessage {
  factory SubAgentCompleted({
    $core.String? childSessionId,
    $core.String? result,
    $core.bool? isError,
    $1.Usage? usage,
  }) {
    final result$ = create();
    if (childSessionId != null) result$.childSessionId = childSessionId;
    if (result != null) result$.result = result;
    if (isError != null) result$.isError = isError;
    if (usage != null) result$.usage = usage;
    return result$;
  }

  SubAgentCompleted._();

  factory SubAgentCompleted.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubAgentCompleted.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubAgentCompleted',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'childSessionId')
    ..aOS(2, _omitFieldNames ? '' : 'result')
    ..aOB(3, _omitFieldNames ? '' : 'isError')
    ..aOM<$1.Usage>(4, _omitFieldNames ? '' : 'usage',
        subBuilder: $1.Usage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubAgentCompleted clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubAgentCompleted copyWith(void Function(SubAgentCompleted) updates) =>
      super.copyWith((message) => updates(message as SubAgentCompleted))
          as SubAgentCompleted;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubAgentCompleted create() => SubAgentCompleted._();
  @$core.override
  SubAgentCompleted createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubAgentCompleted getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubAgentCompleted>(create);
  static SubAgentCompleted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get childSessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set childSessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChildSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChildSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get result => $_getSZ(1);
  @$pb.TagNumber(2)
  set result($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResult() => $_has(1);
  @$pb.TagNumber(2)
  void clearResult() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isError => $_getBF(2);
  @$pb.TagNumber(3)
  set isError($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsError() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsError() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.Usage get usage => $_getN(3);
  @$pb.TagNumber(4)
  set usage($1.Usage value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUsage() => $_has(3);
  @$pb.TagNumber(4)
  void clearUsage() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Usage ensureUsage() => $_ensure(3);
}

class SteerApplied extends $pb.GeneratedMessage {
  factory SteerApplied({
    $core.String? turnId,
    $core.String? clientRequestId,
  }) {
    final result = create();
    if (turnId != null) result.turnId = turnId;
    if (clientRequestId != null) result.clientRequestId = clientRequestId;
    return result;
  }

  SteerApplied._();

  factory SteerApplied.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SteerApplied.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SteerApplied',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'turnId')
    ..aOS(2, _omitFieldNames ? '' : 'clientRequestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SteerApplied clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SteerApplied copyWith(void Function(SteerApplied) updates) =>
      super.copyWith((message) => updates(message as SteerApplied))
          as SteerApplied;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SteerApplied create() => SteerApplied._();
  @$core.override
  SteerApplied createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SteerApplied getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SteerApplied>(create);
  static SteerApplied? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get turnId => $_getSZ(0);
  @$pb.TagNumber(1)
  set turnId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTurnId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTurnId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clientRequestId => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientRequestId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientRequestId() => $_clearField(2);
}

class SteerFailed extends $pb.GeneratedMessage {
  factory SteerFailed({
    $core.String? turnId,
    $core.String? clientRequestId,
    $core.String? reason,
  }) {
    final result = create();
    if (turnId != null) result.turnId = turnId;
    if (clientRequestId != null) result.clientRequestId = clientRequestId;
    if (reason != null) result.reason = reason;
    return result;
  }

  SteerFailed._();

  factory SteerFailed.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SteerFailed.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SteerFailed',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'turnId')
    ..aOS(2, _omitFieldNames ? '' : 'clientRequestId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SteerFailed clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SteerFailed copyWith(void Function(SteerFailed) updates) =>
      super.copyWith((message) => updates(message as SteerFailed))
          as SteerFailed;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SteerFailed create() => SteerFailed._();
  @$core.override
  SteerFailed createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SteerFailed getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SteerFailed>(create);
  static SteerFailed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get turnId => $_getSZ(0);
  @$pb.TagNumber(1)
  set turnId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTurnId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTurnId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clientRequestId => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientRequestId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientRequestId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class Error extends $pb.GeneratedMessage {
  factory Error({
    $core.String? code,
    $core.String? message,
    $core.bool? fatal,
    $core.String? turnId,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    if (fatal != null) result.fatal = fatal;
    if (turnId != null) result.turnId = turnId;
    return result;
  }

  Error._();

  factory Error.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Error.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Error',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOB(3, _omitFieldNames ? '' : 'fatal')
    ..aOS(4, _omitFieldNames ? '' : 'turnId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Error clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Error copyWith(void Function(Error) updates) =>
      super.copyWith((message) => updates(message as Error)) as Error;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Error create() => Error._();
  @$core.override
  Error createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Error getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Error>(create);
  static Error? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get fatal => $_getBF(2);
  @$pb.TagNumber(3)
  set fatal($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFatal() => $_has(2);
  @$pb.TagNumber(3)
  void clearFatal() => $_clearField(3);

  /// Optional context — empty when the error is session-level.
  @$pb.TagNumber(4)
  $core.String get turnId => $_getSZ(3);
  @$pb.TagNumber(4)
  set turnId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTurnId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTurnId() => $_clearField(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
