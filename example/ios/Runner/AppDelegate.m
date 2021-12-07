#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <Map4dMap/MFServices.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  NSAssert(false, @"Provide a valid key registered with the demo app bundle id. Then delete this line.");
  [MFServices provideAccessKey:@""];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
