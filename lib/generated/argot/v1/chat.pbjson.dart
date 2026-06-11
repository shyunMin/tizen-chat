// This is a generated file - do not edit.
//
// Generated from argot/v1/chat.proto.

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

@$core.Deprecated('Use chatRequestDescriptor instead')
const ChatRequest$json = {
  '1': 'ChatRequest',
  '2': [
    {
      '1': 'conversation_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'conversationId'
    },
    {
      '1': 'new',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.NewConversation',
      '9': 0,
      '10': 'new'
    },
    {
      '1': 'ephemeral',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.argot.v1.EphemeralConversation',
      '9': 0,
      '10': 'ephemeral'
    },
    {
      '1': 'parts',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.argot.v1.MessagePart',
      '10': 'parts'
    },
    {
      '1': 'tool_detail',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.argot.v1.ToolDetail',
      '10': 'toolDetail'
    },
  ],
  '8': [
    {'1': 'target'},
  ],
};

/// Descriptor for `ChatRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatRequestDescriptor = $convert.base64Decode(
    'CgtDaGF0UmVxdWVzdBIpCg9jb252ZXJzYXRpb25faWQYASABKAlIAFIOY29udmVyc2F0aW9uSW'
    'QSLQoDbmV3GAIgASgLMhkuYXJnb3QudjEuTmV3Q29udmVyc2F0aW9uSABSA25ldxI/CgllcGhl'
    'bWVyYWwYAyABKAsyHy5hcmdvdC52MS5FcGhlbWVyYWxDb252ZXJzYXRpb25IAFIJZXBoZW1lcm'
    'FsEisKBXBhcnRzGAQgAygLMhUuYXJnb3QudjEuTWVzc2FnZVBhcnRSBXBhcnRzEjUKC3Rvb2xf'
    'ZGV0YWlsGAUgASgOMhQuYXJnb3QudjEuVG9vbERldGFpbFIKdG9vbERldGFpbEIICgZ0YXJnZX'
    'Q=');

@$core.Deprecated('Use newConversationDescriptor instead')
const NewConversation$json = {
  '1': 'NewConversation',
  '2': [
    {'1': 'conversation_id', '3': 1, '4': 1, '5': 9, '10': 'conversationId'},
  ],
};

/// Descriptor for `NewConversation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List newConversationDescriptor = $convert.base64Decode(
    'Cg9OZXdDb252ZXJzYXRpb24SJwoPY29udmVyc2F0aW9uX2lkGAEgASgJUg5jb252ZXJzYXRpb2'
    '5JZA==');

@$core.Deprecated('Use ephemeralConversationDescriptor instead')
const EphemeralConversation$json = {
  '1': 'EphemeralConversation',
};

/// Descriptor for `EphemeralConversation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ephemeralConversationDescriptor =
    $convert.base64Decode('ChVFcGhlbWVyYWxDb252ZXJzYXRpb24=');
