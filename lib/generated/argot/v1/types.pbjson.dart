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

@$core.Deprecated('Use stopReasonDescriptor instead')
const StopReason$json = {
  '1': 'StopReason',
  '2': [
    {'1': 'STOP_REASON_UNSPECIFIED', '2': 0},
    {'1': 'STOP_REASON_ITER_CAP', '2': 1},
    {'1': 'STOP_REASON_TOKEN_CAP', '2': 2},
    {'1': 'STOP_REASON_TIME_CAP', '2': 3},
    {'1': 'STOP_REASON_CANCELLED', '2': 4},
  ],
};

/// Descriptor for `StopReason`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List stopReasonDescriptor = $convert.base64Decode(
    'CgpTdG9wUmVhc29uEhsKF1NUT1BfUkVBU09OX1VOU1BFQ0lGSUVEEAASGAoUU1RPUF9SRUFTT0'
    '5fSVRFUl9DQVAQARIZChVTVE9QX1JFQVNPTl9UT0tFTl9DQVAQAhIYChRTVE9QX1JFQVNPTl9U'
    'SU1FX0NBUBADEhkKFVNUT1BfUkVBU09OX0NBTkNFTExFRBAE');

@$core.Deprecated('Use phaseDescriptor instead')
const Phase$json = {
  '1': 'Phase',
  '2': [
    {'1': 'PHASE_UNSPECIFIED', '2': 0},
    {'1': 'PHASE_THINKING', '2': 1},
    {'1': 'PHASE_MEMORY_RETRIEVING', '2': 2},
    {'1': 'PHASE_STREAMING', '2': 3},
    {'1': 'PHASE_TOOL_EXECUTING', '2': 4},
    {'1': 'PHASE_DONE', '2': 5},
    {'1': 'PHASE_SUMMARY', '2': 6},
  ],
};

/// Descriptor for `Phase`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List phaseDescriptor = $convert.base64Decode(
    'CgVQaGFzZRIVChFQSEFTRV9VTlNQRUNJRklFRBAAEhIKDlBIQVNFX1RISU5LSU5HEAESGwoXUE'
    'hBU0VfTUVNT1JZX1JFVFJJRVZJTkcQAhITCg9QSEFTRV9TVFJFQU1JTkcQAxIYChRQSEFTRV9U'
    'T09MX0VYRUNVVElORxAEEg4KClBIQVNFX0RPTkUQBRIRCg1QSEFTRV9TVU1NQVJZEAY=');

@$core.Deprecated('Use progressSourceDescriptor instead')
const ProgressSource$json = {
  '1': 'ProgressSource',
  '2': [
    {'1': 'PROGRESS_SOURCE_UNSPECIFIED', '2': 0},
    {'1': 'PROGRESS_SOURCE_AGENT_STATUS', '2': 1},
    {'1': 'PROGRESS_SOURCE_AGENT_PROGRESS_SUMMARY', '2': 2},
  ],
};

/// Descriptor for `ProgressSource`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List progressSourceDescriptor = $convert.base64Decode(
    'Cg5Qcm9ncmVzc1NvdXJjZRIfChtQUk9HUkVTU19TT1VSQ0VfVU5TUEVDSUZJRUQQABIgChxQUk'
    '9HUkVTU19TT1VSQ0VfQUdFTlRfU1RBVFVTEAESKgomUFJPR1JFU1NfU09VUkNFX0FHRU5UX1BS'
    'T0dSRVNTX1NVTU1BUlkQAg==');

@$core.Deprecated('Use roleDescriptor instead')
const Role$json = {
  '1': 'Role',
  '2': [
    {'1': 'ROLE_UNSPECIFIED', '2': 0},
    {'1': 'ROLE_USER', '2': 1},
    {'1': 'ROLE_ASSISTANT', '2': 2},
    {'1': 'ROLE_SYSTEM', '2': 3},
    {'1': 'ROLE_TOOL', '2': 4},
  ],
};

/// Descriptor for `Role`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roleDescriptor = $convert.base64Decode(
    'CgRSb2xlEhQKEFJPTEVfVU5TUEVDSUZJRUQQABINCglST0xFX1VTRVIQARISCg5ST0xFX0FTU0'
    'lTVEFOVBACEg8KC1JPTEVfU1lTVEVNEAMSDQoJUk9MRV9UT09MEAQ=');

@$core.Deprecated('Use chatEventDescriptor instead')
const ChatEvent$json = {
  '1': 'ChatEvent',
  '2': [
    {
      '1': 'opened',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.Opened',
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
      '1': 'completed',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.Completed',
      '9': 0,
      '10': 'completed'
    },
    {
      '1': 'failed',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.Failed',
      '9': 0,
      '10': 'failed'
    },
    {
      '1': 'stopped',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.Stopped',
      '9': 0,
      '10': 'stopped'
    },
    {
      '1': 'progress',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.AgentProgress',
      '9': 0,
      '10': 'progress'
    },
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `ChatEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatEventDescriptor = $convert.base64Decode(
    'CglDaGF0RXZlbnQSKgoGb3BlbmVkGAEgASgLMhAuYXJnb3QudjEuT3BlbmVkSABSBm9wZW5lZB'
    'IuCgVkZWx0YRgCIAEoCzIWLmFyZ290LnYxLk1lc3NhZ2VEZWx0YUgAUgVkZWx0YRIxCgl0b29s'
    'X2NhbGwYAyABKAsyEi5hcmdvdC52MS5Ub29sQ2FsbEgAUgh0b29sQ2FsbBI3Cgt0b29sX3Jlc3'
    'VsdBgEIAEoCzIULmFyZ290LnYxLlRvb2xSZXN1bHRIAFIKdG9vbFJlc3VsdBIzCgljb21wbGV0'
    'ZWQYBSABKAsyEy5hcmdvdC52MS5Db21wbGV0ZWRIAFIJY29tcGxldGVkEioKBmZhaWxlZBgGIA'
    'EoCzIQLmFyZ290LnYxLkZhaWxlZEgAUgZmYWlsZWQSLQoHc3RvcHBlZBgHIAEoCzIRLmFyZ290'
    'LnYxLlN0b3BwZWRIAFIHc3RvcHBlZBI1Cghwcm9ncmVzcxgIIAEoCzIXLmFyZ290LnYxLkFnZW'
    '50UHJvZ3Jlc3NIAFIIcHJvZ3Jlc3NCBwoFZXZlbnQ=');

@$core.Deprecated('Use openedDescriptor instead')
const Opened$json = {
  '1': 'Opened',
  '2': [
    {'1': 'conversation_id', '3': 1, '4': 1, '5': 9, '10': 'conversationId'},
    {'1': 'ephemeral', '3': 2, '4': 1, '5': 8, '10': 'ephemeral'},
  ],
};

/// Descriptor for `Opened`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openedDescriptor = $convert.base64Decode(
    'CgZPcGVuZWQSJwoPY29udmVyc2F0aW9uX2lkGAEgASgJUg5jb252ZXJzYXRpb25JZBIcCgllcG'
    'hlbWVyYWwYAiABKAhSCWVwaGVtZXJhbA==');

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

@$core.Deprecated('Use completedDescriptor instead')
const Completed$json = {
  '1': 'Completed',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'turns', '3': 2, '4': 1, '5': 13, '10': 'turns'},
    {'1': 'tool_calls', '3': 3, '4': 1, '5': 13, '10': 'toolCalls'},
  ],
};

/// Descriptor for `Completed`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completedDescriptor = $convert.base64Decode(
    'CglDb21wbGV0ZWQSEgoEdGV4dBgBIAEoCVIEdGV4dBIUCgV0dXJucxgCIAEoDVIFdHVybnMSHQ'
    'oKdG9vbF9jYWxscxgDIAEoDVIJdG9vbENhbGxz');

@$core.Deprecated('Use failedDescriptor instead')
const Failed$json = {
  '1': 'Failed',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `Failed`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List failedDescriptor =
    $convert.base64Decode('CgZGYWlsZWQSGAoHbWVzc2FnZRgBIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use stoppedDescriptor instead')
const Stopped$json = {
  '1': 'Stopped',
  '2': [
    {
      '1': 'reason',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.argot.v1.StopReason',
      '10': 'reason'
    },
    {'1': 'turns', '3': 2, '4': 1, '5': 13, '10': 'turns'},
    {'1': 'tool_calls', '3': 3, '4': 1, '5': 13, '10': 'toolCalls'},
  ],
};

/// Descriptor for `Stopped`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stoppedDescriptor = $convert.base64Decode(
    'CgdTdG9wcGVkEiwKBnJlYXNvbhgBIAEoDjIULmFyZ290LnYxLlN0b3BSZWFzb25SBnJlYXNvbh'
    'IUCgV0dXJucxgCIAEoDVIFdHVybnMSHQoKdG9vbF9jYWxscxgDIAEoDVIJdG9vbENhbGxz');

@$core.Deprecated('Use agentProgressDescriptor instead')
const AgentProgress$json = {
  '1': 'AgentProgress',
  '2': [
    {
      '1': 'phase',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.argot.v1.Phase',
      '10': 'phase'
    },
    {'1': 'status_id', '3': 2, '4': 1, '5': 9, '10': 'statusId'},
    {'1': 'tool_name', '3': 3, '4': 1, '5': 9, '10': 'toolName'},
    {'1': 'message', '3': 4, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'source',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.argot.v1.ProgressSource',
      '10': 'source'
    },
    {'1': 'agent_path', '3': 6, '4': 3, '5': 9, '10': 'agentPath'},
  ],
};

/// Descriptor for `AgentProgress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentProgressDescriptor = $convert.base64Decode(
    'Cg1BZ2VudFByb2dyZXNzEiUKBXBoYXNlGAEgASgOMg8uYXJnb3QudjEuUGhhc2VSBXBoYXNlEh'
    'sKCXN0YXR1c19pZBgCIAEoCVIIc3RhdHVzSWQSGwoJdG9vbF9uYW1lGAMgASgJUgh0b29sTmFt'
    'ZRIYCgdtZXNzYWdlGAQgASgJUgdtZXNzYWdlEjAKBnNvdXJjZRgFIAEoDjIYLmFyZ290LnYxLl'
    'Byb2dyZXNzU291cmNlUgZzb3VyY2USHQoKYWdlbnRfcGF0aBgGIAMoCVIJYWdlbnRQYXRo');

@$core.Deprecated('Use messagePartDescriptor instead')
const MessagePart$json = {
  '1': 'MessagePart',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'text'},
    {
      '1': 'tool_call',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.ToolCall',
      '9': 0,
      '10': 'toolCall'
    },
    {
      '1': 'tool_result',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.ToolResult',
      '9': 0,
      '10': 'toolResult'
    },
    {'1': 'reasoning', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'reasoning'},
  ],
  '8': [
    {'1': 'part'},
  ],
};

/// Descriptor for `MessagePart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messagePartDescriptor = $convert.base64Decode(
    'CgtNZXNzYWdlUGFydBIUCgR0ZXh0GAEgASgJSABSBHRleHQSMQoJdG9vbF9jYWxsGAIgASgLMh'
    'IuYXJnb3QudjEuVG9vbENhbGxIAFIIdG9vbENhbGwSNwoLdG9vbF9yZXN1bHQYAyABKAsyFC5h'
    'cmdvdC52MS5Ub29sUmVzdWx0SABSCnRvb2xSZXN1bHQSHgoJcmVhc29uaW5nGAQgASgJSABSCX'
    'JlYXNvbmluZ0IGCgRwYXJ0');

@$core.Deprecated('Use chatMessageDescriptor instead')
const ChatMessage$json = {
  '1': 'ChatMessage',
  '2': [
    {'1': 'role', '3': 1, '4': 1, '5': 14, '6': '.argot.v1.Role', '10': 'role'},
    {
      '1': 'parts',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.argot.v1.MessagePart',
      '10': 'parts'
    },
    {'1': 'timestamp_ms', '3': 3, '4': 1, '5': 3, '10': 'timestampMs'},
  ],
};

/// Descriptor for `ChatMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageDescriptor = $convert.base64Decode(
    'CgtDaGF0TWVzc2FnZRIiCgRyb2xlGAEgASgOMg4uYXJnb3QudjEuUm9sZVIEcm9sZRIrCgVwYX'
    'J0cxgCIAMoCzIVLmFyZ290LnYxLk1lc3NhZ2VQYXJ0UgVwYXJ0cxIhCgx0aW1lc3RhbXBfbXMY'
    'AyABKANSC3RpbWVzdGFtcE1z');
