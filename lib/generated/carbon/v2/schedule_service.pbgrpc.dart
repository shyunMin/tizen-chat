// This is a generated file - do not edit.
//
// Generated from carbon/v2/schedule_service.proto.

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

import 'schedule_service.pb.dart' as $0;

export 'schedule_service.pb.dart';

@$pb.GrpcServiceName('carbon.v2.ScheduleService')
class ScheduleServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ScheduleServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.Schedule> createSchedule(
    $0.CreateScheduleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createSchedule, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListSchedulesResponse> listSchedules(
    $0.ListSchedulesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listSchedules, request, options: options);
  }

  $grpc.ResponseFuture<$0.Schedule> pauseSchedule(
    $0.PauseScheduleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$pauseSchedule, request, options: options);
  }

  $grpc.ResponseFuture<$0.Schedule> resumeSchedule(
    $0.ResumeScheduleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resumeSchedule, request, options: options);
  }

  $grpc.ResponseFuture<$0.CancelScheduleResponse> cancelSchedule(
    $0.CancelScheduleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cancelSchedule, request, options: options);
  }

  // method descriptors

  static final _$createSchedule =
      $grpc.ClientMethod<$0.CreateScheduleRequest, $0.Schedule>(
          '/carbon.v2.ScheduleService/CreateSchedule',
          ($0.CreateScheduleRequest value) => value.writeToBuffer(),
          $0.Schedule.fromBuffer);
  static final _$listSchedules =
      $grpc.ClientMethod<$0.ListSchedulesRequest, $0.ListSchedulesResponse>(
          '/carbon.v2.ScheduleService/ListSchedules',
          ($0.ListSchedulesRequest value) => value.writeToBuffer(),
          $0.ListSchedulesResponse.fromBuffer);
  static final _$pauseSchedule =
      $grpc.ClientMethod<$0.PauseScheduleRequest, $0.Schedule>(
          '/carbon.v2.ScheduleService/PauseSchedule',
          ($0.PauseScheduleRequest value) => value.writeToBuffer(),
          $0.Schedule.fromBuffer);
  static final _$resumeSchedule =
      $grpc.ClientMethod<$0.ResumeScheduleRequest, $0.Schedule>(
          '/carbon.v2.ScheduleService/ResumeSchedule',
          ($0.ResumeScheduleRequest value) => value.writeToBuffer(),
          $0.Schedule.fromBuffer);
  static final _$cancelSchedule =
      $grpc.ClientMethod<$0.CancelScheduleRequest, $0.CancelScheduleResponse>(
          '/carbon.v2.ScheduleService/CancelSchedule',
          ($0.CancelScheduleRequest value) => value.writeToBuffer(),
          $0.CancelScheduleResponse.fromBuffer);
}

@$pb.GrpcServiceName('carbon.v2.ScheduleService')
abstract class ScheduleServiceBase extends $grpc.Service {
  $core.String get $name => 'carbon.v2.ScheduleService';

  ScheduleServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateScheduleRequest, $0.Schedule>(
        'CreateSchedule',
        createSchedule_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateScheduleRequest.fromBuffer(value),
        ($0.Schedule value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListSchedulesRequest, $0.ListSchedulesResponse>(
            'ListSchedules',
            listSchedules_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListSchedulesRequest.fromBuffer(value),
            ($0.ListSchedulesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PauseScheduleRequest, $0.Schedule>(
        'PauseSchedule',
        pauseSchedule_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.PauseScheduleRequest.fromBuffer(value),
        ($0.Schedule value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ResumeScheduleRequest, $0.Schedule>(
        'ResumeSchedule',
        resumeSchedule_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ResumeScheduleRequest.fromBuffer(value),
        ($0.Schedule value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CancelScheduleRequest,
            $0.CancelScheduleResponse>(
        'CancelSchedule',
        cancelSchedule_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CancelScheduleRequest.fromBuffer(value),
        ($0.CancelScheduleResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.Schedule> createSchedule_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateScheduleRequest> $request) async {
    return createSchedule($call, await $request);
  }

  $async.Future<$0.Schedule> createSchedule(
      $grpc.ServiceCall call, $0.CreateScheduleRequest request);

  $async.Future<$0.ListSchedulesResponse> listSchedules_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListSchedulesRequest> $request) async {
    return listSchedules($call, await $request);
  }

  $async.Future<$0.ListSchedulesResponse> listSchedules(
      $grpc.ServiceCall call, $0.ListSchedulesRequest request);

  $async.Future<$0.Schedule> pauseSchedule_Pre($grpc.ServiceCall $call,
      $async.Future<$0.PauseScheduleRequest> $request) async {
    return pauseSchedule($call, await $request);
  }

  $async.Future<$0.Schedule> pauseSchedule(
      $grpc.ServiceCall call, $0.PauseScheduleRequest request);

  $async.Future<$0.Schedule> resumeSchedule_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ResumeScheduleRequest> $request) async {
    return resumeSchedule($call, await $request);
  }

  $async.Future<$0.Schedule> resumeSchedule(
      $grpc.ServiceCall call, $0.ResumeScheduleRequest request);

  $async.Future<$0.CancelScheduleResponse> cancelSchedule_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CancelScheduleRequest> $request) async {
    return cancelSchedule($call, await $request);
  }

  $async.Future<$0.CancelScheduleResponse> cancelSchedule(
      $grpc.ServiceCall call, $0.CancelScheduleRequest request);
}
