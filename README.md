# Map4dMap Utility Library for Flutter
[![map4d](https://img.shields.io/badge/map4d-map--utils-orange)](https://map4d.vn/)
[![platform](https://img.shields.io/badge/platform-flutter-45d2fd.svg)](https://flutter.dev/)
[![pub package](https://img.shields.io/pub/v/map4d_map_utils.svg)](https://pub.dev/packages/map4d_map_utils)
[![github issues](https://img.shields.io/github/issues/map4d/map4d-map-flutter-utils)](https://github.com/map4d/map4d-map-flutter-utils/issues)


A Flutter plugin that provides utility library for [Map4dMap](https://pub.dev/packages/map4d_map)

## Installing

### Depend on it

To use this plugin, run command:

```bash
flutter pub add map4d_map_utils
```
Or add `map4d_map_utils` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  map4d_map_utils: ^1.0.0
```

### Import it

In your Dart code, you can use:

```dart
import 'package:map4d_map_utils/map4d_map_utils.dart';
```

## Requirements
- Android SDK 21+
- iOS 9.3+

## Example Usage

e.g. Marker Clustering:

```dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';
import 'package:map4d_map_utils/map4d_map_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final int maxClusterItemCount = 500;
  final double cameraLatitude = 16.0432432;
  final double cameraLongitude = 108.032432;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map4D Map Utility',
      home: MFMapView(
        initialCameraPosition: MFCameraPosition(
            target: MFLatLng(cameraLatitude, cameraLongitude), zoom: 10),
        onMapCreated: onMapCreated,
      ),
    );
  }

  void onMapCreated(MFMapViewController controller) {
    final clusterManager = MFClusterManager(
      controller: controller,
      onClusterTap: (cluster) => onClusterTap(cluster, controller)
    );
    // Generate cluster items
    const double extent = 0.2;
    for (int i = 0; i < maxClusterItemCount; i++) {
      double lat = cameraLatitude + extent * (Random().nextDouble() * 2.0 - 1.0);
      double lng = cameraLongitude + extent * (Random().nextDouble() * 2.0 - 1.0);
      final item = MFClusterItem(position: MFLatLng(lat, lng));
      clusterManager.addItem(item);
    }
    clusterManager.cluster();
  }

  void onClusterTap(MFCluster cluster, MFMapViewController controller) async {
    final zoom = await controller.getZoomLevel();
    controller.animateCamera(MFCameraUpdate.newLatLngZoom(cluster.position, zoom + 1));
  }
}
```
