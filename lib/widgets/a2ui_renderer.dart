import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import '../theme/tizen_styles.dart';

class A2uiRenderer extends StatefulWidget {
  final String uiCode;

  const A2uiRenderer({super.key, required this.uiCode});

  @override
  State<A2uiRenderer> createState() => _A2uiRendererState();
}

class _A2uiRendererState extends State<A2uiRenderer> {
  late A2uiMessageProcessor _processor;
  String? _surfaceId;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    // Use CoreCatalogItems from genui package
    _processor = A2uiMessageProcessor(catalogs: [CoreCatalogItems.asCatalog()]);
    _parseAndProcess();
  }

  void _parseAndProcess() {
    try {
      final decoded = jsonDecode(widget.uiCode);
      if (decoded is List) {
        for (var msg in decoded) {
          _handleRawMessage(msg as Map<String, dynamic>);
        }
      } else if (decoded is Map) {
        _handleRawMessage(decoded as Map<String, dynamic>);
      }
    } catch (e) {
      print('DEBUG: A2UI Parse Error: $e');
      setState(() {
        _hasError = true;
      });
    }
  }

  void _handleRawMessage(Map<String, dynamic> msg) {
    // Map A2UI v0.9 (createSurface/updateComponents) to GenUI 0.7.0 (beginRendering/surfaceUpdate)
    try {
      if (msg.containsKey('createSurface')) {
        final data = msg['createSurface'] as Map<String, dynamic>;
        final String sid = data['surfaceId'] ?? 'main';
        setState(() => _surfaceId = sid);
        
        _processor.handleMessage(A2uiMessage.fromJson({
          'beginRendering': {'surfaceId': sid}
        }));
        
        // If there's a root component in createSurface, treat it as an update
        if (data.containsKey('root')) {
            _processor.handleMessage(A2uiMessage.fromJson({
              'surfaceUpdate': {
                'surfaceId': sid,
                'components': [
                  {
                    'id': 'root',
                    'component': data['root']
                  }
                ]
              }
            }));
        }
      } else if (msg.containsKey('updateComponents')) {
        final data = msg['updateComponents'] as Map<String, dynamic>;
        final String sid = data['surfaceId'] ?? _surfaceId ?? 'main';
        
        _processor.handleMessage(A2uiMessage.fromJson({
          'surfaceUpdate': {
            'surfaceId': sid,
            'components': data['components']
          }
        }));
      } else {
        // Try direct parsing if it already matches GenUI 0.7.0
        _processor.handleMessage(A2uiMessage.fromJson(msg));
        
        // Update surfaceId if it was a beginRendering message
        if (msg.containsKey('beginRendering')) {
          setState(() => _surfaceId = msg['beginRendering']['surfaceId']);
        }
      }
    } catch (e) {
      print('DEBUG: Message handling error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('Error rendering UI components', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
      );
    }

    if (_surfaceId == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: TizenStyles.slate900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TizenStyles.cyan400.withValues(alpha: 0.2)),
      ),
      clipBehavior: Clip.antiAlias,
      child: GenUiSurface(
        surfaceId: _surfaceId!,
        host: _processor,
      ),
    );
  }
}
