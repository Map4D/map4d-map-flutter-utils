//
//  FMFClusterItem.h
//  map4d_map_flutter_utils
//
//  Created by Huy Dang on 09/12/2021.
//

#ifndef FMFClusterItem_h
#define FMFClusterItem_h

#import <CoreLocation/CoreLocation.h>
#import "MFClusterItem.h"

@interface FMFClusterItem : NSObject<MFClusterItem>

@property(nonatomic, copy) NSString* title;

@property(nonatomic, copy) NSString* snippet;

@property(nonatomic, readonly) int64_t itemNo;

- (instancetype)initWithData:(NSDictionary*)data;

@end

#endif /* FMFClusterItem_h */
