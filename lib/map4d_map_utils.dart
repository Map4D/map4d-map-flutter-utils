import 'dart:async';

import 'package:flutter/services.dart';

class Map4dMapUtils {
  static const MethodChannel _channel = MethodChannel('map4d_map_utils');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
