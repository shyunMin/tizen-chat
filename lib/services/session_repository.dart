import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/session_meta.dart';

/// 앱이 직접 관리하는 세션 목록 레포지토리.
///
/// 저장 경로: {appSupportDir}/session_list.json
/// 형식: JSON 배열 [ {name, title, createdAt}, ... ]
///
/// Carbon 서버의 실제 세션 데이터(JSONL)는 건드리지 않는다.
class SessionRepository {
  SessionRepository._();
  static final SessionRepository instance = SessionRepository._();

  // ── 날짜 포매팅 (intl 패키지 없이) ─────────────────────────────
  String _todayKey() {
    final now = DateTime.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  // ── 저장 경로 ────────────────────────────────────────────────
  Future<File> _file() async {
    final dir = await getApplicationSupportDirectory();
    return File(p.join(dir.path, 'session_list.json'));
  }

  // ── 읽기 ─────────────────────────────────────────────────────
  Future<List<SessionMeta>> _load() async {
    try {
      final file = await _file();
      if (!await file.exists()) return [];
      final raw = await file.readAsString();
      if (raw.trim().isEmpty) return [];
      return SessionMeta.listFromJson(raw);
    } catch (e) {
      print('[SessionRepository] load error: $e');
      return [];
    }
  }

  // ── 쓰기 ─────────────────────────────────────────────────────
  Future<void> _save(List<SessionMeta> sessions) async {
    try {
      final file = await _file();
      await file.writeAsString(SessionMeta.listToJson(sessions));
    } catch (e) {
      print('[SessionRepository] save error: $e');
    }
  }

  // ── 공개 API ─────────────────────────────────────────────────

  /// 오늘 날짜 세션을 보장하고, 세션 이름(날짜 문자열)을 반환한다.
  /// 목록에 오늘 항목이 없으면 추가하여 저장한다.
  Future<String> ensureTodaySession() async {
    final today = _todayKey();
    final sessions = await _load();

    final exists = sessions.any((s) => s.name == today);
    if (!exists) {
      sessions.add(
        SessionMeta(
          name: today,
          title: today,
          createdAt: DateTime.now().toUtc().toIso8601String(),
        ),
      );
      await _save(sessions);
      print('[SessionRepository] Created new session: $today');
    } else {
      print('[SessionRepository] Session already exists: $today');
    }

    return today;
  }

  /// 전체 세션 목록 반환 (최신순)
  Future<List<SessionMeta>> listSessions() async {
    final sessions = await _load();
    sessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sessions;
  }
}
