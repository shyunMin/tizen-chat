// This is a generated file - do not edit.
//
// Generated from carbon/v2/skill_service.proto.

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

@$core.Deprecated('Use listSkillsRequestDescriptor instead')
const ListSkillsRequest$json = {
  '1': 'ListSkillsRequest',
  '2': [
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `ListSkillsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSkillsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0U2tpbGxzUmVxdWVzdBIdCgpzZXNzaW9uX2lkGAIgASgJUglzZXNzaW9uSWQ=');

@$core.Deprecated('Use listSkillsResponseDescriptor instead')
const ListSkillsResponse$json = {
  '1': 'ListSkillsResponse',
  '2': [
    {
      '1': 'skills',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.carbon.v2.ResolvedSkill',
      '10': 'skills'
    },
  ],
};

/// Descriptor for `ListSkillsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSkillsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0U2tpbGxzUmVzcG9uc2USMAoGc2tpbGxzGAEgAygLMhguY2FyYm9uLnYyLlJlc29sdm'
    'VkU2tpbGxSBnNraWxscw==');

@$core.Deprecated('Use resolveSkillRequestDescriptor instead')
const ResolveSkillRequest$json = {
  '1': 'ResolveSkillRequest',
  '2': [
    {'1': 'trigger', '3': 1, '4': 1, '5': 9, '10': 'trigger'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `ResolveSkillRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveSkillRequestDescriptor = $convert.base64Decode(
    'ChNSZXNvbHZlU2tpbGxSZXF1ZXN0EhgKB3RyaWdnZXIYASABKAlSB3RyaWdnZXISHQoKc2Vzc2'
    'lvbl9pZBgCIAEoCVIJc2Vzc2lvbklk');

@$core.Deprecated('Use resolvedSkillDescriptor instead')
const ResolvedSkill$json = {
  '1': 'ResolvedSkill',
  '2': [
    {'1': 'skill_id', '3': 1, '4': 1, '5': 9, '10': 'skillId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'scope', '3': 4, '4': 1, '5': 9, '10': 'scope'},
  ],
};

/// Descriptor for `ResolvedSkill`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolvedSkillDescriptor = $convert.base64Decode(
    'Cg1SZXNvbHZlZFNraWxsEhkKCHNraWxsX2lkGAEgASgJUgdza2lsbElkEhIKBG5hbWUYAiABKA'
    'lSBG5hbWUSIAoLZGVzY3JpcHRpb24YAyABKAlSC2Rlc2NyaXB0aW9uEhQKBXNjb3BlGAQgASgJ'
    'UgVzY29wZQ==');

@$core.Deprecated('Use readSkillRequestDescriptor instead')
const ReadSkillRequest$json = {
  '1': 'ReadSkillRequest',
  '2': [
    {'1': 'skill_id', '3': 1, '4': 1, '5': 9, '10': 'skillId'},
  ],
};

/// Descriptor for `ReadSkillRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readSkillRequestDescriptor = $convert.base64Decode(
    'ChBSZWFkU2tpbGxSZXF1ZXN0EhkKCHNraWxsX2lkGAEgASgJUgdza2lsbElk');

@$core.Deprecated('Use skillContentDescriptor instead')
const SkillContent$json = {
  '1': 'SkillContent',
  '2': [
    {'1': 'skill_id', '3': 1, '4': 1, '5': 9, '10': 'skillId'},
    {'1': 'body', '3': 2, '4': 1, '5': 9, '10': 'body'},
  ],
};

/// Descriptor for `SkillContent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List skillContentDescriptor = $convert.base64Decode(
    'CgxTa2lsbENvbnRlbnQSGQoIc2tpbGxfaWQYASABKAlSB3NraWxsSWQSEgoEYm9keRgCIAEoCV'
    'IEYm9keQ==');

@$core.Deprecated('Use installSkillRequestDescriptor instead')
const InstallSkillRequest$json = {
  '1': 'InstallSkillRequest',
  '2': [
    {'1': 'source', '3': 1, '4': 1, '5': 9, '10': 'source'},
  ],
};

/// Descriptor for `InstallSkillRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List installSkillRequestDescriptor =
    $convert.base64Decode(
        'ChNJbnN0YWxsU2tpbGxSZXF1ZXN0EhYKBnNvdXJjZRgBIAEoCVIGc291cmNl');

@$core.Deprecated('Use installSkillResponseDescriptor instead')
const InstallSkillResponse$json = {
  '1': 'InstallSkillResponse',
  '2': [
    {'1': 'skill_id', '3': 1, '4': 1, '5': 9, '10': 'skillId'},
    {'1': 'installed', '3': 2, '4': 1, '5': 8, '10': 'installed'},
  ],
};

/// Descriptor for `InstallSkillResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List installSkillResponseDescriptor = $convert.base64Decode(
    'ChRJbnN0YWxsU2tpbGxSZXNwb25zZRIZCghza2lsbF9pZBgBIAEoCVIHc2tpbGxJZBIcCglpbn'
    'N0YWxsZWQYAiABKAhSCWluc3RhbGxlZA==');
