//
//  TodayWeatherAppDelegate.h
//  TodayWeather
//
//  Created by eunkwang on 11. 5. 12..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//kr.smartzoo.${PRODUCT_NAME:rfc1034identifier} plist

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
//#import "ClinetConnector.h"


@class TodayWeatherViewController;

@interface TodayWeatherAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TodayWeatherViewController *viewController;
	
	// Core data
	NSManagedObjectContext *managedObjectContext;
	NSManagedObjectModel *managedObjectModel;
	NSPersistentStoreCoordinator *coordinator;
	
	// Socket network
//	ClinetConnector *conn;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TodayWeatherViewController *viewController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *coordinator;

//@property (nonatomic, retain) ClinetConnector *conn;

@end

