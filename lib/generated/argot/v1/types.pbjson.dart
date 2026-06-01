// This is a generated file - do not edit.
//
// Generated from argot/v1/types.proto.

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

@$core.Deprecated('Use chatEventDescriptor instead')
const ChatEvent$json = {
  '1': 'ChatEvent',
  '2': [
    {
      '1': 'opened',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.SessionOpened',
      '9': 0,
      '10': 'opened'
    },
    {
      '1': 'delta',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.MessageDelta',
      '9': 0,
      '10': 'delta'
    },
    {
      '1': 'tool_call',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.ToolCall',
      '9': 0,
      '10': 'toolCall'
    },
    {
      '1': 'tool_result',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.ToolResult',
      '9': 0,
      '10': 'toolResult'
    },
    {
      '1': 'done',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.TurnDone',
      '9': 0,
      '10': 'done'
    },
    {
      '1': 'error',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.TurnError',
      '9': 0,
      '10': 'error'
    },
    {
      '1': 'terminated',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.TurnTerminated',
      '9': 0,
      '10': 'terminated'
    },
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `ChatEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatEventDescriptor = $convert.base64Decode(
    'CglDaGF0RXZlbnQSMQoGb3BlbmVkGAEgASgLMhcuYXJnb3QudjEuU2Vzc2lvbk9wZW5lZEgAUg'
    'ZvcGVuZWQSLgoFZGVsdGEYAiABKAsyFi5hcmdvdC52MS5NZXNzYWdlRGVsdGFIAFIFZGVsdGES'
    'MQoJdG9vbF9jYWxsGAMgASgLMhIuYXJnb3QudjEuVG9vbENhbGxIAFIIdG9vbENhbGwSNwoLdG'
    '9vbF9yZXN1bHQYBCABKAsyFC5hcmdvdC52MS5Ub29sUmVzdWx0SABSCnRvb2xSZXN1bHQSKAoE'
    'ZG9uZRgFIAEoCzISLmFyZ290LnYxLlR1cm5Eb25lSABSBGRvbmUSKwoFZXJyb3IYBiABKAsyEy'
    '5hcmdvdC52MS5UdXJuRXJyb3JIAFIFZXJyb3ISOgoKdGVybWluYXRlZBgHIAEoCzIYLmFyZ290'
    'LnYxLlR1cm5UZXJtaW5hdGVkSABSCnRlcm1pbmF0ZWRCBwoFZXZlbnQ=');

@$core.Deprecated('Use sessionOpenedDescriptor instead')
const SessionOpened$json = {
  '1': 'SessionOpened',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `SessionOpened`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionOpenedDescriptor = $convert.base64Decode(
    'Cg1TZXNzaW9uT3BlbmVkEh0KCnNlc3Npb25faWQYASABKAlSCXNlc3Npb25JZA==');

@$core.Deprecated('Use messageDeltaDescriptor instead')
const MessageDelta$json = {
  '1': 'MessageDelta',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
  ],
};

/// Descriptor for `MessageDelta`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDeltaDescriptor =
    $convert.base64Decode('CgxNZXNzYWdlRGVsdGESEgoEdGV4dBgBIAEoCVIEdGV4dA==');

@$core.Deprecated('Use toolCallDescriptor instead')
const ToolCall$json = {
  '1': 'ToolCall',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'arguments_json', '3': 3, '4': 1, '5': 9, '10': 'argumentsJson'},
  ],
};

/// Descriptor for `ToolCall`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolCallDescriptor = $convert.base64Decode(
    'CghUb29sQ2FsbBIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIlCg5hcmd1bW'
    'VudHNfanNvbhgDIAEoCVINYXJndW1lbnRzSnNvbg==');

@$core.Deprecated('Use toolResultDescriptor instead')
const ToolResult$json = {
  '1': 'ToolResult',
  '2': [
    {'1': 'call_id', '3': 1, '4': 1, '5': 9, '10': 'callId'},
    {'1': 'output_json', '3': 2, '4': 1, '5': 9, '10': 'outputJson'},
    {'1': 'is_error', '3': 3, '4': 1, '5': 8, '10': 'isError'},
  ],
};

/// Descriptor for `ToolResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolResultDescriptor = $convert.base64Decode(
    'CgpUb29sUmVzdWx0EhcKB2NhbGxfaWQYASABKAlSBmNhbGxJZBIfCgtvdXRwdXRfanNvbhgCIA'
    'EoCVIKb3V0cHV0SnNvbhIZCghpc19lcnJvchgDIAEoCFIHaXNFcnJvcg==');

@$core.Deprecated('Use turnDoneDescriptor instead')
const TurnDone$json = {
  '1': 'TurnDone',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'turns', '3': 2, '4': 1, '5': 13, '10': 'turns'},
    {'1': 'tool_calls', '3': 3, '4': 1, '5': 13, '10': 'toolCalls'},
  ],
};

/// Descriptor for `TurnDone`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List turnDoneDescriptor = $convert.base64Decode(
    'CghUdXJuRG9uZRISCgR0ZXh0GAEgASgJUgR0ZXh0EhQKBXR1cm5zGAIgASgNUgV0dXJucxIdCg'
    'p0b29sX2NhbGxzGAMgASgNUgl0b29sQ2FsbHM=');

@$core.Deprecated('Use turnErrorDescriptor instead')
const TurnError$json = {
  '1': 'TurnError',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `TurnError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List turnErrorDescriptor = $convert
    .base64Decode('CglUdXJuRXJyb3ISGAoHbWVzc2FnZRgBIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use turnTerminatedDescriptor instead')
const TurnTerminated$json = {
  '1': 'TurnTerminated',
  '2': [
    {'1': 'reason', '3': 1, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'turns', '3': 2, '4': 1, '5': 13, '10': 'turns'},
    {'1': 'tool_calls', '3': 3, '4': 1, '5': 13, '10': 'toolCalls'},
  ],
};

/// Descriptor for `TurnTerminated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List turnTerminatedDescriptor = $convert.base64Decode(
    'Cg5UdXJuVGVybWluYXRlZBIWCgZyZWFzb24YASABKAlSBnJlYXNvbhIUCgV0dXJucxgCIAEoDV'
    'IFdHVybnMSHQoKdG9vbF9jYWxscxgDIAEoDVIJdG9vbENhbGxz');
