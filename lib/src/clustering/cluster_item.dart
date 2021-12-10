part of 'cluster_manager.dart';

class MFClusterItem {

  MFClusterItem({
    required this.position,
    this.title,
    this.snippet,
  });

  /// position of the item.
  final MFLatLng position;

  final String? title;

  final String? snippet;

  int? _itemNo;

  Object toJson() {
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