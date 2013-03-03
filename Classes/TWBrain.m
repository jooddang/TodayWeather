//
//  TWBrain.m
//  TodayWeather
//
//  Created by eunkwang on 11. 5. 12..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TWBrain.h"
//#import <CoreData/CoreData.h>
#import "TodayWeatherAppDelegate.h"
#import "setting.h"


@implementation TWBrain

@synthesize regionAndXMLAddress;

int MAX_LOCALNOTIFICATION_DATE = 30;

//위치기반?

+ (NSArray *) regionList {
	return [[NSMutableArray alloc] initWithObjects:
			@"서울특별시",	//0
			@"인천광역시",	//2
			@"경기도 남부",	//9	
			@"경기도 북부",	//10
			@"대전광역시",	//3
			@"충청북도",	//15
			@"충청남도",	//16
			@"강원도 영서",	//7
			@"강원도 영동",	//8
				  @"부산광역시",	//1
				  @"대구광역시",	//4
				  @"울산광역시",	//6
				  @"경상북도",	//11
			@"경상남도",	//12
			@"광주광역시",	//5
				  @"전라북도",	//13
				  @"전라남도",	//14
				  @"제주특별자치도 북부",	//17
				  @"제주특별자치도 남부",	//18
			nil]; 
}

+ (void) reserveLocalNotification: (NSString *)time {
	
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	NSDate *date = [NSDate date];
	NSDateComponents *dateComponents = [cal components:unitFlags fromDate:date];
	NSArray *alarmTime = [[NSString stringWithString:time] componentsSeparatedByString:@":"];
	
	
	NSInteger hour = [dateComponents hour];
	NSInteger minute = [dateComponents minute];
	
	// 알람시간 세팅
	[dateComponents setHour:[[alarmTime objectAtIndex:0] intValue]];
	//		[dateComponents setMinute:4];
	[dateComponents setMinute:[[alarmTime objectAtIndex:1] intValue]];
	[dateComponents setSecond:0];
	date = [cal dateFromComponents:dateComponents];
	NSLog(@"h[%d] m[%d]", hour, minute);
	NSLog(@"0 :[%d] 1: [%d]",[[alarmTime objectAtIndex:0] intValue],[[alarmTime objectAtIndex:1] intValue]);

	NSDateComponents *getTommorrow = [[NSDateComponents alloc] init];
	[getTommorrow setDay:1];

	if ([[alarmTime objectAtIndex:0] intValue] <= hour) {
		if ([[alarmTime objectAtIndex:1] intValue] <= minute) {
			// 오늘은 해당 시간이 지났으니 내일날짜로 하루 +1 
			date = [cal dateByAddingComponents:getTommorrow toDate:date options:0];
		}
	}
	
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
	UILocalNotification *localNotification = [[[UILocalNotification alloc] init] autorelease];
//	localNotification.fireDate = date;
	localNotification.timeZone = [NSTimeZone defaultTimeZone];
	localNotification.alertBody = @"오늘 비와? 알림입니다\n날씨를 확인하세요!:)";
	localNotification.alertAction = nil;
	localNotification.soundName = UILocalNotificationDefaultSoundName;
	localNotification.applicationIconBadgeNumber = 1;
	
	for (int i = 0; i < MAX_LOCALNOTIFICATION_DATE; i++) {
		localNotification.fireDate = date;
		[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
		date = [cal dateByAddingComponents:getTommorrow toDate:date options:0];
	}
	
	NSLog(@"alarmdate [%@]", date);
	[getTommorrow release];	
	/*
	[localNotification release];
	[dateComponents release];
	[date release];
	[alarmTime release];
	[cal release];*/
}


- (NSDictionary *) regionAndXMLAddress
{
	if (!regionAndXMLAddress) {
		
		NSArray *regions = [TWBrain regionList];
		
		// 기상청 주간 예보시 대표지역들로 선정했음. 구/동단위로 쪼개는건 개삽질 같아서 동은 임의로 선정.
		regionAndXMLAddress = [[NSDictionary alloc] initWithObjectsAndKeys:
							   @"http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=1111061500", [regions objectAtIndex:0] , //서울특별시 종로구 종로1.2.3.4가동
							   @"http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=2811061000", [regions objectAtIndex:2], //인천광역시 중구 송월동
							   @"http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=4111751000", [regions objectAtIndex:9], //경기도 수원시영통구 매탄1동
							   @"http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=4115051000", [regions objectAtIndex:10], //경기도 의정부시 의정부1동
							   @"http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=3020058000", [regions objectAtIndex:3], //대전광역시 유성구 구즉동
							   @"http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=4311168000", [regions objectAtIndex:15], //충청북도 청주시상당구 금천동
							   @"http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=4421052500", [regions objectAtIndex:16], //충청남도 서산시 동문1동
							   @"http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=4211062000", [regions objectAtIndex:7], //강원도 춘천시 효자1동
							   @"http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=4215060000", [regions objectAtIndex:8], //강원도 강릉시 내곡동
							   @"http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=2611058000", [regions objectAtIndex:1],	 //부산광역시 중구 남포동
							   @"http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=2726057000", [regions objectAtIndex:4], //대구광역시 수성구 수성1가동
							   @"http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=3111061000", [regions objectAtIndex:6], //울산광역시 중구 다운동
							   @"http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=4717051000", [regions objectAtIndex:11], //경상북도 안동시 중구동 
							   @"http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=4812352000", [regions objectAtIndex:12], //경상남도 창원시 성산구 중앙동
							   @"http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=2920054000", [regions objectAtIndex:5], //광주광역시 광산구 도산동
							   @"http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=4511160500", [regions objectAtIndex:13], //전라북도 전주시완산구 노송동
							   @"http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=4611056500", [regions objectAtIndex:14], //전라남도 목포시 대성동
							   @"http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=5011059000", [regions objectAtIndex:17], //제주특별자치도 제주시 건입동 
							   @"http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=5013053000", [regions objectAtIndex:18], //제주특별자치도 서귀포시 중앙동
							   nil];
	}
	return regionAndXMLAddress;
}


- (XMLParser *)weatherXML
{
	if (!weatherXML) {
		NSLog(@"weatherXML alloc");
		weatherXML = [[XMLParser alloc] init];
	}
	return weatherXML;
}


- (NSDictionary *) getWeatherInformation
{	
//	NSManagedObjectContext *context = [[[UIApplication sharedApplication] delegate] managedObjectContext];
//	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//	
//	[fetchRequest setEntity:[NSEntityDescription entityForName:@"setting" inManagedObjectContext:context]];
//	
////	NSPredicate *searchFilter = [NSPredicate predicateWithFormat:@"attribute = %@", @"alarmSwitch"];
//	NSError *error = nil;
//	NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
	
	
	
	// DB에 세팅이 있으면 그걸 쓰고, 없으면 하나 만든다.
	NSError *error;
	NSManagedObjectContext *context = [(TodayWeatherAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	
	NSFetchRequest* fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"setting" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
	
    NSMutableArray *entities = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
	NSString *regionForPath;
	NSString *alarmTime;
	BOOL alarmSwitch = NO; 
    for (setting *e in entities) {
		regionForPath = e.region;
		alarmTime = e.alarmTime;
		alarmSwitch = [e.alarmSwitch boolValue];
		NSLog(@"entities count [%u]", [entities count]);
		NSLog(@"on[%@] time[%@] region[%@]", e.alarmSwitch, e.alarmTime, e.region);
	}
	NSLog(@"==========entities count [%u]", [entities count]);
	
	if (entities == NULL || [entities count] == 0) {
		//	NSDateFormatter *defaultDate = [[[NSDateFormatter alloc] init] autorelease];
		//	defaultDate.dateFormat = @"h:mm a";
		setting *set = (setting *) [NSEntityDescription insertNewObjectForEntityForName:@"setting" inManagedObjectContext:context];
		set.alarmSwitch = [NSNumber numberWithInt:YES];
		set.alarmTime = [NSString stringWithString:@"6:00"]; //[defaultDate dateFromString:@"6:00 AM"];
		set.region = [NSString stringWithString:@"서울특별시"];	
		
		regionForPath = set.region;
		alarmTime = set.alarmTime;
		alarmSwitch = [set.alarmSwitch boolValue];
		
		if ([context save:&error] == NO) {
			NSLog(@"db insert failed [%@]", [error localizedDescription]);
		}
		else {
			NSLog(@"[db insert success]");
		}
	}
	
	//이걸 여기에 놓는건 참 구리지만 귀찮아서 어쩔 수가 없다. -_-;;
	if (alarmSwitch == YES) {
		NSLog(@"TWBrain:: reserve local notification?!!! switch[%d] time[%@]", alarmSwitch, alarmTime);
		[TWBrain reserveLocalNotification:alarmTime];
	}
	
	NSString *path = [[self regionAndXMLAddress] objectForKey:regionForPath];
	return [[self weatherXML] parseXMLFileAtURL:path];
}

- (void) dealloc {
	NSLog(@"weatherXML release");
	[weatherXML release];
	[regionAndXMLAddress release];
	
	[super dealloc];
}

	
@end
