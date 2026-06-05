// This is a generated file - do not edit.
//
// Generated from argot/v1/monitor.proto.

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

@$core.Deprecated('Use eventCategoryDescriptor instead')
const EventCategory$json = {
  '1': 'EventCategory',
  '2': [
    {'1': 'EVENT_CATEGORY_UNSPECIFIED', '2': 0},
    {'1': 'EVENT_CATEGORY_TURN', '2': 1},
    {'1': 'EVENT_CATEGORY_TOOL', '2': 2},
    {'1': 'EVENT_CATEGORY_ROUTINE', '2': 3},
    {'1': 'EVENT_CATEGORY_STATUS', '2': 4},
    {'1': 'EVENT_CATEGORY_ERROR', '2': 5},
  ],
};

/// Descriptor for `EventCategory`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List eventCategoryDescriptor = $convert.base64Decode(
    'Cg1FdmVudENhdGVnb3J5Eh4KGkVWRU5UX0NBVEVHT1JZX1VOU1BFQ0lGSUVEEAASFwoTRVZFTl'
    'RfQ0FURUdPUllfVFVSThABEhcKE0VWRU5UX0NBVEVHT1JZX1RPT0wQAhIaChZFVkVOVF9DQVRF'
    'R09SWV9ST1VUSU5FEAMSGQoVRVZFTlRfQ0FURUdPUllfU1RBVFVTEAQSGAoURVZFTlRfQ0FURU'
    'dPUllfRVJST1IQBQ==');

@$core.Deprecated('Use getStatusRequestDescriptor instead')
const GetStatusRequest$json = {
  '1': 'GetStatusRequest',
};

/// Descriptor for `GetStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStatusRequestDescriptor =
    $convert.base64Decode('ChBHZXRTdGF0dXNSZXF1ZXN0');

@$core.Deprecated('Use getStatusResponseDescriptor instead')
const GetStatusResponse$json = {
  '1': 'GetStatusResponse',
  '2': [
    {'1': 'ready', '3': 1, '4': 1, '5': 8, '10': 'ready'},
    {'1': 'provider', '3': 2, '4': 1, '5': 9, '10': 'provider'},
    {'1': 'model', '3': 3, '4': 1, '5': 9, '10': 'model'},
    {'1': 'version', '3': 4, '4': 1, '5': 9, '10': 'version'},
    {'1': 'uptime_ms', '3': 5, '4': 1, '5': 3, '10': 'uptimeMs'},
    {
      '1': 'scheduler_running',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'schedulerRunning'
    },
  ],
};

/// Descriptor for `GetStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStatusResponseDescriptor = $convert.base64Decode(
    'ChFHZXRTdGF0dXNSZXNwb25zZRIUCgVyZWFkeRgBIAEoCFIFcmVhZHkSGgoIcHJvdmlkZXIYAi'
    'ABKAlSCHByb3ZpZGVyEhQKBW1vZGVsGAMgASgJUgVtb2RlbBIYCgd2ZXJzaW9uGAQgASgJUgd2'
    'ZXJzaW9uEhsKCXVwdGltZV9tcxgFIAEoA1IIdXB0aW1lTXMSKwoRc2NoZWR1bGVyX3J1bm5pbm'
    'cYBiABKAhSEHNjaGVkdWxlclJ1bm5pbmc=');

@$core.Deprecated('Use watchRequestDescriptor instead')
const WatchRequest$json = {
  '1': 'WatchRequest',
  '2': [
    {
      '1': 'conversation_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'conversationId',
      '17': true
    },
    {
      '1': 'categories',
      '3': 2,
      '4': 3,
      '5': 14,
      '6': '.argot.v1.EventCategory',
      '10': 'categories'
    },
  ],
  '8': [
    {'1': '_conversation_id'},
  ],
};

/// Descriptor for `WatchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchRequestDescriptor = $convert.base64Decode(
    'CgxXYXRjaFJlcXVlc3QSLAoPY29udmVyc2F0aW9uX2lkGAEgASgJSABSDmNvbnZlcnNhdGlvbk'
    'lkiAEBEjcKCmNhdGVnb3JpZXMYAiADKA4yFy5hcmdvdC52MS5FdmVudENhdGVnb3J5UgpjYXRl'
    'Z29yaWVzQhIKEF9jb252ZXJzYXRpb25faWQ=');

@$core.Deprecated('Use systemEventDescriptor instead')
const SystemEvent$json = {
  '1': 'SystemEvent',
  '2': [
    {'1': 'seq', '3': 1, '4': 1, '5': 3, '10': 'seq'},
    {'1': 'occurred_at_ms', '3': 2, '4': 1, '5': 3, '10': 'occurredAtMs'},
    {'1': 'conversation_id', '3': 3, '4': 1, '5': 9, '10': 'conversationId'},
    {'1': 'origin', '3': 4, '4': 1, '5': 9, '10': 'origin'},
    {
      '1': 'category',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.argot.v1.EventCategory',
      '10': 'category'
    },
    {
      '1': 'turn_started',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.TurnStarted',
      '9': 0,
      '10': 'turnStarted'
    },
    {
      '1': 'chat_event',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.ChatEvent',
      '9': 0,
      '10': 'chatEvent'
    },
    {
      '1': 'routine_fired',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.RoutineFired',
      '9': 0,
      '10': 'routineFired'
    },
    {
      '1': 'status',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.StatusChanged',
      '9': 0,
      '10': 'status'
    },
    {
      '1': 'gap',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.Gap',
      '9': 0,
      '10': 'gap'
    },
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `SystemEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List systemEventDescriptor = $convert.base64Decode(
    'CgtTeXN0ZW1FdmVudBIQCgNzZXEYASABKANSA3NlcRIkCg5vY2N1cnJlZF9hdF9tcxgCIAEoA1'
    'IMb2NjdXJyZWRBdE1zEicKD2NvbnZlcnNhdGlvbl9pZBgDIAEoCVIOY29udmVyc2F0aW9uSWQS'
    'FgoGb3JpZ2luGAQgASgJUgZvcmlnaW4SMwoIY2F0ZWdvcnkYBSABKA4yFy5hcmdvdC52MS5Fdm'
    'VudENhdGVnb3J5UghjYXRlZ29yeRI6Cgx0dXJuX3N0YXJ0ZWQYCiABKAsyFS5hcmdvdC52MS5U'
    'dXJuU3RhcnRlZEgAUgt0dXJuU3RhcnRlZBI0CgpjaGF0X2V2ZW50GAsgASgLMhMuYXJnb3Qudj'
    'EuQ2hhdEV2ZW50SABSCWNoYXRFdmVudBI9Cg1yb3V0aW5lX2ZpcmVkGAwgASgLMhYuYXJnb3Qu'
    'djEuUm91dGluZUZpcmVkSABSDHJvdXRpbmVGaXJlZBIxCgZzdGF0dXMYDSABKAsyFy5hcmdvdC'
    '52MS5TdGF0dXNDaGFuZ2VkSABSBnN0YXR1cxIhCgNnYXAYDiABKAsyDS5hcmdvdC52MS5HYXBI'
    'AFIDZ2FwQgcKBWV2ZW50');

@$core.Deprecated('Use turnStartedDescriptor instead')
const TurnStarted$json = {
  '1': 'TurnStarted',
  '2': [
    {'1': 'conversation_id', '3': 1, '4': 1, '5': 9, '10': 'conversationId'},
    {'1': 'ephemeral', '3': 2, '4': 1, '5': 8, '10': 'ephemeral'},
  ],
};

/// Descriptor for `TurnStarted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List turnStartedDescriptor = $convert.base64Decode(
    'CgtUdXJuU3RhcnRlZBInCg9jb252ZXJzYXRpb25faWQYASABKAlSDmNvbnZlcnNhdGlvbklkEh'
    'wKCWVwaGVtZXJhbBgCIAEoCFIJZXBoZW1lcmFs');

@$core.Deprecated('Use routineFiredDescriptor instead')
const RoutineFired$json = {
  '1': 'RoutineFired',
  '2': [
    {'1': 'routine_id', '3': 1, '4': 1, '5': 9, '10': 'routineId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'action', '3': 3, '4': 1, '5': 9, '10': 'action'},
    {'1': 'ok', '3': 4, '4': 1, '5': 8, '10': 'ok'},
    {'1': 'detail', '3': 5, '4': 1, '5': 9, '10': 'detail'},
  ],
};

/// Descriptor for `RoutineFired`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List routineFiredDescriptor = $convert.base64Decode(
    'CgxSb3V0aW5lRmlyZWQSHQoKcm91dGluZV9pZBgBIAEoCVIJcm91dGluZUlkEhIKBG5hbWUYAi'
    'ABKAlSBG5hbWUSFgoGYWN0aW9uGAMgASgJUgZhY3Rpb24SDgoCb2sYBCABKAhSAm9rEhYKBmRl'
    'dGFpbBgFIAEoCVIGZGV0YWls');

@$core.Deprecated('Use statusChangedDescriptor instead')
const StatusChanged$json = {
  '1': 'StatusChanged',
  '2': [
    {'1': 'ready', '3': 1, '4': 1, '5': 8, '10': 'ready'},
    {
      '1': 'scheduler_running',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'schedulerRunning'
    },
    {'1': 'provider', '3': 3, '4': 1, '5': 9, '10': 'provider'},
    {'1': 'model', '3': 4, '4': 1, '5': 9, '10': 'model'},
  ],
};

/// Descriptor for `StatusChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statusChangedDescriptor = $convert.base64Decode(
    'Cg1TdGF0dXNDaGFuZ2VkEhQKBXJlYWR5GAEgASgIUgVyZWFkeRIrChFzY2hlZHVsZXJfcnVubm'
    'luZxgCIAEoCFIQc2NoZWR1bGVyUnVubmluZxIaCghwcm92aWRlchgDIAEoCVIIcHJvdmlkZXIS'
    'FAoFbW9kZWwYBCABKAlSBW1vZGVs');

@$core.Deprecated('Use gapDescriptor instead')
const Gap$json = {
  '1': 'Gap',
  '2': [
    {'1': 'missed', '3': 1, '4': 1, '5': 4, '10': 'missed'},
  ],
};

/// Descriptor for `Gap`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gapDescriptor =
    $convert.base64Decode('CgNHYXASFgoGbWlzc2VkGAEgASgEUgZtaXNzZWQ=');
