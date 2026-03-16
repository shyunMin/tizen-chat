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
      'messageType', 'type', 'surfaceId', 'id', 'components', 'root', 
      'layout', 'concept', 'child', 'children', 'surfaceType', 'messages', 'version'
    ];
    return map.keys.any((key) => a2uiKeys.any((aKey) => map.containsKey(aKey)));
  }

  @override
  State<A2uiRenderer> createState() => _A2uiRendererState();
}

class _A2uiRendererState extends State<A2uiRenderer> {
  late A2uiMessageProcessor _processor;
  final List<String> _surfaceIds = [];
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    // Use CoreCatalogItems from genui package
    _processor = A2uiMessageProcessor(catalogs: [CoreCatalogItems.asCatalog()]);
    _parseAndProcess();
  }

  @override
  void didUpdateWidget(A2uiRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.uiCode != oldWidget.uiCode) {
      _parseAndProcess();
    }
  }

  void _parseAndProcess() {
    try {
      final decoded = jsonDecode(widget.uiCode);
      _processItem(decoded);
    } catch (e) {
      print('DEBUG: A2UI Parse Error: $e');
      setState(() {
        _hasError = true;
      });
    }
  }

  void _processItem(dynamic item) {
    if (item is List) {
      for (var element in item) {
        _processItem(element);
      }
    } else if (item is Map<String, dynamic>) {
      if (item.containsKey('messages') && item['messages'] is List) {
        for (var msg in (item['messages'] as List)) {
          _processItem(msg);
        }
      } else if (item.containsKey('surfaceId') || 
                 item.containsKey('id') || 
                 item.containsKey('createSurface') || 
                 item.containsKey('updateComponents') ||
                 item.containsKey('type')) {
        _handleRawMessage(item);
      }
    }
  }

  void _handleRawMessage(Map<String, dynamic> msg) {
    try {
      String? type = msg['messageType']?.toString() ?? msg['type']?.toString();
      Map<String, dynamic> data = msg;

      // Extract type from keys if not explicitly defined
      if (type == null) {
        if (msg.containsKey('createSurface')) {
          type = 'createSurface';
          data = Map<String, dynamic>.from(msg['createSurface'] as Map);
        } else if (msg.containsKey('updateComponents')) {
          type = 'updateComponents';
          data = Map<String, dynamic>.from(msg['updateComponents'] as Map);
        }
      }

      final List<Component> collector = [];

      if (type == 'createSurface' || type == 'updateComponents') {
        final String sid = (data['surfaceId'] ?? data['id'] ?? 'main').toString();
        if (!_surfaceIds.contains(sid)) {
          setState(() => _surfaceIds.add(sid));
        }

        if (data.containsKey('components') && data['components'] is List) {
          for (var c in (data['components'] as List)) {
            _flattenComponent(c as Map<String, dynamic>, collector);
          }
        }
        
        if (data.containsKey('root')) {
          final rootData = Map<String, dynamic>.from(data['root'] as Map<String, dynamic>);
          rootData['id'] = rootData['id'] ?? '${sid}_root';
          _flattenComponent(rootData, collector);
        }

        if (data.containsKey('layout') && data['layout'] is Map) {
          final layoutData = Map<String, dynamic>.from(data['layout'] as Map<String, dynamic>);
          final String rid = (layoutData['id'] ?? layoutData['componentId'] ?? '${sid}_root').toString();
          layoutData['id'] = rid;
          _flattenComponent(layoutData, collector);
        }

        if (data['concept'] == 'Card' || data['surfaceType'] == 'Card') {
          final String cardId = '${sid}_root_card';
          final Map<String, dynamic> cardProps = Map<String, dynamic>.from(data['style'] ?? {});
          if (data.containsKey('title')) cardProps['title'] = data['title'];

          final List<String> childrenIds = collector.map((c) => c.id).toList();
          if (childrenIds.isNotEmpty) {
            String finalChildId;
            if (childrenIds.length > 1) {
              finalChildId = '${sid}_card_column';
              collector.add(Component(
                id: finalChildId,
                componentProperties: {
                  'Column': {
                    'children': childrenIds,
                    'crossAxisAlignment': 'center',
                  }
                }
              ));
            } else {
              finalChildId = childrenIds.first;
            }
            cardProps['child'] = finalChildId;
          }

          collector.add(Component(
            id: cardId,
            componentProperties: {'Card': cardProps}
          ));
        }

        if (collector.isNotEmpty) {
          final String rootId = collector.any((c) => c.id == '${sid}_root') 
              ? '${sid}_root' 
              : (collector.any((c) => c.id == '${sid}_root_card') ? '${sid}_root_card' : collector.first.id);

          if (type == 'createSurface') {
            _processor.handleMessage(BeginRendering(surfaceId: sid, root: rootId));
          }

          _processor.handleMessage(SurfaceUpdate(
            surfaceId: sid,
            components: collector,
          ));
        }
        return;
      } else {
        _processor.handleMessage(A2uiMessage.fromJson(msg));
        if (msg.containsKey('beginRendering')) {
          final sid = msg['beginRendering']['surfaceId']?.toString();
          if (sid != null && !_surfaceIds.contains(sid)) {
            setState(() => _surfaceIds.add(sid));
          }
        }
      }
    } catch (e) {
      print('DEBUG: Message handling error: $e');
    }
  }

  void _flattenComponent(Map<String, dynamic> raw, List<Component> collector) {
    final String id = (raw['id'] ?? raw['componentId'] ?? 'comp_${DateTime.now().microsecondsSinceEpoch}_${collector.length}').toString();
    String type = (raw['component'] ?? raw['componentType'] ?? raw['type'] ?? 'Column').toString();
    
    final Map<String, dynamic> props = Map<String, dynamic>.from(raw);
    
    // Merge 'props' or 'style' object wrappers into top-level
    if (props.containsKey('props') && props['props'] is Map) {
      props.addAll(Map<String, dynamic>.from(props['props'] as Map));
      props.remove('props');
    }
    if (props.containsKey('style') && props['style'] is Map) {
      props.addAll(Map<String, dynamic>.from(props['style'] as Map));
      // We don't necessarily remove 'style' as some widgets might use it, but common props are now top-level
    }

    if (type == 'Group' || type == 'Stack' || type == 'Container' || type == 'VStack' || type == 'HStack') {
      final String dir = (props['direction'] ?? props['layout'] ?? 
                         (type == 'HStack' ? 'horizontal' : 'vertical')).toString().toLowerCase();
      type = (dir == 'horizontal' || type == 'HStack') ? 'Row' : 'Column';
    }

    props.remove('id');
    props.remove('componentId');
    props.remove('component');
    props.remove('componentType');
    props.remove('type');

    // Handle nested 'size' object: {width: X, height: Y}
    if (props.containsKey('size') && props['size'] is Map) {
      final sizeMap = props['size'] as Map;
      if (sizeMap.containsKey('width')) props['width'] = sizeMap['width'];
      if (sizeMap.containsKey('height')) props['height'] = sizeMap['height'];
    }

    // Handle nested 'border' object
    if (props.containsKey('border') && props['border'] is Map) {
       final borderMap = props['border'] as Map;
       if (borderMap.containsKey('width')) props['borderWidth'] = borderMap['width'];
       if (borderMap.containsKey('color')) props['borderColor'] = borderMap['color'];
    }

    // Handle 'label' as an object for Buttons
    if (type == 'Button' && props.containsKey('label') && props['label'] is Map) {
      final labelMap = props['label'] as Map;
      if (labelMap.containsKey('text')) props['label'] = labelMap['text'];
    }

    _normalizeProperties(type, props);

    // Recursively flatten children
    if (props.containsKey('children') && props['children'] is List) {
      final List<dynamic> rawChildren = props['children'] as List<dynamic>;
      final List<String> childIds = [];
      for (var childJson in rawChildren) {
        if (childJson is Map<String, dynamic>) {
          final String childId = (childJson['id'] ?? childJson['componentId'] ?? 'comp_${DateTime.now().microsecondsSinceEpoch}_${collector.length}_${childIds.length}').toString();
          childJson['id'] = childId;
          childIds.add(childId);
          _flattenComponent(childJson, collector);
        } else if (childJson is String) {
          childIds.add(childJson);
        }
      }
      props['children'] = childIds;
    } else if (props.containsKey('components') && props['components'] is List) {
      final List<dynamic> rawChildren = props['components'] as List<dynamic>;
      final List<String> childIds = [];
      for (var childJson in rawChildren) {
        if (childJson is Map<String, dynamic>) {
          final String childId = (childJson['id'] ?? childJson['componentId'] ?? 'comp_${DateTime.now().microsecondsSinceEpoch}_${collector.length}_${childIds.length}').toString();
          childJson['id'] = childId;
          childIds.add(childId);
          _flattenComponent(childJson, collector);
        } else if (childJson is String) {
           childIds.add(childJson);
        }
      }
      props['children'] = childIds;
      props.remove('components');
    }

    if (props.containsKey('child') && props['child'] is Map) {
      final Map<String, dynamic> childJson = Map<String, dynamic>.from(props['child'] as Map);
      final String childId = (childJson['id'] ?? childJson['componentId'] ?? 'comp_${DateTime.now().microsecondsSinceEpoch}_child').toString();
      childJson['id'] = childId;
      props['child'] = childId;
      _flattenComponent(childJson, collector);
    }

    collector.add(Component(
      id: id,
      componentProperties: {type: props},
    ));
  }

  void _normalizeProperties(String type, Map<String, dynamic> props) {
    if (type == 'Image' || type == 'Icon') {
      if (props.containsKey('icon')) props['src'] = props['icon'].toString();
      if (props.containsKey('iconName')) props['src'] = props['iconName'].toString();
      if (props.containsKey('source')) props['src'] = props['source'].toString();
    }

    // Convert CSS-like units to numbers
    final List<String> numericKeys = ['padding', 'borderRadius', 'gap', 'spacing', 'width', 'height', 'fontSize', 'marginBottom', 'marginTop', 'marginLeft', 'marginRight'];
    for (var key in numericKeys) {
      if (props.containsKey(key)) {
        final val = props[key].toString().toLowerCase();
        if (val == 'full') {
            props[key] = 999.0;
            continue;
        }
        final parsed = double.tryParse(val.replaceAll(RegExp(r'[^0-9.]'), ''));
        if (parsed != null) {
          props[key] = parsed;
        }
      }
    }

    if (props.containsKey('fontWeight')) {
      final fw = props['fontWeight'].toString().toLowerCase();
      int weight = 400;
      if (fw.contains('bold') || fw == '700') weight = 700;
      else if (fw.contains('extrabold') || fw == '800' || fw == '900') weight = 900;
      else if (fw.contains('semibold') || fw == '600') weight = 600;
      else if (fw.contains('medium') || fw == '500') weight = 500;
      else if (fw.contains('light') || fw == '300') weight = 300;
      else if (fw.contains('thin') || fw == '100') weight = 100;
      props['fontWeight'] = weight;
    }

    // Specific mapping for fontSize if not already a double
    if (props.containsKey('fontSize') && props['fontSize'] is! double) {
      final fs = props['fontSize'].toString().toLowerCase();
      if (fs == 'xs') props['fontSize'] = 12.0;
      else if (fs == 'sm') props['fontSize'] = 14.0;
      else if (fs == 'md' || fs == 'base') props['fontSize'] = 16.0;
      else if (fs == 'lg') props['fontSize'] = 18.0;
      else if (fs == 'xl') props['fontSize'] = 20.0;
      else if (fs == '2xl') props['fontSize'] = 24.0;
      else if (fs == '3xl') props['fontSize'] = 30.0;
      else if (fs == '4xl') props['fontSize'] = 36.0;
      else if (fs == '5xl') props['fontSize'] = 48.0;
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

    if (_surfaceIds.isEmpty) {
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _surfaceIds.map((sid) => GenUiSurface(
          key: ValueKey(sid),
          surfaceId: sid,
          host: _processor,
        )).toList(),
      ),
    );
  }
}
