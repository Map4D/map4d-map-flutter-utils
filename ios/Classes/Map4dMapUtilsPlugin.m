#import "Map4dMapUtilsPlugin.h"
#import "FMFUClusterManager.h"
#import "Map4dFLTConvert.h"

@interface Map4dMapUtilsPlugin()
@property (nonatomic, weak) NSObject<FlutterPluginRegistrar>* registrar;
@property (nonatomic, strong, nonnull) NSMutableArray<FMFUClusterManager*>* managers;
@end

@implementation Map4dMapUtilsPlugin

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  if (self = [super init]) {
    _registrar = registrar;
    _managers = [NSMutableArray arrayWithCapacity:1];
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
  NSLog(@"handleMethodCall: %s", [call.method UTF8String]);

  if ([@"cluster#init" isEqualToString:call.method]) {
    int64_t mapId = [Map4dFLTConvert toInt:call.arguments[@"mapId"]];
    int64_t managerId = [Map4dFLTConvert toInt:call.arguments[@"id"]];
    NSString* name = call.arguments[@"channel"];

    FMFUClusterManager* manager = [[FMFUClusterManager alloc] initWithId:managerId channelName:name registrar:_registrar mapId:mapId];
    [_managers addObject:manager];

    return;
  }

  result(FlutterMethodNotImplemented);
}

@end
