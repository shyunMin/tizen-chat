// This is a generated file - do not edit.
//
// Generated from carbon/v1/agent.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/struct.pb.dart' as $1;

import 'agent.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'agent.pbenum.dart';

enum ClientMessage_Message {
  createSession,
  userMessage,
  toolApproval,
  cancelSession,
  setSchedule,
  spawnSubAgent,
  ingressInput,
  scheduleRequest,
  interruptTurn,
  notSet
}

/// Wrapper for all client-to-server messages on the session stream.
class ClientMessage extends $pb.GeneratedMessage {
  factory ClientMessage({
    CreateSessionRequest? createSession,
    UserMessage? userMessage,
    ToolApproval? toolApproval,
    CancelSessionRequest? cancelSession,
    SetScheduleRequest? setSchedule,
    SpawnSubAgentRequest? spawnSubAgent,
    IngressInput? ingressInput,
    ScheduleRequest? scheduleRequest,
    InterruptTurnRequest? interruptTurn,
  }) {
    final result = create();
    if (createSession != null) result.createSession = createSession;
    if (userMessage != null) result.userMessage = userMessage;
    if (toolApproval != null) result.toolApproval = toolApproval;
    if (cancelSession != null) result.cancelSession = cancelSession;
    if (setSchedule != null) result.setSchedule = setSchedule;
    if (spawnSubAgent != null) result.spawnSubAgent = spawnSubAgent;
    if (ingressInput != null) result.ingressInput = ingressInput;
    if (scheduleRequest != null) result.scheduleRequest = scheduleRequest;
    if (interruptTurn != null) result.interruptTurn = interruptTurn;
    return result;
  }

  ClientMessage._();

  factory ClientMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClientMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ClientMessage_Message>
      _ClientMessage_MessageByTag = {
    1: ClientMessage_Message.createSession,
    2: ClientMessage_Message.userMessage,
    3: ClientMessage_Message.toolApproval,
    4: ClientMessage_Message.cancelSession,
    5: ClientMessage_Message.setSchedule,
    6: ClientMessage_Message.spawnSubAgent,
    7: ClientMessage_Message.ingressInput,
    8: ClientMessage_Message.scheduleRequest,
    9: ClientMessage_Message.interruptTurn,
    0: ClientMessage_Message.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClientMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9])
    ..aOM<CreateSessionRequest>(1, _omitFieldNames ? '' : 'createSession',
        subBuilder: CreateSessionRequest.create)
    ..aOM<UserMessage>(2, _omitFieldNames ? '' : 'userMessage',
        subBuilder: UserMessage.create)
    ..aOM<ToolApproval>(3, _omitFieldNames ? '' : 'toolApproval',
        subBuilder: ToolApproval.create)
    ..aOM<CancelSessionRequest>(4, _omitFieldNames ? '' : 'cancelSession',
        subBuilder: CancelSessionRequest.create)
    ..aOM<SetScheduleRequest>(5, _omitFieldNames ? '' : 'setSchedule',
        subBuilder: SetScheduleRequest.create)
    ..aOM<SpawnSubAgentRequest>(6, _omitFieldNames ? '' : 'spawnSubAgent',
        subBuilder: SpawnSubAgentRequest.create)
    ..aOM<IngressInput>(7, _omitFieldNames ? '' : 'ingressInput',
        subBuilder: IngressInput.create)
    ..aOM<ScheduleRequest>(8, _omitFieldNames ? '' : 'scheduleRequest',
        subBuilder: ScheduleRequest.create)
    ..aOM<InterruptTurnRequest>(9, _omitFieldNames ? '' : 'interruptTurn',
        subBuilder: InterruptTurnRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientMessage copyWith(void Function(ClientMessage) updates) =>
      super.copyWith((message) => updates(message as ClientMessage))
          as ClientMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClientMessage create() => ClientMessage._();
  @$core.override
  ClientMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClientMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClientMessage>(create);
  static ClientMessage? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  ClientMessage_Message whichMessage() =>
      _ClientMessage_MessageByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  void clearMessage() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  CreateSessionRequest get createSession => $_getN(0);
  @$pb.TagNumber(1)
  set createSession(CreateSessionRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCreateSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreateSession() => $_clearField(1);
  @$pb.TagNumber(1)
  CreateSessionRequest ensureCreateSession() => $_ensure(0);

  @$pb.TagNumber(2)
  UserMessage get userMessage => $_getN(1);
  @$pb.TagNumber(2)
  set userMessage(UserMessage value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUserMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserMessage() => $_clearField(2);
  @$pb.TagNumber(2)
  UserMessage ensureUserMessage() => $_ensure(1);

  @$pb.TagNumber(3)
  ToolApproval get toolApproval => $_getN(2);
  @$pb.TagNumber(3)
  set toolApproval(ToolApproval value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasToolApproval() => $_has(2);
  @$pb.TagNumber(3)
  void clearToolApproval() => $_clearField(3);
  @$pb.TagNumber(3)
  ToolApproval ensureToolApproval() => $_ensure(2);

  @$pb.TagNumber(4)
  CancelSessionRequest get cancelSession => $_getN(3);
  @$pb.TagNumber(4)
  set cancelSession(CancelSessionRequest value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCancelSession() => $_has(3);
  @$pb.TagNumber(4)
  void clearCancelSession() => $_clearField(4);
  @$pb.TagNumber(4)
  CancelSessionRequest ensureCancelSession() => $_ensure(3);

  @$pb.TagNumber(5)
  SetScheduleRequest get setSchedule => $_getN(4);
  @$pb.TagNumber(5)
  set setSchedule(SetScheduleRequest value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSetSchedule() => $_has(4);
  @$pb.TagNumber(5)
  void clearSetSchedule() => $_clearField(5);
  @$pb.TagNumber(5)
  SetScheduleRequest ensureSetSchedule() => $_ensure(4);

  @$pb.TagNumber(6)
  SpawnSubAgentRequest get spawnSubAgent => $_getN(5);
  @$pb.TagNumber(6)
  set spawnSubAgent(SpawnSubAgentRequest value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSpawnSubAgent() => $_has(5);
  @$pb.TagNumber(6)
  void clearSpawnSubAgent() => $_clearField(6);
  @$pb.TagNumber(6)
  SpawnSubAgentRequest ensureSpawnSubAgent() => $_ensure(5);

  @$pb.TagNumber(7)
  IngressInput get ingressInput => $_getN(6);
  @$pb.TagNumber(7)
  set ingressInput(IngressInput value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasIngressInput() => $_has(6);
  @$pb.TagNumber(7)
  void clearIngressInput() => $_clearField(7);
  @$pb.TagNumber(7)
  IngressInput ensureIngressInput() => $_ensure(6);

  @$pb.TagNumber(8)
  ScheduleRequest get scheduleRequest => $_getN(7);
  @$pb.TagNumber(8)
  set scheduleRequest(ScheduleRequest value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasScheduleRequest() => $_has(7);
  @$pb.TagNumber(8)
  void clearScheduleRequest() => $_clearField(8);
  @$pb.TagNumber(8)
  ScheduleRequest ensureScheduleRequest() => $_ensure(7);

  @$pb.TagNumber(9)
  InterruptTurnRequest get interruptTurn => $_getN(8);
  @$pb.TagNumber(9)
  set interruptTurn(InterruptTurnRequest value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasInterruptTurn() => $_has(8);
  @$pb.TagNumber(9)
  void clearInterruptTurn() => $_clearField(9);
  @$pb.TagNumber(9)
  InterruptTurnRequest ensureInterruptTurn() => $_ensure(8);
}

/// Create a new agent session.
/// Must be the first message on the stream.
class CreateSessionRequest extends $pb.GeneratedMessage {
  factory CreateSessionRequest({
    $core.String? product,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? config,
  }) {
    final result = create();
    if (product != null) result.product = product;
    if (config != null) result.config.addEntries(config);
    return result;
  }

  CreateSessionRequest._();

  factory CreateSessionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateSessionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateSessionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'product')
    ..m<$core.String, $core.String>(2, _omitFieldNames ? '' : 'config',
        entryClassName: 'CreateSessionRequest.ConfigEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('carbon.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateSessionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateSessionRequest copyWith(void Function(CreateSessionRequest) updates) =>
      super.copyWith((message) => updates(message as CreateSessionRequest))
          as CreateSessionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateSessionRequest create() => CreateSessionRequest._();
  @$core.override
  CreateSessionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateSessionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateSessionRequest>(create);
  static CreateSessionRequest? _defaultInstance;

  /// Product identifier (e.g. "claw"). Determines which plane implementations to use.
  @$pb.TagNumber(1)
  $core.String get product => $_getSZ(0);
  @$pb.TagNumber(1)
  set product($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProduct() => $_has(0);
  @$pb.TagNumber(1)
  void clearProduct() => $_clearField(1);

  /// Optional key-value configuration for the session.
  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.String> get config => $_getMap(1);
}

/// Send user input to the agent. Triggers an agentic loop turn.
class UserMessage extends $pb.GeneratedMessage {
  factory UserMessage({
    $core.String? sessionId,
    $core.String? content,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (content != null) result.content = content;
    return result;
  }

  UserMessage._();

  factory UserMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserMessage copyWith(void Function(UserMessage) updates) =>
      super.copyWith((message) => updates(message as UserMessage))
          as UserMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserMessage create() => UserMessage._();
  @$core.override
  UserMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserMessage>(create);
  static UserMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  /// The user's message content.
  @$pb.TagNumber(2)
  $core.String get content => $_getSZ(1);
  @$pb.TagNumber(2)
  set content($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => $_clearField(2);
}

/// Raw media payload for structured ingress.
class MediaBlob extends $pb.GeneratedMessage {
  factory MediaBlob({
    $core.List<$core.int>? data,
    $core.String? mediaType,
  }) {
    final result = create();
    if (data != null) result.data = data;
    if (mediaType != null) result.mediaType = mediaType;
    return result;
  }

  MediaBlob._();

  factory MediaBlob.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaBlob.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaBlob',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'mediaType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaBlob clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaBlob copyWith(void Function(MediaBlob) updates) =>
      super.copyWith((message) => updates(message as MediaBlob)) as MediaBlob;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaBlob create() => MediaBlob._();
  @$core.override
  MediaBlob createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MediaBlob getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MediaBlob>(create);
  static MediaBlob? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mediaType => $_getSZ(1);
  @$pb.TagNumber(2)
  set mediaType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMediaType() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaType() => $_clearField(2);
}

/// Event payload for structured ingress.
class EventPayload extends $pb.GeneratedMessage {
  factory EventPayload({
    $core.String? eventType,
    $1.Value? payload,
  }) {
    final result = create();
    if (eventType != null) result.eventType = eventType;
    if (payload != null) result.payload = payload;
    return result;
  }

  EventPayload._();

  factory EventPayload.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EventPayload.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EventPayload',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'eventType')
    ..aOM<$1.Value>(2, _omitFieldNames ? '' : 'payload',
        subBuilder: $1.Value.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EventPayload clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EventPayload copyWith(void Function(EventPayload) updates) =>
      super.copyWith((message) => updates(message as EventPayload))
          as EventPayload;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EventPayload create() => EventPayload._();
  @$core.override
  EventPayload createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EventPayload getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EventPayload>(create);
  static EventPayload? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get eventType => $_getSZ(0);
  @$pb.TagNumber(1)
  set eventType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEventType() => $_has(0);
  @$pb.TagNumber(1)
  void clearEventType() => $_clearField(1);

  /// Arbitrary structured payload, aligned with runtime MessageContent::Event.
  @$pb.TagNumber(2)
  $1.Value get payload => $_getN(1);
  @$pb.TagNumber(2)
  set payload($1.Value value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPayload() => $_has(1);
  @$pb.TagNumber(2)
  void clearPayload() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Value ensurePayload() => $_ensure(1);
}

enum IngressInput_Content { text, image, audio, json, event, notSet }

/// Structured ingress input aligned with the runtime IngressMessage model.
class IngressInput extends $pb.GeneratedMessage {
  factory IngressInput({
    $core.String? sessionId,
    IngressIntent? intent,
    $core.String? source,
    $core.String? targetAgent,
    $1.Struct? metadata,
    $core.bool? steer,
    $core.String? text,
    MediaBlob? image,
    MediaBlob? audio,
    $1.Value? json,
    EventPayload? event,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (intent != null) result.intent = intent;
    if (source != null) result.source = source;
    if (targetAgent != null) result.targetAgent = targetAgent;
    if (metadata != null) result.metadata = metadata;
    if (steer != null) result.steer = steer;
    if (text != null) result.text = text;
    if (image != null) result.image = image;
    if (audio != null) result.audio = audio;
    if (json != null) result.json = json;
    if (event != null) result.event = event;
    return result;
  }

  IngressInput._();

  factory IngressInput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IngressInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, IngressInput_Content>
      _IngressInput_ContentByTag = {
    10: IngressInput_Content.text,
    11: IngressInput_Content.image,
    12: IngressInput_Content.audio,
    13: IngressInput_Content.json,
    14: IngressInput_Content.event,
    0: IngressInput_Content.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IngressInput',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..oo(0, [10, 11, 12, 13, 14])
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aE<IngressIntent>(2, _omitFieldNames ? '' : 'intent',
        enumValues: IngressIntent.values)
    ..aOS(3, _omitFieldNames ? '' : 'source')
    ..aOS(4, _omitFieldNames ? '' : 'targetAgent')
    ..aOM<$1.Struct>(5, _omitFieldNames ? '' : 'metadata',
        subBuilder: $1.Struct.create)
    ..aOB(6, _omitFieldNames ? '' : 'steer')
    ..aOS(10, _omitFieldNames ? '' : 'text')
    ..aOM<MediaBlob>(11, _omitFieldNames ? '' : 'image',
        subBuilder: MediaBlob.create)
    ..aOM<MediaBlob>(12, _omitFieldNames ? '' : 'audio',
        subBuilder: MediaBlob.create)
    ..aOM<$1.Value>(13, _omitFieldNames ? '' : 'json',
        subBuilder: $1.Value.create)
    ..aOM<EventPayload>(14, _omitFieldNames ? '' : 'event',
        subBuilder: EventPayload.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngressInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngressInput copyWith(void Function(IngressInput) updates) =>
      super.copyWith((message) => updates(message as IngressInput))
          as IngressInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IngressInput create() => IngressInput._();
  @$core.override
  IngressInput createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IngressInput getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IngressInput>(create);
  static IngressInput? _defaultInstance;

  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  IngressInput_Content whichContent() =>
      _IngressInput_ContentByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  void clearContent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  IngressIntent get intent => $_getN(1);
  @$pb.TagNumber(2)
  set intent(IngressIntent value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasIntent() => $_has(1);
  @$pb.TagNumber(2)
  void clearIntent() => $_clearField(2);

  /// Optional caller-provided source identifier. If empty, the daemon assigns one.
  @$pb.TagNumber(3)
  $core.String get source => $_getSZ(2);
  @$pb.TagNumber(3)
  set source($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => $_clearField(3);

  /// Optional target agent. If empty, the daemon uses the current session.
  @$pb.TagNumber(4)
  $core.String get targetAgent => $_getSZ(3);
  @$pb.TagNumber(4)
  set targetAgent($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTargetAgent() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetAgent() => $_clearField(4);

  /// Optional structured metadata for routing or extra context.
  @$pb.TagNumber(5)
  $1.Struct get metadata => $_getN(4);
  @$pb.TagNumber(5)
  set metadata($1.Struct value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMetadata() => $_has(4);
  @$pb.TagNumber(5)
  void clearMetadata() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Struct ensureMetadata() => $_ensure(4);

  /// If true and a turn is in flight, the daemon enqueues this input for
  /// injection at the next round boundary inside the running turn (Codex-style
  /// "steer"). If false (default), the daemon applies its mailbox policy
  /// (Serialize or DropIfBusy). Only the gRPC ingress path may set this; other
  /// ingress producers (scheduler, telegram) have steer forced to false.
  @$pb.TagNumber(6)
  $core.bool get steer => $_getBF(5);
  @$pb.TagNumber(6)
  set steer($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSteer() => $_has(5);
  @$pb.TagNumber(6)
  void clearSteer() => $_clearField(6);

  @$pb.TagNumber(10)
  $core.String get text => $_getSZ(6);
  @$pb.TagNumber(10)
  set text($core.String value) => $_setString(6, value);
  @$pb.TagNumber(10)
  $core.bool hasText() => $_has(6);
  @$pb.TagNumber(10)
  void clearText() => $_clearField(10);

  @$pb.TagNumber(11)
  MediaBlob get image => $_getN(7);
  @$pb.TagNumber(11)
  set image(MediaBlob value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasImage() => $_has(7);
  @$pb.TagNumber(11)
  void clearImage() => $_clearField(11);
  @$pb.TagNumber(11)
  MediaBlob ensureImage() => $_ensure(7);

  @$pb.TagNumber(12)
  MediaBlob get audio => $_getN(8);
  @$pb.TagNumber(12)
  set audio(MediaBlob value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasAudio() => $_has(8);
  @$pb.TagNumber(12)
  void clearAudio() => $_clearField(12);
  @$pb.TagNumber(12)
  MediaBlob ensureAudio() => $_ensure(8);

  /// Arbitrary structured JSON-like content.
  @$pb.TagNumber(13)
  $1.Value get json => $_getN(9);
  @$pb.TagNumber(13)
  set json($1.Value value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasJson() => $_has(9);
  @$pb.TagNumber(13)
  void clearJson() => $_clearField(13);
  @$pb.TagNumber(13)
  $1.Value ensureJson() => $_ensure(9);

  @$pb.TagNumber(14)
  EventPayload get event => $_getN(10);
  @$pb.TagNumber(14)
  set event(EventPayload value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasEvent() => $_has(10);
  @$pb.TagNumber(14)
  void clearEvent() => $_clearField(14);
  @$pb.TagNumber(14)
  EventPayload ensureEvent() => $_ensure(10);
}

/// Approve or reject a tool call that requires user confirmation.
class ToolApproval extends $pb.GeneratedMessage {
  factory ToolApproval({
    $core.String? sessionId,
    $core.String? toolCallId,
    ApprovalDecision? decision,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (toolCallId != null) result.toolCallId = toolCallId;
    if (decision != null) result.decision = decision;
    return result;
  }

  ToolApproval._();

  factory ToolApproval.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToolApproval.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToolApproval',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'toolCallId')
    ..aE<ApprovalDecision>(3, _omitFieldNames ? '' : 'decision',
        enumValues: ApprovalDecision.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolApproval clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolApproval copyWith(void Function(ToolApproval) updates) =>
      super.copyWith((message) => updates(message as ToolApproval))
          as ToolApproval;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToolApproval create() => ToolApproval._();
  @$core.override
  ToolApproval createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ToolApproval getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToolApproval>(create);
  static ToolApproval? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toolCallId => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolCallId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolCallId() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolCallId() => $_clearField(2);

  @$pb.TagNumber(3)
  ApprovalDecision get decision => $_getN(2);
  @$pb.TagNumber(3)
  set decision(ApprovalDecision value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDecision() => $_has(2);
  @$pb.TagNumber(3)
  void clearDecision() => $_clearField(3);
}

/// Cancel a running session. The daemon will emit SessionEnded.
class CancelSessionRequest extends $pb.GeneratedMessage {
  factory CancelSessionRequest({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  CancelSessionRequest._();

  factory CancelSessionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelSessionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelSessionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelSessionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelSessionRequest copyWith(void Function(CancelSessionRequest) updates) =>
      super.copyWith((message) => updates(message as CancelSessionRequest))
          as CancelSessionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelSessionRequest create() => CancelSessionRequest._();
  @$core.override
  CancelSessionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelSessionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelSessionRequest>(create);
  static CancelSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

/// Cancel only the in-flight turn for this session. The session stays alive
/// and the next ingress is processed normally. Idempotent: no-op if no turn
/// is in flight.
class InterruptTurnRequest extends $pb.GeneratedMessage {
  factory InterruptTurnRequest({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  InterruptTurnRequest._();

  factory InterruptTurnRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InterruptTurnRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InterruptTurnRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InterruptTurnRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InterruptTurnRequest copyWith(void Function(InterruptTurnRequest) updates) =>
      super.copyWith((message) => updates(message as InterruptTurnRequest))
          as InterruptTurnRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InterruptTurnRequest create() => InterruptTurnRequest._();
  @$core.override
  InterruptTurnRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InterruptTurnRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InterruptTurnRequest>(create);
  static InterruptTurnRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

/// Deprecated: use ScheduleRequest instead.
class SetScheduleRequest extends $pb.GeneratedMessage {
  factory SetScheduleRequest({
    $core.String? sessionId,
    $core.String? schedule,
    $core.String? prompt,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (schedule != null) result.schedule = schedule;
    if (prompt != null) result.prompt = prompt;
    return result;
  }

  SetScheduleRequest._();

  factory SetScheduleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetScheduleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetScheduleRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'schedule')
    ..aOS(3, _omitFieldNames ? '' : 'prompt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetScheduleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetScheduleRequest copyWith(void Function(SetScheduleRequest) updates) =>
      super.copyWith((message) => updates(message as SetScheduleRequest))
          as SetScheduleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetScheduleRequest create() => SetScheduleRequest._();
  @$core.override
  SetScheduleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetScheduleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetScheduleRequest>(create);
  static SetScheduleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get schedule => $_getSZ(1);
  @$pb.TagNumber(2)
  set schedule($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSchedule() => $_has(1);
  @$pb.TagNumber(2)
  void clearSchedule() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get prompt => $_getSZ(2);
  @$pb.TagNumber(3)
  set prompt($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrompt() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrompt() => $_clearField(3);
}

/// Manage daemon-owned persistent schedules.
/// Replaces SetScheduleRequest with richer operations.
class ScheduleRequest extends $pb.GeneratedMessage {
  factory ScheduleRequest({
    $core.String? sessionId,
    ScheduleAction? action,
    $core.String? id,
    ScheduleType? scheduleType,
    $core.String? scheduleValue,
    $core.String? timezone,
    $core.String? prompt,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (action != null) result.action = action;
    if (id != null) result.id = id;
    if (scheduleType != null) result.scheduleType = scheduleType;
    if (scheduleValue != null) result.scheduleValue = scheduleValue;
    if (timezone != null) result.timezone = timezone;
    if (prompt != null) result.prompt = prompt;
    return result;
  }

  ScheduleRequest._();

  factory ScheduleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScheduleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScheduleRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aE<ScheduleAction>(2, _omitFieldNames ? '' : 'action',
        enumValues: ScheduleAction.values)
    ..aOS(3, _omitFieldNames ? '' : 'id')
    ..aE<ScheduleType>(4, _omitFieldNames ? '' : 'scheduleType',
        enumValues: ScheduleType.values)
    ..aOS(5, _omitFieldNames ? '' : 'scheduleValue')
    ..aOS(6, _omitFieldNames ? '' : 'timezone')
    ..aOS(7, _omitFieldNames ? '' : 'prompt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleRequest copyWith(void Function(ScheduleRequest) updates) =>
      super.copyWith((message) => updates(message as ScheduleRequest))
          as ScheduleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScheduleRequest create() => ScheduleRequest._();
  @$core.override
  ScheduleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScheduleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScheduleRequest>(create);
  static ScheduleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  ScheduleAction get action => $_getN(1);
  @$pb.TagNumber(2)
  set action(ScheduleAction value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => $_clearField(2);

  /// Schedule job identifier. Required for set, pause, resume, remove.
  @$pb.TagNumber(3)
  $core.String get id => $_getSZ(2);
  @$pb.TagNumber(3)
  set id($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(2);
  @$pb.TagNumber(3)
  void clearId() => $_clearField(3);

  /// Schedule type. Required for set.
  @$pb.TagNumber(4)
  ScheduleType get scheduleType => $_getN(3);
  @$pb.TagNumber(4)
  set scheduleType(ScheduleType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasScheduleType() => $_has(3);
  @$pb.TagNumber(4)
  void clearScheduleType() => $_clearField(4);

  /// Schedule value: seconds for interval, cron expression for cron,
  /// epoch milliseconds for once.
  @$pb.TagNumber(5)
  $core.String get scheduleValue => $_getSZ(4);
  @$pb.TagNumber(5)
  set scheduleValue($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasScheduleValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearScheduleValue() => $_clearField(5);

  /// Timezone for cron expressions (e.g. "Asia/Seoul"). Default: UTC.
  @$pb.TagNumber(6)
  $core.String get timezone => $_getSZ(5);
  @$pb.TagNumber(6)
  set timezone($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTimezone() => $_has(5);
  @$pb.TagNumber(6)
  void clearTimezone() => $_clearField(6);

  /// Prompt to execute when the schedule fires. Required for set.
  @$pb.TagNumber(7)
  $core.String get prompt => $_getSZ(6);
  @$pb.TagNumber(7)
  set prompt($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPrompt() => $_has(6);
  @$pb.TagNumber(7)
  void clearPrompt() => $_clearField(7);
}

enum ServerEvent_Event {
  sessionCreated,
  textDelta,
  toolUseStart,
  toolResult,
  turnComplete,
  error,
  sessionEnded,
  scheduleSet,
  scheduledTurnStarted,
  subAgentSpawned,
  subAgentCompleted,
  threadComplete,
  scheduleEvent,
  turnStarted,
  toolApprovalRequest,
  notSet
}

/// Wrapper for all server-to-client events on the session stream.
class ServerEvent extends $pb.GeneratedMessage {
  factory ServerEvent({
    $core.String? sessionId,
    SessionCreated? sessionCreated,
    TextDelta? textDelta,
    ToolUseStart? toolUseStart,
    ToolResult? toolResult,
    TurnComplete? turnComplete,
    ErrorEvent? error,
    SessionEnded? sessionEnded,
    ScheduleSet? scheduleSet,
    ScheduledTurnStarted? scheduledTurnStarted,
    SubAgentSpawned? subAgentSpawned,
    SubAgentCompleted? subAgentCompleted,
    ThreadComplete? threadComplete,
    ScheduleEvent? scheduleEvent,
    TurnStarted? turnStarted,
    ToolApprovalRequest? toolApprovalRequest,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (sessionCreated != null) result.sessionCreated = sessionCreated;
    if (textDelta != null) result.textDelta = textDelta;
    if (toolUseStart != null) result.toolUseStart = toolUseStart;
    if (toolResult != null) result.toolResult = toolResult;
    if (turnComplete != null) result.turnComplete = turnComplete;
    if (error != null) result.error = error;
    if (sessionEnded != null) result.sessionEnded = sessionEnded;
    if (scheduleSet != null) result.scheduleSet = scheduleSet;
    if (scheduledTurnStarted != null)
      result.scheduledTurnStarted = scheduledTurnStarted;
    if (subAgentSpawned != null) result.subAgentSpawned = subAgentSpawned;
    if (subAgentCompleted != null) result.subAgentCompleted = subAgentCompleted;
    if (threadComplete != null) result.threadComplete = threadComplete;
    if (scheduleEvent != null) result.scheduleEvent = scheduleEvent;
    if (turnStarted != null) result.turnStarted = turnStarted;
    if (toolApprovalRequest != null)
      result.toolApprovalRequest = toolApprovalRequest;
    return result;
  }

  ServerEvent._();

  factory ServerEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServerEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ServerEvent_Event> _ServerEvent_EventByTag =
      {
    2: ServerEvent_Event.sessionCreated,
    3: ServerEvent_Event.textDelta,
    4: ServerEvent_Event.toolUseStart,
    5: ServerEvent_Event.toolResult,
    6: ServerEvent_Event.turnComplete,
    7: ServerEvent_Event.error,
    8: ServerEvent_Event.sessionEnded,
    9: ServerEvent_Event.scheduleSet,
    10: ServerEvent_Event.scheduledTurnStarted,
    11: ServerEvent_Event.subAgentSpawned,
    12: ServerEvent_Event.subAgentCompleted,
    13: ServerEvent_Event.threadComplete,
    14: ServerEvent_Event.scheduleEvent,
    15: ServerEvent_Event.turnStarted,
    16: ServerEvent_Event.toolApprovalRequest,
    0: ServerEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16])
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOM<SessionCreated>(2, _omitFieldNames ? '' : 'sessionCreated',
        subBuilder: SessionCreated.create)
    ..aOM<TextDelta>(3, _omitFieldNames ? '' : 'textDelta',
        subBuilder: TextDelta.create)
    ..aOM<ToolUseStart>(4, _omitFieldNames ? '' : 'toolUseStart',
        subBuilder: ToolUseStart.create)
    ..aOM<ToolResult>(5, _omitFieldNames ? '' : 'toolResult',
        subBuilder: ToolResult.create)
    ..aOM<TurnComplete>(6, _omitFieldNames ? '' : 'turnComplete',
        subBuilder: TurnComplete.create)
    ..aOM<ErrorEvent>(7, _omitFieldNames ? '' : 'error',
        subBuilder: ErrorEvent.create)
    ..aOM<SessionEnded>(8, _omitFieldNames ? '' : 'sessionEnded',
        subBuilder: SessionEnded.create)
    ..aOM<ScheduleSet>(9, _omitFieldNames ? '' : 'scheduleSet',
        subBuilder: ScheduleSet.create)
    ..aOM<ScheduledTurnStarted>(
        10, _omitFieldNames ? '' : 'scheduledTurnStarted',
        subBuilder: ScheduledTurnStarted.create)
    ..aOM<SubAgentSpawned>(11, _omitFieldNames ? '' : 'subAgentSpawned',
        subBuilder: SubAgentSpawned.create)
    ..aOM<SubAgentCompleted>(12, _omitFieldNames ? '' : 'subAgentCompleted',
        subBuilder: SubAgentCompleted.create)
    ..aOM<ThreadComplete>(13, _omitFieldNames ? '' : 'threadComplete',
        subBuilder: ThreadComplete.create)
    ..aOM<ScheduleEvent>(14, _omitFieldNames ? '' : 'scheduleEvent',
        subBuilder: ScheduleEvent.create)
    ..aOM<TurnStarted>(15, _omitFieldNames ? '' : 'turnStarted',
        subBuilder: TurnStarted.create)
    ..aOM<ToolApprovalRequest>(16, _omitFieldNames ? '' : 'toolApprovalRequest',
        subBuilder: ToolApprovalRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerEvent copyWith(void Function(ServerEvent) updates) =>
      super.copyWith((message) => updates(message as ServerEvent))
          as ServerEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerEvent create() => ServerEvent._();
  @$core.override
  ServerEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServerEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServerEvent>(create);
  static ServerEvent? _defaultInstance;

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
  ServerEvent_Event whichEvent() => _ServerEvent_EventByTag[$_whichOneof(0)]!;
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
  void clearEvent() => $_clearField($_whichOneof(0));

  /// The session this event belongs to.
  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  SessionCreated get sessionCreated => $_getN(1);
  @$pb.TagNumber(2)
  set sessionCreated(SessionCreated value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionCreated() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionCreated() => $_clearField(2);
  @$pb.TagNumber(2)
  SessionCreated ensureSessionCreated() => $_ensure(1);

  @$pb.TagNumber(3)
  TextDelta get textDelta => $_getN(2);
  @$pb.TagNumber(3)
  set textDelta(TextDelta value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTextDelta() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextDelta() => $_clearField(3);
  @$pb.TagNumber(3)
  TextDelta ensureTextDelta() => $_ensure(2);

  @$pb.TagNumber(4)
  ToolUseStart get toolUseStart => $_getN(3);
  @$pb.TagNumber(4)
  set toolUseStart(ToolUseStart value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasToolUseStart() => $_has(3);
  @$pb.TagNumber(4)
  void clearToolUseStart() => $_clearField(4);
  @$pb.TagNumber(4)
  ToolUseStart ensureToolUseStart() => $_ensure(3);

  @$pb.TagNumber(5)
  ToolResult get toolResult => $_getN(4);
  @$pb.TagNumber(5)
  set toolResult(ToolResult value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasToolResult() => $_has(4);
  @$pb.TagNumber(5)
  void clearToolResult() => $_clearField(5);
  @$pb.TagNumber(5)
  ToolResult ensureToolResult() => $_ensure(4);

  @$pb.TagNumber(6)
  TurnComplete get turnComplete => $_getN(5);
  @$pb.TagNumber(6)
  set turnComplete(TurnComplete value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasTurnComplete() => $_has(5);
  @$pb.TagNumber(6)
  void clearTurnComplete() => $_clearField(6);
  @$pb.TagNumber(6)
  TurnComplete ensureTurnComplete() => $_ensure(5);

  @$pb.TagNumber(7)
  ErrorEvent get error => $_getN(6);
  @$pb.TagNumber(7)
  set error(ErrorEvent value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasError() => $_has(6);
  @$pb.TagNumber(7)
  void clearError() => $_clearField(7);
  @$pb.TagNumber(7)
  ErrorEvent ensureError() => $_ensure(6);

  @$pb.TagNumber(8)
  SessionEnded get sessionEnded => $_getN(7);
  @$pb.TagNumber(8)
  set sessionEnded(SessionEnded value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSessionEnded() => $_has(7);
  @$pb.TagNumber(8)
  void clearSessionEnded() => $_clearField(8);
  @$pb.TagNumber(8)
  SessionEnded ensureSessionEnded() => $_ensure(7);

  @$pb.TagNumber(9)
  ScheduleSet get scheduleSet => $_getN(8);
  @$pb.TagNumber(9)
  set scheduleSet(ScheduleSet value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasScheduleSet() => $_has(8);
  @$pb.TagNumber(9)
  void clearScheduleSet() => $_clearField(9);
  @$pb.TagNumber(9)
  ScheduleSet ensureScheduleSet() => $_ensure(8);

  @$pb.TagNumber(10)
  ScheduledTurnStarted get scheduledTurnStarted => $_getN(9);
  @$pb.TagNumber(10)
  set scheduledTurnStarted(ScheduledTurnStarted value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasScheduledTurnStarted() => $_has(9);
  @$pb.TagNumber(10)
  void clearScheduledTurnStarted() => $_clearField(10);
  @$pb.TagNumber(10)
  ScheduledTurnStarted ensureScheduledTurnStarted() => $_ensure(9);

  @$pb.TagNumber(11)
  SubAgentSpawned get subAgentSpawned => $_getN(10);
  @$pb.TagNumber(11)
  set subAgentSpawned(SubAgentSpawned value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasSubAgentSpawned() => $_has(10);
  @$pb.TagNumber(11)
  void clearSubAgentSpawned() => $_clearField(11);
  @$pb.TagNumber(11)
  SubAgentSpawned ensureSubAgentSpawned() => $_ensure(10);

  @$pb.TagNumber(12)
  SubAgentCompleted get subAgentCompleted => $_getN(11);
  @$pb.TagNumber(12)
  set subAgentCompleted(SubAgentCompleted value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasSubAgentCompleted() => $_has(11);
  @$pb.TagNumber(12)
  void clearSubAgentCompleted() => $_clearField(12);
  @$pb.TagNumber(12)
  SubAgentCompleted ensureSubAgentCompleted() => $_ensure(11);

  @$pb.TagNumber(13)
  ThreadComplete get threadComplete => $_getN(12);
  @$pb.TagNumber(13)
  set threadComplete(ThreadComplete value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasThreadComplete() => $_has(12);
  @$pb.TagNumber(13)
  void clearThreadComplete() => $_clearField(13);
  @$pb.TagNumber(13)
  ThreadComplete ensureThreadComplete() => $_ensure(12);

  @$pb.TagNumber(14)
  ScheduleEvent get scheduleEvent => $_getN(13);
  @$pb.TagNumber(14)
  set scheduleEvent(ScheduleEvent value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasScheduleEvent() => $_has(13);
  @$pb.TagNumber(14)
  void clearScheduleEvent() => $_clearField(14);
  @$pb.TagNumber(14)
  ScheduleEvent ensureScheduleEvent() => $_ensure(13);

  @$pb.TagNumber(15)
  TurnStarted get turnStarted => $_getN(14);
  @$pb.TagNumber(15)
  set turnStarted(TurnStarted value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasTurnStarted() => $_has(14);
  @$pb.TagNumber(15)
  void clearTurnStarted() => $_clearField(15);
  @$pb.TagNumber(15)
  TurnStarted ensureTurnStarted() => $_ensure(14);

  @$pb.TagNumber(16)
  ToolApprovalRequest get toolApprovalRequest => $_getN(15);
  @$pb.TagNumber(16)
  set toolApprovalRequest(ToolApprovalRequest value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasToolApprovalRequest() => $_has(15);
  @$pb.TagNumber(16)
  void clearToolApprovalRequest() => $_clearField(16);
  @$pb.TagNumber(16)
  ToolApprovalRequest ensureToolApprovalRequest() => $_ensure(15);
}

/// A new turn has started processing. Broadcast to all connected clients
/// so observers can see what prompt triggered the turn.
class TurnStarted extends $pb.GeneratedMessage {
  factory TurnStarted({
    $core.String? source,
    $core.String? prompt,
  }) {
    final result = create();
    if (source != null) result.source = source;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'source')
    ..aOS(2, _omitFieldNames ? '' : 'prompt')
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
  $core.String get source => $_getSZ(0);
  @$pb.TagNumber(1)
  set source($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSource() => $_has(0);
  @$pb.TagNumber(1)
  void clearSource() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get prompt => $_getSZ(1);
  @$pb.TagNumber(2)
  set prompt($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrompt() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrompt() => $_clearField(2);
}

/// Confirms session was created. Contains the assigned session ID.
class SessionCreated extends $pb.GeneratedMessage {
  factory SessionCreated({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  SessionCreated._();

  factory SessionCreated.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SessionCreated.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionCreated',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionCreated clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionCreated copyWith(void Function(SessionCreated) updates) =>
      super.copyWith((message) => updates(message as SessionCreated))
          as SessionCreated;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SessionCreated create() => SessionCreated._();
  @$core.override
  SessionCreated createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SessionCreated getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionCreated>(create);
  static SessionCreated? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

/// A chunk of text output from the LLM. May arrive in multiple deltas.
class TextDelta extends $pb.GeneratedMessage {
  factory TextDelta({
    $core.String? content,
  }) {
    final result = create();
    if (content != null) result.content = content;
    return result;
  }

  TextDelta._();

  factory TextDelta.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TextDelta.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TextDelta',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextDelta clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextDelta copyWith(void Function(TextDelta) updates) =>
      super.copyWith((message) => updates(message as TextDelta)) as TextDelta;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TextDelta create() => TextDelta._();
  @$core.override
  TextDelta createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TextDelta getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TextDelta>(create);
  static TextDelta? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get content => $_getSZ(0);
  @$pb.TagNumber(1)
  set content($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => $_clearField(1);
}

/// The LLM wants to call a tool. Followed by ToolResult after execution.
class ToolUseStart extends $pb.GeneratedMessage {
  factory ToolUseStart({
    $core.String? toolCallId,
    $core.String? toolName,
    $core.String? argumentsJson,
  }) {
    final result = create();
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'toolCallId')
    ..aOS(2, _omitFieldNames ? '' : 'toolName')
    ..aOS(3, _omitFieldNames ? '' : 'argumentsJson')
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
  $core.String get toolCallId => $_getSZ(0);
  @$pb.TagNumber(1)
  set toolCallId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToolCallId() => $_has(0);
  @$pb.TagNumber(1)
  void clearToolCallId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toolName => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolName() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolName() => $_clearField(2);

  /// Tool arguments as JSON string.
  @$pb.TagNumber(3)
  $core.String get argumentsJson => $_getSZ(2);
  @$pb.TagNumber(3)
  set argumentsJson($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasArgumentsJson() => $_has(2);
  @$pb.TagNumber(3)
  void clearArgumentsJson() => $_clearField(3);
}

/// Result of a tool execution.
class ToolResult extends $pb.GeneratedMessage {
  factory ToolResult({
    $core.String? toolCallId,
    $core.String? output,
    $core.bool? isError,
    $core.String? metadataJson,
    $core.String? cursorJson,
  }) {
    final result = create();
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'toolCallId')
    ..aOS(2, _omitFieldNames ? '' : 'output')
    ..aOB(3, _omitFieldNames ? '' : 'isError')
    ..aOS(4, _omitFieldNames ? '' : 'metadataJson')
    ..aOS(5, _omitFieldNames ? '' : 'cursorJson')
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
  $core.String get toolCallId => $_getSZ(0);
  @$pb.TagNumber(1)
  set toolCallId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToolCallId() => $_has(0);
  @$pb.TagNumber(1)
  void clearToolCallId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get output => $_getSZ(1);
  @$pb.TagNumber(2)
  set output($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOutput() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutput() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isError => $_getBF(2);
  @$pb.TagNumber(3)
  set isError($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsError() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsError() => $_clearField(3);

  /// Optional JSON-serialized metadata emitted by the tool.
  @$pb.TagNumber(4)
  $core.String get metadataJson => $_getSZ(3);
  @$pb.TagNumber(4)
  set metadataJson($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMetadataJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearMetadataJson() => $_clearField(4);

  /// Optional JSON-serialized cursor handle emitted by the tool.
  @$pb.TagNumber(5)
  $core.String get cursorJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set cursorJson($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCursorJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearCursorJson() => $_clearField(5);
}

/// The agent needs user approval before executing a tool.
/// Sent when tool policy is Confirm. Port should prompt user and respond with ToolApproval.
class ToolApprovalRequest extends $pb.GeneratedMessage {
  factory ToolApprovalRequest({
    $core.String? toolCallId,
    $core.String? toolName,
    $core.String? argumentsJson,
    $core.String? reason,
    $core.int? timeoutSecs,
  }) {
    final result = create();
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'toolCallId')
    ..aOS(2, _omitFieldNames ? '' : 'toolName')
    ..aOS(3, _omitFieldNames ? '' : 'argumentsJson')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..aI(5, _omitFieldNames ? '' : 'timeoutSecs',
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
  $core.String get toolCallId => $_getSZ(0);
  @$pb.TagNumber(1)
  set toolCallId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToolCallId() => $_has(0);
  @$pb.TagNumber(1)
  void clearToolCallId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toolName => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolName() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get argumentsJson => $_getSZ(2);
  @$pb.TagNumber(3)
  set argumentsJson($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasArgumentsJson() => $_has(2);
  @$pb.TagNumber(3)
  void clearArgumentsJson() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get timeoutSecs => $_getIZ(4);
  @$pb.TagNumber(5)
  set timeoutSecs($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTimeoutSecs() => $_has(4);
  @$pb.TagNumber(5)
  void clearTimeoutSecs() => $_clearField(5);
}

/// A turn (one cycle of user input → LLM → tools → response) has completed.
class TurnComplete extends $pb.GeneratedMessage {
  factory TurnComplete({
    $core.String? usageJson,
  }) {
    final result = create();
    if (usageJson != null) result.usageJson = usageJson;
    return result;
  }

  TurnComplete._();

  factory TurnComplete.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TurnComplete.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TurnComplete',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'usageJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnComplete clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnComplete copyWith(void Function(TurnComplete) updates) =>
      super.copyWith((message) => updates(message as TurnComplete))
          as TurnComplete;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TurnComplete create() => TurnComplete._();
  @$core.override
  TurnComplete createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TurnComplete getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TurnComplete>(create);
  static TurnComplete? _defaultInstance;

  /// Structured token usage summary as JSON.
  @$pb.TagNumber(1)
  $core.String get usageJson => $_getSZ(0);
  @$pb.TagNumber(1)
  set usageJson($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsageJson() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsageJson() => $_clearField(1);
}

/// The current thread (user-request and all its continuation turns) has finished.
class ThreadComplete extends $pb.GeneratedMessage {
  factory ThreadComplete() => create();

  ThreadComplete._();

  factory ThreadComplete.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ThreadComplete.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadComplete',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadComplete clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadComplete copyWith(void Function(ThreadComplete) updates) =>
      super.copyWith((message) => updates(message as ThreadComplete))
          as ThreadComplete;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThreadComplete create() => ThreadComplete._();
  @$core.override
  ThreadComplete createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ThreadComplete getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadComplete>(create);
  static ThreadComplete? _defaultInstance;
}

/// An error occurred. If fatal=true, the session is terminated.
class ErrorEvent extends $pb.GeneratedMessage {
  factory ErrorEvent({
    $core.String? code,
    $core.String? message,
    $core.bool? fatal,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    if (fatal != null) result.fatal = fatal;
    return result;
  }

  ErrorEvent._();

  factory ErrorEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ErrorEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ErrorEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOB(3, _omitFieldNames ? '' : 'fatal')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorEvent copyWith(void Function(ErrorEvent) updates) =>
      super.copyWith((message) => updates(message as ErrorEvent)) as ErrorEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ErrorEvent create() => ErrorEvent._();
  @$core.override
  ErrorEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ErrorEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ErrorEvent>(create);
  static ErrorEvent? _defaultInstance;

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
}

/// The session has ended (cancelled, completed, or expired).
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
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

/// Deprecated: use ScheduleEvent instead.
class ScheduleSet extends $pb.GeneratedMessage {
  factory ScheduleSet({
    $core.String? schedule,
    $core.String? prompt,
  }) {
    final result = create();
    if (schedule != null) result.schedule = schedule;
    if (prompt != null) result.prompt = prompt;
    return result;
  }

  ScheduleSet._();

  factory ScheduleSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScheduleSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScheduleSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'schedule')
    ..aOS(2, _omitFieldNames ? '' : 'prompt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleSet copyWith(void Function(ScheduleSet) updates) =>
      super.copyWith((message) => updates(message as ScheduleSet))
          as ScheduleSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScheduleSet create() => ScheduleSet._();
  @$core.override
  ScheduleSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScheduleSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScheduleSet>(create);
  static ScheduleSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get schedule => $_getSZ(0);
  @$pb.TagNumber(1)
  set schedule($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSchedule() => $_has(0);
  @$pb.TagNumber(1)
  void clearSchedule() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get prompt => $_getSZ(1);
  @$pb.TagNumber(2)
  set prompt($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrompt() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrompt() => $_clearField(2);
}

/// A scheduled turn is starting. Emitted before the agentic loop runs.
class ScheduledTurnStarted extends $pb.GeneratedMessage {
  factory ScheduledTurnStarted({
    $core.String? prompt,
  }) {
    final result = create();
    if (prompt != null) result.prompt = prompt;
    return result;
  }

  ScheduledTurnStarted._();

  factory ScheduledTurnStarted.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScheduledTurnStarted.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScheduledTurnStarted',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'prompt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduledTurnStarted clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduledTurnStarted copyWith(void Function(ScheduledTurnStarted) updates) =>
      super.copyWith((message) => updates(message as ScheduledTurnStarted))
          as ScheduledTurnStarted;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScheduledTurnStarted create() => ScheduledTurnStarted._();
  @$core.override
  ScheduledTurnStarted createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScheduledTurnStarted getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScheduledTurnStarted>(create);
  static ScheduledTurnStarted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get prompt => $_getSZ(0);
  @$pb.TagNumber(1)
  set prompt($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrompt() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrompt() => $_clearField(1);
}

/// Server event for schedule operations (richer than ScheduleSet).
class ScheduleEvent extends $pb.GeneratedMessage {
  factory ScheduleEvent({
    ScheduleAction? action,
    $core.String? id,
    $core.String? status,
    $core.String? scheduleDescription,
    $fixnum.Int64? nextRunAtMs,
    $core.String? jobsJson,
  }) {
    final result = create();
    if (action != null) result.action = action;
    if (id != null) result.id = id;
    if (status != null) result.status = status;
    if (scheduleDescription != null)
      result.scheduleDescription = scheduleDescription;
    if (nextRunAtMs != null) result.nextRunAtMs = nextRunAtMs;
    if (jobsJson != null) result.jobsJson = jobsJson;
    return result;
  }

  ScheduleEvent._();

  factory ScheduleEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScheduleEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScheduleEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aE<ScheduleAction>(1, _omitFieldNames ? '' : 'action',
        enumValues: ScheduleAction.values)
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..aOS(3, _omitFieldNames ? '' : 'status')
    ..aOS(4, _omitFieldNames ? '' : 'scheduleDescription')
    ..aInt64(5, _omitFieldNames ? '' : 'nextRunAtMs')
    ..aOS(6, _omitFieldNames ? '' : 'jobsJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleEvent copyWith(void Function(ScheduleEvent) updates) =>
      super.copyWith((message) => updates(message as ScheduleEvent))
          as ScheduleEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScheduleEvent create() => ScheduleEvent._();
  @$core.override
  ScheduleEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScheduleEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScheduleEvent>(create);
  static ScheduleEvent? _defaultInstance;

  @$pb.TagNumber(1)
  ScheduleAction get action => $_getN(0);
  @$pb.TagNumber(1)
  set action(ScheduleAction value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAction() => $_has(0);
  @$pb.TagNumber(1)
  void clearAction() => $_clearField(1);

  /// Job identifier.
  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  /// Human-readable status message (e.g. "created", "paused", "removed").
  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  /// Human-readable description of the schedule (e.g. "every 300s", "cron '0 9 * * *'").
  @$pb.TagNumber(4)
  $core.String get scheduleDescription => $_getSZ(3);
  @$pb.TagNumber(4)
  set scheduleDescription($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScheduleDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearScheduleDescription() => $_clearField(4);

  /// Next run time as epoch milliseconds, if applicable.
  @$pb.TagNumber(5)
  $fixnum.Int64 get nextRunAtMs => $_getI64(4);
  @$pb.TagNumber(5)
  set nextRunAtMs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNextRunAtMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearNextRunAtMs() => $_clearField(5);

  /// Full job listing (for list action). JSON-encoded array.
  @$pb.TagNumber(6)
  $core.String get jobsJson => $_getSZ(5);
  @$pb.TagNumber(6)
  set jobsJson($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasJobsJson() => $_has(5);
  @$pb.TagNumber(6)
  void clearJobsJson() => $_clearField(6);
}

/// Spawn a sub-agent within the current session.
/// The sub-agent runs as a separate session inside the daemon and reports
/// its result back to the parent session.
class SpawnSubAgentRequest extends $pb.GeneratedMessage {
  factory SpawnSubAgentRequest({
    $core.String? sessionId,
    $core.String? product,
    $core.String? prompt,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? config,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (product != null) result.product = product;
    if (prompt != null) result.prompt = prompt;
    if (config != null) result.config.addEntries(config);
    return result;
  }

  SpawnSubAgentRequest._();

  factory SpawnSubAgentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SpawnSubAgentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SpawnSubAgentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'product')
    ..aOS(3, _omitFieldNames ? '' : 'prompt')
    ..m<$core.String, $core.String>(4, _omitFieldNames ? '' : 'config',
        entryClassName: 'SpawnSubAgentRequest.ConfigEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('carbon.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpawnSubAgentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpawnSubAgentRequest copyWith(void Function(SpawnSubAgentRequest) updates) =>
      super.copyWith((message) => updates(message as SpawnSubAgentRequest))
          as SpawnSubAgentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SpawnSubAgentRequest create() => SpawnSubAgentRequest._();
  @$core.override
  SpawnSubAgentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SpawnSubAgentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SpawnSubAgentRequest>(create);
  static SpawnSubAgentRequest? _defaultInstance;

  /// Parent session ID.
  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  /// Product for the sub-agent (can be same or different from parent).
  @$pb.TagNumber(2)
  $core.String get product => $_getSZ(1);
  @$pb.TagNumber(2)
  set product($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProduct() => $_has(1);
  @$pb.TagNumber(2)
  void clearProduct() => $_clearField(2);

  /// The task/prompt for the sub-agent.
  @$pb.TagNumber(3)
  $core.String get prompt => $_getSZ(2);
  @$pb.TagNumber(3)
  set prompt($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrompt() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrompt() => $_clearField(3);

  /// Optional config overrides for the sub-agent session.
  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.String> get config => $_getMap(3);
}

/// Confirms a sub-agent was spawned. The sub_session_id can be used to track it.
class SubAgentSpawned extends $pb.GeneratedMessage {
  factory SubAgentSpawned({
    $core.String? subSessionId,
    $core.String? prompt,
  }) {
    final result = create();
    if (subSessionId != null) result.subSessionId = subSessionId;
    if (prompt != null) result.prompt = prompt;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'subSessionId')
    ..aOS(2, _omitFieldNames ? '' : 'prompt')
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
  $core.String get subSessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set subSessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSubSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get prompt => $_getSZ(1);
  @$pb.TagNumber(2)
  set prompt($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrompt() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrompt() => $_clearField(2);
}

/// A sub-agent has finished its task and returned a result.
class SubAgentCompleted extends $pb.GeneratedMessage {
  factory SubAgentCompleted({
    $core.String? subSessionId,
    $core.String? result,
    $core.bool? isError,
  }) {
    final result$ = create();
    if (subSessionId != null) result$.subSessionId = subSessionId;
    if (result != null) result$.result = result;
    if (isError != null) result$.isError = isError;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'subSessionId')
    ..aOS(2, _omitFieldNames ? '' : 'result')
    ..aOB(3, _omitFieldNames ? '' : 'isError')
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
  $core.String get subSessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set subSessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSubSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubSessionId() => $_clearField(1);

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
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
