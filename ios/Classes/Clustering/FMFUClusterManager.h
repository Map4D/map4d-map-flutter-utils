//
//  FMFUClusterManager.h
//  map4d_map_utils
//
//  Created by Huy Dang on 12/7/21.
//

#ifndef FMFUClusterManager_h
#define FMFUClusterManager_h

#import <Flutter/Flutter.h>

@interface FMFUClusterManager : NSObject

@property (nonatomic) int64_t managerId;

- (instancetype)initWithId:(int64_t)managerId
               channelName:(NSString*)name
                 registrar:(NSObject<FlutterPluginRegistrar>*)registrar
                     mapId:(int64_t)mapId;

@end


#endif /* FMFUClusterManager_h */
