// This is a generated file - do not edit.
//
// Generated from carbon/v2/event_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class EventKind extends $pb.ProtobufEnum {
  static const EventKind EVENT_KIND_UNSPECIFIED =
      EventKind._(0, _omitEnumNames ? '' : 'EVENT_KIND_UNSPECIFIED');
  static const EventKind EVENT_KIND_TURN_STARTED =
      EventKind._(1, _omitEnumNames ? '' : 'EVENT_KIND_TURN_STARTED');
  static const EventKind EVENT_KIND_TURN_COMPLETED =
      EventKind._(2, _omitEnumNames ? '' : 'EVENT_KIND_TURN_COMPLETED');
  static const EventKind EVENT_KIND_MESSAGE_DELTA =
      EventKind._(3, _omitEnumNames ? '' : 'EVENT_KIND_MESSAGE_DELTA');
  static const EventKind EVENT_KIND_MESSAGE_FINALIZED =
      EventKind._(4, _omitEnumNames ? '' : 'EVENT_KIND_MESSAGE_FINALIZED');
  static const EventKind EVENT_KIND_TOOL_USE_START =
      EventKind._(5, _omitEnumNames ? '' : 'EVENT_KIND_TOOL_USE_START');
  static const EventKind EVENT_KIND_TOOL_RESULT =
      EventKind._(6, _omitEnumNames ? '' : 'EVENT_KIND_TOOL_RESULT');
  static const EventKind EVENT_KIND_TOOL_APPROVAL_REQUEST =
      EventKind._(7, _omitEnumNames ? '' : 'EVENT_KIND_TOOL_APPROVAL_REQUEST');
  static const EventKind EVENT_KIND_THREAD_STARTED =
      EventKind._(8, _omitEnumNames ? '' : 'EVENT_KIND_THREAD_STARTED');
  static const EventKind EVENT_KIND_THREAD_COMPLETED =
      EventKind._(9, _omitEnumNames ? '' : 'EVENT_KIND_THREAD_COMPLETED');
  static const EventKind EVENT_KIND_SESSION_ENDED =
      EventKind._(10, _omitEnumNames ? '' : 'EVENT_KIND_SESSION_ENDED');
  static const EventKind EVENT_KIND_SCHEDULE_CHANGED =
      EventKind._(11, _omitEnumNames ? '' : 'EVENT_KIND_SCHEDULE_CHANGED');
  static const EventKind EVENT_KIND_SUB_AGENT_SPAWNED =
      EventKind._(12, _omitEnumNames ? '' : 'EVENT_KIND_SUB_AGENT_SPAWNED');
  static const EventKind EVENT_KIND_SUB_AGENT_COMPLETED =
      EventKind._(13, _omitEnumNames ? '' : 'EVENT_KIND_SUB_AGENT_COMPLETED');
  static const EventKind EVENT_KIND_STEER_APPLIED =
      EventKind._(14, _omitEnumNames ? '' : 'EVENT_KIND_STEER_APPLIED');
  static const EventKind EVENT_KIND_STEER_FAILED =
      EventKind._(15, _omitEnumNames ? '' : 'EVENT_KIND_STEER_FAILED');
  static const EventKind EVENT_KIND_ERROR =
      EventKind._(16, _omitEnumNames ? '' : 'EVENT_KIND_ERROR');
  static const EventKind EVENT_KIND_CONTINUATION_REQUESTED = EventKind._(
      17, _omitEnumNames ? '' : 'EVENT_KIND_CONTINUATION_REQUESTED');
  static const EventKind EVENT_KIND_VALIDATION_STARTED =
      EventKind._(18, _omitEnumNames ? '' : 'EVENT_KIND_VALIDATION_STARTED');
  static const EventKind EVENT_KIND_VALIDATION_COMPLETED =
      EventKind._(19, _omitEnumNames ? '' : 'EVENT_KIND_VALIDATION_COMPLETED');

  static const $core.List<EventKind> values = <EventKind>[
    EVENT_KIND_UNSPECIFIED,
    EVENT_KIND_TURN_STARTED,
    EVENT_KIND_TURN_COMPLETED,
    EVENT_KIND_MESSAGE_DELTA,
    EVENT_KIND_MESSAGE_FINALIZED,
    EVENT_KIND_TOOL_USE_START,
    EVENT_KIND_TOOL_RESULT,
    EVENT_KIND_TOOL_APPROVAL_REQUEST,
    EVENT_KIND_THREAD_STARTED,
    EVENT_KIND_THREAD_COMPLETED,
    EVENT_KIND_SESSION_ENDED,
    EVENT_KIND_SCHEDULE_CHANGED,
    EVENT_KIND_SUB_AGENT_SPAWNED,
    EVENT_KIND_SUB_AGENT_COMPLETED,
    EVENT_KIND_STEER_APPLIED,
    EVENT_KIND_STEER_FAILED,
    EVENT_KIND_ERROR,
    EVENT_KIND_CONTINUATION_REQUESTED,
    EVENT_KIND_VALIDATION_STARTED,
    EVENT_KIND_VALIDATION_COMPLETED,
  ];

  static final $core.List<EventKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 19);
  static EventKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EventKind._(super.value, super.name);
}

class AssistantMessagePhase extends $pb.ProtobufEnum {
  static const AssistantMessagePhase ASSISTANT_MESSAGE_PHASE_UNSPECIFIED =
      AssistantMessagePhase._(
          0, _omitEnumNames ? '' : 'ASSISTANT_MESSAGE_PHASE_UNSPECIFIED');
  static const AssistantMessagePhase ASSISTANT_MESSAGE_PHASE_COMMENTARY =
      AssistantMessagePhase._(
          1, _omitEnumNames ? '' : 'ASSISTANT_MESSAGE_PHASE_COMMENTARY');
  static const AssistantMessagePhase ASSISTANT_MESSAGE_PHASE_FINAL_ANSWER =
      AssistantMessagePhase._(
          2, _omitEnumNames ? '' : 'ASSISTANT_MESSAGE_PHASE_FINAL_ANSWER');

  static const $core.List<AssistantMessagePhase> values =
      <AssistantMessagePhase>[
    ASSISTANT_MESSAGE_PHASE_UNSPECIFIED,
    ASSISTANT_MESSAGE_PHASE_COMMENTARY,
    ASSISTANT_MESSAGE_PHASE_FINAL_ANSWER,
  ];

  static final $core.List<AssistantMessagePhase?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static AssistantMessagePhase? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AssistantMessagePhase._(super.value, super.name);
}

class ThreadCompleteReason extends $pb.ProtobufEnum {
  static const ThreadCompleteReason THREAD_COMPLETE_REASON_UNSPECIFIED =
      ThreadCompleteReason._(
          0, _omitEnumNames ? '' : 'THREAD_COMPLETE_REASON_UNSPECIFIED');
  static const ThreadCompleteReason THREAD_COMPLETE_REASON_COMPLETED =
      ThreadCompleteReason._(
          1, _omitEnumNames ? '' : 'THREAD_COMPLETE_REASON_COMPLETED');
  static const ThreadCompleteReason THREAD_COMPLETE_REASON_CANCELLED =
      ThreadCompleteReason._(
          2, _omitEnumNames ? '' : 'THREAD_COMPLETE_REASON_CANCELLED');
  static const ThreadCompleteReason
      THREAD_COMPLETE_REASON_PAUSED_VALIDATION_EXHAUSTED =
      ThreadCompleteReason._(
          3,
          _omitEnumNames
              ? ''
              : 'THREAD_COMPLETE_REASON_PAUSED_VALIDATION_EXHAUSTED');
  static const ThreadCompleteReason THREAD_COMPLETE_REASON_FATAL =
      ThreadCompleteReason._(
          4, _omitEnumNames ? '' : 'THREAD_COMPLETE_REASON_FATAL');

  static const $core.List<ThreadCompleteReason> values = <ThreadCompleteReason>[
    THREAD_COMPLETE_REASON_UNSPECIFIED,
    THREAD_COMPLETE_REASON_COMPLETED,
    THREAD_COMPLETE_REASON_CANCELLED,
    THREAD_COMPLETE_REASON_PAUSED_VALIDATION_EXHAUSTED,
    THREAD_COMPLETE_REASON_FATAL,
  ];

  static final $core.List<ThreadCompleteReason?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ThreadCompleteReason? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ThreadCompleteReason._(super.value, super.name);
}

class ScheduleChange extends $pb.ProtobufEnum {
  static const ScheduleChange SCHEDULE_CHANGE_UNSPECIFIED =
      ScheduleChange._(0, _omitEnumNames ? '' : 'SCHEDULE_CHANGE_UNSPECIFIED');
  static const ScheduleChange SCHEDULE_CHANGE_CREATED =
      ScheduleChange._(1, _omitEnumNames ? '' : 'SCHEDULE_CHANGE_CREATED');
  static const ScheduleChange SCHEDULE_CHANGE_PAUSED =
      ScheduleChange._(2, _omitEnumNames ? '' : 'SCHEDULE_CHANGE_PAUSED');
  static const ScheduleChange SCHEDULE_CHANGE_RESUMED =
      ScheduleChange._(3, _omitEnumNames ? '' : 'SCHEDULE_CHANGE_RESUMED');
  static const ScheduleChange SCHEDULE_CHANGE_CANCELED =
      ScheduleChange._(4, _omitEnumNames ? '' : 'SCHEDULE_CHANGE_CANCELED');
  static const ScheduleChange SCHEDULE_CHANGE_FIRED =
      ScheduleChange._(5, _omitEnumNames ? '' : 'SCHEDULE_CHANGE_FIRED');

  static const $core.List<ScheduleChange> values = <ScheduleChange>[
    SCHEDULE_CHANGE_UNSPECIFIED,
    SCHEDULE_CHANGE_CREATED,
    SCHEDULE_CHANGE_PAUSED,
    SCHEDULE_CHANGE_RESUMED,
    SCHEDULE_CHANGE_CANCELED,
    SCHEDULE_CHANGE_FIRED,
  ];

  static final $core.List<ScheduleChange?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ScheduleChange? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ScheduleChange._(super.value, super.name);
}

class SpawnMode extends $pb.ProtobufEnum {
  static const SpawnMode SPAWN_MODE_UNSPECIFIED =
      SpawnMode._(0, _omitEnumNames ? '' : 'SPAWN_MODE_UNSPECIFIED');

  /// Parent's next tool result will carry the child's output.
  static const SpawnMode SPAWN_MODE_SYNC =
      SpawnMode._(1, _omitEnumNames ? '' : 'SPAWN_MODE_SYNC');

  /// Child's result will arrive later as TurnStarted with
  /// source = "sub-agent-result".
  static const SpawnMode SPAWN_MODE_ASYNC =
      SpawnMode._(2, _omitEnumNames ? '' : 'SPAWN_MODE_ASYNC');

  /// No SubAgentCompleted will ever arrive.
  static const SpawnMode SPAWN_MODE_DETACHED =
      SpawnMode._(3, _omitEnumNames ? '' : 'SPAWN_MODE_DETACHED');

  static const $core.List<SpawnMode> values = <SpawnMode>[
    SPAWN_MODE_UNSPECIFIED,
    SPAWN_MODE_SYNC,
    SPAWN_MODE_ASYNC,
    SPAWN_MODE_DETACHED,
  ];

  static final $core.List<SpawnMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static SpawnMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SpawnMode._(super.value, super.name);
}

/// Mirrors crates/core/runtime/src/thread.rs::ContinuationReason. Wire
/// shape lives here so consumers can branch on the structural reason
/// instead of parsing a "continuation:Foo" string code.
class ContinuationReason extends $pb.ProtobufEnum {
  static const ContinuationReason CONTINUATION_REASON_UNSPECIFIED =
      ContinuationReason._(
          0, _omitEnumNames ? '' : 'CONTINUATION_REASON_UNSPECIFIED');
  static const ContinuationReason CONTINUATION_REASON_BUDGET_EXCEEDED =
      ContinuationReason._(
          1, _omitEnumNames ? '' : 'CONTINUATION_REASON_BUDGET_EXCEEDED');
  static const ContinuationReason CONTINUATION_REASON_PLAN_FRONTIER_CHANGED =
      ContinuationReason._(
          2, _omitEnumNames ? '' : 'CONTINUATION_REASON_PLAN_FRONTIER_CHANGED');
  static const ContinuationReason CONTINUATION_REASON_UNRESOLVED_FRONTIER =
      ContinuationReason._(
          3, _omitEnumNames ? '' : 'CONTINUATION_REASON_UNRESOLVED_FRONTIER');
  static const ContinuationReason CONTINUATION_REASON_DEPTH_LIMIT_REACHED =
      ContinuationReason._(
          4, _omitEnumNames ? '' : 'CONTINUATION_REASON_DEPTH_LIMIT_REACHED');
  static const ContinuationReason CONTINUATION_REASON_CONTEXT_WINDOW_PRESSURE =
      ContinuationReason._(5,
          _omitEnumNames ? '' : 'CONTINUATION_REASON_CONTEXT_WINDOW_PRESSURE');
  static const ContinuationReason
      CONTINUATION_REASON_ACCEPTANCE_CRITERIA_MISSING = ContinuationReason._(
          6,
          _omitEnumNames
              ? ''
              : 'CONTINUATION_REASON_ACCEPTANCE_CRITERIA_MISSING');
  static const ContinuationReason CONTINUATION_REASON_VALIDATION_FAILED =
      ContinuationReason._(
          7, _omitEnumNames ? '' : 'CONTINUATION_REASON_VALIDATION_FAILED');
  static const ContinuationReason CONTINUATION_REASON_STEP_EXHAUSTED =
      ContinuationReason._(
          8, _omitEnumNames ? '' : 'CONTINUATION_REASON_STEP_EXHAUSTED');
  static const ContinuationReason CONTINUATION_REASON_CATASTROPHIC_FAILURE =
      ContinuationReason._(
          9, _omitEnumNames ? '' : 'CONTINUATION_REASON_CATASTROPHIC_FAILURE');

  /// Reserved for Slice E: signals the Step → Validation transition.
  /// Declared in Slice B for forward compatibility; not emitted yet.
  static const ContinuationReason CONTINUATION_REASON_VALIDATE =
      ContinuationReason._(
          10, _omitEnumNames ? '' : 'CONTINUATION_REASON_VALIDATE');

  static const $core.List<ContinuationReason> values = <ContinuationReason>[
    CONTINUATION_REASON_UNSPECIFIED,
    CONTINUATION_REASON_BUDGET_EXCEEDED,
    CONTINUATION_REASON_PLAN_FRONTIER_CHANGED,
    CONTINUATION_REASON_UNRESOLVED_FRONTIER,
    CONTINUATION_REASON_DEPTH_LIMIT_REACHED,
    CONTINUATION_REASON_CONTEXT_WINDOW_PRESSURE,
    CONTINUATION_REASON_ACCEPTANCE_CRITERIA_MISSING,
    CONTINUATION_REASON_VALIDATION_FAILED,
    CONTINUATION_REASON_STEP_EXHAUSTED,
    CONTINUATION_REASON_CATASTROPHIC_FAILURE,
    CONTINUATION_REASON_VALIDATE,
  ];

  static final $core.List<ContinuationReason?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 10);
  static ContinuationReason? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ContinuationReason._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
