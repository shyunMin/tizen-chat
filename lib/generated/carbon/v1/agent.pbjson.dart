//
//  Generated code. Do not modify.
//  source: carbon/v1/agent.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use ingressIntentDescriptor instead')
const IngressIntent$json = {
  '1': 'IngressIntent',
  '2': [
    {'1': 'INGRESS_INTENT_UNSPECIFIED', '2': 0},
    {'1': 'INGRESS_INTENT_RUN_TURN', '2': 1},
    {'1': 'INGRESS_INTENT_OBSERVE', '2': 2},
    {'1': 'INGRESS_INTENT_STATE_UPDATE', '2': 3},
  ],
};

/// Descriptor for `IngressIntent`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List ingressIntentDescriptor = $convert.base64Decode(
    'Cg1JbmdyZXNzSW50ZW50Eh4KGklOR1JFU1NfSU5URU5UX1VOU1BFQ0lGSUVEEAASGwoXSU5HUk'
    'VTU19JTlRFTlRfUlVOX1RVUk4QARIaChZJTkdSRVNTX0lOVEVOVF9PQlNFUlZFEAISHwobSU5H'
    'UkVTU19JTlRFTlRfU1RBVEVfVVBEQVRFEAM=');

@$core.Deprecated('Use clientMessageDescriptor instead')
const ClientMessage$json = {
  '1': 'ClientMessage',
  '2': [
    {'1': 'create_session', '3': 1, '4': 1, '5': 11, '6': '.carbon.v1.CreateSessionRequest', '9': 0, '10': 'createSession'},
    {'1': 'user_message', '3': 2, '4': 1, '5': 11, '6': '.carbon.v1.UserMessage', '9': 0, '10': 'userMessage'},
    {'1': 'tool_approval', '3': 3, '4': 1, '5': 11, '6': '.carbon.v1.ToolApproval', '9': 0, '10': 'toolApproval'},
    {'1': 'cancel_session', '3': 4, '4': 1, '5': 11, '6': '.carbon.v1.CancelSessionRequest', '9': 0, '10': 'cancelSession'},
    {'1': 'set_schedule', '3': 5, '4': 1, '5': 11, '6': '.carbon.v1.SetScheduleRequest', '9': 0, '10': 'setSchedule'},
    {'1': 'spawn_sub_agent', '3': 6, '4': 1, '5': 11, '6': '.carbon.v1.SpawnSubAgentRequest', '9': 0, '10': 'spawnSubAgent'},
    {'1': 'ingress_input', '3': 7, '4': 1, '5': 11, '6': '.carbon.v1.IngressInput', '9': 0, '10': 'ingressInput'},
  ],
  '8': [
    {'1': 'message'},
  ],
};

/// Descriptor for `ClientMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientMessageDescriptor = $convert.base64Decode(
    'Cg1DbGllbnRNZXNzYWdlEkgKDmNyZWF0ZV9zZXNzaW9uGAEgASgLMh8uY2FyYm9uLnYxLkNyZW'
    'F0ZVNlc3Npb25SZXF1ZXN0SABSDWNyZWF0ZVNlc3Npb24SOwoMdXNlcl9tZXNzYWdlGAIgASgL'
    'MhYuY2FyYm9uLnYxLlVzZXJNZXNzYWdlSABSC3VzZXJNZXNzYWdlEj4KDXRvb2xfYXBwcm92YW'
    'wYAyABKAsyFy5jYXJib24udjEuVG9vbEFwcHJvdmFsSABSDHRvb2xBcHByb3ZhbBJICg5jYW5j'
    'ZWxfc2Vzc2lvbhgEIAEoCzIfLmNhcmJvbi52MS5DYW5jZWxTZXNzaW9uUmVxdWVzdEgAUg1jYW'
    '5jZWxTZXNzaW9uEkIKDHNldF9zY2hlZHVsZRgFIAEoCzIdLmNhcmJvbi52MS5TZXRTY2hlZHVs'
    'ZVJlcXVlc3RIAFILc2V0U2NoZWR1bGUSSQoPc3Bhd25fc3ViX2FnZW50GAYgASgLMh8uY2FyYm'
    '9uLnYxLlNwYXduU3ViQWdlbnRSZXF1ZXN0SABSDXNwYXduU3ViQWdlbnQSPgoNaW5ncmVzc19p'
    'bnB1dBgHIAEoCzIXLmNhcmJvbi52MS5JbmdyZXNzSW5wdXRIAFIMaW5ncmVzc0lucHV0QgkKB2'
    '1lc3NhZ2U=');

@$core.Deprecated('Use createSessionRequestDescriptor instead')
const CreateSessionRequest$json = {
  '1': 'CreateSessionRequest',
  '2': [
    {'1': 'product', '3': 1, '4': 1, '5': 9, '10': 'product'},
    {'1': 'config', '3': 2, '4': 3, '5': 11, '6': '.carbon.v1.CreateSessionRequest.ConfigEntry', '10': 'config'},
  ],
  '3': [CreateSessionRequest_ConfigEntry$json],
};

@$core.Deprecated('Use createSessionRequestDescriptor instead')
const CreateSessionRequest_ConfigEntry$json = {
  '1': 'ConfigEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `CreateSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createSessionRequestDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVTZXNzaW9uUmVxdWVzdBIYCgdwcm9kdWN0GAEgASgJUgdwcm9kdWN0EkMKBmNvbm'
    'ZpZxgCIAMoCzIrLmNhcmJvbi52MS5DcmVhdGVTZXNzaW9uUmVxdWVzdC5Db25maWdFbnRyeVIG'
    'Y29uZmlnGjkKC0NvbmZpZ0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUg'
    'V2YWx1ZToCOAE=');

@$core.Deprecated('Use userMessageDescriptor instead')
const UserMessage$json = {
  '1': 'UserMessage',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'content', '3': 2, '4': 1, '5': 9, '10': 'content'},
  ],
};

/// Descriptor for `UserMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userMessageDescriptor = $convert.base64Decode(
    'CgtVc2VyTWVzc2FnZRIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQSGAoHY29udGVudB'
    'gCIAEoCVIHY29udGVudA==');

@$core.Deprecated('Use mediaBlobDescriptor instead')
const MediaBlob$json = {
  '1': 'MediaBlob',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
    {'1': 'media_type', '3': 2, '4': 1, '5': 9, '10': 'mediaType'},
  ],
};

/// Descriptor for `MediaBlob`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaBlobDescriptor = $convert.base64Decode(
    'CglNZWRpYUJsb2ISEgoEZGF0YRgBIAEoDFIEZGF0YRIdCgptZWRpYV90eXBlGAIgASgJUgltZW'
    'RpYVR5cGU=');

@$core.Deprecated('Use eventPayloadDescriptor instead')
const EventPayload$json = {
  '1': 'EventPayload',
  '2': [
    {'1': 'event_type', '3': 1, '4': 1, '5': 9, '10': 'eventType'},
    {'1': 'payload', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Value', '10': 'payload'},
  ],
};

/// Descriptor for `EventPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventPayloadDescriptor = $convert.base64Decode(
    'CgxFdmVudFBheWxvYWQSHQoKZXZlbnRfdHlwZRgBIAEoCVIJZXZlbnRUeXBlEjAKB3BheWxvYW'
    'QYAiABKAsyFi5nb29nbGUucHJvdG9idWYuVmFsdWVSB3BheWxvYWQ=');

@$core.Deprecated('Use ingressInputDescriptor instead')
const IngressInput$json = {
  '1': 'IngressInput',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'intent', '3': 2, '4': 1, '5': 14, '6': '.carbon.v1.IngressIntent', '10': 'intent'},
    {'1': 'source', '3': 3, '4': 1, '5': 9, '10': 'source'},
    {'1': 'target_agent', '3': 4, '4': 1, '5': 9, '10': 'targetAgent'},
    {'1': 'metadata', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'metadata'},
    {'1': 'text', '3': 10, '4': 1, '5': 9, '9': 0, '10': 'text'},
    {'1': 'image', '3': 11, '4': 1, '5': 11, '6': '.carbon.v1.MediaBlob', '9': 0, '10': 'image'},
    {'1': 'audio', '3': 12, '4': 1, '5': 11, '6': '.carbon.v1.MediaBlob', '9': 0, '10': 'audio'},
    {'1': 'json', '3': 13, '4': 1, '5': 11, '6': '.google.protobuf.Value', '9': 0, '10': 'json'},
    {'1': 'event', '3': 14, '4': 1, '5': 11, '6': '.carbon.v1.EventPayload', '9': 0, '10': 'event'},
  ],
  '8': [
    {'1': 'content'},
  ],
};

/// Descriptor for `IngressInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ingressInputDescriptor = $convert.base64Decode(
    'CgxJbmdyZXNzSW5wdXQSHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklkEjAKBmludGVudB'
    'gCIAEoDjIYLmNhcmJvbi52MS5JbmdyZXNzSW50ZW50UgZpbnRlbnQSFgoGc291cmNlGAMgASgJ'
    'UgZzb3VyY2USIQoMdGFyZ2V0X2FnZW50GAQgASgJUgt0YXJnZXRBZ2VudBIzCghtZXRhZGF0YR'
    'gFIAEoCzIXLmdvb2dsZS5wcm90b2J1Zi5TdHJ1Y3RSCG1ldGFkYXRhEhQKBHRleHQYCiABKAlI'
    'AFIEdGV4dBIsCgVpbWFnZRgLIAEoCzIULmNhcmJvbi52MS5NZWRpYUJsb2JIAFIFaW1hZ2USLA'
    'oFYXVkaW8YDCABKAsyFC5jYXJib24udjEuTWVkaWFCbG9iSABSBWF1ZGlvEiwKBGpzb24YDSAB'
    'KAsyFi5nb29nbGUucHJvdG9idWYuVmFsdWVIAFIEanNvbhIvCgVldmVudBgOIAEoCzIXLmNhcm'
    'Jvbi52MS5FdmVudFBheWxvYWRIAFIFZXZlbnRCCQoHY29udGVudA==');

@$core.Deprecated('Use toolApprovalDescriptor instead')
const ToolApproval$json = {
  '1': 'ToolApproval',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'tool_call_id', '3': 2, '4': 1, '5': 9, '10': 'toolCallId'},
    {'1': 'approved', '3': 3, '4': 1, '5': 8, '10': 'approved'},
  ],
};

/// Descriptor for `ToolApproval`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolApprovalDescriptor = $convert.base64Decode(
    'CgxUb29sQXBwcm92YWwSHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklkEiAKDHRvb2xfY2'
    'FsbF9pZBgCIAEoCVIKdG9vbENhbGxJZBIaCghhcHByb3ZlZBgDIAEoCFIIYXBwcm92ZWQ=');

@$core.Deprecated('Use cancelSessionRequestDescriptor instead')
const CancelSessionRequest$json = {
  '1': 'CancelSessionRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `CancelSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelSessionRequestDescriptor = $convert.base64Decode(
    'ChRDYW5jZWxTZXNzaW9uUmVxdWVzdBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQ=');

@$core.Deprecated('Use setScheduleRequestDescriptor instead')
const SetScheduleRequest$json = {
  '1': 'SetScheduleRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'schedule', '3': 2, '4': 1, '5': 9, '10': 'schedule'},
    {'1': 'prompt', '3': 3, '4': 1, '5': 9, '10': 'prompt'},
  ],
};

/// Descriptor for `SetScheduleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setScheduleRequestDescriptor = $convert.base64Decode(
    'ChJTZXRTY2hlZHVsZVJlcXVlc3QSHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklkEhoKCH'
    'NjaGVkdWxlGAIgASgJUghzY2hlZHVsZRIWCgZwcm9tcHQYAyABKAlSBnByb21wdA==');

@$core.Deprecated('Use serverEventDescriptor instead')
const ServerEvent$json = {
  '1': 'ServerEvent',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'session_created', '3': 2, '4': 1, '5': 11, '6': '.carbon.v1.SessionCreated', '9': 0, '10': 'sessionCreated'},
    {'1': 'text_delta', '3': 3, '4': 1, '5': 11, '6': '.carbon.v1.TextDelta', '9': 0, '10': 'textDelta'},
    {'1': 'tool_use_start', '3': 4, '4': 1, '5': 11, '6': '.carbon.v1.ToolUseStart', '9': 0, '10': 'toolUseStart'},
    {'1': 'tool_result', '3': 5, '4': 1, '5': 11, '6': '.carbon.v1.ToolResult', '9': 0, '10': 'toolResult'},
    {'1': 'turn_complete', '3': 6, '4': 1, '5': 11, '6': '.carbon.v1.TurnComplete', '9': 0, '10': 'turnComplete'},
    {'1': 'error', '3': 7, '4': 1, '5': 11, '6': '.carbon.v1.ErrorEvent', '9': 0, '10': 'error'},
    {'1': 'session_ended', '3': 8, '4': 1, '5': 11, '6': '.carbon.v1.SessionEnded', '9': 0, '10': 'sessionEnded'},
    {'1': 'schedule_set', '3': 9, '4': 1, '5': 11, '6': '.carbon.v1.ScheduleSet', '9': 0, '10': 'scheduleSet'},
    {'1': 'scheduled_turn_started', '3': 10, '4': 1, '5': 11, '6': '.carbon.v1.ScheduledTurnStarted', '9': 0, '10': 'scheduledTurnStarted'},
    {'1': 'sub_agent_spawned', '3': 11, '4': 1, '5': 11, '6': '.carbon.v1.SubAgentSpawned', '9': 0, '10': 'subAgentSpawned'},
    {'1': 'sub_agent_completed', '3': 12, '4': 1, '5': 11, '6': '.carbon.v1.SubAgentCompleted', '9': 0, '10': 'subAgentCompleted'},
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `ServerEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverEventDescriptor = $convert.base64Decode(
    'CgtTZXJ2ZXJFdmVudBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQSRAoPc2Vzc2lvbl'
    '9jcmVhdGVkGAIgASgLMhkuY2FyYm9uLnYxLlNlc3Npb25DcmVhdGVkSABSDnNlc3Npb25DcmVh'
    'dGVkEjUKCnRleHRfZGVsdGEYAyABKAsyFC5jYXJib24udjEuVGV4dERlbHRhSABSCXRleHREZW'
    'x0YRI/Cg50b29sX3VzZV9zdGFydBgEIAEoCzIXLmNhcmJvbi52MS5Ub29sVXNlU3RhcnRIAFIM'
    'dG9vbFVzZVN0YXJ0EjgKC3Rvb2xfcmVzdWx0GAUgASgLMhUuY2FyYm9uLnYxLlRvb2xSZXN1bH'
    'RIAFIKdG9vbFJlc3VsdBI+Cg10dXJuX2NvbXBsZXRlGAYgASgLMhcuY2FyYm9uLnYxLlR1cm5D'
    'b21wbGV0ZUgAUgx0dXJuQ29tcGxldGUSLQoFZXJyb3IYByABKAsyFS5jYXJib24udjEuRXJyb3'
    'JFdmVudEgAUgVlcnJvchI+Cg1zZXNzaW9uX2VuZGVkGAggASgLMhcuY2FyYm9uLnYxLlNlc3Np'
    'b25FbmRlZEgAUgxzZXNzaW9uRW5kZWQSOwoMc2NoZWR1bGVfc2V0GAkgASgLMhYuY2FyYm9uLn'
    'YxLlNjaGVkdWxlU2V0SABSC3NjaGVkdWxlU2V0ElcKFnNjaGVkdWxlZF90dXJuX3N0YXJ0ZWQY'
    'CiABKAsyHy5jYXJib24udjEuU2NoZWR1bGVkVHVyblN0YXJ0ZWRIAFIUc2NoZWR1bGVkVHVybl'
    'N0YXJ0ZWQSSAoRc3ViX2FnZW50X3NwYXduZWQYCyABKAsyGi5jYXJib24udjEuU3ViQWdlbnRT'
    'cGF3bmVkSABSD3N1YkFnZW50U3Bhd25lZBJOChNzdWJfYWdlbnRfY29tcGxldGVkGAwgASgLMh'
    'wuY2FyYm9uLnYxLlN1YkFnZW50Q29tcGxldGVkSABSEXN1YkFnZW50Q29tcGxldGVkQgcKBWV2'
    'ZW50');

@$core.Deprecated('Use sessionCreatedDescriptor instead')
const SessionCreated$json = {
  '1': 'SessionCreated',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `SessionCreated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionCreatedDescriptor = $convert.base64Decode(
    'Cg5TZXNzaW9uQ3JlYXRlZBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQ=');

@$core.Deprecated('Use textDeltaDescriptor instead')
const TextDelta$json = {
  '1': 'TextDelta',
  '2': [
    {'1': 'content', '3': 1, '4': 1, '5': 9, '10': 'content'},
  ],
};

/// Descriptor for `TextDelta`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textDeltaDescriptor = $convert.base64Decode(
    'CglUZXh0RGVsdGESGAoHY29udGVudBgBIAEoCVIHY29udGVudA==');

@$core.Deprecated('Use toolUseStartDescriptor instead')
const ToolUseStart$json = {
  '1': 'ToolUseStart',
  '2': [
    {'1': 'tool_call_id', '3': 1, '4': 1, '5': 9, '10': 'toolCallId'},
    {'1': 'tool_name', '3': 2, '4': 1, '5': 9, '10': 'toolName'},
    {'1': 'arguments_json', '3': 3, '4': 1, '5': 9, '10': 'argumentsJson'},
  ],
};

/// Descriptor for `ToolUseStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolUseStartDescriptor = $convert.base64Decode(
    'CgxUb29sVXNlU3RhcnQSIAoMdG9vbF9jYWxsX2lkGAEgASgJUgp0b29sQ2FsbElkEhsKCXRvb2'
    'xfbmFtZRgCIAEoCVIIdG9vbE5hbWUSJQoOYXJndW1lbnRzX2pzb24YAyABKAlSDWFyZ3VtZW50'
    'c0pzb24=');

@$core.Deprecated('Use toolResultDescriptor instead')
const ToolResult$json = {
  '1': 'ToolResult',
  '2': [
    {'1': 'tool_call_id', '3': 1, '4': 1, '5': 9, '10': 'toolCallId'},
    {'1': 'output', '3': 2, '4': 1, '5': 9, '10': 'output'},
    {'1': 'is_error', '3': 3, '4': 1, '5': 8, '10': 'isError'},
  ],
};

/// Descriptor for `ToolResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolResultDescriptor = $convert.base64Decode(
    'CgpUb29sUmVzdWx0EiAKDHRvb2xfY2FsbF9pZBgBIAEoCVIKdG9vbENhbGxJZBIWCgZvdXRwdX'
    'QYAiABKAlSBm91dHB1dBIZCghpc19lcnJvchgDIAEoCFIHaXNFcnJvcg==');

@$core.Deprecated('Use turnCompleteDescriptor instead')
const TurnComplete$json = {
  '1': 'TurnComplete',
  '2': [
    {'1': 'usage_json', '3': 1, '4': 1, '5': 9, '10': 'usageJson'},
  ],
};

/// Descriptor for `TurnComplete`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List turnCompleteDescriptor = $convert.base64Decode(
    'CgxUdXJuQ29tcGxldGUSHQoKdXNhZ2VfanNvbhgBIAEoCVIJdXNhZ2VKc29u');

@$core.Deprecated('Use errorEventDescriptor instead')
const ErrorEvent$json = {
  '1': 'ErrorEvent',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'fatal', '3': 3, '4': 1, '5': 8, '10': 'fatal'},
  ],
};

/// Descriptor for `ErrorEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorEventDescriptor = $convert.base64Decode(
    'CgpFcnJvckV2ZW50EhIKBGNvZGUYASABKAlSBGNvZGUSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2'
    'FnZRIUCgVmYXRhbBgDIAEoCFIFZmF0YWw=');

@$core.Deprecated('Use sessionEndedDescriptor instead')
const SessionEnded$json = {
  '1': 'SessionEnded',
  '2': [
    {'1': 'reason', '3': 1, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `SessionEnded`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionEndedDescriptor = $convert.base64Decode(
    'CgxTZXNzaW9uRW5kZWQSFgoGcmVhc29uGAEgASgJUgZyZWFzb24=');

@$core.Deprecated('Use scheduleSetDescriptor instead')
const ScheduleSet$json = {
  '1': 'ScheduleSet',
  '2': [
    {'1': 'schedule', '3': 1, '4': 1, '5': 9, '10': 'schedule'},
    {'1': 'prompt', '3': 2, '4': 1, '5': 9, '10': 'prompt'},
  ],
};

/// Descriptor for `ScheduleSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleSetDescriptor = $convert.base64Decode(
    'CgtTY2hlZHVsZVNldBIaCghzY2hlZHVsZRgBIAEoCVIIc2NoZWR1bGUSFgoGcHJvbXB0GAIgAS'
    'gJUgZwcm9tcHQ=');

@$core.Deprecated('Use scheduledTurnStartedDescriptor instead')
const ScheduledTurnStarted$json = {
  '1': 'ScheduledTurnStarted',
  '2': [
    {'1': 'prompt', '3': 1, '4': 1, '5': 9, '10': 'prompt'},
  ],
};

/// Descriptor for `ScheduledTurnStarted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduledTurnStartedDescriptor = $convert.base64Decode(
    'ChRTY2hlZHVsZWRUdXJuU3RhcnRlZBIWCgZwcm9tcHQYASABKAlSBnByb21wdA==');

@$core.Deprecated('Use spawnSubAgentRequestDescriptor instead')
const SpawnSubAgentRequest$json = {
  '1': 'SpawnSubAgentRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'product', '3': 2, '4': 1, '5': 9, '10': 'product'},
    {'1': 'prompt', '3': 3, '4': 1, '5': 9, '10': 'prompt'},
    {'1': 'config', '3': 4, '4': 3, '5': 11, '6': '.carbon.v1.SpawnSubAgentRequest.ConfigEntry', '10': 'config'},
  ],
  '3': [SpawnSubAgentRequest_ConfigEntry$json],
};

@$core.Deprecated('Use spawnSubAgentRequestDescriptor instead')
const SpawnSubAgentRequest_ConfigEntry$json = {
  '1': 'ConfigEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `SpawnSubAgentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List spawnSubAgentRequestDescriptor = $convert.base64Decode(
    'ChRTcGF3blN1YkFnZW50UmVxdWVzdBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQSGA'
    'oHcHJvZHVjdBgCIAEoCVIHcHJvZHVjdBIWCgZwcm9tcHQYAyABKAlSBnByb21wdBJDCgZjb25m'
    'aWcYBCADKAsyKy5jYXJib24udjEuU3Bhd25TdWJBZ2VudFJlcXVlc3QuQ29uZmlnRW50cnlSBm'
    'NvbmZpZxo5CgtDb25maWdFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIF'
    'dmFsdWU6AjgB');

@$core.Deprecated('Use subAgentSpawnedDescriptor instead')
const SubAgentSpawned$json = {
  '1': 'SubAgentSpawned',
  '2': [
    {'1': 'sub_session_id', '3': 1, '4': 1, '5': 9, '10': 'subSessionId'},
    {'1': 'prompt', '3': 2, '4': 1, '5': 9, '10': 'prompt'},
  ],
};

/// Descriptor for `SubAgentSpawned`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subAgentSpawnedDescriptor = $convert.base64Decode(
    'Cg9TdWJBZ2VudFNwYXduZWQSJAoOc3ViX3Nlc3Npb25faWQYASABKAlSDHN1YlNlc3Npb25JZB'
    'IWCgZwcm9tcHQYAiABKAlSBnByb21wdA==');

@$core.Deprecated('Use subAgentCompletedDescriptor instead')
const SubAgentCompleted$json = {
  '1': 'SubAgentCompleted',
  '2': [
    {'1': 'sub_session_id', '3': 1, '4': 1, '5': 9, '10': 'subSessionId'},
    {'1': 'result', '3': 2, '4': 1, '5': 9, '10': 'result'},
    {'1': 'is_error', '3': 3, '4': 1, '5': 8, '10': 'isError'},
  ],
};

/// Descriptor for `SubAgentCompleted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subAgentCompletedDescriptor = $convert.base64Decode(
    'ChFTdWJBZ2VudENvbXBsZXRlZBIkCg5zdWJfc2Vzc2lvbl9pZBgBIAEoCVIMc3ViU2Vzc2lvbk'
    'lkEhYKBnJlc3VsdBgCIAEoCVIGcmVzdWx0EhkKCGlzX2Vycm9yGAMgASgIUgdpc0Vycm9y');

