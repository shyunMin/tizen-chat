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

import 'package:protobuf/protobuf.dart' as $pb;

/// How much tool-result output a stream carries. Stated per chat request
/// (ChatRequest.tool_detail) and per watch subscriber (WatchRequest.tool_detail);
/// it governs only ToolResult.output_json — ToolCall.arguments_json is carried
/// whole at every level. Reduction is signaled by output_truncated +
/// output_bytes, never by in-band markers.
class ToolDetail extends $pb.ProtobufEnum {
  /// Proto3 zero value: an unstated level. The daemon treats it as FULL, so
  /// clients predating this field keep today's wire.
  static const ToolDetail TOOL_DETAIL_UNSPECIFIED =
      ToolDetail._(0, _omitEnumNames ? '' : 'TOOL_DETAIL_UNSPECIFIED');

  /// The complete output as the runtime produced it.
  static const ToolDetail TOOL_DETAIL_FULL =
      ToolDetail._(1, _omitEnumNames ? '' : 'TOOL_DETAIL_FULL');

  /// Output truncated byte-safe at the 4096-byte wire cap.
  static const ToolDetail TOOL_DETAIL_CAPPED =
      ToolDetail._(2, _omitEnumNames ? '' : 'TOOL_DETAIL_CAPPED');

  /// Empty on success; on failure the failure payload, up to the wire cap.
  static const ToolDetail TOOL_DETAIL_OUTCOME =
      ToolDetail._(3, _omitEnumNames ? '' : 'TOOL_DETAIL_OUTCOME');

  static const $core.List<ToolDetail> values = <ToolDetail>[
    TOOL_DETAIL_UNSPECIFIED,
    TOOL_DETAIL_FULL,
    TOOL_DETAIL_CAPPED,
    TOOL_DETAIL_OUTCOME,
  ];

  static final $core.List<ToolDetail?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ToolDetail? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ToolDetail._(super.value, super.name);
}

/// Prefixed values — proto3 enum values are package-scoped, so they must be
/// unique across all enums in argot.v1 (prost strips the prefix → StopReason::IterCap).
class StopReason extends $pb.ProtobufEnum {
  static const StopReason STOP_REASON_UNSPECIFIED =
      StopReason._(0, _omitEnumNames ? '' : 'STOP_REASON_UNSPECIFIED');
  static const StopReason STOP_REASON_ITER_CAP =
      StopReason._(1, _omitEnumNames ? '' : 'STOP_REASON_ITER_CAP');
  static const StopReason STOP_REASON_TOKEN_CAP =
      StopReason._(2, _omitEnumNames ? '' : 'STOP_REASON_TOKEN_CAP');
  static const StopReason STOP_REASON_TIME_CAP =
      StopReason._(3, _omitEnumNames ? '' : 'STOP_REASON_TIME_CAP');
  static const StopReason STOP_REASON_CANCELLED =
      StopReason._(4, _omitEnumNames ? '' : 'STOP_REASON_CANCELLED');

  static const $core.List<StopReason> values = <StopReason>[
    STOP_REASON_UNSPECIFIED,
    STOP_REASON_ITER_CAP,
    STOP_REASON_TOKEN_CAP,
    STOP_REASON_TIME_CAP,
    STOP_REASON_CANCELLED,
  ];

  static final $core.List<StopReason?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static StopReason? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const StopReason._(super.value, super.name);
}

/// Prefixed values (package-scoped → unique across argot.v1; prost strips the
/// prefix → Phase::Thinking).
class Phase extends $pb.ProtobufEnum {
  static const Phase PHASE_UNSPECIFIED =
      Phase._(0, _omitEnumNames ? '' : 'PHASE_UNSPECIFIED');
  static const Phase PHASE_THINKING =
      Phase._(1, _omitEnumNames ? '' : 'PHASE_THINKING');
  static const Phase PHASE_MEMORY_RETRIEVING =
      Phase._(2, _omitEnumNames ? '' : 'PHASE_MEMORY_RETRIEVING');
  static const Phase PHASE_STREAMING =
      Phase._(3, _omitEnumNames ? '' : 'PHASE_STREAMING');
  static const Phase PHASE_TOOL_EXECUTING =
      Phase._(4, _omitEnumNames ? '' : 'PHASE_TOOL_EXECUTING');
  static const Phase PHASE_DONE =
      Phase._(5, _omitEnumNames ? '' : 'PHASE_DONE');
  static const Phase PHASE_SUMMARY =
      Phase._(6, _omitEnumNames ? '' : 'PHASE_SUMMARY');

  static const $core.List<Phase> values = <Phase>[
    PHASE_UNSPECIFIED,
    PHASE_THINKING,
    PHASE_MEMORY_RETRIEVING,
    PHASE_STREAMING,
    PHASE_TOOL_EXECUTING,
    PHASE_DONE,
    PHASE_SUMMARY,
  ];

  static final $core.List<Phase?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static Phase? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Phase._(super.value, super.name);
}

class ProgressSource extends $pb.ProtobufEnum {
  static const ProgressSource PROGRESS_SOURCE_UNSPECIFIED =
      ProgressSource._(0, _omitEnumNames ? '' : 'PROGRESS_SOURCE_UNSPECIFIED');

  /// A coarse AgentStatus transition (deterministic, cheap).
  static const ProgressSource PROGRESS_SOURCE_AGENT_STATUS =
      ProgressSource._(1, _omitEnumNames ? '' : 'PROGRESS_SOURCE_AGENT_STATUS');

  /// A periodic LLM-backed AgentProgress narration tick.
  static const ProgressSource PROGRESS_SOURCE_AGENT_PROGRESS_SUMMARY =
      ProgressSource._(
          2, _omitEnumNames ? '' : 'PROGRESS_SOURCE_AGENT_PROGRESS_SUMMARY');

  static const $core.List<ProgressSource> values = <ProgressSource>[
    PROGRESS_SOURCE_UNSPECIFIED,
    PROGRESS_SOURCE_AGENT_STATUS,
    PROGRESS_SOURCE_AGENT_PROGRESS_SUMMARY,
  ];

  static final $core.List<ProgressSource?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ProgressSource? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ProgressSource._(super.value, super.name);
}

class Role extends $pb.ProtobufEnum {
  /// Prefixed because proto3 enum values are package-scoped: an unprefixed
  /// TOOL/USER/... would collide with another enum in argot.v1 (e.g.
  /// EventCategory.TOOL). prost strips the prefix → Role::User, Role::Tool.
  static const Role ROLE_UNSPECIFIED =
      Role._(0, _omitEnumNames ? '' : 'ROLE_UNSPECIFIED');
  static const Role ROLE_USER = Role._(1, _omitEnumNames ? '' : 'ROLE_USER');
  static const Role ROLE_ASSISTANT =
      Role._(2, _omitEnumNames ? '' : 'ROLE_ASSISTANT');
  static const Role ROLE_SYSTEM =
      Role._(3, _omitEnumNames ? '' : 'ROLE_SYSTEM');
  static const Role ROLE_TOOL = Role._(4, _omitEnumNames ? '' : 'ROLE_TOOL');

  static const $core.List<Role> values = <Role>[
    ROLE_UNSPECIFIED,
    ROLE_USER,
    ROLE_ASSISTANT,
    ROLE_SYSTEM,
    ROLE_TOOL,
  ];

  static final $core.List<Role?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Role? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Role._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
