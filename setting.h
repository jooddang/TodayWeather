//
//  setting.h
//  TodayWeather
//
//  Created by eunkwang on 11. 5. 16..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface setting :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * alarmSwitch;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) NSString * alarmTime;

@end



