// This is a generated file - do not edit.
//
// Generated from carbon/v2/schedule_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

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
