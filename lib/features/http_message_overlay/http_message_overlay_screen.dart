// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:genui/genui.dart';
// import 'http_message_bus.dart';

// class HttpMessageOverlayScreen extends StatefulWidget {
//   const HttpMessageOverlayScreen({super.key});

//   @override
//   State<HttpMessageOverlayScreen> createState() =>
//       _HttpMessageOverlayScreenState();
// }

// class _HttpMessageOverlayScreenState extends State<HttpMessageOverlayScreen> {
//   StreamSubscription<String>? _subscription;
//   String _currentMessage = "HTTP 메시지를 기다리는 중...";
//   final FocusNode _keyboardFocusNode = FocusNode();
  
//   late final SurfaceController _controller;
//   String _activeSurfaceId = 'overlay_surface';
//   bool _isGenUIActive = false;

//   @override
//   void initState() {
//     super.initState();
    
//     // GenUI Controller 초기화
//     _controller = SurfaceController(
//       catalogs: [BasicCatalogItems.asCatalog()],
//     );

//     _subscription = HttpMessageBus.instance.stream.listen((msg) {
//       if (mounted) {
//         _handleIncomingMessage(msg);
//       }
//     });
//   }

//   void _handleIncomingMessage(String msg) {
//     try {
//       final decoded = jsonDecode(msg);
//       if (decoded is Map<String, dynamic> && decoded['version'] == 'v0.9') {
//         String? extractedId;
//         if (decoded.containsKey('createSurface')) {
//            extractedId = decoded['createSurface']['surfaceId'];
//         } else if (decoded.containsKey('updateComponents')) {
//            extractedId = decoded['updateComponents']['surfaceId'];
//         } else if (decoded.containsKey('updateDataModel')) {
//            extractedId = decoded['updateDataModel']['surfaceId'];
//         }

//         final a2uiMsg = A2uiMessage.fromJson(decoded);
//         _controller.handleMessage(a2uiMsg);
        
//         setState(() {
//           _isGenUIActive = true;
//           if (extractedId != null && extractedId.isNotEmpty) {
//             _activeSurfaceId = extractedId;
//           }
          
//           if (decoded.containsKey('createSurface')) {
//              _currentMessage = "새로운 화면 생성됨: $_activeSurfaceId";
//           } else if (decoded.containsKey('updateComponents')) {
//              _currentMessage = "화면 컴포넌트 업데이트 중...";
//           } else {
//              _currentMessage = "GenUI 데이터 수신됨";
//           }
//         });
//         return;
//       }
//     } catch (e) {
//       // JSON 파싱 실패 또는 GenUI 형식이 아님
//     }

//     setState(() {
//       _currentMessage = msg;
//       _isGenUIActive = false;
//     });
//   }

//   @override
//   void dispose() {
//     _subscription?.cancel();
//     _keyboardFocusNode.dispose();
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Focus(
//         focusNode: _keyboardFocusNode,
//         autofocus: true,
//         onKeyEvent: (node, event) {
//           if (event is KeyDownEvent &&
//               (event.logicalKey == LogicalKeyboardKey.escape ||
//                event.logicalKey == LogicalKeyboardKey.goBack ||
//                event.logicalKey == LogicalKeyboardKey.browserBack ||
//                event.logicalKey == LogicalKeyboardKey.arrowDown)) {
//             Navigator.of(context).pop();
//             return KeyEventResult.handled;
//           }
//           return KeyEventResult.ignored;
//         },
//         child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           color: Colors.black.withValues(alpha: 0.3), // 전체 배경 살짝 어둡게
//           child: Column(
//             children: [
//               // 상단 메시지 영역
//               SafeArea(
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                   margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withValues(alpha: 0.7),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.white12),
//                   ),
//                   child: Text(
//                     _currentMessage,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
              
//               // 하단 GenUI 렌더링 영역
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: _isGenUIActive 
//                     ? Surface(
//                         key: ValueKey(_activeSurfaceId),
//                         surfaceContext: _controller.contextFor(_activeSurfaceId),
//                       )
//                     : const Center(
//                         child: Opacity(
//                           opacity: 0.2,
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.auto_awesome, 
//                                 color: Colors.white, 
//                                 size: 80,
//                               ),
//                               SizedBox(height: 16),
//                               Text(
//                                 "GenUI Waiting...",
//                                 style: TextStyle(color: Colors.white, fontSize: 18),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
