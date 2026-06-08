// This is a generated file - do not edit.
//
// Generated from argot/v1/chat.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'types.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

enum ChatRequest_Target { conversationId, new_2, ephemeral, notSet }

/// The turn's target is an explicit, mutually-exclusive protocol intent — the
/// daemon NEVER infers it from an empty string. An unset target is rejected
/// (invalid_argument).
class ChatRequest extends $pb.GeneratedMessage {
  factory ChatRequest({
    $core.String? conversationId,
    NewConversation? new_2,
    EphemeralConversation? ephemeral,
    $core.Iterable<$1.MessagePart>? parts,
  }) {
    final result = create();
    if (conversationId != null) result.conversationId = conversationId;
    if (new_2 != null) result.new_2 = new_2;
    if (ephemeral != null) result.ephemeral = ephemeral;
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

  static const $core.Map<$core.int, ChatRequest_Target>
      _ChatRequest_TargetByTag = {
    1: ChatRequest_Target.conversationId,
    2: ChatRequest_Target.new_2,
    3: ChatRequest_Target.ephemeral,
    0: ChatRequest_Target.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChatRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOS(1, _omitFieldNames ? '' : 'conversationId')
    ..aOM<NewConversation>(2, _omitFieldNames ? '' : 'new',
        subBuilder: NewConversation.create)
    ..aOM<EphemeralConversation>(3, _omitFieldNames ? '' : 'ephemeral',
        subBuilder: EphemeralConversation.create)
    ..pPM<$1.MessagePart>(4, _omitFieldNames ? '' : 'parts',
        subBuilder: $1.MessagePart.create)
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
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  ChatRequest_Target whichTarget() =>
      _ChatRequest_TargetByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearTarget() => $_clearField($_whichOneof(0));

  /// Continue an existing conversation → PERSISTENT. The daemon verifies
  /// existence and returns not_found if absent (it never creates here).
  @$pb.TagNumber(1)
  $core.String get conversationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set conversationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConversationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConversationId() => $_clearField(1);

  /// Start (or, with a client id, get-or-create) a persistent conversation.
  /// If `NewConversation.conversation_id` is empty the daemon mints a uuid;
  /// if set, the daemon uses that client-supplied id — reusing it if it
  /// already exists, creating it if not (never already_exists), so a stable
  /// id is resumable across restarts. The resolved id is returned in the
  /// first Opened frame.
  @$pb.TagNumber(2)
  NewConversation get new_2 => $_getN(1);
  @$pb.TagNumber(2)
  set new_2(NewConversation value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasNew_2() => $_has(1);
  @$pb.TagNumber(2)
  void clearNew_2() => $_clearField(2);
  @$pb.TagNumber(2)
  NewConversation ensureNew_2() => $_ensure(1);

  /// One-shot intent: persists nothing once true statelessness lands. TODAY this behaves
  /// like `new` (mints + persists) — true statelessness is deferred.
  @$pb.TagNumber(3)
  EphemeralConversation get ephemeral => $_getN(2);
  @$pb.TagNumber(3)
  set ephemeral(EphemeralConversation value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEphemeral() => $_has(2);
  @$pb.TagNumber(3)
  void clearEphemeral() => $_clearField(3);
  @$pb.TagNumber(3)
  EphemeralConversation ensureEphemeral() => $_ensure(2);

  /// `MessagePart` lives in types.proto (shared with `ChatMessage`). Empty (no
  /// user message) is valid: the request resolves/provisions the conversation,
  /// emits Opened, and runs no turn (see the Chat stream contract above).
  @$pb.TagNumber(4)
  $pb.PbList<$1.MessagePart> get parts => $_getList(3);
}

class NewConversation extends $pb.GeneratedMessage {
  factory NewConversation({
    $core.String? conversationId,
  }) {
    final result = create();
    if (conversationId != null) result.conversationId = conversationId;
    return result;
  }

  NewConversation._();

  factory NewConversation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NewConversation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NewConversation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'conversationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NewConversation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NewConversation copyWith(void Function(NewConversation) updates) =>
      super.copyWith((message) => updates(message as NewConversation))
          as NewConversation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NewConversation create() => NewConversation._();
  @$core.override
  NewConversation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NewConversation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NewConversation>(create);
  static NewConversation? _defaultInstance;

  /// Optional client-supplied id for the conversation (e.g. a stable
  /// human-chosen handle so it can be resumed across restarts). Empty ⇒ the
  /// daemon mints a uuid. Non-empty ⇒ get-or-create: reuse it if it exists,
  /// create it if not (never errors on a taken id).
  @$pb.TagNumber(1)
  $core.String get conversationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set conversationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConversationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConversationId() => $_clearField(1);
}

class EphemeralConversation extends $pb.GeneratedMessage {
  factory EphemeralConversation() => create();

  EphemeralConversation._();

  factory EphemeralConversation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EphemeralConversation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EphemeralConversation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'argot.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EphemeralConversation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EphemeralConversation copyWith(
          void Function(EphemeralConversation) updates) =>
      super.copyWith((message) => updates(message as EphemeralConversation))
          as EphemeralConversation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EphemeralConversation create() => EphemeralConversation._();
  @$core.override
  EphemeralConversation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EphemeralConversation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EphemeralConversation>(create);
  static EphemeralConversation? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
