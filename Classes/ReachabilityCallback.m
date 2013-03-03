//
//  ReachabilityCallback.m
//  TodayWeather
//
//  Created by eunkwang on 11. 5. 17..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReachabilityCallback.h"
#import <netinet/in.h>
//#import <sys/socket.h>
//#import <netinet6/in6.h>
//#import <arpa/inet.h>
//#import <ifaddrs.h>
//#import <netdb.h>


@implementation UIDevice (ReachabilityCallback)

SCNetworkConnectionFlags connectionFlags;
SCNetworkConnectionRef reachability;


// 연결에 변화가 생겼을 경우 감지하고 콜백 주는 감시자 

#pragma mark Checking Connection 
//change connection flag
+ (void) pingReachabilityInternal {
	if (!reachability) {
		BOOL ignoresAdHocWiFi = NO;
		struct sockaddr_in ipAddress;
		bzero(&ipAddress, sizeof(ipAddress));
		ipAddress.sin_len = sizeof (ipAddress);
		ipAddress.sin_family = AF_INET;
		ipAddress.sin_addr.s_addr = htonl(ignoresAdHocWiFi ? INADDR_ANY : IN_LINKLOCALNETNUM);
		
		reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (struct sockaddr *) &ipAddress);
		CFRetain(reachability);
	}
	
	// restore connection flag
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(reachability, &connectionFlags);
	if (!didRetrieveFlags) {
		NSLog(@"error. could not recover reachability flags");
	}
}


#pragma mark Monitoring reachability
//실제 callback은 delegate로 전달 됨
// 콜백이 설정될 때 info 인자는 정의된다
static void ReachabilityCallback (SCNetworkReachabilityRef target, SCNetworkConnectionFlags flags, void *info) {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	[(id)info performSelector:@selector (reachabilityChanged)];
	[pool release];
}


// 감시자 등록
+ (BOOL) scheduleReachabilityWatcher: (id) watcher {
	//프로토콜 필수 구현 메소드
	if (![watcher conformsToProtocol:@protocol(ReachabilityWatcher)]) {
		NSLog(@"watcher doesn't conform to protocol");
		return NO;
	}
	[self pingReachabilityInternal];
	
	//set info as Watcher
	SCNetworkReachabilityContext context = {0, watcher, NULL, NULL, NULL};
	
	//set callback
	if (SCNetworkReachabilitySetCallback(reachability, ReachabilityCallback, &context)) {
		if (!SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetCurrent(), kCFRunLoopCommonModes)) {
			NSLog(@"error. could not schedule reachability");
			SCNetworkReachabilitySetCallback(reachability, NULL, NULL);
			return NO;
		}
	}
	else {
		NSLog(@"error. could not set reachability callback");
		return NO;
	}
	
	return YES;
}


+ (void) unscheduleReachabilityWatcher {
	//등록해제 콜백
	SCNetworkReachabilitySetCallback(reachability, NULL, NULL);
	
	//실행루프 제거
	if (SCNetworkReachabilityUnscheduleFromRunLoop(reachability, CFRunLoopGetCurrent(), kCFRunLoopCommonModes)) {
		NSLog(@"unscheduled reachability");
	}
	else {
		NSLog(@"error. could not unschedule reachability");
	}
	
	CFRelease(reachability);
	reachability = nil;
}




@end
