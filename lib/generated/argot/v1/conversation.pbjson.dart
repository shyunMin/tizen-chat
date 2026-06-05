// This is a generated file - do not edit.
//
// Generated from argot/v1/conversation.proto.

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

@$core.Deprecated('Use listConversationsRequestDescriptor instead')
const ListConversationsRequest$json = {
  '1': 'ListConversationsRequest',
  '2': [
    {'1': 'limit', '3': 1, '4': 1, '5': 13, '10': 'limit'},
    {'1': 'include_archived', '3': 2, '4': 1, '5': 8, '10': 'includeArchived'},
    {'1': 'include_routines', '3': 3, '4': 1, '5': 8, '10': 'includeRoutines'},
  ],
};

/// Descriptor for `ListConversationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listConversationsRequestDescriptor = $convert.base64Decode(
    'ChhMaXN0Q29udmVyc2F0aW9uc1JlcXVlc3QSFAoFbGltaXQYASABKA1SBWxpbWl0EikKEGluY2'
    'x1ZGVfYXJjaGl2ZWQYAiABKAhSD2luY2x1ZGVBcmNoaXZlZBIpChBpbmNsdWRlX3JvdXRpbmVz'
    'GAMgASgIUg9pbmNsdWRlUm91dGluZXM=');

@$core.Deprecated('Use conversationInfoDescriptor instead')
const ConversationInfo$json = {
  '1': 'ConversationInfo',
  '2': [
    {'1': 'conversation_id', '3': 1, '4': 1, '5': 9, '10': 'conversationId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'last_activity_ms', '3': 3, '4': 1, '5': 3, '10': 'lastActivityMs'},
    {'1': 'created_at_ms', '3': 4, '4': 1, '5': 3, '10': 'createdAtMs'},
    {'1': 'message_count', '3': 5, '4': 1, '5': 13, '10': 'messageCount'},
    {'1': 'pinned', '3': 6, '4': 1, '5': 8, '10': 'pinned'},
    {'1': 'archived', '3': 7, '4': 1, '5': 8, '10': 'archived'},
  ],
};

/// Descriptor for `ConversationInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List conversationInfoDescriptor = $convert.base64Decode(
    'ChBDb252ZXJzYXRpb25JbmZvEicKD2NvbnZlcnNhdGlvbl9pZBgBIAEoCVIOY29udmVyc2F0aW'
    '9uSWQSFAoFdGl0bGUYAiABKAlSBXRpdGxlEigKEGxhc3RfYWN0aXZpdHlfbXMYAyABKANSDmxh'
    'c3RBY3Rpdml0eU1zEiIKDWNyZWF0ZWRfYXRfbXMYBCABKANSC2NyZWF0ZWRBdE1zEiMKDW1lc3'
    'NhZ2VfY291bnQYBSABKA1SDG1lc3NhZ2VDb3VudBIWCgZwaW5uZWQYBiABKAhSBnBpbm5lZBIa'
    'CghhcmNoaXZlZBgHIAEoCFIIYXJjaGl2ZWQ=');

@$core.Deprecated('Use listConversationsResponseDescriptor instead')
const ListConversationsResponse$json = {
  '1': 'ListConversationsResponse',
  '2': [
    {
      '1': 'conversations',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.argot.v1.ConversationInfo',
      '10': 'conversations'
    },
    {'1': 'has_more', '3': 2, '4': 1, '5': 8, '10': 'hasMore'},
  ],
};

/// Descriptor for `ListConversationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listConversationsResponseDescriptor = $convert.base64Decode(
    'ChlMaXN0Q29udmVyc2F0aW9uc1Jlc3BvbnNlEkAKDWNvbnZlcnNhdGlvbnMYASADKAsyGi5hcm'
    'dvdC52MS5Db252ZXJzYXRpb25JbmZvUg1jb252ZXJzYXRpb25zEhkKCGhhc19tb3JlGAIgASgI'
    'UgdoYXNNb3Jl');

@$core.Deprecated('Use getConversationRequestDescriptor instead')
const GetConversationRequest$json = {
  '1': 'GetConversationRequest',
  '2': [
    {'1': 'conversation_id', '3': 1, '4': 1, '5': 9, '10': 'conversationId'},
  ],
};

/// Descriptor for `GetConversationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConversationRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRDb252ZXJzYXRpb25SZXF1ZXN0EicKD2NvbnZlcnNhdGlvbl9pZBgBIAEoCVIOY29udm'
        'Vyc2F0aW9uSWQ=');

@$core.Deprecated('Use getHistoryRequestDescriptor instead')
const GetHistoryRequest$json = {
  '1': 'GetHistoryRequest',
  '2': [
    {'1': 'conversation_id', '3': 1, '4': 1, '5': 9, '10': 'conversationId'},
    {'1': 'limit', '3': 2, '4': 1, '5': 13, '10': 'limit'},
  ],
};

/// Descriptor for `GetHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHistoryRequestDescriptor = $convert.base64Decode(
    'ChFHZXRIaXN0b3J5UmVxdWVzdBInCg9jb252ZXJzYXRpb25faWQYASABKAlSDmNvbnZlcnNhdG'
    'lvbklkEhQKBWxpbWl0GAIgASgNUgVsaW1pdA==');

@$core.Deprecated('Use getHistoryResponseDescriptor instead')
const GetHistoryResponse$json = {
  '1': 'GetHistoryResponse',
  '2': [
    {
      '1': 'messages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.argot.v1.ChatMessage',
      '10': 'messages'
    },
    {'1': 'has_more', '3': 2, '4': 1, '5': 8, '10': 'hasMore'},
  ],
};

/// Descriptor for `GetHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHistoryResponseDescriptor = $convert.base64Decode(
    'ChJHZXRIaXN0b3J5UmVzcG9uc2USMQoIbWVzc2FnZXMYASADKAsyFS5hcmdvdC52MS5DaGF0TW'
    'Vzc2FnZVIIbWVzc2FnZXMSGQoIaGFzX21vcmUYAiABKAhSB2hhc01vcmU=');

@$core.Deprecated('Use deleteConversationRequestDescriptor instead')
const DeleteConversationRequest$json = {
  '1': 'DeleteConversationRequest',
  '2': [
    {'1': 'conversation_id', '3': 1, '4': 1, '5': 9, '10': 'conversationId'},
    {'1': 'purge', '3': 2, '4': 1, '5': 8, '10': 'purge'},
  ],
};

/// Descriptor for `DeleteConversationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteConversationRequestDescriptor =
    $convert.base64Decode(
        'ChlEZWxldGVDb252ZXJzYXRpb25SZXF1ZXN0EicKD2NvbnZlcnNhdGlvbl9pZBgBIAEoCVIOY2'
        '9udmVyc2F0aW9uSWQSFAoFcHVyZ2UYAiABKAhSBXB1cmdl');

@$core.Deprecated('Use deleteConversationResponseDescriptor instead')
const DeleteConversationResponse$json = {
  '1': 'DeleteConversationResponse',
};

/// Descriptor for `DeleteConversationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteConversationResponseDescriptor =
    $convert.base64Decode('ChpEZWxldGVDb252ZXJzYXRpb25SZXNwb25zZQ==');
