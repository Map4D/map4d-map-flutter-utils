//
//  FMFUClusterManager.m
//  map4d_map_utils
//
//  Created by Huy Dang on 12/7/21.
//

#import "FMFUClusterManager.h"

@implementation FMFUClusterManager {
  FlutterMethodChannel* _channel;
  NSObject<FlutterPluginRegistrar>* _registrar;
}

- (instancetype)initWithId:(int64_t)managerId
               channelName:(NSString *)name
                 registrar:(NSObject<FlutterPluginRegistrar> *)registrar
                     mapId:(int64_t)mapId {
  if (self = [super init]) {
    _managerId = managerId;
    _registrar = registrar;
    _channel = [FlutterMethodChannel methodChannelWithName:name binaryMessenger:registrar.messenger];
    
    __weak __typeof(self) weakSelf = self;
    [_channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
      [weakSelf onMethodCall:call result:result];
    }];
  }
  return self;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSLog(@"onMethodCall: %s", [call.method UTF8String]);
  
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}

@end
