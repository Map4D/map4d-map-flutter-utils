package vn.map4d.maputils.map4d_map_utils;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import vn.map4d.map.core.Map4D;
import vn.map4d.map.map4d_map.FMFMapViewController;
import vn.map4d.map.map4d_map.FMFMapViewFactory;
import vn.map4d.utils.android.clustering.MFClusterManager;

public class FMFClusterManager implements MethodChannel.MethodCallHandler {

  private Map4D map4D;

  private MFClusterManager<FMFClusterItem> clusterManager;

  private final MethodChannel methodChannel;

  private Map<Integer, FMFClusterItem> clusterItemMap;

  FMFClusterManager(BinaryMessenger binaryMessenger, int mapId, int managerId, String channel) {
    this.methodChannel = new MethodChannel(binaryMessenger, "map4d_map_utils:cluster:" + managerId);
    methodChannel.setMethodCallHandler(this);
    FMFMapViewController mapViewController = FMFMapViewFactory.mapViewControllerMap.get(mapId);
    map4D = mapViewController.getMap();
    clusterManager = new MFClusterManager<>(mapViewController.getContext(), map4D);
    map4D.setOnCameraIdleListener(clusterManager);
    clusterItemMap = new HashMap<>();
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
}
