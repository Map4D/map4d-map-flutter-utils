import 'package:flutter/services.dart';
import 'package:map4d_map/map4d_map.dart';

import 'cluster_algorithm.dart';
import 'cluster_renderer.dart';
import '../map_utils_channel.dart';

part 'cluster.dart';
part 'cluster_item.dart';

///
///
///
class MFClusterManager {

  MFClusterManager({
    required this.controller,
    this.algorithm = const MFNonHierarchicalDistanceBasedAlgorithm(),
    this.renderer = const MFDefaultClusterRenderer(),
  }) {
    Map<String, Object> data = <String, Object>{};
    data['algorithmName'] = _getClusterAlgorithmName();
    data['rendererName'] = _getClusterRendererName();

    String name = MapUtilsChannel.createPlatformClusterManager(controller.mapId, data);
    _channel = MethodChannel(name);
    _channel.setMethodCallHandler((call) => _methodCallHandler(call));

    _items = <MFClusterItem>[];
    _itemNoCounter = 1;
  }

  ///
  final MFMapViewController controller;

  ///
  final MFClusterAlgorithm algorithm;

  ///
  final MFClusterRenderer renderer;

  ///
  late final MethodChannel _channel;

  ///
  late final List<MFClusterItem> _items;

  late int _itemNoCounter;

  ///
  Future<void> cluster() {
    return _channel.invokeListMethod('cluster#cluster');
  }

  ///
  Future<void> addItem(MFClusterItem item) {
    if (item._itemNo != null) {
      throw Exception('Cluster item already exists');
    }

    item._itemNo = _itemNoCounter++;
    _items.add(item);
    return _channel.invokeListMethod('cluster#addItem', <String, Object>{
      'item': item.toJson()
    });
  }

  ///
  Future<void> addItems(List<MFClusterItem> items) {
    final List<Object> jsonItems = <Object>[];
    for (final MFClusterItem item in items) {
      if (item._itemNo != null) {
        throw Exception('Cluster item already exists: ${item.toJson()}');
      }

      item._itemNo = _itemNoCounter++;
      _items.add(item);
      jsonItems.add(item.toJson());
    }
    return _channel.invokeListMethod('cluster#addItems', <String, Object>{
      'items': jsonItems
    });
  }

  ///
  Future<void> removeItem(MFClusterItem item) {
    if (item._itemNo == null) {
      throw Exception('Cluster item not exists');
    }

    Object itemJson = item.toJson();
    item._itemNo = null;
    return _channel.invokeListMethod('cluster#removeItem', <String, Object>{
      'item': itemJson
    });
  }

  ///
  Future<void> clearItems() {
    for (final item in _items) {
      item._itemNo = null;
    }
    _items.clear();
    return _channel.invokeListMethod('cluster#clearItems');
  }

  /// Handle message from platform.
  Future<dynamic> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      default:
        throw Exception('Unknow callback method: ${call.method}');
    }
  }

  String _getClusterAlgorithmName() {
    if (algorithm is MFGridBasedAlgorithm) {
      return 'MFGridBasedAlgorithm';
    }
    
    if (algorithm is MFNonHierarchicalDistanceBasedAlgorithm) {
      return 'MFNonHierarchicalDistanceBasedAlgorithm';
    }
    
    return 'CustomAlgorithm';
  }

  String _getClusterRendererName() {
    if (renderer is MFDefaultClusterRenderer) {
      return 'MFDefaultClusterRenderer';
    }

    return 'CustomRenderer';
  }
}