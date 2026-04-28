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

import 'package:protobuf/protobuf.dart' as $pb;

/// Intent for a structured ingress message.
class IngressIntent extends $pb.ProtobufEnum {
  static const IngressIntent INGRESS_INTENT_UNSPECIFIED =
      IngressIntent._(0, _omitEnumNames ? '' : 'INGRESS_INTENT_UNSPECIFIED');
  static const IngressIntent INGRESS_INTENT_RUN_TURN =
      IngressIntent._(1, _omitEnumNames ? '' : 'INGRESS_INTENT_RUN_TURN');
  static const IngressIntent INGRESS_INTENT_OBSERVE =
      IngressIntent._(2, _omitEnumNames ? '' : 'INGRESS_INTENT_OBSERVE');
  static const IngressIntent INGRESS_INTENT_STATE_UPDATE =
      IngressIntent._(3, _omitEnumNames ? '' : 'INGRESS_INTENT_STATE_UPDATE');

  static const $core.List<IngressIntent> values = <IngressIntent>[
    INGRESS_INTENT_UNSPECIFIED,
    INGRESS_INTENT_RUN_TURN,
    INGRESS_INTENT_OBSERVE,
    INGRESS_INTENT_STATE_UPDATE,
  ];

  static final $core.List<IngressIntent?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static IngressIntent? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const IngressIntent._(super.value, super.name);
}

/// Decision for tool approval requests.
class ApprovalDecision extends $pb.ProtobufEnum {
  static const ApprovalDecision APPROVAL_DECISION_UNSPECIFIED =
      ApprovalDecision._(
          0, _omitEnumNames ? '' : 'APPROVAL_DECISION_UNSPECIFIED');
  static const ApprovalDecision APPROVAL_DECISION_APPROVE =
      ApprovalDecision._(1, _omitEnumNames ? '' : 'APPROVAL_DECISION_APPROVE');
  static const ApprovalDecision APPROVAL_DECISION_DENY =
      ApprovalDecision._(2, _omitEnumNames ? '' : 'APPROVAL_DECISION_DENY');
  static const ApprovalDecision APPROVAL_DECISION_ALWAYS_SESSION =
      ApprovalDecision._(
          3, _omitEnumNames ? '' : 'APPROVAL_DECISION_ALWAYS_SESSION');

  static const $core.List<ApprovalDecision> values = <ApprovalDecision>[
    APPROVAL_DECISION_UNSPECIFIED,
    APPROVAL_DECISION_APPROVE,
    APPROVAL_DECISION_DENY,
    APPROVAL_DECISION_ALWAYS_SESSION,
  ];

  static final $core.List<ApprovalDecision?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ApprovalDecision? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ApprovalDecision._(super.value, super.name);
}

/// Schedule action type.
class ScheduleAction extends $pb.ProtobufEnum {
  static const ScheduleAction SCHEDULE_ACTION_UNSPECIFIED =
      ScheduleAction._(0, _omitEnumNames ? '' : 'SCHEDULE_ACTION_UNSPECIFIED');
  static const ScheduleAction SCHEDULE_ACTION_SET =
      ScheduleAction._(1, _omitEnumNames ? '' : 'SCHEDULE_ACTION_SET');
  static const ScheduleAction SCHEDULE_ACTION_PAUSE =
      ScheduleAction._(2, _omitEnumNames ? '' : 'SCHEDULE_ACTION_PAUSE');
  static const ScheduleAction SCHEDULE_ACTION_RESUME =
      ScheduleAction._(3, _omitEnumNames ? '' : 'SCHEDULE_ACTION_RESUME');
  static const ScheduleAction SCHEDULE_ACTION_REMOVE =
      ScheduleAction._(4, _omitEnumNames ? '' : 'SCHEDULE_ACTION_REMOVE');
  static const ScheduleAction SCHEDULE_ACTION_LIST =
      ScheduleAction._(5, _omitEnumNames ? '' : 'SCHEDULE_ACTION_LIST');

  static const $core.List<ScheduleAction> values = <ScheduleAction>[
    SCHEDULE_ACTION_UNSPECIFIED,
    SCHEDULE_ACTION_SET,
    SCHEDULE_ACTION_PAUSE,
    SCHEDULE_ACTION_RESUME,
    SCHEDULE_ACTION_REMOVE,
    SCHEDULE_ACTION_LIST,
  ];

  static final $core.List<ScheduleAction?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ScheduleAction? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ScheduleAction._(super.value, super.name);
}

/// Schedule type discriminant.
class ScheduleType extends $pb.ProtobufEnum {
  static const ScheduleType SCHEDULE_TYPE_UNSPECIFIED =
      ScheduleType._(0, _omitEnumNames ? '' : 'SCHEDULE_TYPE_UNSPECIFIED');
  static const ScheduleType SCHEDULE_TYPE_INTERVAL =
      ScheduleType._(1, _omitEnumNames ? '' : 'SCHEDULE_TYPE_INTERVAL');
  static const ScheduleType SCHEDULE_TYPE_CRON =
      ScheduleType._(2, _omitEnumNames ? '' : 'SCHEDULE_TYPE_CRON');
  static const ScheduleType SCHEDULE_TYPE_ONCE =
      ScheduleType._(3, _omitEnumNames ? '' : 'SCHEDULE_TYPE_ONCE');

  static const $core.List<ScheduleType> values = <ScheduleType>[
    SCHEDULE_TYPE_UNSPECIFIED,
    SCHEDULE_TYPE_INTERVAL,
    SCHEDULE_TYPE_CRON,
    SCHEDULE_TYPE_ONCE,
  ];

  static final $core.List<ScheduleType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ScheduleType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ScheduleType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
