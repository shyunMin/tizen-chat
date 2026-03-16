import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import '../theme/tizen_styles.dart';

class A2uiRenderer extends StatefulWidget {
  final String uiCode;

  const A2uiRenderer({super.key, required this.uiCode});

  /// Validates if the given string is a potentially valid A2UI JSON.
  static bool isValidJson(String? code) {
    if (code == null || code.isEmpty) return false;
    try {
      final decoded = jsonDecode(code);
      bool isValid = false;
      if (decoded is List) {
        if (decoded.isNotEmpty) {
          final first = decoded.first;
          if (first is Map) isValid = _isA2uiMap(first as Map<String, dynamic>);
        }
      } else if (decoded is Map<String, dynamic>) {
        if (decoded.containsKey('messages') && decoded['messages'] is List) {
           isValid = (decoded['messages'] as List).isNotEmpty;
        } else {
          isValid = _isA2uiMap(decoded);
        }
      }
      
      if (!isValid) {
        print('DEBUG: Invalid A2UI JSON detected: $code');
      }
      return isValid;
    } catch (e) {
      print('DEBUG: A2UI JSON Decode Error: $e, Payload: $code');
      return false;
    }
  }

  static bool _isA2uiMap(Map<String, dynamic> map) {
    final List<String> a2uiKeys = [
      'createSurface', 'updateComponents', 'beginRendering', 'surfaceUpdate',
      'messageType', 'type', 'surfaceId', 'id'
    ];
    return map.keys.any((key) => a2uiKeys.contains(key));
  }

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
      final String? type = msg['messageType']?.toString() ?? msg['type']?.toString();
      
      if (type == 'createSurface' || type == 'updateComponents') {
        final String sid = (msg['surfaceId'] ?? msg['id'] ?? 'main').toString();
        setState(() => _surfaceId = sid);


        final List<Component> transformed = [];
        
        // Handle 'components' list directly in message
        if (msg.containsKey('components') && msg['components'] is List) {
          for (var c in (msg['components'] as List)) {
            transformed.add(Component.fromJson(_transformComponent(c as Map<String, dynamic>)));
          }
        }
        
        // Handle 'root' component
        if (msg.containsKey('root')) {
          final rootData = Map<String, dynamic>.from(msg['root'] as Map<String, dynamic>);
          rootData['id'] = '${sid}_root';
          transformed.add(Component.fromJson(_transformComponent(rootData)));
        }

        // Handle 'layout' as a root container
        if (msg.containsKey('layout') && msg['layout'] is Map) {
            final layoutData = Map<String, dynamic>.from(msg['layout'] as Map<String, dynamic>);
            layoutData['id'] = '${sid}_root';
            transformed.add(Component.fromJson(_transformComponent(layoutData)));
        }

        // Support for 'concept: Card' or 'surfaceType: Card'
        if (msg['concept'] == 'Card' || msg['surfaceType'] == 'Card') {
          final cardProps = Map<String, dynamic>.from(msg['style'] ?? {});
          if (msg.containsKey('title')) cardProps['title'] = msg['title'];

          final List<Map<String, dynamic>> innerTransformed = [];
          if (msg.containsKey('components') && msg['components'] is List) {
            for (var c in (msg['components'] as List)) {
              innerTransformed.add(_transformComponent(c as Map<String, dynamic>));
            }
          }

          final Map<String, dynamic> cardComp = {
            'id': '${sid}_root_card',
            'component': {
              'Card': {
                ...cardProps,
                if (innerTransformed.isNotEmpty)
                  'child': innerTransformed.length > 1 
                      ? {
                          'id': '${sid}_card_inner',
                          'component': {
                            'Column': {
                              'children': innerTransformed,
                              'crossAxisAlignment': 'center',
                            }
                          }
                        }
                      : innerTransformed.first
              }
            }
          };
          transformed.clear();
          transformed.add(Component.fromJson(cardComp));
        }

        if (transformed.isNotEmpty) {
          final String rootId = transformed.any((c) => c.id == '${sid}_root') 
              ? '${sid}_root' 
              : transformed.first.id;

          if (type == 'createSurface') {
             _processor.handleMessage(BeginRendering(surfaceId: sid, root: rootId));
          }

          _processor.handleMessage(SurfaceUpdate(
            surfaceId: sid,
            components: transformed,
          ));
        }
        return;
      }

      // Default Flavor 1 & 2: createSurface/updateComponents as keys
      if (msg.containsKey('createSurface')) {
        final data = msg['createSurface'] as Map<String, dynamic>;
        final String sid = (data['surfaceId'] ?? data['id'] ?? 'main').toString();
        setState(() => _surfaceId = sid);
        
        _processor.handleMessage(BeginRendering(surfaceId: sid, root: '${sid}_root'));
        
        if (data.containsKey('root')) {
            final rootData = Map<String, dynamic>.from(data['root'] as Map<String, dynamic>);
            rootData['id'] = '${sid}_root'; // Ensure root component has the predicted ID
            final rootComp = Component.fromJson(_transformComponent(rootData));
             _processor.handleMessage(SurfaceUpdate(
              surfaceId: sid,
              components: [rootComp],
            ));
        }
      } else if (msg.containsKey('updateComponents')) {
        final data = msg['updateComponents'] as Map<String, dynamic>;
        final String sid = (data['surfaceId'] ?? data['id'] ?? _surfaceId ?? 'main').toString();
        
        final List<dynamic> rawComponents = data['components'] as List<dynamic>;
        final List<Component> transformed = rawComponents
            .map((c) => Component.fromJson(_transformComponent(c as Map<String, dynamic>)))
            .toList();

        _processor.handleMessage(SurfaceUpdate(
          surfaceId: sid,
          components: transformed,
        ));
      } else {
        // Final fallback to the library's fromJson
        _processor.handleMessage(A2uiMessage.fromJson(msg));
        if (msg.containsKey('beginRendering')) {
          setState(() => _surfaceId = msg['beginRendering']['surfaceId']?.toString());
        }
      }
    } catch (e) {
      print('DEBUG: Message handling error: $e');
    }
  }

  Map<String, dynamic> _transformComponent(Map<String, dynamic> raw) {
    final Map<String, dynamic> result = {};
    
    // 1. Extract ID
    final String id = (raw['id'] ?? raw['componentId'] ?? 'comp_${DateTime.now().microsecondsSinceEpoch}').toString();
    result['id'] = id;
    
    // 2. Extract Type
    String type = raw['component']?.toString() ?? 
                  raw['componentType']?.toString() ?? 
                  raw['type']?.toString() ?? 'Column';
    
    if (type == 'Group') {
      type = (raw['layout'] == 'horizontal') ? 'Row' : 'Column';
    }

    final Map<String, dynamic> props = Map<String, dynamic>.from(raw);
    props.remove('id');
    props.remove('componentId');
    props.remove('component');
    props.remove('componentType');
    props.remove('type');

    // Normalize Image/Icon fields
    if (type == 'Image' || type == 'Icon') {
        if (props.containsKey('icon') && props['icon'] != null) {
            props['src'] = props['icon'].toString();
        }
        if (props.containsKey('iconName') && props['iconName'] != null) {
            props['src'] = props['iconName'].toString();
        }
    }

    // Normalize font weight
    if (props.containsKey('fontWeight')) {
        final fw = props['fontWeight'].toString().toLowerCase();
        int weight = 400; // default
        if (fw.contains('bold') || fw == '700') weight = 700;
        else if (fw.contains('extrabold') || fw == '800' || fw == '900') weight = 900;
        else if (fw.contains('semibold') || fw == '600') weight = 600;
        else if (fw.contains('medium') || fw == '500') weight = 500;
        else if (fw.contains('light') || fw == '300') weight = 300;
        else if (fw.contains('thin') || fw == '100') weight = 100;
        props['fontWeight'] = weight;
    }

    // Normalize font sizes
    if (props.containsKey('fontSize')) {
        final fs = props['fontSize'].toString().toLowerCase();
        double size = 16.0;
        if (fs == 'xs') size = 12.0;
        else if (fs == 'sm') size = 14.0;
        else if (fs == 'md' || fs == 'base') size = 16.0;
        else if (fs == 'lg') size = 18.0;
        else if (fs == 'xl') size = 20.0;
        else if (fs == '2xl') size = 24.0;
        else if (fs == '3xl') size = 30.0;
        else if (fs == '4xl') size = 36.0;
        else if (fs == '5xl') size = 48.0;
        else {
            final parsed = double.tryParse(fs.replaceAll(RegExp(r'[^0-9.]'), ''));
            if (parsed != null) size = parsed;
        }
        props['fontSize'] = size;
    }
    
    // 3. Process children recursively
    if (props.containsKey('children') && props['children'] is List) {
      props['children'] = (props['children'] as List)
          .map((c) => _transformComponent(c as Map<String, dynamic>))
          .toList();
    } else if (props.containsKey('components') && props['components'] is List) {
      props['children'] = (props['components'] as List)
          .map((c) => _transformComponent(c as Map<String, dynamic>))
          .toList();
      props.remove('components');
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
