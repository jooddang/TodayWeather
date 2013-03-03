//
//  NetworkUtility.m
//  TodayWeather
//
//  Created by eunkwang on 11. 5. 17..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetworkUtility.h"
#import <arpa/inet.h>
#import <unistd.h>
#import <netdb.h>


@implementation NetworkUtility
//@implementation UIDevice (ReachabilityCallback)


// 여기까지 UIDevice 확장
///////////////////////////////////////////////////////////////////////////////////////
// 이 밑으로는 따로 독립 가능한 Network Utility 모듈


+ (BOOL) hostAvailable:(NSString *) theHost {
	//호스트를 주소 문자열로 변환
	NSString *addressString = [NetworkUtility getIPAddressForHost:theHost];
	if (!addressString) {
		NSLog(@"error. recovering ip address from host name");
		return NO;
	}
	
	//주소 구조체로 반환
	struct sockaddr_in address;
	BOOL gotAddress = [NetworkUtility addressFromString:addressString address:&address];
	if (!gotAddress) {
		NSLog(@"error. recovering sockaddr address from %@", [addressString UTF8String]);
		return NO;
	}
	
	//연결 플래그 확인
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&address);
	SCNetworkReachabilityFlags flags;
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	if (!didRetrieveFlags) {
		NSLog(@"error. could not recover flags");
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	return isReachable ? YES : NO;
}


#define CHECK (SITE)  NSLog(@"? %@ : %@", SITE, [self hostAvailable:SITE] ? @"연결 가능", @"연결 불가능");





// IP 주소를 문자열 표현으로 반환
+ (NSString *) stringFromAddress:(const struct sockaddr *)address {
	if (address && address->sa_family == AF_INET) {
		const struct sockaddr_in* sin = (struct sockaddr_in *)address;
		return [NSString stringWithFormat:@"%@%d", [NSString stringWithUTF8String:inet_ntoa(sin->sin_addr)],
				ntohs(sin->sin_port)];
	}
	return nil;
}


// NSString 을 주소 객체로 변환
+ (BOOL) addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address {
	if (!IPAddress || ![IPAddress length]) {
		return NO;
	}
	
	memset ((char *) address, sizeof (struct sockaddr_in), 0);
	address->sin_family = AF_INET;
	address->sin_len = sizeof(struct sockaddr_in);
	
	int conversionResult = inet_aton([IPAddress UTF8String], &address->sin_addr);
	if (conversionResult == 0) {
		return NO;
	}
	return YES;
}


// 현재 호스트 이름 반환
+ (NSString *) hostname {
	char baseHostName[255];
	int success = gethostname(baseHostName, 255);
	if (success != 0) {
		return nil;
	}
	
#if !TARGET_IPHONE_SIMULATOR
	return [NSString stringWithFormat:@"%s.local", baseHostName];
	
#else
	return [NSString stringWithFormat:@"%s", baseHostName];
#endif
}


// 입력 호스트의 IP 주소 문자열 반환
+ (NSString *) getIPAddressForHost: (NSString *) theHost {
	struct hostent *host = gethostbyname([theHost UTF8String]);
	
	if (!host) {
		herror("resolv");
		return NULL;
	}
	
	struct in_addr **list = (struct in_addr**)host->h_addr_list;
	NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
	
	return addressString;
}


// return local IP address
+ (NSString *) localIPAddress {
	struct hostent *host = gethostbyname([[self hostname] UTF8String]);
	if (!host) {
		herror("resolv");
		return nil;
	}
	
	struct in_addr **list = (struct in_addr **)host->h_addr_list;
	
	return [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
}

@end
