import 'package:flutter/services.dart';

class MapUtilsChannel {
  static const MethodChannel _channel = MethodChannel('map4d_map_utils');
  static int _clusteringIdCounter = 1;

  /// Invoke method to create cluster manager on platform (android, ios).
  ///
  /// Return: method channel name
  static String createPlatformClusterManager(
      int mapId, Map<String, Object> data) {
    final id = _clusteringIdCounter++;
    String channelName = 'map4d_map_utils:cluster:$id';
    _channel.invokeMethod('cluster#init', <String, dynamic>{
      'id': id,
      'channel': channelName,
      'mapId': mapId,
      'data': data,
    });
    return channelName;
  }
}
