part of 'cluster_manager.dart';

/// A collection of [MFClusterItem] that are nearby each other.
abstract class MFCluster {
  /// The position of the cluster.
  MFLatLng get position;

  /// The number of items in the cluster.
  int get length;

  /// List of items in the cluster.
  List<MFClusterItem> get items;
}
