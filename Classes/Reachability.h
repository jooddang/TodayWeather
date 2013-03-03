//
//  Reachability.h
//  TodayWeather
//
//  Created by eunkwang on 11. 5. 17..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>


// UIDevice 확장. Reachability
@interface UIDevice (Reachability)

+ (NSString *) localWiFiIPAddress;
+ (void) pingReachabilityInternal;
+ (BOOL) networkAvailable;
+ (BOOL) activeWWAN;
+ (BOOL) activeWLAN;


@end
