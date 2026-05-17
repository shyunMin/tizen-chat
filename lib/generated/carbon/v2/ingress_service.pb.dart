// This is a generated file - do not edit.
//
// Generated from carbon/v2/ingress_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/struct.pb.dart' as $1;

import 'ingress_service.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'ingress_service.pbenum.dart';

class SubmitRequest extends $pb.GeneratedMessage {
  factory SubmitRequest({
    $core.String? sessionId,
    IngressContent? content,
    IngressIntent? intent,
    ThreadTarget? thread,
    IngressOptions? options,
    $core.String? clientRequestId,
    $core.bool? steer,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (content != null) result.content = content;
    if (intent != null) result.intent = intent;
    if (thread != null) result.thread = thread;
    if (options != null) result.options = options;
    if (clientRequestId != null) result.clientRequestId = clientRequestId;
    if (steer != null) result.steer = steer;
    return result;
  }

  SubmitRequest._();

  factory SubmitRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubmitRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubmitRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOM<IngressContent>(2, _omitFieldNames ? '' : 'content',
        subBuilder: IngressContent.create)
    ..aE<IngressIntent>(3, _omitFieldNames ? '' : 'intent',
        enumValues: IngressIntent.values)
    ..aOM<ThreadTarget>(4, _omitFieldNames ? '' : 'thread',
        subBuilder: ThreadTarget.create)
    ..aOM<IngressOptions>(5, _omitFieldNames ? '' : 'options',
        subBuilder: IngressOptions.create)
    ..aOS(6, _omitFieldNames ? '' : 'clientRequestId')
    ..aOB(7, _omitFieldNames ? '' : 'steer')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitRequest copyWith(void Function(SubmitRequest) updates) =>
      super.copyWith((message) => updates(message as SubmitRequest))
          as SubmitRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitRequest create() => SubmitRequest._();
  @$core.override
  SubmitRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubmitRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubmitRequest>(create);
  static SubmitRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  IngressContent get content => $_getN(1);
  @$pb.TagNumber(2)
  set content(IngressContent value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => $_clearField(2);
  @$pb.TagNumber(2)
  IngressContent ensureContent() => $_ensure(1);

  @$pb.TagNumber(3)
  IngressIntent get intent => $_getN(2);
  @$pb.TagNumber(3)
  set intent(IngressIntent value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasIntent() => $_has(2);
  @$pb.TagNumber(3)
  void clearIntent() => $_clearField(3);

  @$pb.TagNumber(4)
  ThreadTarget get thread => $_getN(3);
  @$pb.TagNumber(4)
  set thread(ThreadTarget value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasThread() => $_has(3);
  @$pb.TagNumber(4)
  void clearThread() => $_clearField(4);
  @$pb.TagNumber(4)
  ThreadTarget ensureThread() => $_ensure(3);

  @$pb.TagNumber(5)
  IngressOptions get options => $_getN(4);
  @$pb.TagNumber(5)
  set options(IngressOptions value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasOptions() => $_has(4);
  @$pb.TagNumber(5)
  void clearOptions() => $_clearField(5);
  @$pb.TagNumber(5)
  IngressOptions ensureOptions() => $_ensure(4);

  /// Client-supplied dedupe / correlation handle. Empty = skip dedupe.
  @$pb.TagNumber(6)
  $core.String get clientRequestId => $_getSZ(5);
  @$pb.TagNumber(6)
  set clientRequestId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasClientRequestId() => $_has(5);
  @$pb.TagNumber(6)
  void clearClientRequestId() => $_clearField(6);

  /// Client-controlled routing intent:
  ///   true  = if a turn is in flight, inject at the next tool/result
  ///           boundary (the steer queue). If no turn is in flight, falls
  ///           through to MailboxPolicy → STARTED_NOW.
  ///   false = MailboxPolicy decides. With turn in flight this lands in
  ///           the post-thread queue (QUEUED). With no turn it starts
  ///           immediately (STARTED_NOW).
  @$pb.TagNumber(7)
  $core.bool get steer => $_getBF(6);
  @$pb.TagNumber(7)
  set steer($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSteer() => $_has(6);
  @$pb.TagNumber(7)
  void clearSteer() => $_clearField(7);
}

class SubmitResponse extends $pb.GeneratedMessage {
  factory SubmitResponse({
    Disposition? disposition,
    $core.String? threadId,
    $core.String? turnId,
    $core.String? clientRequestId,
  }) {
    final result = create();
    if (disposition != null) result.disposition = disposition;
    if (threadId != null) result.threadId = threadId;
    if (turnId != null) result.turnId = turnId;
    if (clientRequestId != null) result.clientRequestId = clientRequestId;
    return result;
  }

  SubmitResponse._();

  factory SubmitResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubmitResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubmitResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aE<Disposition>(1, _omitFieldNames ? '' : 'disposition',
        enumValues: Disposition.values)
    ..aOS(2, _omitFieldNames ? '' : 'threadId')
    ..aOS(3, _omitFieldNames ? '' : 'turnId')
    ..aOS(4, _omitFieldNames ? '' : 'clientRequestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitResponse copyWith(void Function(SubmitResponse) updates) =>
      super.copyWith((message) => updates(message as SubmitResponse))
          as SubmitResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitResponse create() => SubmitResponse._();
  @$core.override
  SubmitResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubmitResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubmitResponse>(create);
  static SubmitResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Disposition get disposition => $_getN(0);
  @$pb.TagNumber(1)
  set disposition(Disposition value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDisposition() => $_has(0);
  @$pb.TagNumber(1)
  void clearDisposition() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);

  /// STARTED_NOW / STEERED = set. QUEUED = "" (assigned when turn starts).
  @$pb.TagNumber(3)
  $core.String get turnId => $_getSZ(2);
  @$pb.TagNumber(3)
  set turnId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTurnId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTurnId() => $_clearField(3);

  /// Always echoed for client correlation.
  @$pb.TagNumber(4)
  $core.String get clientRequestId => $_getSZ(3);
  @$pb.TagNumber(4)
  set clientRequestId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasClientRequestId() => $_has(3);
  @$pb.TagNumber(4)
  void clearClientRequestId() => $_clearField(4);
}

enum IngressContent_Content { text, media, skillActivation, event, notSet }

class IngressContent extends $pb.GeneratedMessage {
  factory IngressContent({
    $core.String? text,
    MediaBlob? media,
    SkillActivation? skillActivation,
    EventPayload? event,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (media != null) result.media = media;
    if (skillActivation != null) result.skillActivation = skillActivation;
    if (event != null) result.event = event;
    return result;
  }

  IngressContent._();

  factory IngressContent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IngressContent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, IngressContent_Content>
      _IngressContent_ContentByTag = {
    1: IngressContent_Content.text,
    2: IngressContent_Content.media,
    3: IngressContent_Content.skillActivation,
    4: IngressContent_Content.event,
    0: IngressContent_Content.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IngressContent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOM<MediaBlob>(2, _omitFieldNames ? '' : 'media',
        subBuilder: MediaBlob.create)
    ..aOM<SkillActivation>(3, _omitFieldNames ? '' : 'skillActivation',
        subBuilder: SkillActivation.create)
    ..aOM<EventPayload>(4, _omitFieldNames ? '' : 'event',
        subBuilder: EventPayload.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngressContent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngressContent copyWith(void Function(IngressContent) updates) =>
      super.copyWith((message) => updates(message as IngressContent))
          as IngressContent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IngressContent create() => IngressContent._();
  @$core.override
  IngressContent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IngressContent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IngressContent>(create);
  static IngressContent? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  IngressContent_Content whichContent() =>
      _IngressContent_ContentByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearContent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  MediaBlob get media => $_getN(1);
  @$pb.TagNumber(2)
  set media(MediaBlob value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMedia() => $_has(1);
  @$pb.TagNumber(2)
  void clearMedia() => $_clearField(2);
  @$pb.TagNumber(2)
  MediaBlob ensureMedia() => $_ensure(1);

  @$pb.TagNumber(3)
  SkillActivation get skillActivation => $_getN(2);
  @$pb.TagNumber(3)
  set skillActivation(SkillActivation value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSkillActivation() => $_has(2);
  @$pb.TagNumber(3)
  void clearSkillActivation() => $_clearField(3);
  @$pb.TagNumber(3)
  SkillActivation ensureSkillActivation() => $_ensure(2);

  @$pb.TagNumber(4)
  EventPayload get event => $_getN(3);
  @$pb.TagNumber(4)
  set event(EventPayload value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEvent() => $_has(3);
  @$pb.TagNumber(4)
  void clearEvent() => $_clearField(4);
  @$pb.TagNumber(4)
  EventPayload ensureEvent() => $_ensure(3);
}

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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
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

class SkillActivation extends $pb.GeneratedMessage {
  factory SkillActivation({
    $core.String? skillId,
    $core.String? argsText,
  }) {
    final result = create();
    if (skillId != null) result.skillId = skillId;
    if (argsText != null) result.argsText = argsText;
    return result;
  }

  SkillActivation._();

  factory SkillActivation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SkillActivation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SkillActivation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'skillId')
    ..aOS(2, _omitFieldNames ? '' : 'argsText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SkillActivation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SkillActivation copyWith(void Function(SkillActivation) updates) =>
      super.copyWith((message) => updates(message as SkillActivation))
          as SkillActivation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SkillActivation create() => SkillActivation._();
  @$core.override
  SkillActivation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SkillActivation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SkillActivation>(create);
  static SkillActivation? _defaultInstance;

  /// Resolved skill id (after SkillService.ResolveSkill).
  @$pb.TagNumber(1)
  $core.String get skillId => $_getSZ(0);
  @$pb.TagNumber(1)
  set skillId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSkillId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSkillId() => $_clearField(1);

  /// Trailing args text after the `$skill-name ` prefix, if any.
  @$pb.TagNumber(2)
  $core.String get argsText => $_getSZ(1);
  @$pb.TagNumber(2)
  set argsText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasArgsText() => $_has(1);
  @$pb.TagNumber(2)
  void clearArgsText() => $_clearField(2);
}

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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
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

class IngressOptions extends $pb.GeneratedMessage {
  factory IngressOptions({
    $core.String? source,
    $1.Struct? metadata,
  }) {
    final result = create();
    if (source != null) result.source = source;
    if (metadata != null) result.metadata = metadata;
    return result;
  }

  IngressOptions._();

  factory IngressOptions.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IngressOptions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IngressOptions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'source')
    ..aOM<$1.Struct>(2, _omitFieldNames ? '' : 'metadata',
        subBuilder: $1.Struct.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngressOptions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngressOptions copyWith(void Function(IngressOptions) updates) =>
      super.copyWith((message) => updates(message as IngressOptions))
          as IngressOptions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IngressOptions create() => IngressOptions._();
  @$core.override
  IngressOptions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IngressOptions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IngressOptions>(create);
  static IngressOptions? _defaultInstance;

  /// Caller-provided source label (e.g. "telegram", "schedule:<id>").
  /// Empty = daemon assigns.
  @$pb.TagNumber(1)
  $core.String get source => $_getSZ(0);
  @$pb.TagNumber(1)
  set source($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSource() => $_has(0);
  @$pb.TagNumber(1)
  void clearSource() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Struct get metadata => $_getN(1);
  @$pb.TagNumber(2)
  set metadata($1.Struct value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMetadata() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetadata() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Struct ensureMetadata() => $_ensure(1);
}

enum ThreadTarget_Target { auto, resume, newThread, notSet }

/// Where this ingress should land.
class ThreadTarget extends $pb.GeneratedMessage {
  factory ThreadTarget({
    AutoTarget? auto,
    ResumeTarget? resume,
    NewTarget? newThread,
  }) {
    final result = create();
    if (auto != null) result.auto = auto;
    if (resume != null) result.resume = resume;
    if (newThread != null) result.newThread = newThread;
    return result;
  }

  ThreadTarget._();

  factory ThreadTarget.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ThreadTarget.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ThreadTarget_Target>
      _ThreadTarget_TargetByTag = {
    1: ThreadTarget_Target.auto,
    2: ThreadTarget_Target.resume,
    3: ThreadTarget_Target.newThread,
    0: ThreadTarget_Target.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadTarget',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<AutoTarget>(1, _omitFieldNames ? '' : 'auto',
        subBuilder: AutoTarget.create)
    ..aOM<ResumeTarget>(2, _omitFieldNames ? '' : 'resume',
        subBuilder: ResumeTarget.create)
    ..aOM<NewTarget>(3, _omitFieldNames ? '' : 'newThread',
        subBuilder: NewTarget.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadTarget clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadTarget copyWith(void Function(ThreadTarget) updates) =>
      super.copyWith((message) => updates(message as ThreadTarget))
          as ThreadTarget;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThreadTarget create() => ThreadTarget._();
  @$core.override
  ThreadTarget createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ThreadTarget getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadTarget>(create);
  static ThreadTarget? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  ThreadTarget_Target whichTarget() =>
      _ThreadTarget_TargetByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearTarget() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  AutoTarget get auto => $_getN(0);
  @$pb.TagNumber(1)
  set auto(AutoTarget value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAuto() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuto() => $_clearField(1);
  @$pb.TagNumber(1)
  AutoTarget ensureAuto() => $_ensure(0);

  @$pb.TagNumber(2)
  ResumeTarget get resume => $_getN(1);
  @$pb.TagNumber(2)
  set resume(ResumeTarget value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasResume() => $_has(1);
  @$pb.TagNumber(2)
  void clearResume() => $_clearField(2);
  @$pb.TagNumber(2)
  ResumeTarget ensureResume() => $_ensure(1);

  @$pb.TagNumber(3)
  NewTarget get newThread => $_getN(2);
  @$pb.TagNumber(3)
  set newThread(NewTarget value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNewThread() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewThread() => $_clearField(3);
  @$pb.TagNumber(3)
  NewTarget ensureNewThread() => $_ensure(2);
}

/// Default: continue the latest open thread, or start one if none.
class AutoTarget extends $pb.GeneratedMessage {
  factory AutoTarget() => create();

  AutoTarget._();

  factory AutoTarget.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AutoTarget.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AutoTarget',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AutoTarget clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AutoTarget copyWith(void Function(AutoTarget) updates) =>
      super.copyWith((message) => updates(message as AutoTarget)) as AutoTarget;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AutoTarget create() => AutoTarget._();
  @$core.override
  AutoTarget createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AutoTarget getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AutoTarget>(create);
  static AutoTarget? _defaultInstance;
}

/// Resume the previously paused thread. Empty thread_id = latest paused.
/// Effective only when the prior turn ended in Pause(<reason>) and the
/// daemon process is still the same one that produced the pause.
class ResumeTarget extends $pb.GeneratedMessage {
  factory ResumeTarget({
    $core.String? threadId,
  }) {
    final result = create();
    if (threadId != null) result.threadId = threadId;
    return result;
  }

  ResumeTarget._();

  factory ResumeTarget.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResumeTarget.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResumeTarget',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'threadId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeTarget clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeTarget copyWith(void Function(ResumeTarget) updates) =>
      super.copyWith((message) => updates(message as ResumeTarget))
          as ResumeTarget;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResumeTarget create() => ResumeTarget._();
  @$core.override
  ResumeTarget createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResumeTarget getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResumeTarget>(create);
  static ResumeTarget? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get threadId => $_getSZ(0);
  @$pb.TagNumber(1)
  set threadId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasThreadId() => $_has(0);
  @$pb.TagNumber(1)
  void clearThreadId() => $_clearField(1);
}

/// Force-start a new thread. Optional human-readable label.
class NewTarget extends $pb.GeneratedMessage {
  factory NewTarget({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  NewTarget._();

  factory NewTarget.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NewTarget.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NewTarget',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NewTarget clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NewTarget copyWith(void Function(NewTarget) updates) =>
      super.copyWith((message) => updates(message as NewTarget)) as NewTarget;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NewTarget create() => NewTarget._();
  @$core.override
  NewTarget createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NewTarget getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NewTarget>(create);
  static NewTarget? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class InterruptTurnRequest extends $pb.GeneratedMessage {
  factory InterruptTurnRequest({
    $core.String? sessionId,
    $core.String? turnId,
    InterruptMode? mode,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (turnId != null) result.turnId = turnId;
    if (mode != null) result.mode = mode;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'turnId')
    ..aE<InterruptMode>(3, _omitFieldNames ? '' : 'mode',
        enumValues: InterruptMode.values)
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

  /// Race-safe: if turn_id mismatches the current in-flight turn, the daemon
  /// returns a no-op response and does not cancel anything.
  @$pb.TagNumber(2)
  $core.String get turnId => $_getSZ(1);
  @$pb.TagNumber(2)
  set turnId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTurnId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTurnId() => $_clearField(2);

  @$pb.TagNumber(3)
  InterruptMode get mode => $_getN(2);
  @$pb.TagNumber(3)
  set mode(InterruptMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearMode() => $_clearField(3);
}

class InterruptTurnResponse extends $pb.GeneratedMessage {
  factory InterruptTurnResponse({
    $core.String? sessionId,
    $core.String? turnId,
    $core.bool? interrupted,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (turnId != null) result.turnId = turnId;
    if (interrupted != null) result.interrupted = interrupted;
    return result;
  }

  InterruptTurnResponse._();

  factory InterruptTurnResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InterruptTurnResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InterruptTurnResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'turnId')
    ..aOB(3, _omitFieldNames ? '' : 'interrupted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InterruptTurnResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InterruptTurnResponse copyWith(
          void Function(InterruptTurnResponse) updates) =>
      super.copyWith((message) => updates(message as InterruptTurnResponse))
          as InterruptTurnResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InterruptTurnResponse create() => InterruptTurnResponse._();
  @$core.override
  InterruptTurnResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InterruptTurnResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InterruptTurnResponse>(create);
  static InterruptTurnResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get turnId => $_getSZ(1);
  @$pb.TagNumber(2)
  set turnId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTurnId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTurnId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get interrupted => $_getBF(2);
  @$pb.TagNumber(3)
  set interrupted($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInterrupted() => $_has(2);
  @$pb.TagNumber(3)
  void clearInterrupted() => $_clearField(3);
}

class ApproveToolRequest extends $pb.GeneratedMessage {
  factory ApproveToolRequest({
    $core.String? approvalId,
    ApprovalDecision? decision,
  }) {
    final result = create();
    if (approvalId != null) result.approvalId = approvalId;
    if (decision != null) result.decision = decision;
    return result;
  }

  ApproveToolRequest._();

  factory ApproveToolRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveToolRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveToolRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'approvalId')
    ..aE<ApprovalDecision>(2, _omitFieldNames ? '' : 'decision',
        enumValues: ApprovalDecision.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveToolRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveToolRequest copyWith(void Function(ApproveToolRequest) updates) =>
      super.copyWith((message) => updates(message as ApproveToolRequest))
          as ApproveToolRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveToolRequest create() => ApproveToolRequest._();
  @$core.override
  ApproveToolRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveToolRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveToolRequest>(create);
  static ApproveToolRequest? _defaultInstance;

  /// Daemon-issued approval handle.
  @$pb.TagNumber(1)
  $core.String get approvalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set approvalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasApprovalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearApprovalId() => $_clearField(1);

  @$pb.TagNumber(2)
  ApprovalDecision get decision => $_getN(1);
  @$pb.TagNumber(2)
  set decision(ApprovalDecision value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDecision() => $_has(1);
  @$pb.TagNumber(2)
  void clearDecision() => $_clearField(2);
}

class ApproveToolResponse extends $pb.GeneratedMessage {
  factory ApproveToolResponse({
    $core.String? approvalId,
    $core.bool? applied,
  }) {
    final result = create();
    if (approvalId != null) result.approvalId = approvalId;
    if (applied != null) result.applied = applied;
    return result;
  }

  ApproveToolResponse._();

  factory ApproveToolResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveToolResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveToolResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'approvalId')
    ..aOB(2, _omitFieldNames ? '' : 'applied')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveToolResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveToolResponse copyWith(void Function(ApproveToolResponse) updates) =>
      super.copyWith((message) => updates(message as ApproveToolResponse))
          as ApproveToolResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveToolResponse create() => ApproveToolResponse._();
  @$core.override
  ApproveToolResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveToolResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveToolResponse>(create);
  static ApproveToolResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get approvalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set approvalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasApprovalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearApprovalId() => $_clearField(1);

  /// True if this caller's decision was applied. False = ALREADY_RESOLVED
  /// (another client resolved first) or approval not found.
  @$pb.TagNumber(2)
  $core.bool get applied => $_getBF(1);
  @$pb.TagNumber(2)
  set applied($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasApplied() => $_has(1);
  @$pb.TagNumber(2)
  void clearApplied() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
