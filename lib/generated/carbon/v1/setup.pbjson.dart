// This is a generated file - do not edit.
//
// Generated from carbon/v1/setup.proto.

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

@$core.Deprecated('Use startSetupRequestDescriptor instead')
const StartSetupRequest$json = {
  '1': 'StartSetupRequest',
  '2': [
    {'1': 'preferred_port', '3': 1, '4': 1, '5': 5, '10': 'preferredPort'},
  ],
};

/// Descriptor for `StartSetupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startSetupRequestDescriptor = $convert.base64Decode(
    'ChFTdGFydFNldHVwUmVxdWVzdBIlCg5wcmVmZXJyZWRfcG9ydBgBIAEoBVINcHJlZmVycmVkUG'
    '9ydA==');

@$core.Deprecated('Use startSetupResponseDescriptor instead')
const StartSetupResponse$json = {
  '1': 'StartSetupResponse',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
  ],
};

/// Descriptor for `StartSetupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startSetupResponseDescriptor = $convert
    .base64Decode('ChJTdGFydFNldHVwUmVzcG9uc2USEAoDdXJsGAEgASgJUgN1cmw=');

@$core.Deprecated('Use stopSetupRequestDescriptor instead')
const StopSetupRequest$json = {
  '1': 'StopSetupRequest',
};

/// Descriptor for `StopSetupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopSetupRequestDescriptor =
    $convert.base64Decode('ChBTdG9wU2V0dXBSZXF1ZXN0');

@$core.Deprecated('Use stopSetupResponseDescriptor instead')
const StopSetupResponse$json = {
  '1': 'StopSetupResponse',
};

/// Descriptor for `StopSetupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopSetupResponseDescriptor =
    $convert.base64Decode('ChFTdG9wU2V0dXBSZXNwb25zZQ==');

@$core.Deprecated('Use watchSetupRequestDescriptor instead')
const WatchSetupRequest$json = {
  '1': 'WatchSetupRequest',
};

/// Descriptor for `WatchSetupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchSetupRequestDescriptor =
    $convert.base64Decode('ChFXYXRjaFNldHVwUmVxdWVzdA==');

@$core.Deprecated('Use setupEventDescriptor instead')
const SetupEvent$json = {
  '1': 'SetupEvent',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.carbon.v1.SetupEvent.Kind',
      '10': 'kind'
    },
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
  ],
  '4': [SetupEvent_Kind$json],
};

@$core.Deprecated('Use setupEventDescriptor instead')
const SetupEvent_Kind$json = {
  '1': 'Kind',
  '2': [
    {'1': 'UNKNOWN', '2': 0},
    {'1': 'COMPLETED', '2': 1},
    {'1': 'STOPPED', '2': 2},
  ],
};

/// Descriptor for `SetupEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setupEventDescriptor = $convert.base64Decode(
    'CgpTZXR1cEV2ZW50Ei4KBGtpbmQYASABKA4yGi5jYXJib24udjEuU2V0dXBFdmVudC5LaW5kUg'
    'RraW5kEhAKA3VybBgCIAEoCVIDdXJsIi8KBEtpbmQSCwoHVU5LTk9XThAAEg0KCUNPTVBMRVRF'
    'RBABEgsKB1NUT1BQRUQQAg==');
