//
//  YBReachability.h
//  YPMobileChargePlugin
//
//  Created by yuan fang on 11-6-5.
//  Copyright 2011 enalex. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <netdb.h>

@protocol IRReachabilityWatcher <NSObject>
- (void) reachabilityChanged;
@end

@interface AHReachability : NSObject
+ (BOOL)networkAvailable;
+ (BOOL)activeWWAN;
+ (BOOL)scheduleReachabilityWatcher:(id)watcher;
+ (void)unscheduleReachabilityWatcher;
+ (BOOL)hostAvailable:(NSString *)theHost;
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address;
+ (NSString *)getIPAddressForHost:(NSString *)theHost;
@end
