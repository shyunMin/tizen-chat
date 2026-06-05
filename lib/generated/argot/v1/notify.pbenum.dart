// This is a generated file - do not edit.
//
// Generated from argot/v1/notify.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Notification severity. Values carry the enum-name prefix because proto3
/// enum values are package-scoped (C++ scoping) and would otherwise collide
/// within argot.v1; prost strips the prefix → Severity::Info etc. UNSPECIFIED
/// is the zero value and is never sent (the data layer decodes it to Info).
class Severity extends $pb.ProtobufEnum {
  static const Severity SEVERITY_UNSPECIFIED =
      Severity._(0, _omitEnumNames ? '' : 'SEVERITY_UNSPECIFIED');
  static const Severity SEVERITY_INFO =
      Severity._(1, _omitEnumNames ? '' : 'SEVERITY_INFO');
  static const Severity SEVERITY_WARN =
      Severity._(2, _omitEnumNames ? '' : 'SEVERITY_WARN');
  static const Severity SEVERITY_ERROR =
      Severity._(3, _omitEnumNames ? '' : 'SEVERITY_ERROR');

  static const $core.List<Severity> values = <Severity>[
    SEVERITY_UNSPECIFIED,
    SEVERITY_INFO,
    SEVERITY_WARN,
    SEVERITY_ERROR,
  ];

  static final $core.List<Severity?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Severity? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Severity._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
