#import "Map4dMapUtilsPlugin.h"
#import "FMFClusterManager.h"

@interface Map4dMapUtilsPlugin()
@property (nonatomic, weak) NSObject<FlutterPluginRegistrar>* registrar;
@property (nonatomic, strong, nonnull) NSMutableArray<FMFClusterManager*>* clusterManagers;
@end

@implementation Map4dMapUtilsPlugin

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  if (self = [super init]) {
    _registrar = registrar;
    _clusterManagers = [NSMutableArray arrayWithCapacity:1];
  }
  return self;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"map4d_map_utils"
            binaryMessenger:[registrar messenger]];
  Map4dMapUtilsPlugin* instance = [[Map4dMapUtilsPlugin alloc] initWithRegistrar:registrar];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  // Initial new cluster manager
  if ([@"cluster#init" isEqualToString:call.method]) {
    FMFClusterManager* manager = [[FMFClusterManager alloc] initWithRegistrar:_registrar arguments:call.arguments];
    [_clusterManagers addObject:manager];
    result(nil);
    return;
  }

  NSLog(@"Map4dMapUtilsPlugin - Method not implemented: %s", [call.method UTF8String]);
  result(FlutterMethodNotImplemented);
}

@end
