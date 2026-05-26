import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// 요청별 처리 시간을 CSV 파일로 기록하는 로거.
/// [enabled]가 false이면 모든 메서드는 no-op.
class RequestPerfLogger {
  final bool enabled;
  File? _file;
  int _seq = 0;

  RequestPerfLogger({required this.enabled});

  Future<void> init() async {
    if (!enabled) return;
    final dir = await getApplicationDocumentsDirectory();
    _file = File('${dir.path}/perf_log.csv');
    if (!await _file!.exists()) {
      await _file!.writeAsString(
        'seq,user_message,speech_start_time,request_sent_time,request_complete_time,elapsed_ms\n',
      );
    }
  }

  Future<void> record({
    required String userMessage,
    required DateTime? speechStartTime,
    required DateTime? requestSentTime,
    required DateTime requestCompleteTime,
  }) async {
    if (!enabled || _file == null) return;
    _seq++;
    final elapsedMs = requestSentTime != null
        ? requestCompleteTime.difference(requestSentTime).inMilliseconds
        : -1;
    final sanitized = userMessage.replaceAll('"', '""');
    final line = '$_seq,'
        '"$sanitized",'
        '${speechStartTime?.toIso8601String() ?? ''},'
        '${requestSentTime?.toIso8601String() ?? ''},'
        '${requestCompleteTime.toIso8601String()},'
        '$elapsedMs\n';
    await _file!.writeAsString(line, mode: FileMode.append);
  }
}
