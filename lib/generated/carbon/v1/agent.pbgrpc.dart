//
//  Generated code. Do not modify.
//  source: carbon/v1/agent.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'agent.pb.dart' as $0;

export 'agent.pb.dart';

@$pb.GrpcServiceName('carbon.v1.AgentService')
class AgentServiceClient extends $grpc.Client {
  static final _$session = $grpc.ClientMethod<$0.ClientMessage, $0.ServerEvent>(
      '/carbon.v1.AgentService/Session',
      ($0.ClientMessage value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ServerEvent.fromBuffer(value));

  AgentServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseStream<$0.ServerEvent> session($async.Stream<$0.ClientMessage> request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$session, request, options: options);
  }
}

@$pb.GrpcServiceName('carbon.v1.AgentService')
abstract class AgentServiceBase extends $grpc.Service {
  $core.String get $name => 'carbon.v1.AgentService';

  AgentServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ClientMessage, $0.ServerEvent>(
        'Session',
        session,
        true,
        true,
        ($core.List<$core.int> value) => $0.ClientMessage.fromBuffer(value),
        ($0.ServerEvent value) => value.writeToBuffer()));
  }

  $async.Stream<$0.ServerEvent> session($grpc.ServiceCall call, $async.Stream<$0.ClientMessage> request);
}
