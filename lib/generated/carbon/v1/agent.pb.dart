//
//  Generated code. Do not modify.
//  source: carbon/v1/agent.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/struct.pb.dart' as $1;
import 'agent.pbenum.dart';

export 'agent.pbenum.dart';

enum ClientMessage_Message {
  createSession, 
  userMessage, 
  toolApproval, 
  cancelSession, 
  setSchedule, 
  spawnSubAgent, 
  ingressInput, 
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
  }) {
    final $result = create();
    if (createSession != null) {
      $result.createSession = createSession;
    }
    if (userMessage != null) {
      $result.userMessage = userMessage;
    }
    if (toolApproval != null) {
      $result.toolApproval = toolApproval;
    }
    if (cancelSession != null) {
      $result.cancelSession = cancelSession;
    }
    if (setSchedule != null) {
      $result.setSchedule = setSchedule;
    }
    if (spawnSubAgent != null) {
      $result.spawnSubAgent = spawnSubAgent;
    }
    if (ingressInput != null) {
      $result.ingressInput = ingressInput;
    }
    return $result;
  }
  ClientMessage._() : super();
  factory ClientMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ClientMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, ClientMessage_Message> _ClientMessage_MessageByTag = {
    1 : ClientMessage_Message.createSession,
    2 : ClientMessage_Message.userMessage,
    3 : ClientMessage_Message.toolApproval,
    4 : ClientMessage_Message.cancelSession,
    5 : ClientMessage_Message.setSchedule,
    6 : ClientMessage_Message.spawnSubAgent,
    7 : ClientMessage_Message.ingressInput,
    0 : ClientMessage_Message.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ClientMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7])
    ..aOM<CreateSessionRequest>(1, _omitFieldNames ? '' : 'createSession', subBuilder: CreateSessionRequest.create)
    ..aOM<UserMessage>(2, _omitFieldNames ? '' : 'userMessage', subBuilder: UserMessage.create)
    ..aOM<ToolApproval>(3, _omitFieldNames ? '' : 'toolApproval', subBuilder: ToolApproval.create)
    ..aOM<CancelSessionRequest>(4, _omitFieldNames ? '' : 'cancelSession', subBuilder: CancelSessionRequest.create)
    ..aOM<SetScheduleRequest>(5, _omitFieldNames ? '' : 'setSchedule', subBuilder: SetScheduleRequest.create)
    ..aOM<SpawnSubAgentRequest>(6, _omitFieldNames ? '' : 'spawnSubAgent', subBuilder: SpawnSubAgentRequest.create)
    ..aOM<IngressInput>(7, _omitFieldNames ? '' : 'ingressInput', subBuilder: IngressInput.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ClientMessage clone() => ClientMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ClientMessage copyWith(void Function(ClientMessage) updates) => super.copyWith((message) => updates(message as ClientMessage)) as ClientMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClientMessage create() => ClientMessage._();
  ClientMessage createEmptyInstance() => create();
  static $pb.PbList<ClientMessage> createRepeated() => $pb.PbList<ClientMessage>();
  @$core.pragma('dart2js:noInline')
  static ClientMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClientMessage>(create);
  static ClientMessage? _defaultInstance;

  ClientMessage_Message whichMessage() => _ClientMessage_MessageByTag[$_whichOneof(0)]!;
  void clearMessage() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  CreateSessionRequest get createSession => $_getN(0);
  @$pb.TagNumber(1)
  set createSession(CreateSessionRequest v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreateSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreateSession() => clearField(1);
  @$pb.TagNumber(1)
  CreateSessionRequest ensureCreateSession() => $_ensure(0);

  @$pb.TagNumber(2)
  UserMessage get userMessage => $_getN(1);
  @$pb.TagNumber(2)
  set userMessage(UserMessage v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserMessage() => clearField(2);
  @$pb.TagNumber(2)
  UserMessage ensureUserMessage() => $_ensure(1);

  @$pb.TagNumber(3)
  ToolApproval get toolApproval => $_getN(2);
  @$pb.TagNumber(3)
  set toolApproval(ToolApproval v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasToolApproval() => $_has(2);
  @$pb.TagNumber(3)
  void clearToolApproval() => clearField(3);
  @$pb.TagNumber(3)
  ToolApproval ensureToolApproval() => $_ensure(2);

  @$pb.TagNumber(4)
  CancelSessionRequest get cancelSession => $_getN(3);
  @$pb.TagNumber(4)
  set cancelSession(CancelSessionRequest v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCancelSession() => $_has(3);
  @$pb.TagNumber(4)
  void clearCancelSession() => clearField(4);
  @$pb.TagNumber(4)
  CancelSessionRequest ensureCancelSession() => $_ensure(3);

  @$pb.TagNumber(5)
  SetScheduleRequest get setSchedule => $_getN(4);
  @$pb.TagNumber(5)
  set setSchedule(SetScheduleRequest v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasSetSchedule() => $_has(4);
  @$pb.TagNumber(5)
  void clearSetSchedule() => clearField(5);
  @$pb.TagNumber(5)
  SetScheduleRequest ensureSetSchedule() => $_ensure(4);

  @$pb.TagNumber(6)
  SpawnSubAgentRequest get spawnSubAgent => $_getN(5);
  @$pb.TagNumber(6)
  set spawnSubAgent(SpawnSubAgentRequest v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasSpawnSubAgent() => $_has(5);
  @$pb.TagNumber(6)
  void clearSpawnSubAgent() => clearField(6);
  @$pb.TagNumber(6)
  SpawnSubAgentRequest ensureSpawnSubAgent() => $_ensure(5);

  @$pb.TagNumber(7)
  IngressInput get ingressInput => $_getN(6);
  @$pb.TagNumber(7)
  set ingressInput(IngressInput v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasIngressInput() => $_has(6);
  @$pb.TagNumber(7)
  void clearIngressInput() => clearField(7);
  @$pb.TagNumber(7)
  IngressInput ensureIngressInput() => $_ensure(6);
}

/// Create a new agent session.
/// Must be the first message on the stream.
class CreateSessionRequest extends $pb.GeneratedMessage {
  factory CreateSessionRequest({
    $core.String? product,
    $core.Map<$core.String, $core.String>? config,
  }) {
    final $result = create();
    if (product != null) {
      $result.product = product;
    }
    if (config != null) {
      $result.config.addAll(config);
    }
    return $result;
  }
  CreateSessionRequest._() : super();
  factory CreateSessionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateSessionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateSessionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'product')
    ..m<$core.String, $core.String>(2, _omitFieldNames ? '' : 'config', entryClassName: 'CreateSessionRequest.ConfigEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('carbon.v1'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateSessionRequest clone() => CreateSessionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateSessionRequest copyWith(void Function(CreateSessionRequest) updates) => super.copyWith((message) => updates(message as CreateSessionRequest)) as CreateSessionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateSessionRequest create() => CreateSessionRequest._();
  CreateSessionRequest createEmptyInstance() => create();
  static $pb.PbList<CreateSessionRequest> createRepeated() => $pb.PbList<CreateSessionRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateSessionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateSessionRequest>(create);
  static CreateSessionRequest? _defaultInstance;

  /// Product identifier (e.g. "claw"). Determines which plane implementations to use.
  @$pb.TagNumber(1)
  $core.String get product => $_getSZ(0);
  @$pb.TagNumber(1)
  set product($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProduct() => $_has(0);
  @$pb.TagNumber(1)
  void clearProduct() => clearField(1);

  /// Optional key-value configuration for the session.
  @$pb.TagNumber(2)
  $core.Map<$core.String, $core.String> get config => $_getMap(1);
}

/// Send user input to the agent. Triggers an agentic loop turn.
class UserMessage extends $pb.GeneratedMessage {
  factory UserMessage({
    $core.String? sessionId,
    $core.String? content,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (content != null) {
      $result.content = content;
    }
    return $result;
  }
  UserMessage._() : super();
  factory UserMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UserMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserMessage clone() => UserMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserMessage copyWith(void Function(UserMessage) updates) => super.copyWith((message) => updates(message as UserMessage)) as UserMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserMessage create() => UserMessage._();
  UserMessage createEmptyInstance() => create();
  static $pb.PbList<UserMessage> createRepeated() => $pb.PbList<UserMessage>();
  @$core.pragma('dart2js:noInline')
  static UserMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserMessage>(create);
  static UserMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  /// The user's message content.
  @$pb.TagNumber(2)
  $core.String get content => $_getSZ(1);
  @$pb.TagNumber(2)
  set content($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => clearField(2);
}

/// Raw media payload for structured ingress.
class MediaBlob extends $pb.GeneratedMessage {
  factory MediaBlob({
    $core.List<$core.int>? data,
    $core.String? mediaType,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    if (mediaType != null) {
      $result.mediaType = mediaType;
    }
    return $result;
  }
  MediaBlob._() : super();
  factory MediaBlob.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MediaBlob.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MediaBlob', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'mediaType')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MediaBlob clone() => MediaBlob()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MediaBlob copyWith(void Function(MediaBlob) updates) => super.copyWith((message) => updates(message as MediaBlob)) as MediaBlob;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaBlob create() => MediaBlob._();
  MediaBlob createEmptyInstance() => create();
  static $pb.PbList<MediaBlob> createRepeated() => $pb.PbList<MediaBlob>();
  @$core.pragma('dart2js:noInline')
  static MediaBlob getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MediaBlob>(create);
  static MediaBlob? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get mediaType => $_getSZ(1);
  @$pb.TagNumber(2)
  set mediaType($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMediaType() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaType() => clearField(2);
}

/// Event payload for structured ingress.
class EventPayload extends $pb.GeneratedMessage {
  factory EventPayload({
    $core.String? eventType,
    $1.Value? payload,
  }) {
    final $result = create();
    if (eventType != null) {
      $result.eventType = eventType;
    }
    if (payload != null) {
      $result.payload = payload;
    }
    return $result;
  }
  EventPayload._() : super();
  factory EventPayload.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventPayload.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EventPayload', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'eventType')
    ..aOM<$1.Value>(2, _omitFieldNames ? '' : 'payload', subBuilder: $1.Value.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventPayload clone() => EventPayload()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventPayload copyWith(void Function(EventPayload) updates) => super.copyWith((message) => updates(message as EventPayload)) as EventPayload;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EventPayload create() => EventPayload._();
  EventPayload createEmptyInstance() => create();
  static $pb.PbList<EventPayload> createRepeated() => $pb.PbList<EventPayload>();
  @$core.pragma('dart2js:noInline')
  static EventPayload getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventPayload>(create);
  static EventPayload? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get eventType => $_getSZ(0);
  @$pb.TagNumber(1)
  set eventType($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEventType() => $_has(0);
  @$pb.TagNumber(1)
  void clearEventType() => clearField(1);

  /// Arbitrary structured payload, aligned with runtime MessageContent::Event.
  @$pb.TagNumber(2)
  $1.Value get payload => $_getN(1);
  @$pb.TagNumber(2)
  set payload($1.Value v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPayload() => $_has(1);
  @$pb.TagNumber(2)
  void clearPayload() => clearField(2);
  @$pb.TagNumber(2)
  $1.Value ensurePayload() => $_ensure(1);
}

enum IngressInput_Content {
  text, 
  image, 
  audio, 
  json, 
  event, 
  notSet
}

/// Structured ingress input aligned with the runtime IngressMessage model.
class IngressInput extends $pb.GeneratedMessage {
  factory IngressInput({
    $core.String? sessionId,
    IngressIntent? intent,
    $core.String? source,
    $core.String? targetAgent,
    $1.Struct? metadata,
    $core.String? text,
    MediaBlob? image,
    MediaBlob? audio,
    $1.Value? json,
    EventPayload? event,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (intent != null) {
      $result.intent = intent;
    }
    if (source != null) {
      $result.source = source;
    }
    if (targetAgent != null) {
      $result.targetAgent = targetAgent;
    }
    if (metadata != null) {
      $result.metadata = metadata;
    }
    if (text != null) {
      $result.text = text;
    }
    if (image != null) {
      $result.image = image;
    }
    if (audio != null) {
      $result.audio = audio;
    }
    if (json != null) {
      $result.json = json;
    }
    if (event != null) {
      $result.event = event;
    }
    return $result;
  }
  IngressInput._() : super();
  factory IngressInput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IngressInput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, IngressInput_Content> _IngressInput_ContentByTag = {
    10 : IngressInput_Content.text,
    11 : IngressInput_Content.image,
    12 : IngressInput_Content.audio,
    13 : IngressInput_Content.json,
    14 : IngressInput_Content.event,
    0 : IngressInput_Content.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'IngressInput', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..oo(0, [10, 11, 12, 13, 14])
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..e<IngressIntent>(2, _omitFieldNames ? '' : 'intent', $pb.PbFieldType.OE, defaultOrMaker: IngressIntent.INGRESS_INTENT_UNSPECIFIED, valueOf: IngressIntent.valueOf, enumValues: IngressIntent.values)
    ..aOS(3, _omitFieldNames ? '' : 'source')
    ..aOS(4, _omitFieldNames ? '' : 'targetAgent')
    ..aOM<$1.Struct>(5, _omitFieldNames ? '' : 'metadata', subBuilder: $1.Struct.create)
    ..aOS(10, _omitFieldNames ? '' : 'text')
    ..aOM<MediaBlob>(11, _omitFieldNames ? '' : 'image', subBuilder: MediaBlob.create)
    ..aOM<MediaBlob>(12, _omitFieldNames ? '' : 'audio', subBuilder: MediaBlob.create)
    ..aOM<$1.Value>(13, _omitFieldNames ? '' : 'json', subBuilder: $1.Value.create)
    ..aOM<EventPayload>(14, _omitFieldNames ? '' : 'event', subBuilder: EventPayload.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  IngressInput clone() => IngressInput()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  IngressInput copyWith(void Function(IngressInput) updates) => super.copyWith((message) => updates(message as IngressInput)) as IngressInput;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IngressInput create() => IngressInput._();
  IngressInput createEmptyInstance() => create();
  static $pb.PbList<IngressInput> createRepeated() => $pb.PbList<IngressInput>();
  @$core.pragma('dart2js:noInline')
  static IngressInput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IngressInput>(create);
  static IngressInput? _defaultInstance;

  IngressInput_Content whichContent() => _IngressInput_ContentByTag[$_whichOneof(0)]!;
  void clearContent() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  IngressIntent get intent => $_getN(1);
  @$pb.TagNumber(2)
  set intent(IngressIntent v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasIntent() => $_has(1);
  @$pb.TagNumber(2)
  void clearIntent() => clearField(2);

  /// Optional caller-provided source identifier. If empty, the daemon assigns one.
  @$pb.TagNumber(3)
  $core.String get source => $_getSZ(2);
  @$pb.TagNumber(3)
  set source($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => clearField(3);

  /// Optional target agent. If empty, the daemon uses the current session.
  @$pb.TagNumber(4)
  $core.String get targetAgent => $_getSZ(3);
  @$pb.TagNumber(4)
  set targetAgent($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTargetAgent() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetAgent() => clearField(4);

  /// Optional structured metadata for routing or extra context.
  @$pb.TagNumber(5)
  $1.Struct get metadata => $_getN(4);
  @$pb.TagNumber(5)
  set metadata($1.Struct v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasMetadata() => $_has(4);
  @$pb.TagNumber(5)
  void clearMetadata() => clearField(5);
  @$pb.TagNumber(5)
  $1.Struct ensureMetadata() => $_ensure(4);

  @$pb.TagNumber(10)
  $core.String get text => $_getSZ(5);
  @$pb.TagNumber(10)
  set text($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(10)
  $core.bool hasText() => $_has(5);
  @$pb.TagNumber(10)
  void clearText() => clearField(10);

  @$pb.TagNumber(11)
  MediaBlob get image => $_getN(6);
  @$pb.TagNumber(11)
  set image(MediaBlob v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasImage() => $_has(6);
  @$pb.TagNumber(11)
  void clearImage() => clearField(11);
  @$pb.TagNumber(11)
  MediaBlob ensureImage() => $_ensure(6);

  @$pb.TagNumber(12)
  MediaBlob get audio => $_getN(7);
  @$pb.TagNumber(12)
  set audio(MediaBlob v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasAudio() => $_has(7);
  @$pb.TagNumber(12)
  void clearAudio() => clearField(12);
  @$pb.TagNumber(12)
  MediaBlob ensureAudio() => $_ensure(7);

  /// Arbitrary structured JSON-like content.
  @$pb.TagNumber(13)
  $1.Value get json => $_getN(8);
  @$pb.TagNumber(13)
  set json($1.Value v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasJson() => $_has(8);
  @$pb.TagNumber(13)
  void clearJson() => clearField(13);
  @$pb.TagNumber(13)
  $1.Value ensureJson() => $_ensure(8);

  @$pb.TagNumber(14)
  EventPayload get event => $_getN(9);
  @$pb.TagNumber(14)
  set event(EventPayload v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasEvent() => $_has(9);
  @$pb.TagNumber(14)
  void clearEvent() => clearField(14);
  @$pb.TagNumber(14)
  EventPayload ensureEvent() => $_ensure(9);
}

/// Approve or reject a tool call that requires user confirmation.
/// Currently auto-approved; will be enforced when approval policies are added.
class ToolApproval extends $pb.GeneratedMessage {
  factory ToolApproval({
    $core.String? sessionId,
    $core.String? toolCallId,
    $core.bool? approved,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (toolCallId != null) {
      $result.toolCallId = toolCallId;
    }
    if (approved != null) {
      $result.approved = approved;
    }
    return $result;
  }
  ToolApproval._() : super();
  factory ToolApproval.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ToolApproval.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ToolApproval', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'toolCallId')
    ..aOB(3, _omitFieldNames ? '' : 'approved')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ToolApproval clone() => ToolApproval()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ToolApproval copyWith(void Function(ToolApproval) updates) => super.copyWith((message) => updates(message as ToolApproval)) as ToolApproval;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToolApproval create() => ToolApproval._();
  ToolApproval createEmptyInstance() => create();
  static $pb.PbList<ToolApproval> createRepeated() => $pb.PbList<ToolApproval>();
  @$core.pragma('dart2js:noInline')
  static ToolApproval getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ToolApproval>(create);
  static ToolApproval? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get toolCallId => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolCallId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToolCallId() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolCallId() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get approved => $_getBF(2);
  @$pb.TagNumber(3)
  set approved($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasApproved() => $_has(2);
  @$pb.TagNumber(3)
  void clearApproved() => clearField(3);
}

/// Cancel a running session. The daemon will emit SessionEnded.
class CancelSessionRequest extends $pb.GeneratedMessage {
  factory CancelSessionRequest({
    $core.String? sessionId,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    return $result;
  }
  CancelSessionRequest._() : super();
  factory CancelSessionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CancelSessionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CancelSessionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CancelSessionRequest clone() => CancelSessionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CancelSessionRequest copyWith(void Function(CancelSessionRequest) updates) => super.copyWith((message) => updates(message as CancelSessionRequest)) as CancelSessionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelSessionRequest create() => CancelSessionRequest._();
  CancelSessionRequest createEmptyInstance() => create();
  static $pb.PbList<CancelSessionRequest> createRepeated() => $pb.PbList<CancelSessionRequest>();
  @$core.pragma('dart2js:noInline')
  static CancelSessionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CancelSessionRequest>(create);
  static CancelSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);
}

/// Set or update a periodic schedule for this session.
/// When the schedule fires, the daemon runs a turn with the given prompt.
class SetScheduleRequest extends $pb.GeneratedMessage {
  factory SetScheduleRequest({
    $core.String? sessionId,
    $core.String? schedule,
    $core.String? prompt,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (schedule != null) {
      $result.schedule = schedule;
    }
    if (prompt != null) {
      $result.prompt = prompt;
    }
    return $result;
  }
  SetScheduleRequest._() : super();
  factory SetScheduleRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SetScheduleRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SetScheduleRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'schedule')
    ..aOS(3, _omitFieldNames ? '' : 'prompt')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SetScheduleRequest clone() => SetScheduleRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SetScheduleRequest copyWith(void Function(SetScheduleRequest) updates) => super.copyWith((message) => updates(message as SetScheduleRequest)) as SetScheduleRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetScheduleRequest create() => SetScheduleRequest._();
  SetScheduleRequest createEmptyInstance() => create();
  static $pb.PbList<SetScheduleRequest> createRepeated() => $pb.PbList<SetScheduleRequest>();
  @$core.pragma('dart2js:noInline')
  static SetScheduleRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SetScheduleRequest>(create);
  static SetScheduleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  /// Cron expression (e.g. "*/5 * * * *" for every 5 minutes) or
  /// interval in seconds (e.g. "300" for every 5 minutes).
  @$pb.TagNumber(2)
  $core.String get schedule => $_getSZ(1);
  @$pb.TagNumber(2)
  set schedule($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSchedule() => $_has(1);
  @$pb.TagNumber(2)
  void clearSchedule() => clearField(2);

  /// The prompt to send when the schedule fires.
  @$pb.TagNumber(3)
  $core.String get prompt => $_getSZ(2);
  @$pb.TagNumber(3)
  set prompt($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPrompt() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrompt() => clearField(3);
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
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (sessionCreated != null) {
      $result.sessionCreated = sessionCreated;
    }
    if (textDelta != null) {
      $result.textDelta = textDelta;
    }
    if (toolUseStart != null) {
      $result.toolUseStart = toolUseStart;
    }
    if (toolResult != null) {
      $result.toolResult = toolResult;
    }
    if (turnComplete != null) {
      $result.turnComplete = turnComplete;
    }
    if (error != null) {
      $result.error = error;
    }
    if (sessionEnded != null) {
      $result.sessionEnded = sessionEnded;
    }
    if (scheduleSet != null) {
      $result.scheduleSet = scheduleSet;
    }
    if (scheduledTurnStarted != null) {
      $result.scheduledTurnStarted = scheduledTurnStarted;
    }
    if (subAgentSpawned != null) {
      $result.subAgentSpawned = subAgentSpawned;
    }
    if (subAgentCompleted != null) {
      $result.subAgentCompleted = subAgentCompleted;
    }
    return $result;
  }
  ServerEvent._() : super();
  factory ServerEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServerEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, ServerEvent_Event> _ServerEvent_EventByTag = {
    2 : ServerEvent_Event.sessionCreated,
    3 : ServerEvent_Event.textDelta,
    4 : ServerEvent_Event.toolUseStart,
    5 : ServerEvent_Event.toolResult,
    6 : ServerEvent_Event.turnComplete,
    7 : ServerEvent_Event.error,
    8 : ServerEvent_Event.sessionEnded,
    9 : ServerEvent_Event.scheduleSet,
    10 : ServerEvent_Event.scheduledTurnStarted,
    11 : ServerEvent_Event.subAgentSpawned,
    12 : ServerEvent_Event.subAgentCompleted,
    0 : ServerEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServerEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOM<SessionCreated>(2, _omitFieldNames ? '' : 'sessionCreated', subBuilder: SessionCreated.create)
    ..aOM<TextDelta>(3, _omitFieldNames ? '' : 'textDelta', subBuilder: TextDelta.create)
    ..aOM<ToolUseStart>(4, _omitFieldNames ? '' : 'toolUseStart', subBuilder: ToolUseStart.create)
    ..aOM<ToolResult>(5, _omitFieldNames ? '' : 'toolResult', subBuilder: ToolResult.create)
    ..aOM<TurnComplete>(6, _omitFieldNames ? '' : 'turnComplete', subBuilder: TurnComplete.create)
    ..aOM<ErrorEvent>(7, _omitFieldNames ? '' : 'error', subBuilder: ErrorEvent.create)
    ..aOM<SessionEnded>(8, _omitFieldNames ? '' : 'sessionEnded', subBuilder: SessionEnded.create)
    ..aOM<ScheduleSet>(9, _omitFieldNames ? '' : 'scheduleSet', subBuilder: ScheduleSet.create)
    ..aOM<ScheduledTurnStarted>(10, _omitFieldNames ? '' : 'scheduledTurnStarted', subBuilder: ScheduledTurnStarted.create)
    ..aOM<SubAgentSpawned>(11, _omitFieldNames ? '' : 'subAgentSpawned', subBuilder: SubAgentSpawned.create)
    ..aOM<SubAgentCompleted>(12, _omitFieldNames ? '' : 'subAgentCompleted', subBuilder: SubAgentCompleted.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServerEvent clone() => ServerEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServerEvent copyWith(void Function(ServerEvent) updates) => super.copyWith((message) => updates(message as ServerEvent)) as ServerEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerEvent create() => ServerEvent._();
  ServerEvent createEmptyInstance() => create();
  static $pb.PbList<ServerEvent> createRepeated() => $pb.PbList<ServerEvent>();
  @$core.pragma('dart2js:noInline')
  static ServerEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerEvent>(create);
  static ServerEvent? _defaultInstance;

  ServerEvent_Event whichEvent() => _ServerEvent_EventByTag[$_whichOneof(0)]!;
  void clearEvent() => clearField($_whichOneof(0));

  /// The session this event belongs to.
  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  SessionCreated get sessionCreated => $_getN(1);
  @$pb.TagNumber(2)
  set sessionCreated(SessionCreated v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionCreated() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionCreated() => clearField(2);
  @$pb.TagNumber(2)
  SessionCreated ensureSessionCreated() => $_ensure(1);

  @$pb.TagNumber(3)
  TextDelta get textDelta => $_getN(2);
  @$pb.TagNumber(3)
  set textDelta(TextDelta v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTextDelta() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextDelta() => clearField(3);
  @$pb.TagNumber(3)
  TextDelta ensureTextDelta() => $_ensure(2);

  @$pb.TagNumber(4)
  ToolUseStart get toolUseStart => $_getN(3);
  @$pb.TagNumber(4)
  set toolUseStart(ToolUseStart v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasToolUseStart() => $_has(3);
  @$pb.TagNumber(4)
  void clearToolUseStart() => clearField(4);
  @$pb.TagNumber(4)
  ToolUseStart ensureToolUseStart() => $_ensure(3);

  @$pb.TagNumber(5)
  ToolResult get toolResult => $_getN(4);
  @$pb.TagNumber(5)
  set toolResult(ToolResult v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasToolResult() => $_has(4);
  @$pb.TagNumber(5)
  void clearToolResult() => clearField(5);
  @$pb.TagNumber(5)
  ToolResult ensureToolResult() => $_ensure(4);

  @$pb.TagNumber(6)
  TurnComplete get turnComplete => $_getN(5);
  @$pb.TagNumber(6)
  set turnComplete(TurnComplete v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasTurnComplete() => $_has(5);
  @$pb.TagNumber(6)
  void clearTurnComplete() => clearField(6);
  @$pb.TagNumber(6)
  TurnComplete ensureTurnComplete() => $_ensure(5);

  @$pb.TagNumber(7)
  ErrorEvent get error => $_getN(6);
  @$pb.TagNumber(7)
  set error(ErrorEvent v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasError() => $_has(6);
  @$pb.TagNumber(7)
  void clearError() => clearField(7);
  @$pb.TagNumber(7)
  ErrorEvent ensureError() => $_ensure(6);

  @$pb.TagNumber(8)
  SessionEnded get sessionEnded => $_getN(7);
  @$pb.TagNumber(8)
  set sessionEnded(SessionEnded v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasSessionEnded() => $_has(7);
  @$pb.TagNumber(8)
  void clearSessionEnded() => clearField(8);
  @$pb.TagNumber(8)
  SessionEnded ensureSessionEnded() => $_ensure(7);

  @$pb.TagNumber(9)
  ScheduleSet get scheduleSet => $_getN(8);
  @$pb.TagNumber(9)
  set scheduleSet(ScheduleSet v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasScheduleSet() => $_has(8);
  @$pb.TagNumber(9)
  void clearScheduleSet() => clearField(9);
  @$pb.TagNumber(9)
  ScheduleSet ensureScheduleSet() => $_ensure(8);

  @$pb.TagNumber(10)
  ScheduledTurnStarted get scheduledTurnStarted => $_getN(9);
  @$pb.TagNumber(10)
  set scheduledTurnStarted(ScheduledTurnStarted v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasScheduledTurnStarted() => $_has(9);
  @$pb.TagNumber(10)
  void clearScheduledTurnStarted() => clearField(10);
  @$pb.TagNumber(10)
  ScheduledTurnStarted ensureScheduledTurnStarted() => $_ensure(9);

  @$pb.TagNumber(11)
  SubAgentSpawned get subAgentSpawned => $_getN(10);
  @$pb.TagNumber(11)
  set subAgentSpawned(SubAgentSpawned v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasSubAgentSpawned() => $_has(10);
  @$pb.TagNumber(11)
  void clearSubAgentSpawned() => clearField(11);
  @$pb.TagNumber(11)
  SubAgentSpawned ensureSubAgentSpawned() => $_ensure(10);

  @$pb.TagNumber(12)
  SubAgentCompleted get subAgentCompleted => $_getN(11);
  @$pb.TagNumber(12)
  set subAgentCompleted(SubAgentCompleted v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasSubAgentCompleted() => $_has(11);
  @$pb.TagNumber(12)
  void clearSubAgentCompleted() => clearField(12);
  @$pb.TagNumber(12)
  SubAgentCompleted ensureSubAgentCompleted() => $_ensure(11);
}

/// Confirms session was created. Contains the assigned session ID.
class SessionCreated extends $pb.GeneratedMessage {
  factory SessionCreated({
    $core.String? sessionId,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    return $result;
  }
  SessionCreated._() : super();
  factory SessionCreated.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SessionCreated.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SessionCreated', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SessionCreated clone() => SessionCreated()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SessionCreated copyWith(void Function(SessionCreated) updates) => super.copyWith((message) => updates(message as SessionCreated)) as SessionCreated;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SessionCreated create() => SessionCreated._();
  SessionCreated createEmptyInstance() => create();
  static $pb.PbList<SessionCreated> createRepeated() => $pb.PbList<SessionCreated>();
  @$core.pragma('dart2js:noInline')
  static SessionCreated getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SessionCreated>(create);
  static SessionCreated? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);
}

/// A chunk of text output from the LLM. May arrive in multiple deltas.
class TextDelta extends $pb.GeneratedMessage {
  factory TextDelta({
    $core.String? content,
  }) {
    final $result = create();
    if (content != null) {
      $result.content = content;
    }
    return $result;
  }
  TextDelta._() : super();
  factory TextDelta.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TextDelta.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TextDelta', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TextDelta clone() => TextDelta()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TextDelta copyWith(void Function(TextDelta) updates) => super.copyWith((message) => updates(message as TextDelta)) as TextDelta;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TextDelta create() => TextDelta._();
  TextDelta createEmptyInstance() => create();
  static $pb.PbList<TextDelta> createRepeated() => $pb.PbList<TextDelta>();
  @$core.pragma('dart2js:noInline')
  static TextDelta getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TextDelta>(create);
  static TextDelta? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get content => $_getSZ(0);
  @$pb.TagNumber(1)
  set content($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => clearField(1);
}

/// The LLM wants to call a tool. Followed by ToolResult after execution.
class ToolUseStart extends $pb.GeneratedMessage {
  factory ToolUseStart({
    $core.String? toolCallId,
    $core.String? toolName,
    $core.String? argumentsJson,
  }) {
    final $result = create();
    if (toolCallId != null) {
      $result.toolCallId = toolCallId;
    }
    if (toolName != null) {
      $result.toolName = toolName;
    }
    if (argumentsJson != null) {
      $result.argumentsJson = argumentsJson;
    }
    return $result;
  }
  ToolUseStart._() : super();
  factory ToolUseStart.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ToolUseStart.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ToolUseStart', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'toolCallId')
    ..aOS(2, _omitFieldNames ? '' : 'toolName')
    ..aOS(3, _omitFieldNames ? '' : 'argumentsJson')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ToolUseStart clone() => ToolUseStart()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ToolUseStart copyWith(void Function(ToolUseStart) updates) => super.copyWith((message) => updates(message as ToolUseStart)) as ToolUseStart;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToolUseStart create() => ToolUseStart._();
  ToolUseStart createEmptyInstance() => create();
  static $pb.PbList<ToolUseStart> createRepeated() => $pb.PbList<ToolUseStart>();
  @$core.pragma('dart2js:noInline')
  static ToolUseStart getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ToolUseStart>(create);
  static ToolUseStart? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get toolCallId => $_getSZ(0);
  @$pb.TagNumber(1)
  set toolCallId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToolCallId() => $_has(0);
  @$pb.TagNumber(1)
  void clearToolCallId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get toolName => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToolName() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolName() => clearField(2);

  /// Tool arguments as JSON string.
  @$pb.TagNumber(3)
  $core.String get argumentsJson => $_getSZ(2);
  @$pb.TagNumber(3)
  set argumentsJson($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasArgumentsJson() => $_has(2);
  @$pb.TagNumber(3)
  void clearArgumentsJson() => clearField(3);
}

/// Result of a tool execution.
class ToolResult extends $pb.GeneratedMessage {
  factory ToolResult({
    $core.String? toolCallId,
    $core.String? output,
    $core.bool? isError,
  }) {
    final $result = create();
    if (toolCallId != null) {
      $result.toolCallId = toolCallId;
    }
    if (output != null) {
      $result.output = output;
    }
    if (isError != null) {
      $result.isError = isError;
    }
    return $result;
  }
  ToolResult._() : super();
  factory ToolResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ToolResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ToolResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'toolCallId')
    ..aOS(2, _omitFieldNames ? '' : 'output')
    ..aOB(3, _omitFieldNames ? '' : 'isError')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ToolResult clone() => ToolResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ToolResult copyWith(void Function(ToolResult) updates) => super.copyWith((message) => updates(message as ToolResult)) as ToolResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToolResult create() => ToolResult._();
  ToolResult createEmptyInstance() => create();
  static $pb.PbList<ToolResult> createRepeated() => $pb.PbList<ToolResult>();
  @$core.pragma('dart2js:noInline')
  static ToolResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ToolResult>(create);
  static ToolResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get toolCallId => $_getSZ(0);
  @$pb.TagNumber(1)
  set toolCallId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToolCallId() => $_has(0);
  @$pb.TagNumber(1)
  void clearToolCallId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get output => $_getSZ(1);
  @$pb.TagNumber(2)
  set output($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOutput() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutput() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isError => $_getBF(2);
  @$pb.TagNumber(3)
  set isError($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsError() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsError() => clearField(3);
}

/// A turn (one cycle of user input → LLM → tools → response) has completed.
class TurnComplete extends $pb.GeneratedMessage {
  factory TurnComplete({
    $core.String? usageJson,
  }) {
    final $result = create();
    if (usageJson != null) {
      $result.usageJson = usageJson;
    }
    return $result;
  }
  TurnComplete._() : super();
  factory TurnComplete.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TurnComplete.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TurnComplete', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'usageJson')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TurnComplete clone() => TurnComplete()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TurnComplete copyWith(void Function(TurnComplete) updates) => super.copyWith((message) => updates(message as TurnComplete)) as TurnComplete;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TurnComplete create() => TurnComplete._();
  TurnComplete createEmptyInstance() => create();
  static $pb.PbList<TurnComplete> createRepeated() => $pb.PbList<TurnComplete>();
  @$core.pragma('dart2js:noInline')
  static TurnComplete getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TurnComplete>(create);
  static TurnComplete? _defaultInstance;

  /// Structured token usage summary as JSON.
  @$pb.TagNumber(1)
  $core.String get usageJson => $_getSZ(0);
  @$pb.TagNumber(1)
  set usageJson($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUsageJson() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsageJson() => clearField(1);
}

/// An error occurred. If fatal=true, the session is terminated.
class ErrorEvent extends $pb.GeneratedMessage {
  factory ErrorEvent({
    $core.String? code,
    $core.String? message,
    $core.bool? fatal,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (message != null) {
      $result.message = message;
    }
    if (fatal != null) {
      $result.fatal = fatal;
    }
    return $result;
  }
  ErrorEvent._() : super();
  factory ErrorEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ErrorEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ErrorEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOB(3, _omitFieldNames ? '' : 'fatal')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ErrorEvent clone() => ErrorEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ErrorEvent copyWith(void Function(ErrorEvent) updates) => super.copyWith((message) => updates(message as ErrorEvent)) as ErrorEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ErrorEvent create() => ErrorEvent._();
  ErrorEvent createEmptyInstance() => create();
  static $pb.PbList<ErrorEvent> createRepeated() => $pb.PbList<ErrorEvent>();
  @$core.pragma('dart2js:noInline')
  static ErrorEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ErrorEvent>(create);
  static ErrorEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get fatal => $_getBF(2);
  @$pb.TagNumber(3)
  set fatal($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFatal() => $_has(2);
  @$pb.TagNumber(3)
  void clearFatal() => clearField(3);
}

/// The session has ended (cancelled, completed, or expired).
class SessionEnded extends $pb.GeneratedMessage {
  factory SessionEnded({
    $core.String? reason,
  }) {
    final $result = create();
    if (reason != null) {
      $result.reason = reason;
    }
    return $result;
  }
  SessionEnded._() : super();
  factory SessionEnded.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SessionEnded.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SessionEnded', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SessionEnded clone() => SessionEnded()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SessionEnded copyWith(void Function(SessionEnded) updates) => super.copyWith((message) => updates(message as SessionEnded)) as SessionEnded;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SessionEnded create() => SessionEnded._();
  SessionEnded createEmptyInstance() => create();
  static $pb.PbList<SessionEnded> createRepeated() => $pb.PbList<SessionEnded>();
  @$core.pragma('dart2js:noInline')
  static SessionEnded getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SessionEnded>(create);
  static SessionEnded? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reason => $_getSZ(0);
  @$pb.TagNumber(1)
  set reason($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearReason() => clearField(1);
}

/// Confirms a schedule was set or updated.
class ScheduleSet extends $pb.GeneratedMessage {
  factory ScheduleSet({
    $core.String? schedule,
    $core.String? prompt,
  }) {
    final $result = create();
    if (schedule != null) {
      $result.schedule = schedule;
    }
    if (prompt != null) {
      $result.prompt = prompt;
    }
    return $result;
  }
  ScheduleSet._() : super();
  factory ScheduleSet.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScheduleSet.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ScheduleSet', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'schedule')
    ..aOS(2, _omitFieldNames ? '' : 'prompt')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScheduleSet clone() => ScheduleSet()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScheduleSet copyWith(void Function(ScheduleSet) updates) => super.copyWith((message) => updates(message as ScheduleSet)) as ScheduleSet;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScheduleSet create() => ScheduleSet._();
  ScheduleSet createEmptyInstance() => create();
  static $pb.PbList<ScheduleSet> createRepeated() => $pb.PbList<ScheduleSet>();
  @$core.pragma('dart2js:noInline')
  static ScheduleSet getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScheduleSet>(create);
  static ScheduleSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get schedule => $_getSZ(0);
  @$pb.TagNumber(1)
  set schedule($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSchedule() => $_has(0);
  @$pb.TagNumber(1)
  void clearSchedule() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get prompt => $_getSZ(1);
  @$pb.TagNumber(2)
  set prompt($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPrompt() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrompt() => clearField(2);
}

/// A scheduled turn is starting. Emitted before the agentic loop runs.
class ScheduledTurnStarted extends $pb.GeneratedMessage {
  factory ScheduledTurnStarted({
    $core.String? prompt,
  }) {
    final $result = create();
    if (prompt != null) {
      $result.prompt = prompt;
    }
    return $result;
  }
  ScheduledTurnStarted._() : super();
  factory ScheduledTurnStarted.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScheduledTurnStarted.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ScheduledTurnStarted', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'prompt')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScheduledTurnStarted clone() => ScheduledTurnStarted()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScheduledTurnStarted copyWith(void Function(ScheduledTurnStarted) updates) => super.copyWith((message) => updates(message as ScheduledTurnStarted)) as ScheduledTurnStarted;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScheduledTurnStarted create() => ScheduledTurnStarted._();
  ScheduledTurnStarted createEmptyInstance() => create();
  static $pb.PbList<ScheduledTurnStarted> createRepeated() => $pb.PbList<ScheduledTurnStarted>();
  @$core.pragma('dart2js:noInline')
  static ScheduledTurnStarted getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScheduledTurnStarted>(create);
  static ScheduledTurnStarted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get prompt => $_getSZ(0);
  @$pb.TagNumber(1)
  set prompt($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPrompt() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrompt() => clearField(1);
}

/// Spawn a sub-agent within the current session.
/// The sub-agent runs as a separate session inside the daemon and reports
/// its result back to the parent session.
class SpawnSubAgentRequest extends $pb.GeneratedMessage {
  factory SpawnSubAgentRequest({
    $core.String? sessionId,
    $core.String? product,
    $core.String? prompt,
    $core.Map<$core.String, $core.String>? config,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (product != null) {
      $result.product = product;
    }
    if (prompt != null) {
      $result.prompt = prompt;
    }
    if (config != null) {
      $result.config.addAll(config);
    }
    return $result;
  }
  SpawnSubAgentRequest._() : super();
  factory SpawnSubAgentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SpawnSubAgentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SpawnSubAgentRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'product')
    ..aOS(3, _omitFieldNames ? '' : 'prompt')
    ..m<$core.String, $core.String>(4, _omitFieldNames ? '' : 'config', entryClassName: 'SpawnSubAgentRequest.ConfigEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('carbon.v1'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SpawnSubAgentRequest clone() => SpawnSubAgentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SpawnSubAgentRequest copyWith(void Function(SpawnSubAgentRequest) updates) => super.copyWith((message) => updates(message as SpawnSubAgentRequest)) as SpawnSubAgentRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SpawnSubAgentRequest create() => SpawnSubAgentRequest._();
  SpawnSubAgentRequest createEmptyInstance() => create();
  static $pb.PbList<SpawnSubAgentRequest> createRepeated() => $pb.PbList<SpawnSubAgentRequest>();
  @$core.pragma('dart2js:noInline')
  static SpawnSubAgentRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SpawnSubAgentRequest>(create);
  static SpawnSubAgentRequest? _defaultInstance;

  /// Parent session ID.
  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  /// Product for the sub-agent (can be same or different from parent).
  @$pb.TagNumber(2)
  $core.String get product => $_getSZ(1);
  @$pb.TagNumber(2)
  set product($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProduct() => $_has(1);
  @$pb.TagNumber(2)
  void clearProduct() => clearField(2);

  /// The task/prompt for the sub-agent.
  @$pb.TagNumber(3)
  $core.String get prompt => $_getSZ(2);
  @$pb.TagNumber(3)
  set prompt($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPrompt() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrompt() => clearField(3);

  /// Optional config overrides for the sub-agent session.
  @$pb.TagNumber(4)
  $core.Map<$core.String, $core.String> get config => $_getMap(3);
}

/// Confirms a sub-agent was spawned. The sub_session_id can be used to track it.
class SubAgentSpawned extends $pb.GeneratedMessage {
  factory SubAgentSpawned({
    $core.String? subSessionId,
    $core.String? prompt,
  }) {
    final $result = create();
    if (subSessionId != null) {
      $result.subSessionId = subSessionId;
    }
    if (prompt != null) {
      $result.prompt = prompt;
    }
    return $result;
  }
  SubAgentSpawned._() : super();
  factory SubAgentSpawned.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubAgentSpawned.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubAgentSpawned', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'subSessionId')
    ..aOS(2, _omitFieldNames ? '' : 'prompt')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubAgentSpawned clone() => SubAgentSpawned()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubAgentSpawned copyWith(void Function(SubAgentSpawned) updates) => super.copyWith((message) => updates(message as SubAgentSpawned)) as SubAgentSpawned;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubAgentSpawned create() => SubAgentSpawned._();
  SubAgentSpawned createEmptyInstance() => create();
  static $pb.PbList<SubAgentSpawned> createRepeated() => $pb.PbList<SubAgentSpawned>();
  @$core.pragma('dart2js:noInline')
  static SubAgentSpawned getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubAgentSpawned>(create);
  static SubAgentSpawned? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get subSessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set subSessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSubSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get prompt => $_getSZ(1);
  @$pb.TagNumber(2)
  set prompt($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPrompt() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrompt() => clearField(2);
}

/// A sub-agent has finished its task and returned a result.
class SubAgentCompleted extends $pb.GeneratedMessage {
  factory SubAgentCompleted({
    $core.String? subSessionId,
    $core.String? result,
    $core.bool? isError,
  }) {
    final $result = create();
    if (subSessionId != null) {
      $result.subSessionId = subSessionId;
    }
    if (result != null) {
      $result.result = result;
    }
    if (isError != null) {
      $result.isError = isError;
    }
    return $result;
  }
  SubAgentCompleted._() : super();
  factory SubAgentCompleted.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubAgentCompleted.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubAgentCompleted', package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'subSessionId')
    ..aOS(2, _omitFieldNames ? '' : 'result')
    ..aOB(3, _omitFieldNames ? '' : 'isError')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubAgentCompleted clone() => SubAgentCompleted()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubAgentCompleted copyWith(void Function(SubAgentCompleted) updates) => super.copyWith((message) => updates(message as SubAgentCompleted)) as SubAgentCompleted;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubAgentCompleted create() => SubAgentCompleted._();
  SubAgentCompleted createEmptyInstance() => create();
  static $pb.PbList<SubAgentCompleted> createRepeated() => $pb.PbList<SubAgentCompleted>();
  @$core.pragma('dart2js:noInline')
  static SubAgentCompleted getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubAgentCompleted>(create);
  static SubAgentCompleted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get subSessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set subSessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSubSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get result => $_getSZ(1);
  @$pb.TagNumber(2)
  set result($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasResult() => $_has(1);
  @$pb.TagNumber(2)
  void clearResult() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isError => $_getBF(2);
  @$pb.TagNumber(3)
  set isError($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsError() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsError() => clearField(3);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
