// This is a generated file - do not edit.
//
// Generated from carbon/v2/skill_service.proto.

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

import 'skill_service.pb.dart' as $0;

export 'skill_service.pb.dart';

@$pb.GrpcServiceName('carbon.v2.SkillService')
class SkillServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SkillServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ListSkillsResponse> listSkills(
    $0.ListSkillsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listSkills, request, options: options);
  }

  $grpc.ResponseFuture<$0.ResolvedSkill> resolveSkill(
    $0.ResolveSkillRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resolveSkill, request, options: options);
  }

  $grpc.ResponseFuture<$0.SkillContent> readSkill(
    $0.ReadSkillRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$readSkill, request, options: options);
  }

  $grpc.ResponseFuture<$0.InstallSkillResponse> installSkill(
    $0.InstallSkillRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$installSkill, request, options: options);
  }

  // method descriptors

  static final _$listSkills =
      $grpc.ClientMethod<$0.ListSkillsRequest, $0.ListSkillsResponse>(
          '/carbon.v2.SkillService/ListSkills',
          ($0.ListSkillsRequest value) => value.writeToBuffer(),
          $0.ListSkillsResponse.fromBuffer);
  static final _$resolveSkill =
      $grpc.ClientMethod<$0.ResolveSkillRequest, $0.ResolvedSkill>(
          '/carbon.v2.SkillService/ResolveSkill',
          ($0.ResolveSkillRequest value) => value.writeToBuffer(),
          $0.ResolvedSkill.fromBuffer);
  static final _$readSkill =
      $grpc.ClientMethod<$0.ReadSkillRequest, $0.SkillContent>(
          '/carbon.v2.SkillService/ReadSkill',
          ($0.ReadSkillRequest value) => value.writeToBuffer(),
          $0.SkillContent.fromBuffer);
  static final _$installSkill =
      $grpc.ClientMethod<$0.InstallSkillRequest, $0.InstallSkillResponse>(
          '/carbon.v2.SkillService/InstallSkill',
          ($0.InstallSkillRequest value) => value.writeToBuffer(),
          $0.InstallSkillResponse.fromBuffer);
}

@$pb.GrpcServiceName('carbon.v2.SkillService')
abstract class SkillServiceBase extends $grpc.Service {
  $core.String get $name => 'carbon.v2.SkillService';

  SkillServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ListSkillsRequest, $0.ListSkillsResponse>(
        'ListSkills',
        listSkills_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListSkillsRequest.fromBuffer(value),
        ($0.ListSkillsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ResolveSkillRequest, $0.ResolvedSkill>(
        'ResolveSkill',
        resolveSkill_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ResolveSkillRequest.fromBuffer(value),
        ($0.ResolvedSkill value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReadSkillRequest, $0.SkillContent>(
        'ReadSkill',
        readSkill_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ReadSkillRequest.fromBuffer(value),
        ($0.SkillContent value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.InstallSkillRequest, $0.InstallSkillResponse>(
            'InstallSkill',
            installSkill_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.InstallSkillRequest.fromBuffer(value),
            ($0.InstallSkillResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListSkillsResponse> listSkills_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListSkillsRequest> $request) async {
    return listSkills($call, await $request);
  }

  $async.Future<$0.ListSkillsResponse> listSkills(
      $grpc.ServiceCall call, $0.ListSkillsRequest request);

  $async.Future<$0.ResolvedSkill> resolveSkill_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ResolveSkillRequest> $request) async {
    return resolveSkill($call, await $request);
  }

  $async.Future<$0.ResolvedSkill> resolveSkill(
      $grpc.ServiceCall call, $0.ResolveSkillRequest request);

  $async.Future<$0.SkillContent> readSkill_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ReadSkillRequest> $request) async {
    return readSkill($call, await $request);
  }

  $async.Future<$0.SkillContent> readSkill(
      $grpc.ServiceCall call, $0.ReadSkillRequest request);

  $async.Future<$0.InstallSkillResponse> installSkill_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.InstallSkillRequest> $request) async {
    return installSkill($call, await $request);
  }

  $async.Future<$0.InstallSkillResponse> installSkill(
      $grpc.ServiceCall call, $0.InstallSkillRequest request);
}
