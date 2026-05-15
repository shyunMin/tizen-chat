// This is a generated file - do not edit.
//
// Generated from carbon/v2/skill_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ListSkillsRequest extends $pb.GeneratedMessage {
  factory ListSkillsRequest({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  ListSkillsRequest._();

  factory ListSkillsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSkillsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSkillsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSkillsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSkillsRequest copyWith(void Function(ListSkillsRequest) updates) =>
      super.copyWith((message) => updates(message as ListSkillsRequest))
          as ListSkillsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSkillsRequest create() => ListSkillsRequest._();
  @$core.override
  ListSkillsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSkillsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSkillsRequest>(create);
  static ListSkillsRequest? _defaultInstance;

  /// RFC 0008: optional session id. When set, the daemon merges the
  /// session's workspace skills (highest priority) with global / extra /
  /// bundled skills via SkillLoader's existing precedence rules. Empty
  /// string preserves the original workspace-blind behaviour (global +
  /// bundled + extra only). The cli passes its session id so the
  /// dispatcher's skill index sees workspace-local skills.
  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);
}

class ListSkillsResponse extends $pb.GeneratedMessage {
  factory ListSkillsResponse({
    $core.Iterable<ResolvedSkill>? skills,
  }) {
    final result = create();
    if (skills != null) result.skills.addAll(skills);
    return result;
  }

  ListSkillsResponse._();

  factory ListSkillsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSkillsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSkillsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..pPM<ResolvedSkill>(1, _omitFieldNames ? '' : 'skills',
        subBuilder: ResolvedSkill.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSkillsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSkillsResponse copyWith(void Function(ListSkillsResponse) updates) =>
      super.copyWith((message) => updates(message as ListSkillsResponse))
          as ListSkillsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSkillsResponse create() => ListSkillsResponse._();
  @$core.override
  ListSkillsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSkillsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSkillsResponse>(create);
  static ListSkillsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ResolvedSkill> get skills => $_getList(0);
}

class ResolveSkillRequest extends $pb.GeneratedMessage {
  factory ResolveSkillRequest({
    $core.String? trigger,
    $core.String? sessionId,
  }) {
    final result = create();
    if (trigger != null) result.trigger = trigger;
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  ResolveSkillRequest._();

  factory ResolveSkillRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveSkillRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveSkillRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trigger')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveSkillRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveSkillRequest copyWith(void Function(ResolveSkillRequest) updates) =>
      super.copyWith((message) => updates(message as ResolveSkillRequest))
          as ResolveSkillRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveSkillRequest create() => ResolveSkillRequest._();
  @$core.override
  ResolveSkillRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolveSkillRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveSkillRequest>(create);
  static ResolveSkillRequest? _defaultInstance;

  /// Trigger string the user typed (e.g. "review" without the `$` prefix).
  @$pb.TagNumber(1)
  $core.String get trigger => $_getSZ(0);
  @$pb.TagNumber(1)
  set trigger($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrigger() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrigger() => $_clearField(1);

  /// RFC 0008: optional session id; same semantics as in
  /// ListSkillsRequest.session_id. Empty string falls back to the
  /// workspace-blind resolve path.
  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);
}

class ResolvedSkill extends $pb.GeneratedMessage {
  factory ResolvedSkill({
    $core.String? skillId,
    $core.String? name,
    $core.String? description,
    $core.String? scope,
  }) {
    final result = create();
    if (skillId != null) result.skillId = skillId;
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (scope != null) result.scope = scope;
    return result;
  }

  ResolvedSkill._();

  factory ResolvedSkill.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolvedSkill.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolvedSkill',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'skillId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOS(4, _omitFieldNames ? '' : 'scope')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolvedSkill clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolvedSkill copyWith(void Function(ResolvedSkill) updates) =>
      super.copyWith((message) => updates(message as ResolvedSkill))
          as ResolvedSkill;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolvedSkill create() => ResolvedSkill._();
  @$core.override
  ResolvedSkill createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolvedSkill getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolvedSkill>(create);
  static ResolvedSkill? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get skillId => $_getSZ(0);
  @$pb.TagNumber(1)
  set skillId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSkillId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSkillId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  /// RFC 0008 slice 10: scope label as defined by SkillScope
  /// ("global" | "workspace" | "bundled" | "extra"). Used by the cli's
  /// dispatcher to build scope-qualified aliases (e.g. "global/foo")
  /// so SkillLoader's namespace lookup is reachable end-to-end. Empty
  /// string is reserved for legacy daemons that pre-date this field.
  @$pb.TagNumber(4)
  $core.String get scope => $_getSZ(3);
  @$pb.TagNumber(4)
  set scope($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScope() => $_has(3);
  @$pb.TagNumber(4)
  void clearScope() => $_clearField(4);
}

class ReadSkillRequest extends $pb.GeneratedMessage {
  factory ReadSkillRequest({
    $core.String? skillId,
  }) {
    final result = create();
    if (skillId != null) result.skillId = skillId;
    return result;
  }

  ReadSkillRequest._();

  factory ReadSkillRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReadSkillRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReadSkillRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'skillId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadSkillRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadSkillRequest copyWith(void Function(ReadSkillRequest) updates) =>
      super.copyWith((message) => updates(message as ReadSkillRequest))
          as ReadSkillRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReadSkillRequest create() => ReadSkillRequest._();
  @$core.override
  ReadSkillRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReadSkillRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReadSkillRequest>(create);
  static ReadSkillRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get skillId => $_getSZ(0);
  @$pb.TagNumber(1)
  set skillId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSkillId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSkillId() => $_clearField(1);
}

class SkillContent extends $pb.GeneratedMessage {
  factory SkillContent({
    $core.String? skillId,
    $core.String? body,
  }) {
    final result = create();
    if (skillId != null) result.skillId = skillId;
    if (body != null) result.body = body;
    return result;
  }

  SkillContent._();

  factory SkillContent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SkillContent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SkillContent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'skillId')
    ..aOS(2, _omitFieldNames ? '' : 'body')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SkillContent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SkillContent copyWith(void Function(SkillContent) updates) =>
      super.copyWith((message) => updates(message as SkillContent))
          as SkillContent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SkillContent create() => SkillContent._();
  @$core.override
  SkillContent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SkillContent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SkillContent>(create);
  static SkillContent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get skillId => $_getSZ(0);
  @$pb.TagNumber(1)
  set skillId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSkillId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSkillId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get body => $_getSZ(1);
  @$pb.TagNumber(2)
  set body($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBody() => $_has(1);
  @$pb.TagNumber(2)
  void clearBody() => $_clearField(2);
}

class InstallSkillRequest extends $pb.GeneratedMessage {
  factory InstallSkillRequest({
    $core.String? source,
  }) {
    final result = create();
    if (source != null) result.source = source;
    return result;
  }

  InstallSkillRequest._();

  factory InstallSkillRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InstallSkillRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InstallSkillRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'source')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InstallSkillRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InstallSkillRequest copyWith(void Function(InstallSkillRequest) updates) =>
      super.copyWith((message) => updates(message as InstallSkillRequest))
          as InstallSkillRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InstallSkillRequest create() => InstallSkillRequest._();
  @$core.override
  InstallSkillRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InstallSkillRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InstallSkillRequest>(create);
  static InstallSkillRequest? _defaultInstance;

  /// URL or local path. Trust / sandbox model is a slice 6 design item.
  @$pb.TagNumber(1)
  $core.String get source => $_getSZ(0);
  @$pb.TagNumber(1)
  set source($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSource() => $_has(0);
  @$pb.TagNumber(1)
  void clearSource() => $_clearField(1);
}

class InstallSkillResponse extends $pb.GeneratedMessage {
  factory InstallSkillResponse({
    $core.String? skillId,
    $core.bool? installed,
  }) {
    final result = create();
    if (skillId != null) result.skillId = skillId;
    if (installed != null) result.installed = installed;
    return result;
  }

  InstallSkillResponse._();

  factory InstallSkillResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InstallSkillResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InstallSkillResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'skillId')
    ..aOB(2, _omitFieldNames ? '' : 'installed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InstallSkillResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InstallSkillResponse copyWith(void Function(InstallSkillResponse) updates) =>
      super.copyWith((message) => updates(message as InstallSkillResponse))
          as InstallSkillResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InstallSkillResponse create() => InstallSkillResponse._();
  @$core.override
  InstallSkillResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InstallSkillResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InstallSkillResponse>(create);
  static InstallSkillResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get skillId => $_getSZ(0);
  @$pb.TagNumber(1)
  set skillId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSkillId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSkillId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get installed => $_getBF(1);
  @$pb.TagNumber(2)
  set installed($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInstalled() => $_has(1);
  @$pb.TagNumber(2)
  void clearInstalled() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
