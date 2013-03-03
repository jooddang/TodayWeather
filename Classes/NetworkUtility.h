//
//  NetworkUtility.h
//  TodayWeather
//
//  Created by eunkwang on 11. 5. 17..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>



@interface NetworkUtility : NSObject {
//@interface UIDevice (ReachabilityCallback) 

}

+ (BOOL) hostAvailable:(NSString *) theHost;
+ (NSString *) stringFromAddress:(const struct sockaddr *)address;
+ (BOOL) addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address;
+ (NSString *) hostname;
+ (NSString *) getIPAddressForHost: (NSString *) theHost;
+ (NSString *) localIPAddress;

@end
