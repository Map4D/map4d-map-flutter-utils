import 'package:flutter/services.dart';
import 'package:map4d_map/map4d_map.dart';

import 'cluster_algorithm.dart';
import 'cluster_renderer.dart';
import '../map_utils_channel.dart';

part 'cluster.dart';
part 'cluster_item.dart';
part 'cluster_implement.dart';

/// This is used in [MFClusterManager.onClusterTap].
typedef MFClusterCallback = void Function(MFCluster cluster);

/// This is used in [MFClusterManager.onClusterItemTap].
typedef MFClusterItemCallback = void Function(MFClusterItem clusterItem);

/// This class groups many items on a map based on zoom level.
/// Cluster items should be added to the map via this class.
class MFClusterManager {
  MFClusterManager({
    required this.controller,
    this.algorithm = const MFNonHierarchicalDistanceBasedAlgorithm(),
    this.renderer = const MFDefaultClusterRenderer(),
    this.onClusterTap,
    this.onClusterItemTap,
  }) {
    Map<String, Object> data = <String, Object>{};
    data['algorithmName'] = _getClusterAlgorithmName();
    data['rendererName'] = _getClusterRendererName();

    String name =
        MapUtilsChannel.createPlatformClusterManager(controller.mapId, data);
    _channel = MethodChannel(name);
    _channel.setMethodCallHandler((call) => _methodCallHandler(call));

    _items = <MFClusterItem>[];
    _itemNoCounter = 1;
  }

  /// Controller of the [MFMapView] to add cluster items.
  final MFMapViewController controller;

  /// Clustering algorithm.
  final MFClusterAlgorithm algorithm;

  /// Clustering renderer.
  final MFClusterRenderer renderer;

  /// Called when the user taps on a cluster marker.
  final MFClusterCallback? onClusterTap;

  /// Called when the user taps on a cluster item marker.
  final MFClusterItemCallback? onClusterItemTap;

  /// Channel for communicating with platform cluster manager.
  late final MethodChannel _channel;

  /// Cluster items collection.
  late final List<MFClusterItem> _items;

  /// Used to number items added to the collection.
  late int _itemNoCounter;

  /// Called to arrange items into groups.
  /// - This method will be automatically invoked when the map's zoom level changes.
  /// - Manually invoke this method when new items have been added to rearrange items.
  /// You should call this after adding, removing, updating.
  Future<void> cluster() {
    return _channel.invokeListMethod('cluster#cluster');
  }

  /// Adds a cluster item to the collection.
  Future<void> addItem(MFClusterItem item) {
    if (item._itemNo != null) {
      throw Exception('Cluster item already exists');
    }

    item._itemNo = _itemNoCounter++;
    _items.add(item);
    return _channel.invokeListMethod(
        'cluster#addItem', <String, Object>{'item': item._toJson()});
  }

  /// Adds multiple cluster items to the collection.
  Future<void> addItems(List<MFClusterItem> items) {
    final List<Object> jsonItems = <Object>[];
    for (final MFClusterItem item in items) {
      if (item._itemNo != null) {
        throw Exception('Cluster item already exists: ${item.toString()}');
      }

      item._itemNo = _itemNoCounter++;
      _items.add(item);
      jsonItems.add(item._toJson());
    }
    return _channel.invokeListMethod(
        'cluster#addItems', <String, Object>{'items': jsonItems});
  }

  /// Removes a cluster item from the collection.
  Future<void> removeItem(MFClusterItem item) {
    if (item._itemNo == null) {
      throw Exception('Cluster item not exists');
    }

    Object itemJson = item._toJson();
    item._itemNo = null;
    return _channel.invokeListMethod(
        'cluster#removeItem', <String, Object>{'item': itemJson});
  }

  /// Removes all items from the collection.
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
      case 'cluster#onClusterTap':
        if (onClusterTap != null) {
          final position = MFLatLng.fromJson(call.arguments['position']);
          final itemNos = call.arguments['itemNos'] as List;
          List<MFClusterItem> items = <MFClusterItem>[];
          for (final itemNo in itemNos) {
            final clusterItem = _getClusterItem(itemNo);
            if (clusterItem != null) {
              items.add(clusterItem);
            }
          }
          final cluster = _MFClusterImplement(position!, items);
          onClusterTap!(cluster);
        }
        break;
      case 'cluster#onClusterItemTap':
        if (onClusterItemTap != null) {
          final int itemNo = call.arguments['itemNo'];
          final clusterItem = _getClusterItem(itemNo);
          if (clusterItem != null) {
            onClusterItemTap!(clusterItem);
          }
        }
        break;
      default:
        throw Exception('Unknow callback method: ${call.method}');
    }
  }

  MFClusterItem? _getClusterItem(final int itemNo) {
    for (final item in _items) {
      if (itemNo == item._itemNo) {
        return item;
      }
    }
    return null;
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
