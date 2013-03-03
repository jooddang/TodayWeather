//
//  ReachabilityCallback.h
//  TodayWeather
//
//  Created by eunkwang on 11. 5. 17..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@protocol ReachabilityWatcher <NSObject>

- (void) reachabilityChanged;

@end


// UIDevice 확장. Reachability Callback
@interface UIDevice (ReachabilityCallback)


+ (void) pingReachabilityInternal;
+ (BOOL) scheduleReachabilityWatcher: (id) watcher;
+ (void) unscheduleReachabilityWatcher;


@end
