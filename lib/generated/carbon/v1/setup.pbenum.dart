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

class SetupEvent_Kind extends $pb.ProtobufEnum {
  static const SetupEvent_Kind UNKNOWN =
      SetupEvent_Kind._(0, _omitEnumNames ? '' : 'UNKNOWN');
  static const SetupEvent_Kind COMPLETED =
      SetupEvent_Kind._(1, _omitEnumNames ? '' : 'COMPLETED');
  static const SetupEvent_Kind STOPPED =
      SetupEvent_Kind._(2, _omitEnumNames ? '' : 'STOPPED');

  static const $core.List<SetupEvent_Kind> values = <SetupEvent_Kind>[
    UNKNOWN,
    COMPLETED,
    STOPPED,
  ];

  static final $core.List<SetupEvent_Kind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static SetupEvent_Kind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SetupEvent_Kind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
