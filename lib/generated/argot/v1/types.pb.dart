// This is a generated file - do not edit.
//
// Generated from argot/v1/types.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

enum ChatEvent_Event {
  opened,
  delta,
  toolCall,
  toolResult,
  done,
  error,
  terminated,
  notSet
}

class ChatEvent extends $pb.GeneratedMessage {
  factory ChatEvent({
    SessionOpened? opened,
    MessageDelta? delta,
    ToolCall? toolCall,
    ToolResult? toolResult,
    TurnDone? done,
    TurnError? error,
    TurnTerminated? terminated,
  }) {
    final result = create();
    if (opened != null) result.opened = opened;
    if (delta != null) result.delta = delta;
    if (toolCall != null) result.toolCall = toolCall;
    if (toolResult != null) result.toolResult = toolResult;
    if (done != null) result.done = done;
    if (error != null) result.error = error;
    if (terminated != null) result.terminated = terminated;
    return result;
  }

  ChatEvent._();

  factory ChatEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ChatEvent_Event> _ChatEvent_EventByTag = {
    1: ChatEvent_Event.opened,
    2: ChatEvent_Event.delta,
    3: ChatEvent_Event.toolCall,
    4: ChatEvent_Event.toolResult,
    5: ChatEvent_Event.done,
    6: ChatEvent_Event.error,
    7: ChatEvent_Event.terminated,
    0: ChatEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChatEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7])
    ..aOM<SessionOpened>(1, _omitFieldNames ? '' : 'opened',
        subBuilder: SessionOpened.create)
    ..aOM<MessageDelta>(2, _omitFieldNames ? '' : 'delta',
        subBuilder: MessageDelta.create)
    ..aOM<ToolCall>(3, _omitFieldNames ? '' : 'toolCall',
        subBuilder: ToolCall.create)
    ..aOM<ToolResult>(4, _omitFieldNames ? '' : 'toolResult',
        subBuilder: ToolResult.create)
    ..aOM<TurnDone>(5, _omitFieldNames ? '' : 'done',
        subBuilder: TurnDone.create)
    ..aOM<TurnError>(6, _omitFieldNames ? '' : 'error',
        subBuilder: TurnError.create)
    ..aOM<TurnTerminated>(7, _omitFieldNames ? '' : 'terminated',
        subBuilder: TurnTerminated.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatEvent copyWith(void Function(ChatEvent) updates) =>
      super.copyWith((message) => updates(message as ChatEvent)) as ChatEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatEvent create() => ChatEvent._();
  @$core.override
  ChatEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatEvent getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatEvent>(create);
  static ChatEvent? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  ChatEvent_Event whichEvent() => _ChatEvent_EventByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  void clearEvent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  SessionOpened get opened => $_getN(0);
  @$pb.TagNumber(1)
  set opened(SessionOpened value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOpened() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpened() => $_clearField(1);
  @$pb.TagNumber(1)
  SessionOpened ensureOpened() => $_ensure(0);

  @$pb.TagNumber(2)
  MessageDelta get delta => $_getN(1);
  @$pb.TagNumber(2)
  set delta(MessageDelta value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDelta() => $_has(1);
  @$pb.TagNumber(2)
  void clearDelta() => $_clearField(2);
  @$pb.TagNumber(2)
  MessageDelta ensureDelta() => $_ensure(1);

  @$pb.TagNumber(3)
  ToolCall get toolCall => $_getN(2);
  @$pb.TagNumber(3)
  set toolCall(ToolCall value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasToolCall() => $_has(2);
  @$pb.TagNumber(3)
  void clearToolCall() => $_clearField(3);
  @$pb.TagNumber(3)
  ToolCall ensureToolCall() => $_ensure(2);

  @$pb.TagNumber(4)
  ToolResult get toolResult => $_getN(3);
  @$pb.TagNumber(4)
  set toolResult(ToolResult value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasToolResult() => $_has(3);
  @$pb.TagNumber(4)
  void clearToolResult() => $_clearField(4);
  @$pb.TagNumber(4)
  ToolResult ensureToolResult() => $_ensure(3);

  @$pb.TagNumber(5)
  TurnDone get done => $_getN(4);
  @$pb.TagNumber(5)
  set done(TurnDone value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDone() => $_has(4);
  @$pb.TagNumber(5)
  void clearDone() => $_clearField(5);
  @$pb.TagNumber(5)
  TurnDone ensureDone() => $_ensure(4);

  @$pb.TagNumber(6)
  TurnError get error => $_getN(5);
  @$pb.TagNumber(6)
  set error(TurnError value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasError() => $_has(5);
  @$pb.TagNumber(6)
  void clearError() => $_clearField(6);
  @$pb.TagNumber(6)
  TurnError ensureError() => $_ensure(5);

  /// Loop hit a non-error termination (IterCap / TokenCap /
  /// TimeCap / Cancelled). Distinct from TurnError so the cli
  /// can render "ran out of iterations" differently from
  /// "model produced nothing".
  @$pb.TagNumber(7)
  TurnTerminated get terminated => $_getN(6);
  @$pb.TagNumber(7)
  set terminated(TurnTerminated value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTerminated() => $_has(6);
  @$pb.TagNumber(7)
  void clearTerminated() => $_clearField(7);
  @$pb.TagNumber(7)
  TurnTerminated ensureTerminated() => $_ensure(6);
}

class SessionOpened extends $pb.GeneratedMessage {
  factory SessionOpened({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  SessionOpened._();

  factory SessionOpened.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SessionOpened.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionOpened',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionOpened clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionOpened copyWith(void Function(SessionOpened) updates) =>
      super.copyWith((message) => updates(message as SessionOpened))
          as SessionOpened;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SessionOpened create() => SessionOpened._();
  @$core.override
  SessionOpened createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SessionOpened getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionOpened>(create);
  static SessionOpened? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

/// Streaming text fragment from the assistant.
class MessageDelta extends $pb.GeneratedMessage {
  factory MessageDelta({
    $core.String? text,
  }) {
    final result = create();
    if (text != null) result.text = text;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
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
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);
}

/// Emitted when the model requests a tool. Phase-1 surfaces these for
/// the CLI to render; tool execution itself happens inside the daemon.
class ToolCall extends $pb.GeneratedMessage {
  factory ToolCall({
    $core.String? id,
    $core.String? name,
    $core.String? argumentsJson,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (argumentsJson != null) result.argumentsJson = argumentsJson;
    return result;
  }

  ToolCall._();

  factory ToolCall.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToolCall.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToolCall',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'argumentsJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCall clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCall copyWith(void Function(ToolCall) updates) =>
      super.copyWith((message) => updates(message as ToolCall)) as ToolCall;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToolCall create() => ToolCall._();
  @$core.override
  ToolCall createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ToolCall getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ToolCall>(create);
  static ToolCall? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// Arguments serialised as JSON for forward-compat.
  @$pb.TagNumber(3)
  $core.String get argumentsJson => $_getSZ(2);
  @$pb.TagNumber(3)
  set argumentsJson($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasArgumentsJson() => $_has(2);
  @$pb.TagNumber(3)
  void clearArgumentsJson() => $_clearField(3);
}

/// Emitted after the tool runs, before the next assistant turn.
class ToolResult extends $pb.GeneratedMessage {
  factory ToolResult({
    $core.String? callId,
    $core.String? outputJson,
    $core.bool? isError,
  }) {
    final result = create();
    if (callId != null) result.callId = callId;
    if (outputJson != null) result.outputJson = outputJson;
    if (isError != null) result.isError = isError;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'callId')
    ..aOS(2, _omitFieldNames ? '' : 'outputJson')
    ..aOB(3, _omitFieldNames ? '' : 'isError')
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
  $core.String get callId => $_getSZ(0);
  @$pb.TagNumber(1)
  set callId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCallId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get outputJson => $_getSZ(1);
  @$pb.TagNumber(2)
  set outputJson($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOutputJson() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutputJson() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isError => $_getBF(2);
  @$pb.TagNumber(3)
  set isError($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsError() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsError() => $_clearField(3);
}

/// Terminal event for a successful turn. `text` is the aggregated
/// assistant reply (matches `ChatResponse.text`); counters are
/// advisory. Clients can ignore `text` if they already reassembled
/// from `MessageDelta` events.
class TurnDone extends $pb.GeneratedMessage {
  factory TurnDone({
    $core.String? text,
    $core.int? turns,
    $core.int? toolCalls,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (turns != null) result.turns = turns;
    if (toolCalls != null) result.toolCalls = toolCalls;
    return result;
  }

  TurnDone._();

  factory TurnDone.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TurnDone.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TurnDone',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aI(2, _omitFieldNames ? '' : 'turns', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'toolCalls', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnDone clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnDone copyWith(void Function(TurnDone) updates) =>
      super.copyWith((message) => updates(message as TurnDone)) as TurnDone;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TurnDone create() => TurnDone._();
  @$core.override
  TurnDone createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TurnDone getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TurnDone>(create);
  static TurnDone? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get turns => $_getIZ(1);
  @$pb.TagNumber(2)
  set turns($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTurns() => $_has(1);
  @$pb.TagNumber(2)
  void clearTurns() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get toolCalls => $_getIZ(2);
  @$pb.TagNumber(3)
  set toolCalls($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToolCalls() => $_has(2);
  @$pb.TagNumber(3)
  void clearToolCalls() => $_clearField(3);
}

class TurnError extends $pb.GeneratedMessage {
  factory TurnError({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  TurnError._();

  factory TurnError.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TurnError.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TurnError',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnError clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnError copyWith(void Function(TurnError) updates) =>
      super.copyWith((message) => updates(message as TurnError)) as TurnError;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TurnError create() => TurnError._();
  @$core.override
  TurnError createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TurnError getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TurnError>(create);
  static TurnError? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

/// Non-error early termination — agent_loop hit a configured limit.
/// Maps 1:1 to tinicore::agent::TerminationReason {IterCap, TokenCap,
/// TimeCap, Cancelled}; Completed is normally surfaced as TurnDone
/// (or TurnError if no content reached the client).
class TurnTerminated extends $pb.GeneratedMessage {
  factory TurnTerminated({
    $core.String? reason,
    $core.int? turns,
    $core.int? toolCalls,
  }) {
    final result = create();
    if (reason != null) result.reason = reason;
    if (turns != null) result.turns = turns;
    if (toolCalls != null) result.toolCalls = toolCalls;
    return result;
  }

  TurnTerminated._();

  factory TurnTerminated.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TurnTerminated.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TurnTerminated',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reason')
    ..aI(2, _omitFieldNames ? '' : 'turns', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'toolCalls', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnTerminated clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnTerminated copyWith(void Function(TurnTerminated) updates) =>
      super.copyWith((message) => updates(message as TurnTerminated))
          as TurnTerminated;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TurnTerminated create() => TurnTerminated._();
  @$core.override
  TurnTerminated createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TurnTerminated getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TurnTerminated>(create);
  static TurnTerminated? _defaultInstance;

  /// Snake-case reason: "iter_cap" | "token_cap" | "time_cap" | "cancelled".
  @$pb.TagNumber(1)
  $core.String get reason => $_getSZ(0);
  @$pb.TagNumber(1)
  set reason($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearReason() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get turns => $_getIZ(1);
  @$pb.TagNumber(2)
  set turns($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTurns() => $_has(1);
  @$pb.TagNumber(2)
  void clearTurns() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get toolCalls => $_getIZ(2);
  @$pb.TagNumber(3)
  set toolCalls($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToolCalls() => $_has(2);
  @$pb.TagNumber(3)
  void clearToolCalls() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
