// This is a generated file - do not edit.
//
// Generated from carbon/v2/control_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class CompactSessionRequest extends $pb.GeneratedMessage {
  factory CompactSessionRequest({
    $core.String? sessionId,
    $core.String? cue,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (cue != null) result.cue = cue;
    return result;
  }

  CompactSessionRequest._();

  factory CompactSessionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompactSessionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompactSessionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'cue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompactSessionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompactSessionRequest copyWith(
          void Function(CompactSessionRequest) updates) =>
      super.copyWith((message) => updates(message as CompactSessionRequest))
          as CompactSessionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompactSessionRequest create() => CompactSessionRequest._();
  @$core.override
  CompactSessionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompactSessionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompactSessionRequest>(create);
  static CompactSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  /// RFC 0008: free-form user-supplied cue / reason for the compaction.
  /// Carried opaquely; runtime decides how it influences the compaction
  /// prompt or policy. None for compactions that have no caller-supplied
  /// framing (e.g., internal auto-compact when no reason applies).
  @$pb.TagNumber(2)
  $core.String get cue => $_getSZ(1);
  @$pb.TagNumber(2)
  set cue($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCue() => $_has(1);
  @$pb.TagNumber(2)
  void clearCue() => $_clearField(2);
}

class CompactSessionResponse extends $pb.GeneratedMessage {
  factory CompactSessionResponse({
    $core.String? sessionId,
    $core.String? threadId,
    $core.String? newLogId,
    $core.String? summaryExcerpt,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (threadId != null) result.threadId = threadId;
    if (newLogId != null) result.newLogId = newLogId;
    if (summaryExcerpt != null) result.summaryExcerpt = summaryExcerpt;
    return result;
  }

  CompactSessionResponse._();

  factory CompactSessionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompactSessionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompactSessionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'threadId')
    ..aOS(3, _omitFieldNames ? '' : 'newLogId')
    ..aOS(4, _omitFieldNames ? '' : 'summaryExcerpt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompactSessionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompactSessionResponse copyWith(
          void Function(CompactSessionResponse) updates) =>
      super.copyWith((message) => updates(message as CompactSessionResponse))
          as CompactSessionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompactSessionResponse create() => CompactSessionResponse._();
  @$core.override
  CompactSessionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompactSessionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompactSessionResponse>(create);
  static CompactSessionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  /// Thread that was compacted/closed. Reserved for future per-thread
  /// compaction; current whole-session compaction leaves this empty.
  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);

  /// log_id after the rotation that compaction performs. Stable session_id
  /// (field 1) does NOT change — only the internal rotating log_id moves.
  @$pb.TagNumber(3)
  $core.String get newLogId => $_getSZ(2);
  @$pb.TagNumber(3)
  set newLogId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewLogId() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewLogId() => $_clearField(3);

  /// First ~200 characters of the LLM-generated continuation summary.
  /// Lets the cli print "Compacted: <preview>…" without a follow-up RPC.
  @$pb.TagNumber(4)
  $core.String get summaryExcerpt => $_getSZ(3);
  @$pb.TagNumber(4)
  set summaryExcerpt($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSummaryExcerpt() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummaryExcerpt() => $_clearField(4);
}

class ClearSessionRequest extends $pb.GeneratedMessage {
  factory ClearSessionRequest({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  ClearSessionRequest._();

  factory ClearSessionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClearSessionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearSessionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearSessionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearSessionRequest copyWith(void Function(ClearSessionRequest) updates) =>
      super.copyWith((message) => updates(message as ClearSessionRequest))
          as ClearSessionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClearSessionRequest create() => ClearSessionRequest._();
  @$core.override
  ClearSessionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClearSessionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClearSessionRequest>(create);
  static ClearSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

class ClearSessionResponse extends $pb.GeneratedMessage {
  factory ClearSessionResponse({
    $core.String? sessionId,
    $core.String? newLogId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (newLogId != null) result.newLogId = newLogId;
    return result;
  }

  ClearSessionResponse._();

  factory ClearSessionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClearSessionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearSessionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'newLogId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearSessionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearSessionResponse copyWith(void Function(ClearSessionResponse) updates) =>
      super.copyWith((message) => updates(message as ClearSessionResponse))
          as ClearSessionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClearSessionResponse create() => ClearSessionResponse._();
  @$core.override
  ClearSessionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClearSessionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClearSessionResponse>(create);
  static ClearSessionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  /// log_id of the freshly-rotated empty log segment. session_id (field 1)
  /// is the same value the caller passed in — stability invariant per
  /// ADR 0004.
  @$pb.TagNumber(2)
  $core.String get newLogId => $_getSZ(1);
  @$pb.TagNumber(2)
  set newLogId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNewLogId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewLogId() => $_clearField(2);
}

class GetStatusRequest extends $pb.GeneratedMessage {
  factory GetStatusRequest({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  GetStatusRequest._();

  factory GetStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatusRequest copyWith(void Function(GetStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GetStatusRequest))
          as GetStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStatusRequest create() => GetStatusRequest._();
  @$core.override
  GetStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetStatusRequest>(create);
  static GetStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

/// Snapshot of the session's current state. Lightweight subset — full
/// history / thread bodies live behind ThreadService.Browse.
class Status extends $pb.GeneratedMessage {
  factory Status({
    $core.String? sessionId,
    $core.String? logId,
    $core.String? product,
    $core.String? workspace,
    $core.String? sessionName,
    $core.String? provider,
    $core.String? model,
    $core.String? activeThreadId,
    $core.int? turnCount,
    $core.String? approvalPolicy,
    $core.int? historyLen,
    $core.String? status,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (logId != null) result.logId = logId;
    if (product != null) result.product = product;
    if (workspace != null) result.workspace = workspace;
    if (sessionName != null) result.sessionName = sessionName;
    if (provider != null) result.provider = provider;
    if (model != null) result.model = model;
    if (activeThreadId != null) result.activeThreadId = activeThreadId;
    if (turnCount != null) result.turnCount = turnCount;
    if (approvalPolicy != null) result.approvalPolicy = approvalPolicy;
    if (historyLen != null) result.historyLen = historyLen;
    if (status != null) result.status = status;
    return result;
  }

  Status._();

  factory Status.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Status.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Status',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'logId')
    ..aOS(3, _omitFieldNames ? '' : 'product')
    ..aOS(4, _omitFieldNames ? '' : 'workspace')
    ..aOS(5, _omitFieldNames ? '' : 'sessionName')
    ..aOS(6, _omitFieldNames ? '' : 'provider')
    ..aOS(7, _omitFieldNames ? '' : 'model')
    ..aOS(8, _omitFieldNames ? '' : 'activeThreadId')
    ..aI(9, _omitFieldNames ? '' : 'turnCount', fieldType: $pb.PbFieldType.OU3)
    ..aOS(10, _omitFieldNames ? '' : 'approvalPolicy')
    ..aI(11, _omitFieldNames ? '' : 'historyLen',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(12, _omitFieldNames ? '' : 'status')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Status clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Status copyWith(void Function(Status) updates) =>
      super.copyWith((message) => updates(message as Status)) as Status;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Status create() => Status._();
  @$core.override
  Status createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Status getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Status>(create);
  static Status? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  /// Current rotating internal log_id (ADR 0004). Changes after /compact
  /// or /clear; the stable session_id (field 1) does not.
  @$pb.TagNumber(2)
  $core.String get logId => $_getSZ(1);
  @$pb.TagNumber(2)
  set logId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLogId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLogId() => $_clearField(2);

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
  $core.String get sessionName => $_getSZ(4);
  @$pb.TagNumber(5)
  set sessionName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSessionName() => $_has(4);
  @$pb.TagNumber(5)
  void clearSessionName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get provider => $_getSZ(5);
  @$pb.TagNumber(6)
  set provider($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasProvider() => $_has(5);
  @$pb.TagNumber(6)
  void clearProvider() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get model => $_getSZ(6);
  @$pb.TagNumber(7)
  set model($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasModel() => $_has(6);
  @$pb.TagNumber(7)
  void clearModel() => $_clearField(7);

  /// Empty string when no thread is active.
  @$pb.TagNumber(8)
  $core.String get activeThreadId => $_getSZ(7);
  @$pb.TagNumber(8)
  set activeThreadId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasActiveThreadId() => $_has(7);
  @$pb.TagNumber(8)
  void clearActiveThreadId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get turnCount => $_getIZ(8);
  @$pb.TagNumber(9)
  set turnCount($core.int value) => $_setUnsignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTurnCount() => $_has(8);
  @$pb.TagNumber(9)
  void clearTurnCount() => $_clearField(9);

  /// "strict" | "normal" | "permissive" | "off".
  @$pb.TagNumber(10)
  $core.String get approvalPolicy => $_getSZ(9);
  @$pb.TagNumber(10)
  set approvalPolicy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasApprovalPolicy() => $_has(9);
  @$pb.TagNumber(10)
  void clearApprovalPolicy() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get historyLen => $_getIZ(10);
  @$pb.TagNumber(11)
  set historyLen($core.int value) => $_setUnsignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasHistoryLen() => $_has(10);
  @$pb.TagNumber(11)
  void clearHistoryLen() => $_clearField(11);

  /// "active" | "paused". Reserved for future paused-thread surfacing;
  /// today the daemon always reports "active" for a live session.
  @$pb.TagNumber(12)
  $core.String get status => $_getSZ(11);
  @$pb.TagNumber(12)
  set status($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasStatus() => $_has(11);
  @$pb.TagNumber(12)
  void clearStatus() => $_clearField(12);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
