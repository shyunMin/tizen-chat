// This is a generated file - do not edit.
//
// Generated from argot/v1/service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Empty `session_id` opens a new session; the daemon mints an id and
/// echoes it back in the first `ChatEvent.SessionOpened`. Otherwise
/// resumes the named session.
class ChatRequest extends $pb.GeneratedMessage {
  factory ChatRequest({
    $core.String? sessionId,
    $core.Iterable<MessagePart>? parts,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (parts != null) result.parts.addAll(parts);
    return result;
  }

  ChatRequest._();

  factory ChatRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChatRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..pPM<MessagePart>(2, _omitFieldNames ? '' : 'parts',
        subBuilder: MessagePart.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatRequest copyWith(void Function(ChatRequest) updates) =>
      super.copyWith((message) => updates(message as ChatRequest))
          as ChatRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatRequest create() => ChatRequest._();
  @$core.override
  ChatRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChatRequest>(create);
  static ChatRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<MessagePart> get parts => $_getList(1);
}

enum MessagePart_Part { text, notSet }

class MessagePart extends $pb.GeneratedMessage {
  factory MessagePart({
    $core.String? text,
  }) {
    final result = create();
    if (text != null) result.text = text;
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
    0: MessagePart_Part.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MessagePart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..oo(0, [1])
    ..aOS(1, _omitFieldNames ? '' : 'text')
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
  MessagePart_Part whichPart() => _MessagePart_PartByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  void clearPart() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);
}

/// Unary `Chat` response. The aggregated assistant text is the payload;
/// counters + terminated_reason carry the same metadata a streaming
/// consumer would assemble from `TurnDone` / `TurnTerminated`.
class ChatResponse extends $pb.GeneratedMessage {
  factory ChatResponse({
    $core.String? sessionId,
    $core.String? text,
    $core.String? terminatedReason,
    $core.int? turns,
    $core.int? toolCalls,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (text != null) result.text = text;
    if (terminatedReason != null) result.terminatedReason = terminatedReason;
    if (turns != null) result.turns = turns;
    if (toolCalls != null) result.toolCalls = toolCalls;
    return result;
  }

  ChatResponse._();

  factory ChatResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChatResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'terminatedReason')
    ..aI(4, _omitFieldNames ? '' : 'turns', fieldType: $pb.PbFieldType.OU3)
    ..aI(5, _omitFieldNames ? '' : 'toolCalls', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatResponse copyWith(void Function(ChatResponse) updates) =>
      super.copyWith((message) => updates(message as ChatResponse))
          as ChatResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatResponse create() => ChatResponse._();
  @$core.override
  ChatResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChatResponse>(create);
  static ChatResponse? _defaultInstance;

  /// Resolved session id — echo of the input value, or a server-issued
  /// uuid when the request sent an empty `session_id`.
  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  /// Full assistant reply collected from every `MessageDelta`.
  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  /// Set when the turn ended with `TurnTerminated`
  /// (e.g. `"iter_cap"`, `"token_cap"`, `"time_cap"`, `"cancelled"`).
  /// Empty for a clean `TurnDone`. Hard errors surface as gRPC
  /// `Status::internal` instead of populating this field.
  @$pb.TagNumber(3)
  $core.String get terminatedReason => $_getSZ(2);
  @$pb.TagNumber(3)
  set terminatedReason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTerminatedReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearTerminatedReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get turns => $_getIZ(3);
  @$pb.TagNumber(4)
  set turns($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTurns() => $_has(3);
  @$pb.TagNumber(4)
  void clearTurns() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get toolCalls => $_getIZ(4);
  @$pb.TagNumber(5)
  set toolCalls($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasToolCalls() => $_has(4);
  @$pb.TagNumber(5)
  void clearToolCalls() => $_clearField(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
