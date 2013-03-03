//
//  TWBrain.h
//  TodayWeather
//
//  Created by eunkwang on 11. 5. 12..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLParser.h"


@interface TWBrain : NSObject {

	XMLParser *weatherXML;
	NSDictionary *regionAndXMLAddress;
}

@property (nonatomic, retain) NSDictionary *regionAndXMLAddress;

- (XMLParser *)weatherXML;
+ (NSArray *) regionList;
+ (void) reserveLocalNotification: (NSString *)time;
- (NSDictionary *) getWeatherInformation;

@end
