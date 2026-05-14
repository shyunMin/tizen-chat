// This is a generated file - do not edit.
//
// Generated from carbon/v2/settings_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'settings_service.pb.dart' as $0;

export 'settings_service.pb.dart';

@$pb.GrpcServiceName('carbon.v2.SettingsService')
class SettingsServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SettingsServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.Settings> getSettings(
    $0.GetSettingsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSettings, request, options: options);
  }

  $grpc.ResponseFuture<$0.Settings> setModel(
    $0.SetModelRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setModel, request, options: options);
  }

  $grpc.ResponseFuture<$0.Settings> setApprovalPolicy(
    $0.SetApprovalPolicyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setApprovalPolicy, request, options: options);
  }

  // method descriptors

  static final _$getSettings =
      $grpc.ClientMethod<$0.GetSettingsRequest, $0.Settings>(
          '/carbon.v2.SettingsService/GetSettings',
          ($0.GetSettingsRequest value) => value.writeToBuffer(),
          $0.Settings.fromBuffer);
  static final _$setModel = $grpc.ClientMethod<$0.SetModelRequest, $0.Settings>(
      '/carbon.v2.SettingsService/SetModel',
      ($0.SetModelRequest value) => value.writeToBuffer(),
      $0.Settings.fromBuffer);
  static final _$setApprovalPolicy =
      $grpc.ClientMethod<$0.SetApprovalPolicyRequest, $0.Settings>(
          '/carbon.v2.SettingsService/SetApprovalPolicy',
          ($0.SetApprovalPolicyRequest value) => value.writeToBuffer(),
          $0.Settings.fromBuffer);
}

@$pb.GrpcServiceName('carbon.v2.SettingsService')
abstract class SettingsServiceBase extends $grpc.Service {
  $core.String get $name => 'carbon.v2.SettingsService';

  SettingsServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetSettingsRequest, $0.Settings>(
        'GetSettings',
        getSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetSettingsRequest.fromBuffer(value),
        ($0.Settings value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetModelRequest, $0.Settings>(
        'SetModel',
        setModel_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SetModelRequest.fromBuffer(value),
        ($0.Settings value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetApprovalPolicyRequest, $0.Settings>(
        'SetApprovalPolicy',
        setApprovalPolicy_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SetApprovalPolicyRequest.fromBuffer(value),
        ($0.Settings value) => value.writeToBuffer()));
  }

  $async.Future<$0.Settings> getSettings_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetSettingsRequest> $request) async {
    return getSettings($call, await $request);
  }

  $async.Future<$0.Settings> getSettings(
      $grpc.ServiceCall call, $0.GetSettingsRequest request);

  $async.Future<$0.Settings> setModel_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SetModelRequest> $request) async {
    return setModel($call, await $request);
  }

  $async.Future<$0.Settings> setModel(
      $grpc.ServiceCall call, $0.SetModelRequest request);

  $async.Future<$0.Settings> setApprovalPolicy_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SetApprovalPolicyRequest> $request) async {
    return setApprovalPolicy($call, await $request);
  }

  $async.Future<$0.Settings> setApprovalPolicy(
      $grpc.ServiceCall call, $0.SetApprovalPolicyRequest request);
}
