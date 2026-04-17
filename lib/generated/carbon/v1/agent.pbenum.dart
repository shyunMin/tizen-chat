//
//  Generated code. Do not modify.
//  source: carbon/v1/agent.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Intent for a structured ingress message.
class IngressIntent extends $pb.ProtobufEnum {
  static const IngressIntent INGRESS_INTENT_UNSPECIFIED = IngressIntent._(0, _omitEnumNames ? '' : 'INGRESS_INTENT_UNSPECIFIED');
  static const IngressIntent INGRESS_INTENT_RUN_TURN = IngressIntent._(1, _omitEnumNames ? '' : 'INGRESS_INTENT_RUN_TURN');
  static const IngressIntent INGRESS_INTENT_OBSERVE = IngressIntent._(2, _omitEnumNames ? '' : 'INGRESS_INTENT_OBSERVE');
  static const IngressIntent INGRESS_INTENT_STATE_UPDATE = IngressIntent._(3, _omitEnumNames ? '' : 'INGRESS_INTENT_STATE_UPDATE');

  static const $core.List<IngressIntent> values = <IngressIntent> [
    INGRESS_INTENT_UNSPECIFIED,
    INGRESS_INTENT_RUN_TURN,
    INGRESS_INTENT_OBSERVE,
    INGRESS_INTENT_STATE_UPDATE,
  ];

  static final $core.Map<$core.int, IngressIntent> _byValue = $pb.ProtobufEnum.initByValue(values);
  static IngressIntent? valueOf($core.int value) => _byValue[value];

  const IngressIntent._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
