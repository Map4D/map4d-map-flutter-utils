import 'dart:math';
import 'package:flutter/material.dart';
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
  late MFMapViewController _controller;
  final int maxClusterItemCount = 500;
  final double cameraLatitude = 16.0432432;
  final double cameraLongitude = 108.032432;

  void _onMapCreated(MFMapViewController controller) {
    _controller = controller;
    _clusterManager = MFClusterManager(
        controller: controller,
        onClusterTap: _onClusterTap,
        onClusterItemTap: _onClusterItemTap);

    _generateClusterItems();
    _clusterManager.cluster();
  }

  void _onCameraIdle() {
    // _clusterManager.cluster();
  }

  void _onClusterTap(MFCluster cluster) async {
    final zoom = await _controller.getZoomLevel();
    _controller.animateCamera(
        MFCameraUpdate.newLatLngZoom(cluster.position, zoom + 1));
  }

  void _onClusterItemTap(MFClusterItem clusterItem) {
    print('Tap on cluster item: ${clusterItem.toString()}');
  }

  void _onPOITap(String placeId, String name, MFLatLng location) {
    print('on tap POI: $placeId, name: $name');
  }

  void _generateClusterItems() {
    const double extent = 0.2;
    // List<MFClusterItem> items = <MFClusterItem>[];
    for (int index = 1; index <= maxClusterItemCount; ++index) {
      double lat = cameraLatitude + extent * _randomScale();
      double lng = cameraLongitude + extent * _randomScale();
      final item = MFClusterItem(position: MFLatLng(lat, lng));
      // items.add(item);
      _clusterManager.addItem(item);
    }
    // _clusterManager.addItems(items);
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
            onMapCreated: _onMapCreated,
            onCameraIdle: _onCameraIdle,
            onPOITap: _onPOITap,
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
