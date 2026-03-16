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
      } else if (decoded is Map<String, dynamic>) {
        if (decoded.containsKey('messages') && decoded['messages'] is List) {
          for (var msg in decoded['messages']) {
            _handleRawMessage(msg as Map<String, dynamic>);
          }
        } else {
          _handleRawMessage(decoded);
        }
      }
    } catch (e) {
      print('DEBUG: A2UI Parse Error: $e');
      setState(() {
        _hasError = true;
      });
    }
  }

  void _handleRawMessage(Map<String, dynamic> msg) {
    try {
      // Flavor 3: Explicit messageType (Alternative v0.9)
      if (msg['messageType'] == 'createSurface' || msg['messageType'] == 'updateComponents') {
        final String sid = msg['surfaceId'] ?? msg['id'] ?? 'main';
        setState(() => _surfaceId = sid);

        if (msg['messageType'] == 'createSurface') {
          _processor.handleMessage(A2uiMessage.fromJson({
            'beginRendering': {'surfaceId': sid}
          }));
        }

        final List<Map<String, dynamic>> transformed = [];
        
        // Handle 'components' list
        if (msg.containsKey('components') && msg['components'] is List) {
          for (var c in (msg['components'] as List)) {
            transformed.add(_transformComponent(c as Map<String, dynamic>));
          }
        }
        
        // Handle 'root' component if present
        if (msg.containsKey('root')) {
          transformed.add(_transformComponent(msg['root'] as Map<String, dynamic>));
        }

        // If 'concept' is Card, we might need special handling, but GenUI usually prefers explicit components.
        // For now, let's just send the transformed components.
        // Support for 'concept: Card' - wrap components in a Card if requested
        if (msg['concept'] == 'Card') {
          final cardProps = Map<String, dynamic>.from(msg['style'] ?? {});
          // If multiple components, use a Column as the Card's child
          if (transformed.length > 1) {
            cardProps['child'] = {
              'id': '${sid}_card_inner',
              'component': {
                'Column': {
                  'children': transformed,
                  'crossAxisAlignment': 'center',
                }
              }
            };
          } else if (transformed.isNotEmpty) {
            cardProps['child'] = transformed.first;
          }

          transformed.clear();
          transformed.add({
            'id': '${sid}_root_card',
            'component': {
              'Card': cardProps,
            }
          });
        }

        if (transformed.isNotEmpty) {
          _processor.handleMessage(A2uiMessage.fromJson({
            'surfaceUpdate': {
              'surfaceId': sid,
              'components': transformed
            }
          }));
        }
        return;
      }

      // Flavor 1 & 2: createSurface/updateComponents as keys
      if (msg.containsKey('createSurface')) {
        final data = msg['createSurface'] as Map<String, dynamic>;
        final String sid = data['surfaceId'] ?? data['id'] ?? 'main';
        setState(() => _surfaceId = sid);
        
        _processor.handleMessage(A2uiMessage.fromJson({
          'beginRendering': {'surfaceId': sid}
        }));
        
        if (data.containsKey('root')) {
            final rootComp = _transformComponent(data['root'] as Map<String, dynamic>);
            _processor.handleMessage(A2uiMessage.fromJson({
              'surfaceUpdate': {
                'surfaceId': sid,
                'components': [rootComp]
              }
            }));
        }
      } else if (msg.containsKey('updateComponents')) {
        final data = msg['updateComponents'] as Map<String, dynamic>;
        final String sid = data['surfaceId'] ?? data['id'] ?? _surfaceId ?? 'main';
        
        final List<dynamic> rawComponents = data['components'] as List<dynamic>;
        final List<Map<String, dynamic>> transformed = rawComponents
            .map((c) => _transformComponent(c as Map<String, dynamic>))
            .toList();

        _processor.handleMessage(A2uiMessage.fromJson({
          'surfaceUpdate': {
            'surfaceId': sid,
            'components': transformed
          }
        }));
      } else {
        _processor.handleMessage(A2uiMessage.fromJson(msg));
        if (msg.containsKey('beginRendering')) {
          setState(() => _surfaceId = msg['beginRendering']['surfaceId']);
        }
      }
    } catch (e) {
      print('DEBUG: Message handling error: $e');
    }
  }

  Map<String, dynamic> _transformComponent(Map<String, dynamic> raw) {
    final Map<String, dynamic> result = {};
    
    // 1. Extract ID (support id, componentId)
    final String id = (raw['id'] ?? raw['componentId'] ?? 'comp_${DateTime.now().microsecondsSinceEpoch}').toString();
    result['id'] = id;
    
    // 2. Extract Type (support component, componentType)
    String type = raw['component']?.toString() ?? raw['componentType']?.toString() ?? 'Column';
    
    // Map 'Group' to 'Column' or 'Row' based on layout
    if (type == 'Group') {
      type = (raw['layout'] == 'horizontal') ? 'Row' : 'Column';
    }

    final Map<String, dynamic> props = Map<String, dynamic>.from(raw);
    props.remove('id');
    props.remove('componentId');
    props.remove('component');
    props.remove('componentType');
    
    // 3. Process children recursively
    if (props.containsKey('children') && props['children'] is List) {
      props['children'] = (props['children'] as List)
          .map((c) => _transformComponent(c as Map<String, dynamic>))
          .toList();
    }
    if (props.containsKey('child') && props['child'] is Map) {
      props['child'] = _transformComponent(props['child'] as Map<String, dynamic>);
    }
    
    // 4. Wrap into GenUI structure
    result['component'] = {
      type: props
    };
    
    return result;
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
