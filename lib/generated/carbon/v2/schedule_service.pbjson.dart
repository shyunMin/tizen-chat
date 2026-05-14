// This is a generated file - do not edit.
//
// Generated from carbon/v2/schedule_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use scheduleTypeDescriptor instead')
const ScheduleType$json = {
  '1': 'ScheduleType',
  '2': [
    {'1': 'SCHEDULE_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'SCHEDULE_TYPE_INTERVAL', '2': 1},
    {'1': 'SCHEDULE_TYPE_CRON', '2': 2},
    {'1': 'SCHEDULE_TYPE_ONCE', '2': 3},
  ],
};

/// Descriptor for `ScheduleType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List scheduleTypeDescriptor = $convert.base64Decode(
    'CgxTY2hlZHVsZVR5cGUSHQoZU0NIRURVTEVfVFlQRV9VTlNQRUNJRklFRBAAEhoKFlNDSEVEVU'
    'xFX1RZUEVfSU5URVJWQUwQARIWChJTQ0hFRFVMRV9UWVBFX0NST04QAhIWChJTQ0hFRFVMRV9U'
    'WVBFX09OQ0UQAw==');

@$core.Deprecated('Use createScheduleRequestDescriptor instead')
const CreateScheduleRequest$json = {
  '1': 'CreateScheduleRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.carbon.v2.ScheduleType',
      '10': 'type'
    },
    {'1': 'value', '3': 3, '4': 1, '5': 9, '10': 'value'},
    {'1': 'timezone', '3': 4, '4': 1, '5': 9, '10': 'timezone'},
    {'1': 'prompt', '3': 5, '4': 1, '5': 9, '10': 'prompt'},
  ],
};

/// Descriptor for `CreateScheduleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createScheduleRequestDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVTY2hlZHVsZVJlcXVlc3QSHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklkEi'
    'sKBHR5cGUYAiABKA4yFy5jYXJib24udjIuU2NoZWR1bGVUeXBlUgR0eXBlEhQKBXZhbHVlGAMg'
    'ASgJUgV2YWx1ZRIaCgh0aW1lem9uZRgEIAEoCVIIdGltZXpvbmUSFgoGcHJvbXB0GAUgASgJUg'
    'Zwcm9tcHQ=');

@$core.Deprecated('Use listSchedulesRequestDescriptor instead')
const ListSchedulesRequest$json = {
  '1': 'ListSchedulesRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `ListSchedulesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSchedulesRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0U2NoZWR1bGVzUmVxdWVzdBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQ=');

@$core.Deprecated('Use listSchedulesResponseDescriptor instead')
const ListSchedulesResponse$json = {
  '1': 'ListSchedulesResponse',
  '2': [
    {
      '1': 'schedules',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.carbon.v2.Schedule',
      '10': 'schedules'
    },
  ],
};

/// Descriptor for `ListSchedulesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSchedulesResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0U2NoZWR1bGVzUmVzcG9uc2USMQoJc2NoZWR1bGVzGAEgAygLMhMuY2FyYm9uLnYyLl'
    'NjaGVkdWxlUglzY2hlZHVsZXM=');

@$core.Deprecated('Use pauseScheduleRequestDescriptor instead')
const PauseScheduleRequest$json = {
  '1': 'PauseScheduleRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `PauseScheduleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pauseScheduleRequestDescriptor = $convert
    .base64Decode('ChRQYXVzZVNjaGVkdWxlUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');

@$core.Deprecated('Use resumeScheduleRequestDescriptor instead')
const ResumeScheduleRequest$json = {
  '1': 'ResumeScheduleRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `ResumeScheduleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resumeScheduleRequestDescriptor = $convert
    .base64Decode('ChVSZXN1bWVTY2hlZHVsZVJlcXVlc3QSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use cancelScheduleRequestDescriptor instead')
const CancelScheduleRequest$json = {
  '1': 'CancelScheduleRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `CancelScheduleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelScheduleRequestDescriptor = $convert
    .base64Decode('ChVDYW5jZWxTY2hlZHVsZVJlcXVlc3QSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use cancelScheduleResponseDescriptor instead')
const CancelScheduleResponse$json = {
  '1': 'CancelScheduleResponse',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `CancelScheduleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelScheduleResponseDescriptor = $convert
    .base64Decode('ChZDYW5jZWxTY2hlZHVsZVJlc3BvbnNlEg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use scheduleDescriptor instead')
const Schedule$json = {
  '1': 'Schedule',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {
      '1': 'type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.carbon.v2.ScheduleType',
      '10': 'type'
    },
    {'1': 'value', '3': 4, '4': 1, '5': 9, '10': 'value'},
    {'1': 'timezone', '3': 5, '4': 1, '5': 9, '10': 'timezone'},
    {'1': 'prompt', '3': 6, '4': 1, '5': 9, '10': 'prompt'},
    {'1': 'next_run_at_ms', '3': 7, '4': 1, '5': 3, '10': 'nextRunAtMs'},
    {'1': 'paused', '3': 8, '4': 1, '5': 8, '10': 'paused'},
  ],
};

/// Descriptor for `Schedule`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleDescriptor = $convert.base64Decode(
    'CghTY2hlZHVsZRIOCgJpZBgBIAEoCVICaWQSHQoKc2Vzc2lvbl9pZBgCIAEoCVIJc2Vzc2lvbk'
    'lkEisKBHR5cGUYAyABKA4yFy5jYXJib24udjIuU2NoZWR1bGVUeXBlUgR0eXBlEhQKBXZhbHVl'
    'GAQgASgJUgV2YWx1ZRIaCgh0aW1lem9uZRgFIAEoCVIIdGltZXpvbmUSFgoGcHJvbXB0GAYgAS'
    'gJUgZwcm9tcHQSIwoObmV4dF9ydW5fYXRfbXMYByABKANSC25leHRSdW5BdE1zEhYKBnBhdXNl'
    'ZBgIIAEoCFIGcGF1c2Vk');
