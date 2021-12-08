import 'package:flutter/services.dart';
import 'package:map4d_map/map4d_map.dart';

import 'cluster_algorithm.dart';
import 'cluster_renderer.dart';
import '../map_utils_channel.dart';

class MFUClusterManager {

  MFUClusterManager({
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
  Future<void> cluster() {
    return _channel.invokeListMethod('cluster#cluster');
  }

  /// TODO: remove
  Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Handle message from platform.
  Future<dynamic> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      default:
        // ignore: avoid_print
        print('Unknow callback method: ${call.method}');
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