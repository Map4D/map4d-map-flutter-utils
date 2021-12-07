import 'package:flutter/services.dart';

class MapUtilsChannel {
  static const MethodChannel _channel = MethodChannel('map4d_map_utils');
  static int _clusteringIdCounter = 1;

  /// Invoke method to create cluster manager on platform (android, ios).
  /// 
  /// Return: method channel name
  static String createPlatformClusterManager(int mapId) {
    String channelName = 'map4d_map_utils:cluster:$_clusteringIdCounter';
    _channel.invokeMethod('cluster#init', <String, dynamic>{
      'id': _clusteringIdCounter,
      'channel': channelName,
      'mapId': mapId,
    });
    _clusteringIdCounter++;
    return channelName;
  }

}
