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
      final String? type = msg['messageType']?.toString() ?? msg['type']?.toString();
      final List<Component> collector = [];

      if (type == 'createSurface' || type == 'updateComponents') {
        final String sid = (msg['surfaceId'] ?? msg['id'] ?? 'main').toString();
        if (!_surfaceIds.contains(sid)) {
          setState(() => _surfaceIds.add(sid));
        }

        if (msg.containsKey('components') && msg['components'] is List) {
          for (var c in (msg['components'] as List)) {
            _flattenComponent(c as Map<String, dynamic>, collector);
          }
        }
        
        if (msg.containsKey('root')) {
          final rootData = Map<String, dynamic>.from(msg['root'] as Map<String, dynamic>);
          rootData['id'] = rootData['id'] ?? '${sid}_root';
          _flattenComponent(rootData, collector);
        }

        if (msg.containsKey('layout') && msg['layout'] is Map) {
          final layoutData = Map<String, dynamic>.from(msg['layout'] as Map<String, dynamic>);
          layoutData['id'] = layoutData['id'] ?? '${sid}_root';
          _flattenComponent(layoutData, collector);
        }

        if (msg['concept'] == 'Card' || msg['surfaceType'] == 'Card') {
          final String cardId = '${sid}_root_card';
          final Map<String, dynamic> cardProps = Map<String, dynamic>.from(msg['style'] ?? {});
          if (msg.containsKey('title')) cardProps['title'] = msg['title'];

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
      }

      // Legacy/Alternative Flavors
      if (msg.containsKey('createSurface')) {
        final data = msg['createSurface'] as Map<String, dynamic>;
        final String sid = (data['surfaceId'] ?? data['id'] ?? 'main').toString();
        if (!_surfaceIds.contains(sid)) {
          setState(() => _surfaceIds.add(sid));
        }
        
        final List<Component> components = [];
        String? rid;

        if (data.containsKey('root')) {
          final rootData = Map<String, dynamic>.from(data['root'] as Map<String, dynamic>);
          rid = (rootData['id'] ?? '${sid}_root').toString();
          rootData['id'] = rid;
          _flattenComponent(rootData, components);
        } else if (data.containsKey('components') && data['components'] is List) {
          for (var c in (data['components'] as List)) {
            _flattenComponent(c as Map<String, dynamic>, components);
          }
          if (components.isNotEmpty) rid = components.first.id;
        }

        if (rid != null) {
          _processor.handleMessage(BeginRendering(surfaceId: sid, root: rid));
          _processor.handleMessage(SurfaceUpdate(surfaceId: sid, components: components));
        }
      } else if (msg.containsKey('updateComponents')) {
        final data = msg['updateComponents'] as Map<String, dynamic>;
        final String sid = (data['surfaceId'] ?? data['id'] ?? (_surfaceIds.isNotEmpty ? _surfaceIds.last : 'main')).toString();
        
        final List<Component> components = [];
        if (data.containsKey('components') && data['components'] is List) {
          for (var c in (data['components'] as List)) {
            _flattenComponent(c as Map<String, dynamic>, components);
          }
        }
        _processor.handleMessage(SurfaceUpdate(surfaceId: sid, components: components));
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
    
    if (type == 'Group' || type == 'Stack') {
      final String dir = (raw['direction'] ?? raw['layout'] ?? (raw['props'] is Map ? raw['props']['direction'] : null))?.toString() ?? 'vertical';
      type = (dir == 'horizontal') ? 'Row' : 'Column';
    }

    final Map<String, dynamic> props = Map<String, dynamic>.from(raw);
    
    // Handle 'props' object wrapper
    if (props.containsKey('props') && props['props'] is Map) {
      props.addAll(Map<String, dynamic>.from(props['props'] as Map));
      props.remove('props');
    }

    props.remove('id');
    props.remove('componentId');
    props.remove('component');
    props.remove('componentType');
    props.remove('type');

    _normalizeProperties(type, props);

    // Recursively flatten children if they are objects
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
