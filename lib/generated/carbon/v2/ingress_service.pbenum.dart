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

class Disposition extends $pb.ProtobufEnum {
  static const Disposition DISPOSITION_UNSPECIFIED =
      Disposition._(0, _omitEnumNames ? '' : 'DISPOSITION_UNSPECIFIED');

  /// No in-flight turn — new turn started. turn_id set.
  static const Disposition DISPOSITION_STARTED_NOW =
      Disposition._(1, _omitEnumNames ? '' : 'DISPOSITION_STARTED_NOW');

  /// Injection scheduled into in-flight turn. turn_id = in-flight turn.
  static const Disposition DISPOSITION_STEERED =
      Disposition._(2, _omitEnumNames ? '' : 'DISPOSITION_STEERED');

  /// Queued behind in-flight turn. turn_id = "" (assigned later).
  static const Disposition DISPOSITION_QUEUED =
      Disposition._(3, _omitEnumNames ? '' : 'DISPOSITION_QUEUED');

  /// intent=OBSERVE — recorded only, no turn or steer side effects.
  static const Disposition DISPOSITION_OBSERVED =
      Disposition._(4, _omitEnumNames ? '' : 'DISPOSITION_OBSERVED');

  /// Mailbox DropIfBusy fired.
  static const Disposition DISPOSITION_DROPPED =
      Disposition._(5, _omitEnumNames ? '' : 'DISPOSITION_DROPPED');

  static const $core.List<Disposition> values = <Disposition>[
    DISPOSITION_UNSPECIFIED,
    DISPOSITION_STARTED_NOW,
    DISPOSITION_STEERED,
    DISPOSITION_QUEUED,
    DISPOSITION_OBSERVED,
    DISPOSITION_DROPPED,
  ];

  static final $core.List<Disposition?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static Disposition? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Disposition._(super.value, super.name);
}

class InterruptMode extends $pb.ProtobufEnum {
  static const InterruptMode INTERRUPT_MODE_UNSPECIFIED =
      InterruptMode._(0, _omitEnumNames ? '' : 'INTERRUPT_MODE_UNSPECIFIED');

  /// Cancel the entire turn; pending steers dropped.
  static const InterruptMode INTERRUPT_MODE_HARD =
      InterruptMode._(1, _omitEnumNames ? '' : 'INTERRUPT_MODE_HARD');

  /// Cancel only the in-flight tool call, immediately apply pending steers,
  /// then continue the same turn. Reserved — not yet implemented.
  static const InterruptMode INTERRUPT_MODE_SOFT =
      InterruptMode._(2, _omitEnumNames ? '' : 'INTERRUPT_MODE_SOFT');

  static const $core.List<InterruptMode> values = <InterruptMode>[
    INTERRUPT_MODE_UNSPECIFIED,
    INTERRUPT_MODE_HARD,
    INTERRUPT_MODE_SOFT,
  ];

  static final $core.List<InterruptMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static InterruptMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const InterruptMode._(super.value, super.name);
}

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

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
