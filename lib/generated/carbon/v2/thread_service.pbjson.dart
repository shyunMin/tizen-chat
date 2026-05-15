// This is a generated file - do not edit.
//
// Generated from carbon/v2/thread_service.proto.

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

@$core.Deprecated('Use listThreadsRequestDescriptor instead')
const ListThreadsRequest$json = {
  '1': 'ListThreadsRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `ListThreadsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listThreadsRequestDescriptor =
    $convert.base64Decode(
        'ChJMaXN0VGhyZWFkc1JlcXVlc3QSHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklk');

@$core.Deprecated('Use listThreadsResponseDescriptor instead')
const ListThreadsResponse$json = {
  '1': 'ListThreadsResponse',
  '2': [
    {
      '1': 'threads',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.carbon.v2.Thread',
      '10': 'threads'
    },
  ],
};

/// Descriptor for `ListThreadsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listThreadsResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0VGhyZWFkc1Jlc3BvbnNlEisKB3RocmVhZHMYASADKAsyES5jYXJib24udjIuVGhyZW'
    'FkUgd0aHJlYWRz');

@$core.Deprecated('Use getThreadRequestDescriptor instead')
const GetThreadRequest$json = {
  '1': 'GetThreadRequest',
  '2': [
    {'1': 'thread_id', '3': 1, '4': 1, '5': 9, '10': 'threadId'},
  ],
};

/// Descriptor for `GetThreadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getThreadRequestDescriptor = $convert.base64Decode(
    'ChBHZXRUaHJlYWRSZXF1ZXN0EhsKCXRocmVhZF9pZBgBIAEoCVIIdGhyZWFkSWQ=');

@$core.Deprecated('Use renameThreadRequestDescriptor instead')
const RenameThreadRequest$json = {
  '1': 'RenameThreadRequest',
  '2': [
    {'1': 'thread_id', '3': 1, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `RenameThreadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List renameThreadRequestDescriptor = $convert.base64Decode(
    'ChNSZW5hbWVUaHJlYWRSZXF1ZXN0EhsKCXRocmVhZF9pZBgBIAEoCVIIdGhyZWFkSWQSEgoEbm'
    'FtZRgCIAEoCVIEbmFtZQ==');

@$core.Deprecated('Use listTurnsRequestDescriptor instead')
const ListTurnsRequest$json = {
  '1': 'ListTurnsRequest',
  '2': [
    {'1': 'thread_id', '3': 1, '4': 1, '5': 9, '10': 'threadId'},
  ],
};

/// Descriptor for `ListTurnsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTurnsRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0VHVybnNSZXF1ZXN0EhsKCXRocmVhZF9pZBgBIAEoCVIIdGhyZWFkSWQ=');

@$core.Deprecated('Use listTurnsResponseDescriptor instead')
const ListTurnsResponse$json = {
  '1': 'ListTurnsResponse',
  '2': [
    {
      '1': 'turns',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.carbon.v2.Turn',
      '10': 'turns'
    },
  ],
};

/// Descriptor for `ListTurnsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTurnsResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0VHVybnNSZXNwb25zZRIlCgV0dXJucxgBIAMoCzIPLmNhcmJvbi52Mi5UdXJuUgV0dX'
    'Jucw==');

@$core.Deprecated('Use getTurnRequestDescriptor instead')
const GetTurnRequest$json = {
  '1': 'GetTurnRequest',
  '2': [
    {'1': 'turn_id', '3': 1, '4': 1, '5': 9, '10': 'turnId'},
  ],
};

/// Descriptor for `GetTurnRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTurnRequestDescriptor = $convert
    .base64Decode('Cg5HZXRUdXJuUmVxdWVzdBIXCgd0dXJuX2lkGAEgASgJUgZ0dXJuSWQ=');

@$core.Deprecated('Use threadDescriptor instead')
const Thread$json = {
  '1': 'Thread',
  '2': [
    {'1': 'thread_id', '3': 1, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'open', '3': 4, '4': 1, '5': 8, '10': 'open'},
  ],
};

/// Descriptor for `Thread`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadDescriptor = $convert.base64Decode(
    'CgZUaHJlYWQSGwoJdGhyZWFkX2lkGAEgASgJUgh0aHJlYWRJZBIdCgpzZXNzaW9uX2lkGAIgAS'
    'gJUglzZXNzaW9uSWQSEgoEbmFtZRgDIAEoCVIEbmFtZRISCgRvcGVuGAQgASgIUgRvcGVu');

@$core.Deprecated('Use turnDescriptor instead')
const Turn$json = {
  '1': 'Turn',
  '2': [
    {'1': 'turn_id', '3': 1, '4': 1, '5': 9, '10': 'turnId'},
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
  ],
};

/// Descriptor for `Turn`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List turnDescriptor = $convert.base64Decode(
    'CgRUdXJuEhcKB3R1cm5faWQYASABKAlSBnR1cm5JZBIbCgl0aHJlYWRfaWQYAiABKAlSCHRocm'
    'VhZElk');
