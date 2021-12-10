part of 'cluster_manager.dart';

class _MFClusterImplement implements MFCluster {

  final MFLatLng _position;

  final List<MFClusterItem> _items;

  _MFClusterImplement(this._position, this._items);

  @override
  List<MFClusterItem> get items => _items;

  @override
  int get length => _items.length;

  @override
  MFLatLng get position => _position;
}