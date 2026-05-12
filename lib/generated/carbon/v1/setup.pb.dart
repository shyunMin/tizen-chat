// This is a generated file - do not edit.
//
// Generated from carbon/v1/setup.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'setup.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'setup.pbenum.dart';

class StartSetupRequest extends $pb.GeneratedMessage {
  factory StartSetupRequest({
    $core.int? preferredPort,
  }) {
    final result = create();
    if (preferredPort != null) result.preferredPort = preferredPort;
    return result;
  }

  StartSetupRequest._();

  factory StartSetupRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartSetupRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartSetupRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'preferredPort')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartSetupRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartSetupRequest copyWith(void Function(StartSetupRequest) updates) =>
      super.copyWith((message) => updates(message as StartSetupRequest))
          as StartSetupRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartSetupRequest create() => StartSetupRequest._();
  @$core.override
  StartSetupRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartSetupRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartSetupRequest>(create);
  static StartSetupRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get preferredPort => $_getIZ(0);
  @$pb.TagNumber(1)
  set preferredPort($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPreferredPort() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreferredPort() => $_clearField(1);
}

class StartSetupResponse extends $pb.GeneratedMessage {
  factory StartSetupResponse({
    $core.String? url,
  }) {
    final result = create();
    if (url != null) result.url = url;
    return result;
  }

  StartSetupResponse._();

  factory StartSetupResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartSetupResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartSetupResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartSetupResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartSetupResponse copyWith(void Function(StartSetupResponse) updates) =>
      super.copyWith((message) => updates(message as StartSetupResponse))
          as StartSetupResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartSetupResponse create() => StartSetupResponse._();
  @$core.override
  StartSetupResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartSetupResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartSetupResponse>(create);
  static StartSetupResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);
}

class StopSetupRequest extends $pb.GeneratedMessage {
  factory StopSetupRequest() => create();

  StopSetupRequest._();

  factory StopSetupRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StopSetupRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopSetupRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopSetupRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopSetupRequest copyWith(void Function(StopSetupRequest) updates) =>
      super.copyWith((message) => updates(message as StopSetupRequest))
          as StopSetupRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopSetupRequest create() => StopSetupRequest._();
  @$core.override
  StopSetupRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StopSetupRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopSetupRequest>(create);
  static StopSetupRequest? _defaultInstance;
}

class StopSetupResponse extends $pb.GeneratedMessage {
  factory StopSetupResponse() => create();

  StopSetupResponse._();

  factory StopSetupResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StopSetupResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopSetupResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopSetupResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopSetupResponse copyWith(void Function(StopSetupResponse) updates) =>
      super.copyWith((message) => updates(message as StopSetupResponse))
          as StopSetupResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopSetupResponse create() => StopSetupResponse._();
  @$core.override
  StopSetupResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StopSetupResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopSetupResponse>(create);
  static StopSetupResponse? _defaultInstance;
}

class WatchSetupRequest extends $pb.GeneratedMessage {
  factory WatchSetupRequest() => create();

  WatchSetupRequest._();

  factory WatchSetupRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchSetupRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchSetupRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchSetupRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchSetupRequest copyWith(void Function(WatchSetupRequest) updates) =>
      super.copyWith((message) => updates(message as WatchSetupRequest))
          as WatchSetupRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchSetupRequest create() => WatchSetupRequest._();
  @$core.override
  WatchSetupRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchSetupRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchSetupRequest>(create);
  static WatchSetupRequest? _defaultInstance;
}

class SetupEvent extends $pb.GeneratedMessage {
  factory SetupEvent({
    SetupEvent_Kind? kind,
    $core.String? url,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (url != null) result.url = url;
    return result;
  }

  SetupEvent._();

  factory SetupEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetupEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetupEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'carbon.v1'),
      createEmptyInstance: create)
    ..aE<SetupEvent_Kind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: SetupEvent_Kind.values)
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetupEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetupEvent copyWith(void Function(SetupEvent) updates) =>
      super.copyWith((message) => updates(message as SetupEvent)) as SetupEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetupEvent create() => SetupEvent._();
  @$core.override
  SetupEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetupEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetupEvent>(create);
  static SetupEvent? _defaultInstance;

  @$pb.TagNumber(1)
  SetupEvent_Kind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(SetupEvent_Kind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
