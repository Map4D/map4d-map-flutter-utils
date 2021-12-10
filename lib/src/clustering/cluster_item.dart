part of 'cluster_manager.dart';

class MFClusterItem {

  MFClusterItem({
    required this.position,
    this.title,
    this.snippet,
  });

  /// Position of the item.
  final MFLatLng position;

  final String? title;

  final String? snippet;

  @override
  String toString() {
    return '$runtimeType{position: ${position.toString()}, title: $title, snippet: $snippet}';
  }

  int? _itemNo;

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