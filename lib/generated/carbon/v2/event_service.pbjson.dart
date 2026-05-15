// This is a generated file - do not edit.
//
// Generated from carbon/v2/event_service.proto.

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

@$core.Deprecated('Use eventKindDescriptor instead')
const EventKind$json = {
  '1': 'EventKind',
  '2': [
    {'1': 'EVENT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'EVENT_KIND_TURN_STARTED', '2': 1},
    {'1': 'EVENT_KIND_TURN_COMPLETED', '2': 2},
    {'1': 'EVENT_KIND_MESSAGE_DELTA', '2': 3},
    {'1': 'EVENT_KIND_MESSAGE_FINALIZED', '2': 4},
    {'1': 'EVENT_KIND_TOOL_USE_START', '2': 5},
    {'1': 'EVENT_KIND_TOOL_RESULT', '2': 6},
    {'1': 'EVENT_KIND_TOOL_APPROVAL_REQUEST', '2': 7},
    {'1': 'EVENT_KIND_THREAD_STARTED', '2': 8},
    {'1': 'EVENT_KIND_THREAD_COMPLETED', '2': 9},
    {'1': 'EVENT_KIND_SESSION_ENDED', '2': 10},
    {'1': 'EVENT_KIND_SCHEDULE_CHANGED', '2': 11},
    {'1': 'EVENT_KIND_SUB_AGENT_SPAWNED', '2': 12},
    {'1': 'EVENT_KIND_SUB_AGENT_COMPLETED', '2': 13},
    {'1': 'EVENT_KIND_STEER_APPLIED', '2': 14},
    {'1': 'EVENT_KIND_STEER_FAILED', '2': 15},
    {'1': 'EVENT_KIND_ERROR', '2': 16},
  ],
};

/// Descriptor for `EventKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List eventKindDescriptor = $convert.base64Decode(
    'CglFdmVudEtpbmQSGgoWRVZFTlRfS0lORF9VTlNQRUNJRklFRBAAEhsKF0VWRU5UX0tJTkRfVF'
    'VSTl9TVEFSVEVEEAESHQoZRVZFTlRfS0lORF9UVVJOX0NPTVBMRVRFRBACEhwKGEVWRU5UX0tJ'
    'TkRfTUVTU0FHRV9ERUxUQRADEiAKHEVWRU5UX0tJTkRfTUVTU0FHRV9GSU5BTElaRUQQBBIdCh'
    'lFVkVOVF9LSU5EX1RPT0xfVVNFX1NUQVJUEAUSGgoWRVZFTlRfS0lORF9UT09MX1JFU1VMVBAG'
    'EiQKIEVWRU5UX0tJTkRfVE9PTF9BUFBST1ZBTF9SRVFVRVNUEAcSHQoZRVZFTlRfS0lORF9USF'
    'JFQURfU1RBUlRFRBAIEh8KG0VWRU5UX0tJTkRfVEhSRUFEX0NPTVBMRVRFRBAJEhwKGEVWRU5U'
    'X0tJTkRfU0VTU0lPTl9FTkRFRBAKEh8KG0VWRU5UX0tJTkRfU0NIRURVTEVfQ0hBTkdFRBALEi'
    'AKHEVWRU5UX0tJTkRfU1VCX0FHRU5UX1NQQVdORUQQDBIiCh5FVkVOVF9LSU5EX1NVQl9BR0VO'
    'VF9DT01QTEVURUQQDRIcChhFVkVOVF9LSU5EX1NURUVSX0FQUExJRUQQDhIbChdFVkVOVF9LSU'
    '5EX1NURUVSX0ZBSUxFRBAPEhQKEEVWRU5UX0tJTkRfRVJST1IQEA==');

@$core.Deprecated('Use assistantMessagePhaseDescriptor instead')
const AssistantMessagePhase$json = {
  '1': 'AssistantMessagePhase',
  '2': [
    {'1': 'ASSISTANT_MESSAGE_PHASE_UNSPECIFIED', '2': 0},
    {'1': 'ASSISTANT_MESSAGE_PHASE_COMMENTARY', '2': 1},
    {'1': 'ASSISTANT_MESSAGE_PHASE_FINAL_ANSWER', '2': 2},
  ],
};

/// Descriptor for `AssistantMessagePhase`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List assistantMessagePhaseDescriptor = $convert.base64Decode(
    'ChVBc3Npc3RhbnRNZXNzYWdlUGhhc2USJwojQVNTSVNUQU5UX01FU1NBR0VfUEhBU0VfVU5TUE'
    'VDSUZJRUQQABImCiJBU1NJU1RBTlRfTUVTU0FHRV9QSEFTRV9DT01NRU5UQVJZEAESKAokQVNT'
    'SVNUQU5UX01FU1NBR0VfUEhBU0VfRklOQUxfQU5TV0VSEAI=');

@$core.Deprecated('Use scheduleChangeDescriptor instead')
const ScheduleChange$json = {
  '1': 'ScheduleChange',
  '2': [
    {'1': 'SCHEDULE_CHANGE_UNSPECIFIED', '2': 0},
    {'1': 'SCHEDULE_CHANGE_CREATED', '2': 1},
    {'1': 'SCHEDULE_CHANGE_PAUSED', '2': 2},
    {'1': 'SCHEDULE_CHANGE_RESUMED', '2': 3},
    {'1': 'SCHEDULE_CHANGE_CANCELED', '2': 4},
    {'1': 'SCHEDULE_CHANGE_FIRED', '2': 5},
  ],
};

/// Descriptor for `ScheduleChange`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List scheduleChangeDescriptor = $convert.base64Decode(
    'Cg5TY2hlZHVsZUNoYW5nZRIfChtTQ0hFRFVMRV9DSEFOR0VfVU5TUEVDSUZJRUQQABIbChdTQ0'
    'hFRFVMRV9DSEFOR0VfQ1JFQVRFRBABEhoKFlNDSEVEVUxFX0NIQU5HRV9QQVVTRUQQAhIbChdT'
    'Q0hFRFVMRV9DSEFOR0VfUkVTVU1FRBADEhwKGFNDSEVEVUxFX0NIQU5HRV9DQU5DRUxFRBAEEh'
    'kKFVNDSEVEVUxFX0NIQU5HRV9GSVJFRBAF');

@$core.Deprecated('Use spawnModeDescriptor instead')
const SpawnMode$json = {
  '1': 'SpawnMode',
  '2': [
    {'1': 'SPAWN_MODE_UNSPECIFIED', '2': 0},
    {'1': 'SPAWN_MODE_SYNC', '2': 1},
    {'1': 'SPAWN_MODE_ASYNC', '2': 2},
    {'1': 'SPAWN_MODE_DETACHED', '2': 3},
  ],
};

/// Descriptor for `SpawnMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List spawnModeDescriptor = $convert.base64Decode(
    'CglTcGF3bk1vZGUSGgoWU1BBV05fTU9ERV9VTlNQRUNJRklFRBAAEhMKD1NQQVdOX01PREVfU1'
    'lOQxABEhQKEFNQQVdOX01PREVfQVNZTkMQAhIXChNTUEFXTl9NT0RFX0RFVEFDSEVEEAM=');

@$core.Deprecated('Use subscribeRequestDescriptor instead')
const SubscribeRequest$json = {
  '1': 'SubscribeRequest',
  '2': [
    {'1': 'session_ids', '3': 1, '4': 3, '5': 9, '10': 'sessionIds'},
    {
      '1': 'filter',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.EventFilter',
      '10': 'filter'
    },
    {'1': 'resume_from', '3': 3, '4': 1, '5': 9, '10': 'resumeFrom'},
  ],
};

/// Descriptor for `SubscribeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeRequestDescriptor = $convert.base64Decode(
    'ChBTdWJzY3JpYmVSZXF1ZXN0Eh8KC3Nlc3Npb25faWRzGAEgAygJUgpzZXNzaW9uSWRzEi4KBm'
    'ZpbHRlchgCIAEoCzIWLmNhcmJvbi52Mi5FdmVudEZpbHRlclIGZmlsdGVyEh8KC3Jlc3VtZV9m'
    'cm9tGAMgASgJUgpyZXN1bWVGcm9t');

@$core.Deprecated('Use eventFilterDescriptor instead')
const EventFilter$json = {
  '1': 'EventFilter',
  '2': [
    {
      '1': 'kinds',
      '3': 1,
      '4': 3,
      '5': 14,
      '6': '.carbon.v2.EventKind',
      '10': 'kinds'
    },
    {'1': 'thread_ids', '3': 2, '4': 3, '5': 9, '10': 'threadIds'},
    {'1': 'turn_ids', '3': 3, '4': 3, '5': 9, '10': 'turnIds'},
  ],
};

/// Descriptor for `EventFilter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventFilterDescriptor = $convert.base64Decode(
    'CgtFdmVudEZpbHRlchIqCgVraW5kcxgBIAMoDjIULmNhcmJvbi52Mi5FdmVudEtpbmRSBWtpbm'
    'RzEh0KCnRocmVhZF9pZHMYAiADKAlSCXRocmVhZElkcxIZCgh0dXJuX2lkcxgDIAMoCVIHdHVy'
    'bklkcw==');

@$core.Deprecated('Use eventDescriptor instead')
const Event$json = {
  '1': 'Event',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'event_id', '3': 2, '4': 1, '5': 9, '10': 'eventId'},
    {
      '1': 'body',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.EventBody',
      '10': 'body'
    },
  ],
};

/// Descriptor for `Event`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventDescriptor = $convert.base64Decode(
    'CgVFdmVudBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQSGQoIZXZlbnRfaWQYAiABKA'
    'lSB2V2ZW50SWQSKAoEYm9keRgDIAEoCzIULmNhcmJvbi52Mi5FdmVudEJvZHlSBGJvZHk=');

@$core.Deprecated('Use eventBodyDescriptor instead')
const EventBody$json = {
  '1': 'EventBody',
  '2': [
    {
      '1': 'turn_started',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.TurnStarted',
      '9': 0,
      '10': 'turnStarted'
    },
    {
      '1': 'turn_completed',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.TurnCompleted',
      '9': 0,
      '10': 'turnCompleted'
    },
    {
      '1': 'message_delta',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.MessageDelta',
      '9': 0,
      '10': 'messageDelta'
    },
    {
      '1': 'message_finalized',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.MessageFinalized',
      '9': 0,
      '10': 'messageFinalized'
    },
    {
      '1': 'tool_use_start',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.ToolUseStart',
      '9': 0,
      '10': 'toolUseStart'
    },
    {
      '1': 'tool_result',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.ToolResult',
      '9': 0,
      '10': 'toolResult'
    },
    {
      '1': 'tool_approval_request',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.ToolApprovalRequest',
      '9': 0,
      '10': 'toolApprovalRequest'
    },
    {
      '1': 'thread_started',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.ThreadStarted',
      '9': 0,
      '10': 'threadStarted'
    },
    {
      '1': 'thread_completed',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.ThreadCompleted',
      '9': 0,
      '10': 'threadCompleted'
    },
    {
      '1': 'session_ended',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.SessionEnded',
      '9': 0,
      '10': 'sessionEnded'
    },
    {
      '1': 'schedule_changed',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.ScheduleChanged',
      '9': 0,
      '10': 'scheduleChanged'
    },
    {
      '1': 'sub_agent_spawned',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.SubAgentSpawned',
      '9': 0,
      '10': 'subAgentSpawned'
    },
    {
      '1': 'sub_agent_completed',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.SubAgentCompleted',
      '9': 0,
      '10': 'subAgentCompleted'
    },
    {
      '1': 'steer_applied',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.SteerApplied',
      '9': 0,
      '10': 'steerApplied'
    },
    {
      '1': 'steer_failed',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.SteerFailed',
      '9': 0,
      '10': 'steerFailed'
    },
    {
      '1': 'error',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.Error',
      '9': 0,
      '10': 'error'
    },
  ],
  '8': [
    {'1': 'body'},
  ],
};

/// Descriptor for `EventBody`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventBodyDescriptor = $convert.base64Decode(
    'CglFdmVudEJvZHkSOwoMdHVybl9zdGFydGVkGAEgASgLMhYuY2FyYm9uLnYyLlR1cm5TdGFydG'
    'VkSABSC3R1cm5TdGFydGVkEkEKDnR1cm5fY29tcGxldGVkGAIgASgLMhguY2FyYm9uLnYyLlR1'
    'cm5Db21wbGV0ZWRIAFINdHVybkNvbXBsZXRlZBI+Cg1tZXNzYWdlX2RlbHRhGAMgASgLMhcuY2'
    'FyYm9uLnYyLk1lc3NhZ2VEZWx0YUgAUgxtZXNzYWdlRGVsdGESSgoRbWVzc2FnZV9maW5hbGl6'
    'ZWQYBCABKAsyGy5jYXJib24udjIuTWVzc2FnZUZpbmFsaXplZEgAUhBtZXNzYWdlRmluYWxpem'
    'VkEj8KDnRvb2xfdXNlX3N0YXJ0GAUgASgLMhcuY2FyYm9uLnYyLlRvb2xVc2VTdGFydEgAUgx0'
    'b29sVXNlU3RhcnQSOAoLdG9vbF9yZXN1bHQYBiABKAsyFS5jYXJib24udjIuVG9vbFJlc3VsdE'
    'gAUgp0b29sUmVzdWx0ElQKFXRvb2xfYXBwcm92YWxfcmVxdWVzdBgHIAEoCzIeLmNhcmJvbi52'
    'Mi5Ub29sQXBwcm92YWxSZXF1ZXN0SABSE3Rvb2xBcHByb3ZhbFJlcXVlc3QSQQoOdGhyZWFkX3'
    'N0YXJ0ZWQYCCABKAsyGC5jYXJib24udjIuVGhyZWFkU3RhcnRlZEgAUg10aHJlYWRTdGFydGVk'
    'EkcKEHRocmVhZF9jb21wbGV0ZWQYCSABKAsyGi5jYXJib24udjIuVGhyZWFkQ29tcGxldGVkSA'
    'BSD3RocmVhZENvbXBsZXRlZBI+Cg1zZXNzaW9uX2VuZGVkGAogASgLMhcuY2FyYm9uLnYyLlNl'
    'c3Npb25FbmRlZEgAUgxzZXNzaW9uRW5kZWQSRwoQc2NoZWR1bGVfY2hhbmdlZBgLIAEoCzIaLm'
    'NhcmJvbi52Mi5TY2hlZHVsZUNoYW5nZWRIAFIPc2NoZWR1bGVDaGFuZ2VkEkgKEXN1Yl9hZ2Vu'
    'dF9zcGF3bmVkGAwgASgLMhouY2FyYm9uLnYyLlN1YkFnZW50U3Bhd25lZEgAUg9zdWJBZ2VudF'
    'NwYXduZWQSTgoTc3ViX2FnZW50X2NvbXBsZXRlZBgNIAEoCzIcLmNhcmJvbi52Mi5TdWJBZ2Vu'
    'dENvbXBsZXRlZEgAUhFzdWJBZ2VudENvbXBsZXRlZBI+Cg1zdGVlcl9hcHBsaWVkGA4gASgLMh'
    'cuY2FyYm9uLnYyLlN0ZWVyQXBwbGllZEgAUgxzdGVlckFwcGxpZWQSOwoMc3RlZXJfZmFpbGVk'
    'GA8gASgLMhYuY2FyYm9uLnYyLlN0ZWVyRmFpbGVkSABSC3N0ZWVyRmFpbGVkEigKBWVycm9yGB'
    'AgASgLMhAuY2FyYm9uLnYyLkVycm9ySABSBWVycm9yQgYKBGJvZHk=');

@$core.Deprecated('Use turnStartedDescriptor instead')
const TurnStarted$json = {
  '1': 'TurnStarted',
  '2': [
    {'1': 'turn_id', '3': 1, '4': 1, '5': 9, '10': 'turnId'},
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'source', '3': 3, '4': 1, '5': 9, '10': 'source'},
    {'1': 'client_request_id', '3': 4, '4': 1, '5': 9, '10': 'clientRequestId'},
    {'1': 'prompt', '3': 5, '4': 1, '5': 9, '10': 'prompt'},
  ],
};

/// Descriptor for `TurnStarted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List turnStartedDescriptor = $convert.base64Decode(
    'CgtUdXJuU3RhcnRlZBIXCgd0dXJuX2lkGAEgASgJUgZ0dXJuSWQSGwoJdGhyZWFkX2lkGAIgAS'
    'gJUgh0aHJlYWRJZBIWCgZzb3VyY2UYAyABKAlSBnNvdXJjZRIqChFjbGllbnRfcmVxdWVzdF9p'
    'ZBgEIAEoCVIPY2xpZW50UmVxdWVzdElkEhYKBnByb21wdBgFIAEoCVIGcHJvbXB0');

@$core.Deprecated('Use turnCompletedDescriptor instead')
const TurnCompleted$json = {
  '1': 'TurnCompleted',
  '2': [
    {'1': 'turn_id', '3': 1, '4': 1, '5': 9, '10': 'turnId'},
    {
      '1': 'usage',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.Usage',
      '10': 'usage'
    },
  ],
};

/// Descriptor for `TurnCompleted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List turnCompletedDescriptor = $convert.base64Decode(
    'Cg1UdXJuQ29tcGxldGVkEhcKB3R1cm5faWQYASABKAlSBnR1cm5JZBImCgV1c2FnZRgCIAEoCz'
    'IQLmNhcmJvbi52Mi5Vc2FnZVIFdXNhZ2U=');

@$core.Deprecated('Use messageDeltaDescriptor instead')
const MessageDelta$json = {
  '1': 'MessageDelta',
  '2': [
    {'1': 'turn_id', '3': 1, '4': 1, '5': 9, '10': 'turnId'},
    {'1': 'item_id', '3': 2, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'content', '3': 3, '4': 1, '5': 9, '10': 'content'},
  ],
};

/// Descriptor for `MessageDelta`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDeltaDescriptor = $convert.base64Decode(
    'CgxNZXNzYWdlRGVsdGESFwoHdHVybl9pZBgBIAEoCVIGdHVybklkEhcKB2l0ZW1faWQYAiABKA'
    'lSBml0ZW1JZBIYCgdjb250ZW50GAMgASgJUgdjb250ZW50');

@$core.Deprecated('Use messageFinalizedDescriptor instead')
const MessageFinalized$json = {
  '1': 'MessageFinalized',
  '2': [
    {'1': 'turn_id', '3': 1, '4': 1, '5': 9, '10': 'turnId'},
    {'1': 'item_id', '3': 2, '4': 1, '5': 9, '10': 'itemId'},
    {
      '1': 'phase',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.carbon.v2.AssistantMessagePhase',
      '10': 'phase'
    },
  ],
};

/// Descriptor for `MessageFinalized`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageFinalizedDescriptor = $convert.base64Decode(
    'ChBNZXNzYWdlRmluYWxpemVkEhcKB3R1cm5faWQYASABKAlSBnR1cm5JZBIXCgdpdGVtX2lkGA'
    'IgASgJUgZpdGVtSWQSNgoFcGhhc2UYAyABKA4yIC5jYXJib24udjIuQXNzaXN0YW50TWVzc2Fn'
    'ZVBoYXNlUgVwaGFzZQ==');

@$core.Deprecated('Use toolUseStartDescriptor instead')
const ToolUseStart$json = {
  '1': 'ToolUseStart',
  '2': [
    {'1': 'turn_id', '3': 1, '4': 1, '5': 9, '10': 'turnId'},
    {'1': 'tool_call_id', '3': 2, '4': 1, '5': 9, '10': 'toolCallId'},
    {'1': 'tool_name', '3': 3, '4': 1, '5': 9, '10': 'toolName'},
    {'1': 'arguments_json', '3': 4, '4': 1, '5': 9, '10': 'argumentsJson'},
  ],
};

/// Descriptor for `ToolUseStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolUseStartDescriptor = $convert.base64Decode(
    'CgxUb29sVXNlU3RhcnQSFwoHdHVybl9pZBgBIAEoCVIGdHVybklkEiAKDHRvb2xfY2FsbF9pZB'
    'gCIAEoCVIKdG9vbENhbGxJZBIbCgl0b29sX25hbWUYAyABKAlSCHRvb2xOYW1lEiUKDmFyZ3Vt'
    'ZW50c19qc29uGAQgASgJUg1hcmd1bWVudHNKc29u');

@$core.Deprecated('Use toolResultDescriptor instead')
const ToolResult$json = {
  '1': 'ToolResult',
  '2': [
    {'1': 'turn_id', '3': 1, '4': 1, '5': 9, '10': 'turnId'},
    {'1': 'tool_call_id', '3': 2, '4': 1, '5': 9, '10': 'toolCallId'},
    {'1': 'output', '3': 3, '4': 1, '5': 9, '10': 'output'},
    {'1': 'is_error', '3': 4, '4': 1, '5': 8, '10': 'isError'},
    {'1': 'metadata_json', '3': 5, '4': 1, '5': 9, '10': 'metadataJson'},
    {'1': 'cursor_json', '3': 6, '4': 1, '5': 9, '10': 'cursorJson'},
  ],
};

/// Descriptor for `ToolResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolResultDescriptor = $convert.base64Decode(
    'CgpUb29sUmVzdWx0EhcKB3R1cm5faWQYASABKAlSBnR1cm5JZBIgCgx0b29sX2NhbGxfaWQYAi'
    'ABKAlSCnRvb2xDYWxsSWQSFgoGb3V0cHV0GAMgASgJUgZvdXRwdXQSGQoIaXNfZXJyb3IYBCAB'
    'KAhSB2lzRXJyb3ISIwoNbWV0YWRhdGFfanNvbhgFIAEoCVIMbWV0YWRhdGFKc29uEh8KC2N1cn'
    'Nvcl9qc29uGAYgASgJUgpjdXJzb3JKc29u');

@$core.Deprecated('Use toolApprovalRequestDescriptor instead')
const ToolApprovalRequest$json = {
  '1': 'ToolApprovalRequest',
  '2': [
    {'1': 'approval_id', '3': 1, '4': 1, '5': 9, '10': 'approvalId'},
    {'1': 'turn_id', '3': 2, '4': 1, '5': 9, '10': 'turnId'},
    {'1': 'tool_call_id', '3': 3, '4': 1, '5': 9, '10': 'toolCallId'},
    {'1': 'tool_name', '3': 4, '4': 1, '5': 9, '10': 'toolName'},
    {'1': 'arguments_json', '3': 5, '4': 1, '5': 9, '10': 'argumentsJson'},
    {'1': 'reason', '3': 6, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'timeout_secs', '3': 7, '4': 1, '5': 13, '10': 'timeoutSecs'},
  ],
};

/// Descriptor for `ToolApprovalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolApprovalRequestDescriptor = $convert.base64Decode(
    'ChNUb29sQXBwcm92YWxSZXF1ZXN0Eh8KC2FwcHJvdmFsX2lkGAEgASgJUgphcHByb3ZhbElkEh'
    'cKB3R1cm5faWQYAiABKAlSBnR1cm5JZBIgCgx0b29sX2NhbGxfaWQYAyABKAlSCnRvb2xDYWxs'
    'SWQSGwoJdG9vbF9uYW1lGAQgASgJUgh0b29sTmFtZRIlCg5hcmd1bWVudHNfanNvbhgFIAEoCV'
    'INYXJndW1lbnRzSnNvbhIWCgZyZWFzb24YBiABKAlSBnJlYXNvbhIhCgx0aW1lb3V0X3NlY3MY'
    'ByABKA1SC3RpbWVvdXRTZWNz');

@$core.Deprecated('Use threadStartedDescriptor instead')
const ThreadStarted$json = {
  '1': 'ThreadStarted',
  '2': [
    {'1': 'thread_id', '3': 1, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'source', '3': 2, '4': 1, '5': 9, '10': 'source'},
  ],
};

/// Descriptor for `ThreadStarted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadStartedDescriptor = $convert.base64Decode(
    'Cg1UaHJlYWRTdGFydGVkEhsKCXRocmVhZF9pZBgBIAEoCVIIdGhyZWFkSWQSFgoGc291cmNlGA'
    'IgASgJUgZzb3VyY2U=');

@$core.Deprecated('Use threadCompletedDescriptor instead')
const ThreadCompleted$json = {
  '1': 'ThreadCompleted',
  '2': [
    {'1': 'thread_id', '3': 1, '4': 1, '5': 9, '10': 'threadId'},
  ],
};

/// Descriptor for `ThreadCompleted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadCompletedDescriptor = $convert.base64Decode(
    'Cg9UaHJlYWRDb21wbGV0ZWQSGwoJdGhyZWFkX2lkGAEgASgJUgh0aHJlYWRJZA==');

@$core.Deprecated('Use sessionEndedDescriptor instead')
const SessionEnded$json = {
  '1': 'SessionEnded',
  '2': [
    {'1': 'reason', '3': 1, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `SessionEnded`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionEndedDescriptor = $convert
    .base64Decode('CgxTZXNzaW9uRW5kZWQSFgoGcmVhc29uGAEgASgJUgZyZWFzb24=');

@$core.Deprecated('Use scheduleChangedDescriptor instead')
const ScheduleChanged$json = {
  '1': 'ScheduleChanged',
  '2': [
    {'1': 'schedule_id', '3': 1, '4': 1, '5': 9, '10': 'scheduleId'},
    {
      '1': 'change',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.carbon.v2.ScheduleChange',
      '10': 'change'
    },
  ],
};

/// Descriptor for `ScheduleChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleChangedDescriptor = $convert.base64Decode(
    'Cg9TY2hlZHVsZUNoYW5nZWQSHwoLc2NoZWR1bGVfaWQYASABKAlSCnNjaGVkdWxlSWQSMQoGY2'
    'hhbmdlGAIgASgOMhkuY2FyYm9uLnYyLlNjaGVkdWxlQ2hhbmdlUgZjaGFuZ2U=');

@$core.Deprecated('Use subAgentSpawnedDescriptor instead')
const SubAgentSpawned$json = {
  '1': 'SubAgentSpawned',
  '2': [
    {'1': 'child_session_id', '3': 1, '4': 1, '5': 9, '10': 'childSessionId'},
    {'1': 'product', '3': 2, '4': 1, '5': 9, '10': 'product'},
    {'1': 'prompt', '3': 3, '4': 1, '5': 9, '10': 'prompt'},
    {
      '1': 'mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.carbon.v2.SpawnMode',
      '10': 'mode'
    },
  ],
};

/// Descriptor for `SubAgentSpawned`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subAgentSpawnedDescriptor = $convert.base64Decode(
    'Cg9TdWJBZ2VudFNwYXduZWQSKAoQY2hpbGRfc2Vzc2lvbl9pZBgBIAEoCVIOY2hpbGRTZXNzaW'
    '9uSWQSGAoHcHJvZHVjdBgCIAEoCVIHcHJvZHVjdBIWCgZwcm9tcHQYAyABKAlSBnByb21wdBIo'
    'CgRtb2RlGAQgASgOMhQuY2FyYm9uLnYyLlNwYXduTW9kZVIEbW9kZQ==');

@$core.Deprecated('Use subAgentCompletedDescriptor instead')
const SubAgentCompleted$json = {
  '1': 'SubAgentCompleted',
  '2': [
    {'1': 'child_session_id', '3': 1, '4': 1, '5': 9, '10': 'childSessionId'},
    {'1': 'result', '3': 2, '4': 1, '5': 9, '10': 'result'},
    {'1': 'is_error', '3': 3, '4': 1, '5': 8, '10': 'isError'},
    {
      '1': 'usage',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.Usage',
      '10': 'usage'
    },
  ],
};

/// Descriptor for `SubAgentCompleted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subAgentCompletedDescriptor = $convert.base64Decode(
    'ChFTdWJBZ2VudENvbXBsZXRlZBIoChBjaGlsZF9zZXNzaW9uX2lkGAEgASgJUg5jaGlsZFNlc3'
    'Npb25JZBIWCgZyZXN1bHQYAiABKAlSBnJlc3VsdBIZCghpc19lcnJvchgDIAEoCFIHaXNFcnJv'
    'chImCgV1c2FnZRgEIAEoCzIQLmNhcmJvbi52Mi5Vc2FnZVIFdXNhZ2U=');

@$core.Deprecated('Use steerAppliedDescriptor instead')
const SteerApplied$json = {
  '1': 'SteerApplied',
  '2': [
    {'1': 'turn_id', '3': 1, '4': 1, '5': 9, '10': 'turnId'},
    {'1': 'client_request_id', '3': 2, '4': 1, '5': 9, '10': 'clientRequestId'},
  ],
};

/// Descriptor for `SteerApplied`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List steerAppliedDescriptor = $convert.base64Decode(
    'CgxTdGVlckFwcGxpZWQSFwoHdHVybl9pZBgBIAEoCVIGdHVybklkEioKEWNsaWVudF9yZXF1ZX'
    'N0X2lkGAIgASgJUg9jbGllbnRSZXF1ZXN0SWQ=');

@$core.Deprecated('Use steerFailedDescriptor instead')
const SteerFailed$json = {
  '1': 'SteerFailed',
  '2': [
    {'1': 'turn_id', '3': 1, '4': 1, '5': 9, '10': 'turnId'},
    {'1': 'client_request_id', '3': 2, '4': 1, '5': 9, '10': 'clientRequestId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `SteerFailed`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List steerFailedDescriptor = $convert.base64Decode(
    'CgtTdGVlckZhaWxlZBIXCgd0dXJuX2lkGAEgASgJUgZ0dXJuSWQSKgoRY2xpZW50X3JlcXVlc3'
    'RfaWQYAiABKAlSD2NsaWVudFJlcXVlc3RJZBIWCgZyZWFzb24YAyABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use errorDescriptor instead')
const Error$json = {
  '1': 'Error',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'fatal', '3': 3, '4': 1, '5': 8, '10': 'fatal'},
    {'1': 'turn_id', '3': 4, '4': 1, '5': 9, '10': 'turnId'},
  ],
};

/// Descriptor for `Error`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorDescriptor = $convert.base64Decode(
    'CgVFcnJvchISCgRjb2RlGAEgASgJUgRjb2RlEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2USFA'
    'oFZmF0YWwYAyABKAhSBWZhdGFsEhcKB3R1cm5faWQYBCABKAlSBnR1cm5JZA==');
