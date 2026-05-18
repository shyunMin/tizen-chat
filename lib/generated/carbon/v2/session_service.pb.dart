// This is a generated file - do not edit.
//
// Generated from carbon/v2/session_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'product')
    ..m<$core.String, $core.String>(2, _omitFieldNames ? '' : 'config',
        entryClassName: 'CreateSessionRequest.ConfigEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('carbon.v2'))
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

  @$pb.TagNumber(1)
  $core.String get product => $_getSZ(0);
  @$pb.TagNumber(1)
  set product($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProduct() => $_has(0);
  @$pb.TagNumber(1)
  void clearProduct() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.String> get config => $_getMap(1);
}

class GetSessionRequest extends $pb.GeneratedMessage {
  factory GetSessionRequest({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  GetSessionRequest._();

  factory GetSessionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSessionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSessionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSessionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSessionRequest copyWith(void Function(GetSessionRequest) updates) =>
      super.copyWith((message) => updates(message as GetSessionRequest))
          as GetSessionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSessionRequest create() => GetSessionRequest._();
  @$core.override
  GetSessionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSessionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSessionRequest>(create);
  static GetSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

class ListSessionsRequest extends $pb.GeneratedMessage {
  factory ListSessionsRequest({
    $core.bool? includeArchived,
  }) {
    final result = create();
    if (includeArchived != null) result.includeArchived = includeArchived;
    return result;
  }

  ListSessionsRequest._();

  factory ListSessionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSessionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSessionsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'includeArchived')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSessionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSessionsRequest copyWith(void Function(ListSessionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListSessionsRequest))
          as ListSessionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSessionsRequest create() => ListSessionsRequest._();
  @$core.override
  ListSessionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSessionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSessionsRequest>(create);
  static ListSessionsRequest? _defaultInstance;

  /// Empty = all sessions visible to this caller.
  @$pb.TagNumber(1)
  $core.bool get includeArchived => $_getBF(0);
  @$pb.TagNumber(1)
  set includeArchived($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIncludeArchived() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncludeArchived() => $_clearField(1);
}

class ListSessionsResponse extends $pb.GeneratedMessage {
  factory ListSessionsResponse({
    $core.Iterable<Session>? sessions,
  }) {
    final result = create();
    if (sessions != null) result.sessions.addAll(sessions);
    return result;
  }

  ListSessionsResponse._();

  factory ListSessionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSessionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSessionsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..pPM<Session>(1, _omitFieldNames ? '' : 'sessions',
        subBuilder: Session.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSessionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSessionsResponse copyWith(void Function(ListSessionsResponse) updates) =>
      super.copyWith((message) => updates(message as ListSessionsResponse))
          as ListSessionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSessionsResponse create() => ListSessionsResponse._();
  @$core.override
  ListSessionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSessionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSessionsResponse>(create);
  static ListSessionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Session> get sessions => $_getList(0);
}

class ArchiveSessionRequest extends $pb.GeneratedMessage {
  factory ArchiveSessionRequest({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  ArchiveSessionRequest._();

  factory ArchiveSessionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ArchiveSessionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArchiveSessionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArchiveSessionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArchiveSessionRequest copyWith(
          void Function(ArchiveSessionRequest) updates) =>
      super.copyWith((message) => updates(message as ArchiveSessionRequest))
          as ArchiveSessionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ArchiveSessionRequest create() => ArchiveSessionRequest._();
  @$core.override
  ArchiveSessionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ArchiveSessionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ArchiveSessionRequest>(create);
  static ArchiveSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

class ArchiveSessionResponse extends $pb.GeneratedMessage {
  factory ArchiveSessionResponse({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  ArchiveSessionResponse._();

  factory ArchiveSessionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ArchiveSessionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArchiveSessionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArchiveSessionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArchiveSessionResponse copyWith(
          void Function(ArchiveSessionResponse) updates) =>
      super.copyWith((message) => updates(message as ArchiveSessionResponse))
          as ArchiveSessionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ArchiveSessionResponse create() => ArchiveSessionResponse._();
  @$core.override
  ArchiveSessionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ArchiveSessionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ArchiveSessionResponse>(create);
  static ArchiveSessionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
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

class CancelSessionResponse extends $pb.GeneratedMessage {
  factory CancelSessionResponse({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  CancelSessionResponse._();

  factory CancelSessionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelSessionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelSessionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelSessionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelSessionResponse copyWith(
          void Function(CancelSessionResponse) updates) =>
      super.copyWith((message) => updates(message as CancelSessionResponse))
          as CancelSessionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelSessionResponse create() => CancelSessionResponse._();
  @$core.override
  CancelSessionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelSessionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelSessionResponse>(create);
  static CancelSessionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

/// Daemon-side root session container for one product instance.
class Session extends $pb.GeneratedMessage {
  factory Session({
    $core.String? sessionId,
    $core.String? sessionName,
    $core.String? product,
    $core.String? workspace,
    RuntimeInfo? runtime,
    $core.bool? archived,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (sessionName != null) result.sessionName = sessionName;
    if (product != null) result.product = product;
    if (workspace != null) result.workspace = workspace;
    if (runtime != null) result.runtime = runtime;
    if (archived != null) result.archived = archived;
    return result;
  }

  Session._();

  factory Session.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Session.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Session',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionName')
    ..aOS(3, _omitFieldNames ? '' : 'product')
    ..aOS(4, _omitFieldNames ? '' : 'workspace')
    ..aOM<RuntimeInfo>(5, _omitFieldNames ? '' : 'runtime',
        subBuilder: RuntimeInfo.create)
    ..aOB(6, _omitFieldNames ? '' : 'archived')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Session clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Session copyWith(void Function(Session) updates) =>
      super.copyWith((message) => updates(message as Session)) as Session;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Session create() => Session._();
  @$core.override
  Session createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Session getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Session>(create);
  static Session? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionName => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionName() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get product => $_getSZ(2);
  @$pb.TagNumber(3)
  set product($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProduct() => $_has(2);
  @$pb.TagNumber(3)
  void clearProduct() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get workspace => $_getSZ(3);
  @$pb.TagNumber(4)
  set workspace($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWorkspace() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorkspace() => $_clearField(4);

  @$pb.TagNumber(5)
  RuntimeInfo get runtime => $_getN(4);
  @$pb.TagNumber(5)
  set runtime(RuntimeInfo value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRuntime() => $_has(4);
  @$pb.TagNumber(5)
  void clearRuntime() => $_clearField(5);
  @$pb.TagNumber(5)
  RuntimeInfo ensureRuntime() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.bool get archived => $_getBF(5);
  @$pb.TagNumber(6)
  set archived($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasArchived() => $_has(5);
  @$pb.TagNumber(6)
  void clearArchived() => $_clearField(6);
}

class RuntimeInfo extends $pb.GeneratedMessage {
  factory RuntimeInfo({
    $core.String? name,
    $core.String? version,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (version != null) result.version = version;
    return result;
  }

  RuntimeInfo._();

  factory RuntimeInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RuntimeInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RuntimeInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeInfo copyWith(void Function(RuntimeInfo) updates) =>
      super.copyWith((message) => updates(message as RuntimeInfo))
          as RuntimeInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RuntimeInfo create() => RuntimeInfo._();
  @$core.override
  RuntimeInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RuntimeInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RuntimeInfo>(create);
  static RuntimeInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
