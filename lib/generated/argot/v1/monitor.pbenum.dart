// This is a generated file - do not edit.
//
// Generated from argot/v1/monitor.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Coarse classification a client filters Watch on (via WatchRequest.categories).
/// The daemon tags each SystemEvent with one category and applies the filter
/// server-side; UNSPECIFIED is the proto3 zero value and is never sent.
class EventCategory extends $pb.ProtobufEnum {
  /// Values are package-scoped (proto3 C++ scoping), so they carry the
  /// enum-name prefix to stay unique within argot.v1 (e.g. Role also has
  /// a TOOL). prost strips the prefix → EventCategory::Tool etc.
  static const EventCategory EVENT_CATEGORY_UNSPECIFIED =
      EventCategory._(0, _omitEnumNames ? '' : 'EVENT_CATEGORY_UNSPECIFIED');
  static const EventCategory EVENT_CATEGORY_TURN =
      EventCategory._(1, _omitEnumNames ? '' : 'EVENT_CATEGORY_TURN');
  static const EventCategory EVENT_CATEGORY_TOOL =
      EventCategory._(2, _omitEnumNames ? '' : 'EVENT_CATEGORY_TOOL');
  static const EventCategory EVENT_CATEGORY_ROUTINE =
      EventCategory._(3, _omitEnumNames ? '' : 'EVENT_CATEGORY_ROUTINE');
  static const EventCategory EVENT_CATEGORY_STATUS =
      EventCategory._(4, _omitEnumNames ? '' : 'EVENT_CATEGORY_STATUS');
  static const EventCategory EVENT_CATEGORY_ERROR =
      EventCategory._(5, _omitEnumNames ? '' : 'EVENT_CATEGORY_ERROR');

  static const $core.List<EventCategory> values = <EventCategory>[
    EVENT_CATEGORY_UNSPECIFIED,
    EVENT_CATEGORY_TURN,
    EVENT_CATEGORY_TOOL,
    EVENT_CATEGORY_ROUTINE,
    EVENT_CATEGORY_STATUS,
    EVENT_CATEGORY_ERROR,
  ];

  static final $core.List<EventCategory?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static EventCategory? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EventCategory._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
