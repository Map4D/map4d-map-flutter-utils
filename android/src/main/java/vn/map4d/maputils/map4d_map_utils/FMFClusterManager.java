package vn.map4d.maputils.map4d_map_utils;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import vn.map4d.map.core.Map4D;
import vn.map4d.map.map4d_map.FMFMapViewController;
import vn.map4d.map.map4d_map.FMFMapViewFactory;
import vn.map4d.utils.android.clustering.MFCluster;
import vn.map4d.utils.android.clustering.MFClusterItem;
import vn.map4d.utils.android.clustering.MFClusterManager;

public class FMFClusterManager implements
  MethodChannel.MethodCallHandler,
  MFClusterManager.OnClusterClickListener,
  MFClusterManager.OnClusterItemClickListener {

  private Map4D map4D;

  private MFClusterManager<FMFClusterItem> clusterManager;

  private final MethodChannel methodChannel;

  private Map<Integer, FMFClusterItem> clusterItemMap;

  FMFClusterManager(BinaryMessenger binaryMessenger, int mapId, int managerId, String channel) {
    clusterItemMap = new HashMap<>();
    this.methodChannel = new MethodChannel(binaryMessenger, "map4d_map_utils:cluster:" + managerId);
    methodChannel.setMethodCallHandler(this);
    FMFMapViewController mapViewController = FMFMapViewFactory.mapViewControllerMap.get(mapId);
    map4D = mapViewController.getMap();
    clusterManager = new MFClusterManager<>(mapViewController.getContext(), map4D);
    map4D.setOnCameraIdleListener(clusterManager);
    clusterManager.setOnClusterClickListener(this);
    clusterManager.setOnClusterItemClickListener(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    switch (call.method) {
      case "cluster#cluster": {
        clusterManager.cluster();
        result.success(null);
        break;
      }
      case "cluster#addItem": {
        final FMFClusterItem item = Convert.interpretClusterItem(call.argument("item"));
        clusterManager.addItem(item);
        clusterItemMap.put(item.getItemNo(), item);
        result.success(null);
        break;
      }
      case "cluster#addItems": {
        List<FMFClusterItem> items = Convert.interpretClusterItems(call.argument("items"));
        clusterManager.addItems(items);
        for (FMFClusterItem item : items) {
          clusterItemMap.put(item.getItemNo(), item);
        }
        result.success(null);
        break;
      }
      case "cluster#removeItem": {
        Integer itemNo = Convert.interpretClusterItemNo(call.argument("item"));
        if (itemNo != null) {
          final FMFClusterItem item = clusterItemMap.get(itemNo);
          clusterManager.removeItem(item);
          clusterItemMap.remove(itemNo);
        }
        result.success(null);
        break;
      }
      case "cluster#clearItems": {
        clusterManager.clearItems();
        clusterItemMap.clear();
        result.success(null);
        break;
      }
      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public boolean onClusterItemClick(MFClusterItem clusterItem) {
    FMFClusterItem item = (FMFClusterItem) clusterItem;
    final Map<String, Integer> arguments = new HashMap<>(2);
    arguments.put("itemNo", item.getItemNo());
    methodChannel.invokeMethod("cluster#onClusterItemTap", arguments);
    return true;
  }

  @Override
  public boolean onClusterClick(MFCluster cluster) {
    final Map<String, Object> arguments = new HashMap<>(2);
    Collection<FMFClusterItem> items = cluster.getItems();
    if (items.size() > 0) {
      List<Integer> itemNos = new ArrayList<>(items.size());
      for (FMFClusterItem item: items) {
        itemNos.add(item.getItemNo());
      }
      arguments.put("itemNos", itemNos);
      arguments.put("position", Convert.latLngToJson(cluster.getPosition()));
      methodChannel.invokeMethod("cluster#onClusterTap", arguments);
    }
    return true;
  }
}
