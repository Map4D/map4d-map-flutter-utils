//
//  FMFClusterItem.h
//  map4d_map_utils
//
//  Created by Huy Dang on 09/12/2021.
//

#ifndef FMFClusterItem_h
#define FMFClusterItem_h

#import <CoreLocation/CoreLocation.h>
#import "MFUClusterItem.h"

@interface FMFClusterItem : NSObject<MFUClusterItem>

@property(nonatomic, copy) NSString* title;

@property(nonatomic, copy) NSString* snippet;

@property(nonatomic, readonly) int64_t itemNo;

- (instancetype)initWithData:(NSDictionary*)data;

@end

#endif /* FMFClusterItem_h */
