/// Base Algorithm class that arranging cluster items into groups.
abstract class MFClusterAlgorithm {
}

/// A simple algorithm which divides the map into a grid where a cell has fixed dimension in screen space.
class MFGridBasedAlgorithm implements MFClusterAlgorithm {
  const MFGridBasedAlgorithm();
}

/// A simple clustering algorithm with O(nlog n) performance. Resulting clusters are not hierarchical.
/// High level algorithm:
/// 1. Iterate over items in the order they were added (candidate clusters).
/// 2. Create a cluster with the center of the item.
/// 3. Add all items that are within a certain distance to the cluster.
/// 4. Move any items out of an existing cluster if they are closer to another cluster.
/// 5. Remove those items from the list of candidate clusters.
/// Clusters have the center of the first element (not the centroid of the items within it).
class MFNonHierarchicalDistanceBasedAlgorithm implements MFClusterAlgorithm {
  const MFNonHierarchicalDistanceBasedAlgorithm();
}