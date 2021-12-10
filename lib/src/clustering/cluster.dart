part of 'cluster_manager.dart';

// class MFCluster {

//   const MFCluster({
//     required this.position,
//     required this.length,
//     required this.items,
//   });

//   final MFLatLng position;

//   final int length;

//   final List<MFClusterItem> items;
// }

abstract class MFCluster {

  MFLatLng get position;

  int get length;

  List<MFClusterItem> get items;
}