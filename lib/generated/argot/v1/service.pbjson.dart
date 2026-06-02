// This is a generated file - do not edit.
//
// Generated from argot/v1/service.proto.

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
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {
      '1': 'parts',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.argot.v1.MessagePart',
      '10': 'parts'
    },
  ],
};

/// Descriptor for `ChatRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatRequestDescriptor = $convert.base64Decode(
    'CgtDaGF0UmVxdWVzdBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQSKwoFcGFydHMYAi'
    'ADKAsyFS5hcmdvdC52MS5NZXNzYWdlUGFydFIFcGFydHM=');

@$core.Deprecated('Use messagePartDescriptor instead')
const MessagePart$json = {
  '1': 'MessagePart',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'text'},
  ],
  '8': [
    {'1': 'part'},
  ],
};

/// Descriptor for `MessagePart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messagePartDescriptor = $convert.base64Decode(
    'CgtNZXNzYWdlUGFydBIUCgR0ZXh0GAEgASgJSABSBHRleHRCBgoEcGFydA==');

@$core.Deprecated('Use chatResponseDescriptor instead')
const ChatResponse$json = {
  '1': 'ChatResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {
      '1': 'terminated_reason',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'terminatedReason'
    },
    {'1': 'turns', '3': 4, '4': 1, '5': 13, '10': 'turns'},
    {'1': 'tool_calls', '3': 5, '4': 1, '5': 13, '10': 'toolCalls'},
  ],
};

/// Descriptor for `ChatResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatResponseDescriptor = $convert.base64Decode(
    'CgxDaGF0UmVzcG9uc2USHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklkEhIKBHRleHQYAi'
    'ABKAlSBHRleHQSKwoRdGVybWluYXRlZF9yZWFzb24YAyABKAlSEHRlcm1pbmF0ZWRSZWFzb24S'
    'FAoFdHVybnMYBCABKA1SBXR1cm5zEh0KCnRvb2xfY2FsbHMYBSABKA1SCXRvb2xDYWxscw==');
