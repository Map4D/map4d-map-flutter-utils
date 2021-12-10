//
//  FMFClusterManager.m
//  map4d_map_utils
//
//  Created by Huy Dang on 12/7/21.
//

#import "FMFClusterManager.h"
#import "Map4dMapPlugin.h"
#import "Map4dFLTConvert.h"
#import "FMFClusterItem.h"
#import <Map4dMapUtils/MarkerCluster.h>

@interface FMFClusterManager()<MFUClusterManagerDelegate>
@property(nonatomic, weak, nullable) MFMapView* mapView;
@property(nonatomic, strong, nullable) MFUClusterManager *clusterManager;
@property(nonatomic, strong, nonnull) NSMutableArray<FMFClusterItem*> *items;
@end

@implementation FMFClusterManager {
  FlutterMethodChannel* _channel;
  NSObject<FlutterPluginRegistrar>* _registrar;
}

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar arguments:(id)arguments {
  if (self = [super init]) {
    _managerId = [Map4dFLTConvert toInt:arguments[@"id"]];
    _registrar = registrar;
    _items = [[NSMutableArray alloc] init];
    _channel = [FlutterMethodChannel methodChannelWithName:arguments[@"channel"]
                                           binaryMessenger:registrar.messenger];
    
    __weak __typeof(self) weakSelf = self;
    [_channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
      [weakSelf onMethodCall:call result:result];
    }];
    
    
    // Get MFMapView from Map4dMap Flutter Plugin
    int64_t mapId = [Map4dFLTConvert toInt:arguments[@"mapId"]];
    id<FlutterPlatformView> platformView = [Map4dMapPlugin.instance getFlutterPlatformViewById:mapId];

    if (platformView != nil) {
      _mapView = (MFMapView*) [platformView view];
      [self setupMFClusterManager:arguments[@"data"]];
    }
    else {
      NSLog(@"MFMapView not exist");
    }
  }
  return self;
}

- (void)setupMFClusterManager:(NSDictionary*)data {
  // Cluster Algorithm
  NSString* algorithmName = data[@"algorithmName"];
  id<MFUClusterAlgorithm> algorithm = nil;
  if ([@"MFGridBasedAlgorithm" isEqualToString:algorithmName]) {
    algorithm = [[MFUGridBasedClusterAlgorithm alloc] init];
  }
  else if ([@"MFNonHierarchicalDistanceBasedAlgorithm" isEqualToString:algorithmName]) {
    algorithm = [[MFUNonHierarchicalDistanceBasedAlgorithm alloc] init];
  }
  else {
    //TODO: custom algorithm
    algorithm = [[MFUNonHierarchicalDistanceBasedAlgorithm alloc] init];
  }
 
  // Cluster Renderer
  NSString* rendererName = data[@"rendererName"];
  id<MFUClusterRenderer> renderer = nil;
  if ([@"MFDefaultClusterRenderer" isEqualToString:rendererName]) {
    id<MFUClusterIconGenerator> iconGenerator = [[MFUDefaultClusterIconGenerator alloc] init];
    renderer = [[MFUDefaultClusterRenderer alloc] initWithMapView:_mapView clusterIconGenerator:iconGenerator];
  }
  else {
    //TODO: custom renderer
    id<MFUClusterIconGenerator> iconGenerator = [[MFUDefaultClusterIconGenerator alloc] init];
    renderer = [[MFUDefaultClusterRenderer alloc] initWithMapView:_mapView clusterIconGenerator:iconGenerator];
  }
  
  _clusterManager = [[MFUClusterManager alloc] initWithMap:_mapView algorithm:algorithm renderer:renderer];
  [_clusterManager setDelegate:self mapDelegate:_mapView.delegate];
}

#pragma mark - Method Handler

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  /** Add new cluster item */
  if ([@"cluster#addItem" isEqualToString:call.method]) {
    FMFClusterItem* clusterItem = [[FMFClusterItem alloc] initWithData:call.arguments[@"item"]];
    [_clusterManager addItem:clusterItem];
    [_items addObject:clusterItem];
    result(nil);
    return;
  }
  
  /** Add new list cluster item */
  if ([@"cluster#addItems" isEqualToString:call.method]) {
    NSArray* items = call.arguments[@"items"];
    for (NSDictionary* item in items) {
      FMFClusterItem* clusterItem = [[FMFClusterItem alloc] initWithData:item];
      [_clusterManager addItem:clusterItem];
      [_items addObject:clusterItem];
    }
    result(nil);
    return;
  }
  
  /** Remove cluster item */
  if ([@"cluster#removeItem" isEqualToString:call.method]) {
    NSDictionary* item = call.arguments[@"item"];
    int64_t itemNo = [Map4dFLTConvert toInt:item[@"itemNo"]];

    for (NSUInteger index = 0; index < _items.count; index++) {
      FMFClusterItem* clusterItem = [_items objectAtIndex:index];
      if (clusterItem.itemNo == itemNo) {
        [_clusterManager removeItem:clusterItem];
        [_items removeObjectAtIndex:index];
        break;
      }
    }
    result(nil);
    return;
  }
  
  /** Remove all cluster items */
  if ([@"cluster#clearItems" isEqualToString:call.method]) {
    [_clusterManager clearItems];
    [_items removeAllObjects];
    result(nil);
    return;
  }
  
  if ([@"cluster#cluster" isEqualToString:call.method]) {
    [_clusterManager cluster];
    result(nil);
    return;
  }
  
  NSLog(@"FMFClusterManager - Method not implemented: %s", [call.method UTF8String]);
  result(FlutterMethodNotImplemented);
}

#pragma mark - MFUClusterManagerDelegate

-(BOOL)clusterManager:(MFUClusterManager *)clusterManager didTapCluster:(id<MFUCluster>)cluster {
  NSMutableArray* itemNos = [NSMutableArray arrayWithCapacity:cluster.count];
  for (id<MFUClusterItem> clusterItem in cluster.items) {
    FMFClusterItem* item = (FMFClusterItem*)clusterItem;
    [itemNos addObject:[NSNumber numberWithLongLong:item.itemNo]];
  }

  NSDictionary* arguments = @{
    @"position": [Map4dFLTConvert locationToJson:cluster.position],
    @"length": @(cluster.count),
    @"itemNos": itemNos
  };
  [_channel invokeMethod:@"cluster#onClusterTap" arguments:arguments];

  // Stop event here
  return YES;
}

- (BOOL)clusterManager:(MFUClusterManager *)clusterManager didTapClusterItem:(id<MFUClusterItem>)clusterItem {
  FMFClusterItem* item = (FMFClusterItem*)clusterItem;
  [_channel invokeMethod:@"cluster#onClusterItemTap" arguments:@{ @"itemNo": @(item.itemNo) }];
  
  // Pass this tap event to other handlers
  return NO;
}

@end
