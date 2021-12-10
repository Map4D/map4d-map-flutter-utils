package vn.map4d.maputils.map4d_map_utils;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** Map4dMapUtilsPlugin */
public class Map4dMapUtilsPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private BinaryMessenger binaryMessenger;

  private List<Object> clusterManagers;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    binaryMessenger = flutterPluginBinding.getBinaryMessenger();
    channel = new MethodChannel(binaryMessenger, "map4d_map_utils");
    channel.setMethodCallHandler(this);
    clusterManagers = new ArrayList<>();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "getPlatformVersion": {
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      }
      case "cluster#init": {
        final int mapId = call.argument("mapId");
        final int managerId = call.argument("id");
        final String channel = call.argument("channel");
        FMFClusterManager clusterManager = new FMFClusterManager(binaryMessenger, mapId, managerId, channel);
        clusterManagers.add(clusterManager);
        result.success(null);
        break;
      }
      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
