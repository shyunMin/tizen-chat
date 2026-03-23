import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';

class PremiumContactCardScreen extends StatefulWidget {
  const PremiumContactCardScreen({super.key, required this.uiCode});

  final String uiCode;

  @override
  State<PremiumContactCardScreen> createState() =>
      _PremiumContactCardScreenState();
}

class _PremiumContactCardScreenState extends State<PremiumContactCardScreen> {
  late A2uiMessageProcessor _processor;

  // 전달해주신 프리미엄 연락처 카드 JSON
  // final String premiumCardJson =
  //     r'''[{"version": "v0.9", "messages": [{"createSurface": {"surfaceId": "premiumContactCardSurface", "layout": {"type": "Vertical", "properties": {"alignment": "center", "spacing": 24, "width": "fill", "height": "fill", "padding": 24, "backgroundColor": "surface"}, "components": [{"type": "Card", "componentId": "contactCard", "properties": {"width": 380, "padding": 24, "cornerRadius": 20, "elevation": 12, "backgroundColor": "surfaceBright"}, "layout": {"type": "Vertical", "properties": {"spacing": 24}, "components": [{"type": "Horizontal", "componentId": "cardHeader", "properties": {"alignment": "start", "spacing": 20}, "components": [{"type": "Avatar", "componentId": "contactAvatar", "properties": {"size": 80, "image": "https://i.pravatar.cc/150?img=3", "backgroundColor": "primaryLight", "borderColor": "primary", "borderWidth": 2}}, {"type": "Vertical", "properties": {"spacing": 6, "alignment": "start"}, "components": [{"type": "Text", "componentId": "contactName", "properties": {"text": "Eleanor Vance", "fontSize": 26, "fontWeight": "bold", "color": "onSurface"}}, {"type": "Text", "componentId": "contactTitle", "properties": {"text": "Senior Product Designer", "fontSize": 17, "color": "onSurfaceVariant"}}]}]}, {"type": "Divider", "properties": {"color": "onSurfaceVariantAlpha20", "thickness": 1}}, {"type": "Vertical", "componentId": "contactDetails", "properties": {"spacing": 16}, "components": [{"type": "Horizontal", "properties": {"alignment": "center", "spacing": 16}, "components": [{"type": "Icon", "properties": {"icon": "phone", "size": 22, "color": "primary"}}, {"type": "Text", "properties": {"text": "+1 (555) 123-4567", "fontSize": 17, "color": "onSurface"}}]}, {"type": "Horizontal", "properties": {"alignment": "center", "spacing": 16}, "components": [{"type": "Icon", "properties": {"icon": "mail", "size": 22, "color": "primary"}}, {"type": "Text", "properties": {"text": "eleanor.v@example.com", "fontSize": 17, "color": "onSurface"}}]}, {"type": "Horizontal", "properties": {"alignment": "center", "spacing": 16}, "components": [{"type": "Icon", "properties": {"icon": "location_on", "size": 22, "color": "primary"}}, {"type": "Text", "properties": {"text": "New York, USA", "fontSize": 17, "color": "onSurface"}}]}]}, {"type": "Divider", "properties": {"color": "onSurfaceVariantAlpha20", "thickness": 1}}, {"type": "Horizontal", "componentId": "contactActions", "properties": {"alignment": "spaceAround", "paddingTop": 12, "spacing": 12}, "components": [{"type": "Button", "componentId": "callButton", "properties": {"text": "Call", "icon": "call", "variant": "text", "color": "primary", "fontSize": 16, "paddingHorizontal": 16, "paddingVertical": 10}}, {"type": "Button", "componentId": "messageButton", "properties": {"text": "Message", "icon": "message", "variant": "text", "color": "primary", "fontSize": 16, "paddingHorizontal": 16, "paddingVertical": 10}}, {"type": "Button", "componentId": "shareButton", "properties": {"text": "Share", "icon": "share", "variant": "text", "color": "primary", "fontSize": 16, "paddingHorizontal": 16, "paddingVertical": 10}}]}]}}]}}}]}]''';

  @override
  void initState() {
    super.initState();

    // 외부 패키지의 프로세서 초기화
    _processor = A2uiMessageProcessor(catalogs: [CoreCatalogItems.asCatalog()]);

    try {
      // JSON 파싱 후 messages 배열 추출하여 프로세서에 주입
      final decoded = jsonDecode(widget.uiCode) as List;
      final messages = decoded.first['messages'] as List;

      for (var msg in messages) {
        _processor.handleMessage(A2uiMessage.fromJson(msg));
      }
    } catch (e) {
      debugPrint('A2UI JSON Parsing Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // genui 패키지의 공식 렌더링 위젯을 사용하여 지정된 surfaceId를 그립니다.
      child: GenUiSurface(
        surfaceId: 'premiumContactCardSurface',
        host: _processor,
      ),
    );
  }
}
