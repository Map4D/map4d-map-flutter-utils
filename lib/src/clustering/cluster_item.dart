part of 'cluster_manager.dart';

/// [MFClusterItem] represents a marker on the map.
class MFClusterItem {

  MFClusterItem({
    required this.position,
    this.title,
    this.snippet,
  });

  /// Position of the item.
  final MFLatLng position;

  /// The title of this item.
  final String? title;

  /// The description of this item.
  final String? snippet;

  int? _itemNo;

  @override
  String toString() {
    return '$runtimeType{position: ${position.toString()}, title: $title, snippet: $snippet}';
  }

  Object _toJson() {
    final Map<String, Object> json = <String, Object>{};

    if (title != null) {
      json['title'] = title!;
    }

    if (title != null) {
      json['snippet'] = snippet!;
    }

    if (_itemNo != null) {
      json['itemNo'] = _itemNo!;
    }

    json['position'] = position.toJson();

    return json;
  }
}