// This is a generated file - do not edit.
//
// Generated from carbon/v2/control_service.proto.

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

@$core.Deprecated('Use compactSessionRequestDescriptor instead')
const CompactSessionRequest$json = {
  '1': 'CompactSessionRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'cue', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'cue', '17': true},
  ],
  '8': [
    {'1': '_cue'},
  ],
};

/// Descriptor for `CompactSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List compactSessionRequestDescriptor = $convert.base64Decode(
    'ChVDb21wYWN0U2Vzc2lvblJlcXVlc3QSHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklkEh'
    'UKA2N1ZRgCIAEoCUgAUgNjdWWIAQFCBgoEX2N1ZQ==');

@$core.Deprecated('Use compactSessionResponseDescriptor instead')
const CompactSessionResponse$json = {
  '1': 'CompactSessionResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'new_log_id', '3': 3, '4': 1, '5': 9, '10': 'newLogId'},
    {'1': 'summary_excerpt', '3': 4, '4': 1, '5': 9, '10': 'summaryExcerpt'},
  ],
};

/// Descriptor for `CompactSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List compactSessionResponseDescriptor = $convert.base64Decode(
    'ChZDb21wYWN0U2Vzc2lvblJlc3BvbnNlEh0KCnNlc3Npb25faWQYASABKAlSCXNlc3Npb25JZB'
    'IbCgl0aHJlYWRfaWQYAiABKAlSCHRocmVhZElkEhwKCm5ld19sb2dfaWQYAyABKAlSCG5ld0xv'
    'Z0lkEicKD3N1bW1hcnlfZXhjZXJwdBgEIAEoCVIOc3VtbWFyeUV4Y2VycHQ=');

@$core.Deprecated('Use clearSessionRequestDescriptor instead')
const ClearSessionRequest$json = {
  '1': 'ClearSessionRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `ClearSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearSessionRequestDescriptor = $convert.base64Decode(
    'ChNDbGVhclNlc3Npb25SZXF1ZXN0Eh0KCnNlc3Npb25faWQYASABKAlSCXNlc3Npb25JZA==');

@$core.Deprecated('Use clearSessionResponseDescriptor instead')
const ClearSessionResponse$json = {
  '1': 'ClearSessionResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'new_log_id', '3': 2, '4': 1, '5': 9, '10': 'newLogId'},
  ],
};

/// Descriptor for `ClearSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearSessionResponseDescriptor = $convert.base64Decode(
    'ChRDbGVhclNlc3Npb25SZXNwb25zZRIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQSHA'
    'oKbmV3X2xvZ19pZBgCIAEoCVIIbmV3TG9nSWQ=');

@$core.Deprecated('Use getStatusRequestDescriptor instead')
const GetStatusRequest$json = {
  '1': 'GetStatusRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `GetStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStatusRequestDescriptor = $convert.base64Decode(
    'ChBHZXRTdGF0dXNSZXF1ZXN0Eh0KCnNlc3Npb25faWQYASABKAlSCXNlc3Npb25JZA==');

@$core.Deprecated('Use statusDescriptor instead')
const Status$json = {
  '1': 'Status',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'log_id', '3': 2, '4': 1, '5': 9, '10': 'logId'},
    {'1': 'product', '3': 3, '4': 1, '5': 9, '10': 'product'},
    {'1': 'workspace', '3': 4, '4': 1, '5': 9, '10': 'workspace'},
    {'1': 'session_name', '3': 5, '4': 1, '5': 9, '10': 'sessionName'},
    {'1': 'provider', '3': 6, '4': 1, '5': 9, '10': 'provider'},
    {'1': 'model', '3': 7, '4': 1, '5': 9, '10': 'model'},
    {'1': 'active_thread_id', '3': 8, '4': 1, '5': 9, '10': 'activeThreadId'},
    {'1': 'turn_count', '3': 9, '4': 1, '5': 13, '10': 'turnCount'},
    {'1': 'approval_policy', '3': 10, '4': 1, '5': 9, '10': 'approvalPolicy'},
    {'1': 'history_len', '3': 11, '4': 1, '5': 13, '10': 'historyLen'},
    {'1': 'status', '3': 12, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `Status`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statusDescriptor = $convert.base64Decode(
    'CgZTdGF0dXMSHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklkEhUKBmxvZ19pZBgCIAEoCV'
    'IFbG9nSWQSGAoHcHJvZHVjdBgDIAEoCVIHcHJvZHVjdBIcCgl3b3Jrc3BhY2UYBCABKAlSCXdv'
    'cmtzcGFjZRIhCgxzZXNzaW9uX25hbWUYBSABKAlSC3Nlc3Npb25OYW1lEhoKCHByb3ZpZGVyGA'
    'YgASgJUghwcm92aWRlchIUCgVtb2RlbBgHIAEoCVIFbW9kZWwSKAoQYWN0aXZlX3RocmVhZF9p'
    'ZBgIIAEoCVIOYWN0aXZlVGhyZWFkSWQSHQoKdHVybl9jb3VudBgJIAEoDVIJdHVybkNvdW50Ei'
    'cKD2FwcHJvdmFsX3BvbGljeRgKIAEoCVIOYXBwcm92YWxQb2xpY3kSHwoLaGlzdG9yeV9sZW4Y'
    'CyABKA1SCmhpc3RvcnlMZW4SFgoGc3RhdHVzGAwgASgJUgZzdGF0dXM=');
