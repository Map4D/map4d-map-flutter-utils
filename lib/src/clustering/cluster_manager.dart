import 'package:flutter/services.dart';
import 'package:map4d_map/map4d_map.dart';
import 'package:map4d_map_utils/src/map_utils_channel.dart';

class MFUClusterManager {

  MFUClusterManager({
    required this.controller,
  }) {
    String name = MapUtilsChannel.createPlatformClusterManager(controller.mapId);
    _channel = MethodChannel(name);
    _channel.setMethodCallHandler((call) => _methodCallHandler(call));
  }

  ///
  final MFMapViewController controller;

  ///
  late final MethodChannel _channel;

  ///
  Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  ///
  Future<dynamic> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      default:
        // ignore: avoid_print
        print('Unknow callback method: ${call.method}');
    }
  }
}