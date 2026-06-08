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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'types.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'types.pbenum.dart';

enum ChatEvent_Event {
  opened,
  delta,
  toolCall,
  toolResult,
  completed,
  failed,
  stopped,
  progress,
  notSet
}

class ChatEvent extends $pb.GeneratedMessage {
  factory ChatEvent({
    Opened? opened,
    MessageDelta? delta,
    ToolCall? toolCall,
    ToolResult? toolResult,
    Completed? completed,
    Failed? failed,
    Stopped? stopped,
    AgentProgress? progress,
  }) {
    final result = create();
    if (opened != null) result.opened = opened;
    if (delta != null) result.delta = delta;
    if (toolCall != null) result.toolCall = toolCall;
    if (toolResult != null) result.toolResult = toolResult;
    if (completed != null) result.completed = completed;
    if (failed != null) result.failed = failed;
    if (stopped != null) result.stopped = stopped;
    if (progress != null) result.progress = progress;
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
    5: ChatEvent_Event.completed,
    6: ChatEvent_Event.failed,
    7: ChatEvent_Event.stopped,
    8: ChatEvent_Event.progress,
    0: ChatEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChatEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8])
    ..aOM<Opened>(1, _omitFieldNames ? '' : 'opened', subBuilder: Opened.create)
    ..aOM<MessageDelta>(2, _omitFieldNames ? '' : 'delta',
        subBuilder: MessageDelta.create)
    ..aOM<ToolCall>(3, _omitFieldNames ? '' : 'toolCall',
        subBuilder: ToolCall.create)
    ..aOM<ToolResult>(4, _omitFieldNames ? '' : 'toolResult',
        subBuilder: ToolResult.create)
    ..aOM<Completed>(5, _omitFieldNames ? '' : 'completed',
        subBuilder: Completed.create)
    ..aOM<Failed>(6, _omitFieldNames ? '' : 'failed', subBuilder: Failed.create)
    ..aOM<Stopped>(7, _omitFieldNames ? '' : 'stopped',
        subBuilder: Stopped.create)
    ..aOM<AgentProgress>(8, _omitFieldNames ? '' : 'progress',
        subBuilder: AgentProgress.create)
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
  @$pb.TagNumber(8)
  ChatEvent_Event whichEvent() => _ChatEvent_EventByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  void clearEvent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Opened get opened => $_getN(0);
  @$pb.TagNumber(1)
  set opened(Opened value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOpened() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpened() => $_clearField(1);
  @$pb.TagNumber(1)
  Opened ensureOpened() => $_ensure(0);

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

  /// Terminal success — the turn completed normally.
  @$pb.TagNumber(5)
  Completed get completed => $_getN(4);
  @$pb.TagNumber(5)
  set completed(Completed value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCompleted() => $_has(4);
  @$pb.TagNumber(5)
  void clearCompleted() => $_clearField(5);
  @$pb.TagNumber(5)
  Completed ensureCompleted() => $_ensure(4);

  /// Terminal failure — the model errored or produced nothing usable.
  @$pb.TagNumber(6)
  Failed get failed => $_getN(5);
  @$pb.TagNumber(6)
  set failed(Failed value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasFailed() => $_has(5);
  @$pb.TagNumber(6)
  void clearFailed() => $_clearField(6);
  @$pb.TagNumber(6)
  Failed ensureFailed() => $_ensure(5);

  /// Non-error early stop — the agent loop hit a configured limit
  /// (iter / token / time cap, or cancellation). Distinct from
  /// Failed so a client can render "ran out of iterations"
  /// differently from "model errored".
  @$pb.TagNumber(7)
  Stopped get stopped => $_getN(6);
  @$pb.TagNumber(7)
  set stopped(Stopped value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStopped() => $_has(6);
  @$pb.TagNumber(7)
  void clearStopped() => $_clearField(7);
  @$pb.TagNumber(7)
  Stopped ensureStopped() => $_ensure(6);

  /// User-safe agent activity on the live turn (thinking, running a
  /// tool, …). Operational, ephemeral, never persisted. Additive: a
  /// client that doesn't recognise it ignores it. See AgentProgress.
  @$pb.TagNumber(8)
  AgentProgress get progress => $_getN(7);
  @$pb.TagNumber(8)
  set progress(AgentProgress value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasProgress() => $_has(7);
  @$pb.TagNumber(8)
  void clearProgress() => $_clearField(8);
  @$pb.TagNumber(8)
  AgentProgress ensureProgress() => $_ensure(7);
}

/// First frame on every Chat stream: the resolved conversation id and
/// whether the turn persists nothing (an ephemeral one-shot). A GUI keys
/// "offer resume / show in history" off `ephemeral == false`.
class Opened extends $pb.GeneratedMessage {
  factory Opened({
    $core.String? conversationId,
    $core.bool? ephemeral,
  }) {
    final result = create();
    if (conversationId != null) result.conversationId = conversationId;
    if (ephemeral != null) result.ephemeral = ephemeral;
    return result;
  }

  Opened._();

  factory Opened.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Opened.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Opened',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'conversationId')
    ..aOB(2, _omitFieldNames ? '' : 'ephemeral')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Opened clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Opened copyWith(void Function(Opened) updates) =>
      super.copyWith((message) => updates(message as Opened)) as Opened;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Opened create() => Opened._();
  @$core.override
  Opened createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Opened getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Opened>(create);
  static Opened? _defaultInstance;

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

/// Emitted when the model requests a tool.
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

/// Terminal event for a successful turn. `text` is the aggregated assistant
/// reply; counters are advisory. Clients can ignore `text` if they already
/// reassembled from `MessageDelta` events.
class Completed extends $pb.GeneratedMessage {
  factory Completed({
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

  Completed._();

  factory Completed.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Completed.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Completed',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aI(2, _omitFieldNames ? '' : 'turns', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'toolCalls', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Completed clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Completed copyWith(void Function(Completed) updates) =>
      super.copyWith((message) => updates(message as Completed)) as Completed;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Completed create() => Completed._();
  @$core.override
  Completed createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Completed getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Completed>(create);
  static Completed? _defaultInstance;

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

/// Terminal event for a failed turn.
class Failed extends $pb.GeneratedMessage {
  factory Failed({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  Failed._();

  factory Failed.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Failed.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Failed',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Failed clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Failed copyWith(void Function(Failed) updates) =>
      super.copyWith((message) => updates(message as Failed)) as Failed;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Failed create() => Failed._();
  @$core.override
  Failed createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Failed getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Failed>(create);
  static Failed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

/// Terminal event for a non-error early stop — the agent loop hit a
/// configured limit. Translated from tinicore's TerminationReason at the
/// transport boundary, so no implementation detail leaks through the value.
class Stopped extends $pb.GeneratedMessage {
  factory Stopped({
    StopReason? reason,
    $core.int? turns,
    $core.int? toolCalls,
  }) {
    final result = create();
    if (reason != null) result.reason = reason;
    if (turns != null) result.turns = turns;
    if (toolCalls != null) result.toolCalls = toolCalls;
    return result;
  }

  Stopped._();

  factory Stopped.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Stopped.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Stopped',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aE<StopReason>(1, _omitFieldNames ? '' : 'reason',
        enumValues: StopReason.values)
    ..aI(2, _omitFieldNames ? '' : 'turns', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'toolCalls', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Stopped clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Stopped copyWith(void Function(Stopped) updates) =>
      super.copyWith((message) => updates(message as Stopped)) as Stopped;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Stopped create() => Stopped._();
  @$core.override
  Stopped createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Stopped getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Stopped>(create);
  static Stopped? _defaultInstance;

  @$pb.TagNumber(1)
  StopReason get reason => $_getN(0);
  @$pb.TagNumber(1)
  set reason(StopReason value) => $_setField(1, value);
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

/// A user-safe activity signal for the active turn, so a chat UI / CLI can show
/// "what the agent is doing" (Thinking, Running bash, Searching memory) without
/// rendering the raw tool_call / tool_result stream. NOT assistant content and
/// NOT reasoning / chain-of-thought. Live-only: never written to history, so
/// GetHistory never replays it. Clients may dedupe consecutive identical events.
class AgentProgress extends $pb.GeneratedMessage {
  factory AgentProgress({
    Phase? phase,
    $core.String? statusId,
    $core.String? toolName,
    $core.String? message,
    ProgressSource? source,
    $core.Iterable<$core.String>? agentPath,
  }) {
    final result = create();
    if (phase != null) result.phase = phase;
    if (statusId != null) result.statusId = statusId;
    if (toolName != null) result.toolName = toolName;
    if (message != null) result.message = message;
    if (source != null) result.source = source;
    if (agentPath != null) result.agentPath.addAll(agentPath);
    return result;
  }

  AgentProgress._();

  factory AgentProgress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AgentProgress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentProgress',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aE<Phase>(1, _omitFieldNames ? '' : 'phase', enumValues: Phase.values)
    ..aOS(2, _omitFieldNames ? '' : 'statusId')
    ..aOS(3, _omitFieldNames ? '' : 'toolName')
    ..aOS(4, _omitFieldNames ? '' : 'message')
    ..aE<ProgressSource>(5, _omitFieldNames ? '' : 'source',
        enumValues: ProgressSource.values)
    ..pPS(6, _omitFieldNames ? '' : 'agentPath')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentProgress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentProgress copyWith(void Function(AgentProgress) updates) =>
      super.copyWith((message) => updates(message as AgentProgress))
          as AgentProgress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgentProgress create() => AgentProgress._();
  @$core.override
  AgentProgress createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AgentProgress getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AgentProgress>(create);
  static AgentProgress? _defaultInstance;

  /// Coarse lifecycle phase. The daemon emits only the phases tinicore's agent
  /// loop actually fires (thinking → memory_retrieving → streaming →
  /// tool_executing → done); `summary` is the optional periodic narration.
  @$pb.TagNumber(1)
  Phase get phase => $_getN(0);
  @$pb.TagNumber(1)
  set phase(Phase value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPhase() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhase() => $_clearField(1);

  /// Stable tinicore catalogue id for the phase, e.g. "agent-status-thinking",
  /// for clients with an i18n label catalogue. Empty for summary-only events.
  @$pb.TagNumber(2)
  $core.String get statusId => $_getSZ(1);
  @$pb.TagNumber(2)
  set statusId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatusId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatusId() => $_clearField(2);

  /// Tool wire-name for tool_executing (e.g. "bash_run"); empty otherwise.
  @$pb.TagNumber(3)
  $core.String get toolName => $_getSZ(2);
  @$pb.TagNumber(3)
  set toolName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToolName() => $_has(2);
  @$pb.TagNumber(3)
  void clearToolName() => $_clearField(3);

  /// Optional short, user-safe narration (e.g. "Reading turn.rs") from the
  /// AgentProgress summarizer. Empty for coarse status. Never reasoning.
  @$pb.TagNumber(4)
  $core.String get message => $_getSZ(3);
  @$pb.TagNumber(4)
  set message($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearMessage() => $_clearField(4);

  /// Whether this came from a coarse status transition or a summarizer tick.
  @$pb.TagNumber(5)
  ProgressSource get source => $_getN(4);
  @$pb.TagNumber(5)
  set source(ProgressSource value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearSource() => $_clearField(5);

  /// Agent / sub-agent / composite-flow attribution, root→emitter. Empty for
  /// the root run. Lets a UI attribute progress within a nested sub-agent tree.
  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get agentPath => $_getList(5);
}

enum MessagePart_Part { text, toolCall, toolResult, reasoning, notSet }

/// A single part of a message body. Relocated here from chat.proto so both
/// the turn surface (`ChatRequest`) and history replay (`ChatMessage`) share
/// one definition. Tool arms keep replayed history from being lossier than
/// the live stream — the daemon persists TOOL-role rows, so `GetHistory`
/// returns tool-call / tool-result / reasoning parts.
class MessagePart extends $pb.GeneratedMessage {
  factory MessagePart({
    $core.String? text,
    ToolCall? toolCall,
    ToolResult? toolResult,
    $core.String? reasoning,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (toolCall != null) result.toolCall = toolCall;
    if (toolResult != null) result.toolResult = toolResult;
    if (reasoning != null) result.reasoning = reasoning;
    return result;
  }

  MessagePart._();

  factory MessagePart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessagePart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, MessagePart_Part> _MessagePart_PartByTag = {
    1: MessagePart_Part.text,
    2: MessagePart_Part.toolCall,
    3: MessagePart_Part.toolResult,
    4: MessagePart_Part.reasoning,
    0: MessagePart_Part.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MessagePart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOM<ToolCall>(2, _omitFieldNames ? '' : 'toolCall',
        subBuilder: ToolCall.create)
    ..aOM<ToolResult>(3, _omitFieldNames ? '' : 'toolResult',
        subBuilder: ToolResult.create)
    ..aOS(4, _omitFieldNames ? '' : 'reasoning')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessagePart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessagePart copyWith(void Function(MessagePart) updates) =>
      super.copyWith((message) => updates(message as MessagePart))
          as MessagePart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessagePart create() => MessagePart._();
  @$core.override
  MessagePart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessagePart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MessagePart>(create);
  static MessagePart? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  MessagePart_Part whichPart() => _MessagePart_PartByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearPart() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  ToolCall get toolCall => $_getN(1);
  @$pb.TagNumber(2)
  set toolCall(ToolCall value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasToolCall() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolCall() => $_clearField(2);
  @$pb.TagNumber(2)
  ToolCall ensureToolCall() => $_ensure(1);

  @$pb.TagNumber(3)
  ToolResult get toolResult => $_getN(2);
  @$pb.TagNumber(3)
  set toolResult(ToolResult value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasToolResult() => $_has(2);
  @$pb.TagNumber(3)
  void clearToolResult() => $_clearField(3);
  @$pb.TagNumber(3)
  ToolResult ensureToolResult() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get reasoning => $_getSZ(3);
  @$pb.TagNumber(4)
  set reasoning($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReasoning() => $_has(3);
  @$pb.TagNumber(4)
  void clearReasoning() => $_clearField(4);
}

/// A persisted message for history replay. Mirrors tinicore's `ChatMessage`:
/// role + content parts + timestamp.
class ChatMessage extends $pb.GeneratedMessage {
  factory ChatMessage({
    Role? role,
    $core.Iterable<MessagePart>? parts,
    $fixnum.Int64? timestampMs,
  }) {
    final result = create();
    if (role != null) result.role = role;
    if (parts != null) result.parts.addAll(parts);
    if (timestampMs != null) result.timestampMs = timestampMs;
    return result;
  }

  ChatMessage._();

  factory ChatMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChatMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aE<Role>(1, _omitFieldNames ? '' : 'role', enumValues: Role.values)
    ..pPM<MessagePart>(2, _omitFieldNames ? '' : 'parts',
        subBuilder: MessagePart.create)
    ..aInt64(3, _omitFieldNames ? '' : 'timestampMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatMessage copyWith(void Function(ChatMessage) updates) =>
      super.copyWith((message) => updates(message as ChatMessage))
          as ChatMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatMessage create() => ChatMessage._();
  @$core.override
  ChatMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChatMessage>(create);
  static ChatMessage? _defaultInstance;

  @$pb.TagNumber(1)
  Role get role => $_getN(0);
  @$pb.TagNumber(1)
  set role(Role value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRole() => $_has(0);
  @$pb.TagNumber(1)
  void clearRole() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<MessagePart> get parts => $_getList(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timestampMs => $_getI64(2);
  @$pb.TagNumber(3)
  set timestampMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimestampMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestampMs() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
