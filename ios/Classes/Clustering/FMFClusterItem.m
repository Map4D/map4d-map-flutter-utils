//
//  FMFClusterItem.m
//  map4d_map_flutter_utils
//
//  Created by Huy Dang on 09/12/2021.
//

#import "FMFClusterItem.h"
#import "Map4dFLTConvert.h"

@interface FMFClusterItem()
@property(nonatomic, readwrite) CLLocationCoordinate2D position;
@end

@implementation FMFClusterItem

- (instancetype)initWithData:(NSDictionary *)data {
  if (self = [super init]) {
    _itemNo = [Map4dFLTConvert toInt:data[@"itemNo"]];
    _position = [Map4dFLTConvert toLocation:data[@"position"]];
    _title = data[@"title"];
    _snippet = data[@"snippet"];
  }
  return self;
}

- (CLLocationCoordinate2D)position {
  return _position;
}

@end
