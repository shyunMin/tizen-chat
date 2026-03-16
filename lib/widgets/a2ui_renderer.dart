import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';

class A2uiRenderer extends StatefulWidget {
  final String uiCode;

  const A2uiRenderer({super.key, required this.uiCode});

  static bool isValidJson(String? code) {
    if (code == null || code.isEmpty) return false;
    try {
      final decoded = jsonDecode(code);
      if (decoded is List) {
        if (decoded.isEmpty) return false;
        final first = decoded.first;
        if (first is Map) return _isA2uiMap(first);
      } else if (decoded is Map) {
        if (decoded.containsKey('messages')) return true;
        return _isA2uiMap(decoded);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static bool _isA2uiMap(Map map) {
    // Unique A2UI keys that are unlikely to appear in random JSON
    const List<String> uniqueA2uiKeys = [
      'createSurface', 'updateComponents', 'beginRendering', 'surfaceUpdate',
      'rootComponent', 'surfaceType'
    ];
    // Common A2UI keys
    const List<String> commonA2uiKeys = [
      'messageType', 'type', 'components', 'root', 'layout', 'concept', 
      'child', 'children', 'component'
    ];
    
    final keys = map.keys.map((k) => k.toString()).toList();
    if (keys.any((key) => uniqueA2uiKeys.contains(key))) return true;
    
    // If it has at least two common keys, it's likely A2UI
    int matches = keys.where((key) => commonA2uiKeys.contains(key)).length;
    return matches >= 2;
  }

  @override
  State<A2uiRenderer> createState() => _A2uiRendererState();
}

class _A2uiRendererState extends State<A2uiRenderer> {
  late A2uiMessageProcessor _processor;
  final List<String> _surfaceIds = [];
  bool _hasError = false;
  static int _idCounter = 0;

  @override
  void initState() {
    super.initState();
    _processor = A2uiMessageProcessor(catalogs: [CoreCatalogItems.asCatalog()]);
    _parseAndProcess();
  }

  @override
  void didUpdateWidget(A2uiRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uiCode != widget.uiCode) {
      _parseAndProcess();
    }
  }

  void _parseAndProcess() {
    try {
      _surfaceIds.clear();
      _hasError = false;
      final decoded = jsonDecode(widget.uiCode);
      _processItem(decoded);
    } catch (e) {
      print('DEBUG: A2UI Parse Error: $e');
      _hasError = true;
      if (mounted) setState(() {});
    }
  }

  void _processItem(dynamic item) {
    if (item is List) {
      if (item.isNotEmpty && item.first is Map && (item.first as Map).containsKey('component')) {
         // Flavor: Raw component list
         final List<Component> components = [];
         String? rootId;
         for (var element in item) {
           if (element is Map) {
             final data = Map<String, dynamic>.from(element);
             final id = (data['id'] ?? data['componentId'] ?? 'root').toString();
             if (id == 'root' || rootId == null) rootId = id;
             _flattenComponent(data, components);
           }
         }
         if (rootId != null) {
           _processor.handleMessage(BeginRendering(surfaceId: 'main', root: rootId));
           _processor.handleMessage(SurfaceUpdate(surfaceId: 'main', components: components));
           if (!_surfaceIds.contains('main')) {
             setState(() => _surfaceIds.add('main'));
           }
         }
      } else {
        for (var element in item) {
          _processItem(element);
        }
      }
    } else if (item is Map) {
      final map = Map<String, dynamic>.from(item);
      if (map.containsKey('messages') && map['messages'] is List) {
        for (var msg in (map['messages'] as List)) {
          _processItem(msg);
        }
      } else {
        _handleRawMessage(map);
      }
    }
  }

  void _handleRawMessage(Map<String, dynamic> msg) {
    try {
      String? type = (msg['messageType'] ?? msg['type'])?.toString();
      Map<String, dynamic> data = msg;

      if (type == null) {
        if (msg.containsKey('createSurface')) {
          type = 'createSurface';
          data = Map<String, dynamic>.from(msg['createSurface'] as Map);
        } else if (msg.containsKey('updateComponents')) {
          type = 'updateComponents';
          data = Map<String, dynamic>.from(msg['updateComponents'] as Map);
        }
      }

      if (type == 'createSurface' || type == 'updateComponents') {
        final sid = (data['surfaceId'] ?? data['id'] ?? 'main').toString();
        if (!_surfaceIds.contains(sid)) {
          setState(() => _surfaceIds.add(sid));
        }

        final List<Component> collector = [];
        
        if (data.containsKey('components') && data['components'] is List) {
          for (var c in (data['components'] as List)) {
            if (c is Map) _flattenComponent(Map<String, dynamic>.from(c), collector);
          }
        }

        for (var key in ['root', 'rootComponent']) {
          if (data.containsKey(key)) {
            final r = data[key];
            if (r is Map) {
              final rootData = Map<String, dynamic>.from(r);
              rootData['id'] = rootData['id'] ?? '${sid}_root';
              _flattenComponent(rootData, collector);
            }
          }
        }

        if (data.containsKey('layout') && data['layout'] is Map) {
          final layoutData = Map<String, dynamic>.from(data['layout'] as Map);
          final rid = (layoutData['id'] ?? layoutData['componentId'] ?? '${sid}_root').toString();
          layoutData['id'] = rid;
          _flattenComponent(layoutData, collector);
        }

        if (collector.isNotEmpty) {
          final rootId = collector.any((c) => c.id == '${sid}_root') ? '${sid}_root' : collector.first.id;
          if (type == 'createSurface') {
            _processor.handleMessage(BeginRendering(surfaceId: sid, root: rootId));
          }
          _processor.handleMessage(SurfaceUpdate(surfaceId: sid, components: collector));
        }
      } else {
        _processor.handleMessage(A2uiMessage.fromJson(msg));
      }
    } catch (e) {
      print('DEBUG: Message handle error: $e');
    }
  }

  void _flattenComponent(Map<String, dynamic> raw, List<Component> collector) {
    final String id = raw['id']?.toString() ?? 
                     raw['componentId']?.toString() ?? 
                     'comp_${++_idCounter}_${DateTime.now().millisecond}';
    
    String typeRaw = (raw['componentType'] ?? raw['type'] ?? 'Column').toString();
    Map<String, dynamic> props = Map<String, dynamic>.from(raw);

    if (raw['component'] is Map) {
      final compMap = raw['component'] as Map;
      if (compMap.isNotEmpty) {
        typeRaw = compMap.keys.first.toString();
        props.addAll(Map<String, dynamic>.from(compMap[typeRaw] as Map));
      }
    }

    String type = _normalizeType(typeRaw);
    
    if (props.containsKey('props') && props['props'] is Map) props.addAll(Map<String, dynamic>.from(props['props'] as Map));
    if (props.containsKey('style') && props['style'] is Map) props.addAll(Map<String, dynamic>.from(props['style'] as Map));
    if (props.containsKey('styles') && props['styles'] is Map) props.addAll(Map<String, dynamic>.from(props['styles'] as Map));

    // Resolve literalString/path
    props.forEach((key, value) {
      if (value is Map) {
        if (value.containsKey('literalString')) props[key] = value['literalString'];
        else if (value.containsKey('path')) props[key] = value['path'];
      }
    });

    if (props['children'] is Map && (props['children'] as Map).containsKey('explicitList')) {
      props['children'] = (props['children'] as Map)['explicitList'];
    }

    _normalizeProperties(type, props);

    if (props['children'] is List) {
      final List<String> childIds = [];
      for (var child in (props['children'] as List)) {
        if (child is Map) {
          final childMap = Map<String, dynamic>.from(child);
          _flattenComponent(childMap, collector);
          childIds.add(childMap['id']?.toString() ?? 'unknown');
        } else if (child is String) {
          childIds.add(child);
        }
      }
      props['children'] = childIds;
    }

    collector.add(Component(id: id, componentProperties: {type: props}));
  }

  String _normalizeType(String raw) {
    if (raw.isEmpty) return 'Container';
    raw = raw.toLowerCase();
    if (raw == 'text') return 'Text';
    if (raw == 'image') return 'Image';
    if (raw == 'icon') return 'Icon';
    if (raw == 'button') return 'Button';
    if (raw == 'card') return 'Card';
    if (raw == 'divider') return 'Divider';
    if (raw == 'container' || raw == 'hstack' || raw == 'vstack' || raw == 'group' || raw == 'column' || raw == 'row') return 'Container';
    return raw[0].toUpperCase() + raw.substring(1);
  }

  void _normalizeProperties(String type, Map<String, dynamic> props) {
    if (type == 'Image' || type == 'Icon') {
      props['src'] = (props['src'] ?? props['url'] ?? props['source'] ?? props['name'] ?? props['icon'])?.toString();
    }
    // Simple unit conversion
    props.forEach((key, value) {
      if (value is String && value.endsWith('px')) {
        props[key] = double.tryParse(value.replaceAll('px', '')) ?? 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) return const Center(child: Text('Render Error'));
    if (_surfaceIds.isEmpty) return const SizedBox.shrink();
    
    return Column(
      children: _surfaceIds.map<Widget>((sid) => GenUiSurface(
        surfaceId: sid,
        host: _processor,
      )).toList(),
    );
  }
}
