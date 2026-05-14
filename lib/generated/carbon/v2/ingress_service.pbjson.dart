// This is a generated file - do not edit.
//
// Generated from carbon/v2/ingress_service.proto.

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

@$core.Deprecated('Use dispositionDescriptor instead')
const Disposition$json = {
  '1': 'Disposition',
  '2': [
    {'1': 'DISPOSITION_UNSPECIFIED', '2': 0},
    {'1': 'DISPOSITION_STARTED_NOW', '2': 1},
    {'1': 'DISPOSITION_STEERED', '2': 2},
    {'1': 'DISPOSITION_QUEUED', '2': 3},
    {'1': 'DISPOSITION_OBSERVED', '2': 4},
    {'1': 'DISPOSITION_DROPPED', '2': 5},
  ],
};

/// Descriptor for `Disposition`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List dispositionDescriptor = $convert.base64Decode(
    'CgtEaXNwb3NpdGlvbhIbChdESVNQT1NJVElPTl9VTlNQRUNJRklFRBAAEhsKF0RJU1BPU0lUSU'
    '9OX1NUQVJURURfTk9XEAESFwoTRElTUE9TSVRJT05fU1RFRVJFRBACEhYKEkRJU1BPU0lUSU9O'
    'X1FVRVVFRBADEhgKFERJU1BPU0lUSU9OX09CU0VSVkVEEAQSFwoTRElTUE9TSVRJT05fRFJPUF'
    'BFRBAF');

@$core.Deprecated('Use interruptModeDescriptor instead')
const InterruptMode$json = {
  '1': 'InterruptMode',
  '2': [
    {'1': 'INTERRUPT_MODE_UNSPECIFIED', '2': 0},
    {'1': 'INTERRUPT_MODE_HARD', '2': 1},
    {'1': 'INTERRUPT_MODE_SOFT', '2': 2},
  ],
};

/// Descriptor for `InterruptMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List interruptModeDescriptor = $convert.base64Decode(
    'Cg1JbnRlcnJ1cHRNb2RlEh4KGklOVEVSUlVQVF9NT0RFX1VOU1BFQ0lGSUVEEAASFwoTSU5URV'
    'JSVVBUX01PREVfSEFSRBABEhcKE0lOVEVSUlVQVF9NT0RFX1NPRlQQAg==');

@$core.Deprecated('Use approvalDecisionDescriptor instead')
const ApprovalDecision$json = {
  '1': 'ApprovalDecision',
  '2': [
    {'1': 'APPROVAL_DECISION_UNSPECIFIED', '2': 0},
    {'1': 'APPROVAL_DECISION_APPROVE', '2': 1},
    {'1': 'APPROVAL_DECISION_DENY', '2': 2},
    {'1': 'APPROVAL_DECISION_ALWAYS_SESSION', '2': 3},
  ],
};

/// Descriptor for `ApprovalDecision`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List approvalDecisionDescriptor = $convert.base64Decode(
    'ChBBcHByb3ZhbERlY2lzaW9uEiEKHUFQUFJPVkFMX0RFQ0lTSU9OX1VOU1BFQ0lGSUVEEAASHQ'
    'oZQVBQUk9WQUxfREVDSVNJT05fQVBQUk9WRRABEhoKFkFQUFJPVkFMX0RFQ0lTSU9OX0RFTlkQ'
    'AhIkCiBBUFBST1ZBTF9ERUNJU0lPTl9BTFdBWVNfU0VTU0lPThAD');

@$core.Deprecated('Use submitRequestDescriptor instead')
const SubmitRequest$json = {
  '1': 'SubmitRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {
      '1': 'content',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.IngressContent',
      '10': 'content'
    },
    {
      '1': 'intent',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.carbon.v2.IngressIntent',
      '10': 'intent'
    },
    {
      '1': 'thread',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.ThreadTarget',
      '10': 'thread'
    },
    {
      '1': 'options',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.IngressOptions',
      '10': 'options'
    },
    {'1': 'client_request_id', '3': 6, '4': 1, '5': 9, '10': 'clientRequestId'},
  ],
};

/// Descriptor for `SubmitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitRequestDescriptor = $convert.base64Decode(
    'Cg1TdWJtaXRSZXF1ZXN0Eh0KCnNlc3Npb25faWQYASABKAlSCXNlc3Npb25JZBIzCgdjb250ZW'
    '50GAIgASgLMhkuY2FyYm9uLnYyLkluZ3Jlc3NDb250ZW50Ugdjb250ZW50EjAKBmludGVudBgD'
    'IAEoDjIYLmNhcmJvbi52Mi5JbmdyZXNzSW50ZW50UgZpbnRlbnQSLwoGdGhyZWFkGAQgASgLMh'
    'cuY2FyYm9uLnYyLlRocmVhZFRhcmdldFIGdGhyZWFkEjMKB29wdGlvbnMYBSABKAsyGS5jYXJi'
    'b24udjIuSW5ncmVzc09wdGlvbnNSB29wdGlvbnMSKgoRY2xpZW50X3JlcXVlc3RfaWQYBiABKA'
    'lSD2NsaWVudFJlcXVlc3RJZA==');

@$core.Deprecated('Use submitResponseDescriptor instead')
const SubmitResponse$json = {
  '1': 'SubmitResponse',
  '2': [
    {
      '1': 'disposition',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.carbon.v2.Disposition',
      '10': 'disposition'
    },
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'turn_id', '3': 3, '4': 1, '5': 9, '10': 'turnId'},
    {'1': 'client_request_id', '3': 4, '4': 1, '5': 9, '10': 'clientRequestId'},
  ],
};

/// Descriptor for `SubmitResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitResponseDescriptor = $convert.base64Decode(
    'Cg5TdWJtaXRSZXNwb25zZRI4CgtkaXNwb3NpdGlvbhgBIAEoDjIWLmNhcmJvbi52Mi5EaXNwb3'
    'NpdGlvblILZGlzcG9zaXRpb24SGwoJdGhyZWFkX2lkGAIgASgJUgh0aHJlYWRJZBIXCgd0dXJu'
    'X2lkGAMgASgJUgZ0dXJuSWQSKgoRY2xpZW50X3JlcXVlc3RfaWQYBCABKAlSD2NsaWVudFJlcX'
    'Vlc3RJZA==');

@$core.Deprecated('Use ingressContentDescriptor instead')
const IngressContent$json = {
  '1': 'IngressContent',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'text'},
    {
      '1': 'media',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.MediaBlob',
      '9': 0,
      '10': 'media'
    },
    {
      '1': 'skill_activation',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.SkillActivation',
      '9': 0,
      '10': 'skillActivation'
    },
    {
      '1': 'event',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.EventPayload',
      '9': 0,
      '10': 'event'
    },
  ],
  '8': [
    {'1': 'content'},
  ],
};

/// Descriptor for `IngressContent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ingressContentDescriptor = $convert.base64Decode(
    'Cg5JbmdyZXNzQ29udGVudBIUCgR0ZXh0GAEgASgJSABSBHRleHQSLAoFbWVkaWEYAiABKAsyFC'
    '5jYXJib24udjIuTWVkaWFCbG9iSABSBW1lZGlhEkcKEHNraWxsX2FjdGl2YXRpb24YAyABKAsy'
    'Gi5jYXJib24udjIuU2tpbGxBY3RpdmF0aW9uSABSD3NraWxsQWN0aXZhdGlvbhIvCgVldmVudB'
    'gEIAEoCzIXLmNhcmJvbi52Mi5FdmVudFBheWxvYWRIAFIFZXZlbnRCCQoHY29udGVudA==');

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

@$core.Deprecated('Use skillActivationDescriptor instead')
const SkillActivation$json = {
  '1': 'SkillActivation',
  '2': [
    {'1': 'skill_id', '3': 1, '4': 1, '5': 9, '10': 'skillId'},
    {'1': 'args_text', '3': 2, '4': 1, '5': 9, '10': 'argsText'},
  ],
};

/// Descriptor for `SkillActivation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List skillActivationDescriptor = $convert.base64Decode(
    'Cg9Ta2lsbEFjdGl2YXRpb24SGQoIc2tpbGxfaWQYASABKAlSB3NraWxsSWQSGwoJYXJnc190ZX'
    'h0GAIgASgJUghhcmdzVGV4dA==');

@$core.Deprecated('Use eventPayloadDescriptor instead')
const EventPayload$json = {
  '1': 'EventPayload',
  '2': [
    {'1': 'event_type', '3': 1, '4': 1, '5': 9, '10': 'eventType'},
    {
      '1': 'payload',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Value',
      '10': 'payload'
    },
  ],
};

/// Descriptor for `EventPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventPayloadDescriptor = $convert.base64Decode(
    'CgxFdmVudFBheWxvYWQSHQoKZXZlbnRfdHlwZRgBIAEoCVIJZXZlbnRUeXBlEjAKB3BheWxvYW'
    'QYAiABKAsyFi5nb29nbGUucHJvdG9idWYuVmFsdWVSB3BheWxvYWQ=');

@$core.Deprecated('Use ingressOptionsDescriptor instead')
const IngressOptions$json = {
  '1': 'IngressOptions',
  '2': [
    {'1': 'source', '3': 1, '4': 1, '5': 9, '10': 'source'},
    {
      '1': 'metadata',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Struct',
      '10': 'metadata'
    },
  ],
};

/// Descriptor for `IngressOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ingressOptionsDescriptor = $convert.base64Decode(
    'Cg5JbmdyZXNzT3B0aW9ucxIWCgZzb3VyY2UYASABKAlSBnNvdXJjZRIzCghtZXRhZGF0YRgCIA'
    'EoCzIXLmdvb2dsZS5wcm90b2J1Zi5TdHJ1Y3RSCG1ldGFkYXRh');

@$core.Deprecated('Use threadTargetDescriptor instead')
const ThreadTarget$json = {
  '1': 'ThreadTarget',
  '2': [
    {
      '1': 'auto',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.AutoTarget',
      '9': 0,
      '10': 'auto'
    },
    {
      '1': 'resume',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.ResumeTarget',
      '9': 0,
      '10': 'resume'
    },
    {
      '1': 'new_thread',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.carbon.v2.NewTarget',
      '9': 0,
      '10': 'newThread'
    },
  ],
  '8': [
    {'1': 'target'},
  ],
};

/// Descriptor for `ThreadTarget`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadTargetDescriptor = $convert.base64Decode(
    'CgxUaHJlYWRUYXJnZXQSKwoEYXV0bxgBIAEoCzIVLmNhcmJvbi52Mi5BdXRvVGFyZ2V0SABSBG'
    'F1dG8SMQoGcmVzdW1lGAIgASgLMhcuY2FyYm9uLnYyLlJlc3VtZVRhcmdldEgAUgZyZXN1bWUS'
    'NQoKbmV3X3RocmVhZBgDIAEoCzIULmNhcmJvbi52Mi5OZXdUYXJnZXRIAFIJbmV3VGhyZWFkQg'
    'gKBnRhcmdldA==');

@$core.Deprecated('Use autoTargetDescriptor instead')
const AutoTarget$json = {
  '1': 'AutoTarget',
};

/// Descriptor for `AutoTarget`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List autoTargetDescriptor =
    $convert.base64Decode('CgpBdXRvVGFyZ2V0');

@$core.Deprecated('Use resumeTargetDescriptor instead')
const ResumeTarget$json = {
  '1': 'ResumeTarget',
  '2': [
    {'1': 'thread_id', '3': 1, '4': 1, '5': 9, '10': 'threadId'},
  ],
};

/// Descriptor for `ResumeTarget`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resumeTargetDescriptor = $convert.base64Decode(
    'CgxSZXN1bWVUYXJnZXQSGwoJdGhyZWFkX2lkGAEgASgJUgh0aHJlYWRJZA==');

@$core.Deprecated('Use newTargetDescriptor instead')
const NewTarget$json = {
  '1': 'NewTarget',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `NewTarget`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List newTargetDescriptor =
    $convert.base64Decode('CglOZXdUYXJnZXQSEgoEbmFtZRgBIAEoCVIEbmFtZQ==');

@$core.Deprecated('Use interruptTurnRequestDescriptor instead')
const InterruptTurnRequest$json = {
  '1': 'InterruptTurnRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'turn_id', '3': 2, '4': 1, '5': 9, '10': 'turnId'},
    {
      '1': 'mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.carbon.v2.InterruptMode',
      '10': 'mode'
    },
  ],
};

/// Descriptor for `InterruptTurnRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List interruptTurnRequestDescriptor = $convert.base64Decode(
    'ChRJbnRlcnJ1cHRUdXJuUmVxdWVzdBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQSFw'
    'oHdHVybl9pZBgCIAEoCVIGdHVybklkEiwKBG1vZGUYAyABKA4yGC5jYXJib24udjIuSW50ZXJy'
    'dXB0TW9kZVIEbW9kZQ==');

@$core.Deprecated('Use interruptTurnResponseDescriptor instead')
const InterruptTurnResponse$json = {
  '1': 'InterruptTurnResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'turn_id', '3': 2, '4': 1, '5': 9, '10': 'turnId'},
    {'1': 'interrupted', '3': 3, '4': 1, '5': 8, '10': 'interrupted'},
  ],
};

/// Descriptor for `InterruptTurnResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List interruptTurnResponseDescriptor = $convert.base64Decode(
    'ChVJbnRlcnJ1cHRUdXJuUmVzcG9uc2USHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklkEh'
    'cKB3R1cm5faWQYAiABKAlSBnR1cm5JZBIgCgtpbnRlcnJ1cHRlZBgDIAEoCFILaW50ZXJydXB0'
    'ZWQ=');

@$core.Deprecated('Use approveToolRequestDescriptor instead')
const ApproveToolRequest$json = {
  '1': 'ApproveToolRequest',
  '2': [
    {'1': 'approval_id', '3': 1, '4': 1, '5': 9, '10': 'approvalId'},
    {
      '1': 'decision',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.carbon.v2.ApprovalDecision',
      '10': 'decision'
    },
  ],
};

/// Descriptor for `ApproveToolRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveToolRequestDescriptor = $convert.base64Decode(
    'ChJBcHByb3ZlVG9vbFJlcXVlc3QSHwoLYXBwcm92YWxfaWQYASABKAlSCmFwcHJvdmFsSWQSNw'
    'oIZGVjaXNpb24YAiABKA4yGy5jYXJib24udjIuQXBwcm92YWxEZWNpc2lvblIIZGVjaXNpb24=');

@$core.Deprecated('Use approveToolResponseDescriptor instead')
const ApproveToolResponse$json = {
  '1': 'ApproveToolResponse',
  '2': [
    {'1': 'approval_id', '3': 1, '4': 1, '5': 9, '10': 'approvalId'},
    {'1': 'applied', '3': 2, '4': 1, '5': 8, '10': 'applied'},
  ],
};

/// Descriptor for `ApproveToolResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveToolResponseDescriptor = $convert.base64Decode(
    'ChNBcHByb3ZlVG9vbFJlc3BvbnNlEh8KC2FwcHJvdmFsX2lkGAEgASgJUgphcHByb3ZhbElkEh'
    'gKB2FwcGxpZWQYAiABKAhSB2FwcGxpZWQ=');
