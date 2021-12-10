package vn.map4d.maputils.map4d_map_utils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import vn.map4d.types.MFLocationCoordinate;

class Convert {
  private static int toInt(Object o) {
    return ((Number) o).intValue();
  }

  private static double toDouble(Object o) {
    return ((Number) o).doubleValue();
  }

  private static String toString(Object o) {
    return (String) o;
  }

  private static Map<?, ?> toMap(Object o) {
    return (Map<?, ?>) o;
  }

  private static List<?> toList(Object o) {
    return (List<?>) o;
  }

  static MFLocationCoordinate toCoordinate(Object o) {
    final List<?> data = toList(o);
    return new MFLocationCoordinate(toDouble(data.get(0)), toDouble(data.get(1)));
  }

  static FMFClusterItem interpretClusterItem(Object o) {
    final Map<?, ?> data = toMap(o);
    String title = null;
    String snippet = null;
    Integer itemNo = null;
    final Object titleData = data.get("title");
    if (titleData != null) {
      title = toString(titleData);
    }
    final Object snippetData = data.get("snippet");
    if (snippetData != null) {
      snippet = toString(snippetData);
    }
    final Object itemNoData = data.get("itemNo");
    if (itemNoData != null) {
      itemNo = toInt(itemNoData);
    }
    final Object position = data.get("position");
    MFLocationCoordinate locationCoordinate =  new MFLocationCoordinate(0.0, 0.0);
    if (position != null) {
      locationCoordinate = toCoordinate(position);
    }
    return new FMFClusterItem(locationCoordinate.getLatitude(), locationCoordinate.getLongitude(), title, snippet, itemNo);
  }

  static List<FMFClusterItem> interpretClusterItems(Object o) {
    final List<?> data = toList(o);
    List<FMFClusterItem> items = new ArrayList<>(data.size());
    MFLocationCoordinate locationCoordinate;
    for (Object rawItem : data) {
      final Map<?, ?> item = toMap(rawItem);
      String title = null;
      String snippet = null;
      Integer itemNo = null;
      final Object titleData = item.get("title");
      if (titleData != null) {
        title = toString(titleData);
      }
      final Object snippetData = item.get("snippet");
      if (snippetData != null) {
        snippet = toString(snippetData);
      }
      final Object itemNoData = item.get("itemNo");
      if (itemNoData != null) {
        itemNo = toInt(itemNoData);
      }
      final Object position = item.get("position");
      if (position != null) {
        locationCoordinate = toCoordinate(position);
        items.add(new FMFClusterItem(locationCoordinate.getLatitude(), locationCoordinate.getLongitude(), title, snippet, itemNo));
      }
    }
    return items;
  }

  static Integer interpretClusterItemNo(Object o) {
    final Map<?, ?> data = toMap(o);
    Integer itemNo = null;
    final Object itemNoData = data.get("itemNo");
    if (itemNoData != null) {
      itemNo = toInt(itemNoData);
    }
    return itemNo;
  }
}
