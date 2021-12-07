import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:map4d_map/map4d_map.dart';
import 'package:map4d_map_utils/map4d_map_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late MFUClusterManager _clusterManager;

  void onMapCreated(MFMapViewController controller) {
    _clusterManager = MFUClusterManager(controller: controller);
    getPlatformVersion();
  }

  Future<void> getPlatformVersion() async {
    String platformVersion;
    try {
      platformVersion = await _clusterManager.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    print('platformVersion: $platformVersion');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Map4d Map Utility'),
        ),
        body: Center(
          child: MFMapView(
            onMapCreated: onMapCreated,
          ),
        ),
      ),
    );
  }
}
