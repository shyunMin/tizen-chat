import 'dart:convert';

class SessionMeta {
  final String name;       // "2025-04-25"  (Carbon session 이름 = 날짜)
  final String title;      // 화면에 표시할 타이틀
  final String createdAt;  // ISO 8601

  SessionMeta({
    required this.name,
    required this.title,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'title': title,
        'createdAt': createdAt,
      };

  factory SessionMeta.fromJson(Map<String, dynamic> json) => SessionMeta(
        name: json['name'] as String,
        title: json['title'] as String,
        createdAt: json['createdAt'] as String,
      );

  static List<SessionMeta> listFromJson(String raw) {
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => SessionMeta.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String listToJson(List<SessionMeta> sessions) =>
      jsonEncode(sessions.map((s) => s.toJson()).toList());
}
