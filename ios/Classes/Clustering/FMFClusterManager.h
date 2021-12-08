//
//  FMFClusterManager.h
//  map4d_map_utils
//
//  Created by Huy Dang on 12/7/21.
//

#ifndef FMFUClusterManager_h
#define FMFUClusterManager_h

#import <Flutter/Flutter.h>

@interface FMFClusterManager : NSObject

@property (nonatomic) int64_t managerId;

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar
                        arguments:(id)arguments;

@end


#endif /* FMFUClusterManager_h */
