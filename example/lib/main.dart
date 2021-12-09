import 'dart:math';

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

  late MFClusterManager _clusterManager;
  final int maxClusterItemCount = 500;
  final double cameraLatitude = 16.0432432;
  final double cameraLongitude = 108.032432;

  void onMapCreated(MFMapViewController controller) {
    _clusterManager = MFClusterManager(
      controller: controller,
      algorithm: MFNonHierarchicalDistanceBasedAlgorithm()
    );
    // letItGo();
    _generateClusterItems();
    _clusterManager.cluster();
  }

  Future<void> letItGo() async {
    final marker0 = MFMarker(
      markerId: MFMarkerId('m0'),
      position: MFLatLng(0, 0)
    );

    final marker1 = MFMarker(
      markerId: MFMarkerId('m1'),
      position: MFLatLng(1, 1)
    );

    final marker2 = MFMarker(
      markerId: MFMarkerId('m2'),
      position: MFLatLng(2, 2)
    );

    await _clusterManager.addItem(marker0);

    final Set<MFMarker> items = <MFMarker>{};
    items.add(marker1);
    items.add(marker2);
    await _clusterManager.addItems(items);
  }

  void _generateClusterItems() {
    const double extent = 0.2;
    for (int index = 1; index <= maxClusterItemCount; ++index) {
      double lat = cameraLatitude + extent * _randomScale();
      double lng = cameraLongitude + extent * _randomScale();
      final marker = MFMarker(
        markerId: MFMarkerId(index.toString()),
        position: MFLatLng(lat, lng),
      );
      _clusterManager.addItem(marker);
    }
  }

  /// Returns a random value between -1.0 and 1.0.
  double _randomScale() {
    return Random().nextDouble() * 2.0 - 1.0;
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
            initialCameraPosition: MFCameraPosition(
              target: MFLatLng(cameraLatitude, cameraLongitude),
              zoom: 10,
            ),
          ),
        ),
      ),
    );
  }
}
