// This is a generated file - do not edit.
//
// Generated from argot/v1/notify.proto.

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

@$core.Deprecated('Use severityDescriptor instead')
const Severity$json = {
  '1': 'Severity',
  '2': [
    {'1': 'SEVERITY_UNSPECIFIED', '2': 0},
    {'1': 'SEVERITY_INFO', '2': 1},
    {'1': 'SEVERITY_WARN', '2': 2},
    {'1': 'SEVERITY_ERROR', '2': 3},
  ],
};

/// Descriptor for `Severity`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List severityDescriptor = $convert.base64Decode(
    'CghTZXZlcml0eRIYChRTRVZFUklUWV9VTlNQRUNJRklFRBAAEhEKDVNFVkVSSVRZX0lORk8QAR'
    'IRCg1TRVZFUklUWV9XQVJOEAISEgoOU0VWRVJJVFlfRVJST1IQAw==');

@$core.Deprecated('Use subscribeRequestDescriptor instead')
const SubscribeRequest$json = {
  '1': 'SubscribeRequest',
  '2': [
    {'1': 'cursor', '3': 1, '4': 1, '5': 4, '10': 'cursor'},
    {'1': 'subscriber_id', '3': 2, '4': 1, '5': 9, '10': 'subscriberId'},
  ],
};

/// Descriptor for `SubscribeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeRequestDescriptor = $convert.base64Decode(
    'ChBTdWJzY3JpYmVSZXF1ZXN0EhYKBmN1cnNvchgBIAEoBFIGY3Vyc29yEiMKDXN1YnNjcmliZX'
    'JfaWQYAiABKAlSDHN1YnNjcmliZXJJZA==');

@$core.Deprecated('Use notificationDescriptor instead')
const Notification$json = {
  '1': 'Notification',
  '2': [
    {'1': 'seq', '3': 1, '4': 1, '5': 4, '10': 'seq'},
    {'1': 'notification_id', '3': 2, '4': 1, '5': 9, '10': 'notificationId'},
    {'1': 'conversation_id', '3': 3, '4': 1, '5': 9, '10': 'conversationId'},
    {'1': 'deeplink', '3': 4, '4': 1, '5': 9, '10': 'deeplink'},
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    {'1': 'summary', '3': 6, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'routine_id', '3': 7, '4': 1, '5': 9, '10': 'routineId'},
    {
      '1': 'severity',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.argot.v1.Severity',
      '10': 'severity'
    },
    {'1': 'created_at_ms', '3': 9, '4': 1, '5': 3, '10': 'createdAtMs'},
  ],
};

/// Descriptor for `Notification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationDescriptor = $convert.base64Decode(
    'CgxOb3RpZmljYXRpb24SEAoDc2VxGAEgASgEUgNzZXESJwoPbm90aWZpY2F0aW9uX2lkGAIgAS'
    'gJUg5ub3RpZmljYXRpb25JZBInCg9jb252ZXJzYXRpb25faWQYAyABKAlSDmNvbnZlcnNhdGlv'
    'bklkEhoKCGRlZXBsaW5rGAQgASgJUghkZWVwbGluaxIUCgV0aXRsZRgFIAEoCVIFdGl0bGUSGA'
    'oHc3VtbWFyeRgGIAEoCVIHc3VtbWFyeRIdCgpyb3V0aW5lX2lkGAcgASgJUglyb3V0aW5lSWQS'
    'LgoIc2V2ZXJpdHkYCCABKA4yEi5hcmdvdC52MS5TZXZlcml0eVIIc2V2ZXJpdHkSIgoNY3JlYX'
    'RlZF9hdF9tcxgJIAEoA1ILY3JlYXRlZEF0TXM=');

@$core.Deprecated('Use ackRequestDescriptor instead')
const AckRequest$json = {
  '1': 'AckRequest',
  '2': [
    {'1': 'subscriber_id', '3': 1, '4': 1, '5': 9, '10': 'subscriberId'},
    {'1': 'seq', '3': 2, '4': 1, '5': 4, '10': 'seq'},
  ],
};

/// Descriptor for `AckRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ackRequestDescriptor = $convert.base64Decode(
    'CgpBY2tSZXF1ZXN0EiMKDXN1YnNjcmliZXJfaWQYASABKAlSDHN1YnNjcmliZXJJZBIQCgNzZX'
    'EYAiABKARSA3NlcQ==');

@$core.Deprecated('Use ackResponseDescriptor instead')
const AckResponse$json = {
  '1': 'AckResponse',
};

/// Descriptor for `AckResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ackResponseDescriptor =
    $convert.base64Decode('CgtBY2tSZXNwb25zZQ==');
