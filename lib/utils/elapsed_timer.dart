class ElapsedTimer {
  static String format(DateTime startTime) {
    final total = DateTime.now().difference(startTime).inSeconds;
    final m = total ~/ 60;
    final s = total % 60;
    return m > 0 ? '${m}m ${s}s' : '${s}s';
  }
}
