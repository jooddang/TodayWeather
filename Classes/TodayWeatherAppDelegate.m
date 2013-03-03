//
//  TodayWeatherAppDelegate.m
//  TodayWeather
//
//  Created by eunkwang on 11. 5. 12..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TodayWeatherAppDelegate.h"
#import "TodayWeatherViewController.h"
//#import "setting.h"
#import "ReachabilityCallback.h"
#import "NetworkUtility.h"


@implementation TodayWeatherAppDelegate

#define TEXTVIEWTAG 11

@synthesize window;
@synthesize viewController;

@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize coordinator;

//@synthesize conn;


#pragma mark -
#pragma mark Application lifecycle

NSMutableData *receivedData;
NSURLResponse *response;


- (void) initCoreData
{
	NSError *error;
	
	//sql 파일 경로
	NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/settings.sqlite"];
	NSURL *url = [NSURL fileURLWithPath:path];
	
	// 모델 초기화
	managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
	
	//영구 저장 코디네이터 생성
	coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
	if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
		NSLog(@"error [%@]", [error localizedDescription]);
	}
	else {
		//컨텍스트 생성 후 코디네이터 할당.
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator:coordinator];
	}
	
}

- (BOOL)requestUrl:(NSString *)url withToken:(NSString *)token {
	// URL 접속 초기화
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] 
														   cachePolicy:NSURLRequestUseProtocolCachePolicy 
													   timeoutInterval:15.0]; 

	NSString *body = [NSString stringWithFormat:@"token=%@&user=%@",token, @"1231"];
	[request setHTTPMethod:@"POST"]; // POST로 선언하고
	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]]; // 전송할 데이터를 변수명=값&변수명=값 형태의 문자열로 등록
	
	// 헤더  추가가 필요하면 아래 메소드를 이용
	// [request setValue:value forHTTPHeaderField:key];
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (connection) { 
		receivedData = [[NSMutableData data] retain]; // 수신할 데이터를 받을 공간을 마련
		return YES;
	}
	
	return NO;
}

/////////////////// async http callbacks /////////////////
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse {
	[receivedData setLength:0]; 
	response = aResponse;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receivedData appendData:data]; 
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection fail with Error : %@", [error localizedDescription]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *data = [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease];
	NSLog(@"finished ::: data [%@]", data);
	[receivedData release];
}
///////////////////////////////////////////////


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
//	NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
	UILocalNotification *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
	
	if (userInfo) {
		// 앱 종료 상태에서 push 알림 수신 시. 백그라운드로 돌 때는 didReceiveRemoteNotification 를 거침. 여기 안 거침.
		NSLog(@"== didFinishLanchingWithOptions :: userInfo [%@]", userInfo);
		/*
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"push"
														message:@"push alarm"
													   delegate:self
											  cancelButtonTitle:@"Nooooo~~!!"
											  otherButtonTitles:nil]; 
		[alert show];
		[alert release];*/
	}
	else {
	}

	// network: register reachability watcher
//	[UIDevice scheduleReachabilityWatcher:self];
	
	
	[self initCoreData];
	
    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];
	
	/* register push alarm
	NSLog(@"=======register push notification ===========");
	[application registerForRemoteNotificationTypes:
	 UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound ];
	 */

    return YES;
}


////////////////////////////////////// PUSH ALARM ///////////////////////////////////////////


//- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)userInfo
{
	// when PUSH alarm arrived whlie this app is on foreground or running in background.
	UITextView *tv = (UITextView *) [[application keyWindow] viewWithTag:TEXTVIEWTAG];
	NSString *status = [NSString stringWithFormat:@"notification received:\n%@", [userInfo description]];
	tv.text = status;
	NSLog(@"didReceiveRemoteNotification [%@]", status);
	/*
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"received noti"
													message:[NSString stringWithFormat: @"userInfo[%@]", status]
												   delegate:self
										  cancelButtonTitle:@"No"
										  otherButtonTitles:nil]; 
	[alert show];
	[alert release];*/
}


NSString *pushStatus() {
	return [[UIApplication sharedApplication] enabledRemoteNotificationTypes] ?
			@"push is active" :
			@"push is NOT active";
}


//- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)localNotification {
//	// 실행중이거나 백그라운드 모드일 때 로컬 알림이 들어오면 여기서 처리
//	NSLog(@"local alarm received");
//}


- (void) confirmationWasHidden: (NSNotification *) notification {
	// 승인 대화상자가 사라지는 시점에...
	// "i want push alarm"
	NSLog(@"confirmationWasHidden.....");
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
		UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound ];
}



- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

	//get Device Token
//	[self showString:[NSString stringWithFormat:@"%@\nRegistration succeeded.\n\ndevice token:%@", pushStatus(), deviceToken]];
	NSLog(@"registered remote notification: device token [%@]",
		  [NSString stringWithFormat:@"%@\nRegistration succeeded.\n\ndevice token:%@", pushStatus(), deviceToken]);

//	conn = [[ClinetConnector alloc] initWithIF:self];
//	[conn connect:ip port:18181];

	NSString *token =  [[NSString alloc] initWithString:[[[deviceToken description] 
						stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
					   stringByReplacingOccurrencesOfString:@" " withString:@""]];

	//reachability check
//	if ([NetworkUtility hostAvailable:@"sparcs.org"] == YES) {
	if ([NetworkUtility hostAvailable:@"http://damnsluts.appspot.com"] == YES) 
	{
		NSLog(@"1");
		// send token (async callbacks)
		if ([self requestUrl:@"http://damnsluts.appspot.com/" withToken:token] == YES) {
			NSLog(@"ok, yes");
		}
	}
	
	
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"register succeed"
//													message:[NSString stringWithFormat: @"device token[%@]", deviceToken]
//												   delegate:self
//										  cancelButtonTitle:@"No"
//										  otherButtonTitles:nil]; 
//	[alert show];
//	[alert release];
}


- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationWithError:(NSError *)error
{
	// when push alarm register failed. overrided by delegate
	UITextView *tv = (UITextView *) [[application keyWindow] viewWithTag:TEXTVIEWTAG];
	NSString *status = [NSString stringWithFormat:@"%@\nRegistration failed.\n\nError:%@", 
						pushStatus(), [error localizedDescription]];
	tv.text = status;
//	[self showString:status];
	NSLog(@"didFailToRegisterForRemoteNotificationWithError [%@]",status);
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"register fail"
													message:[NSString stringWithFormat: @"error[%@]", status]
												   delegate:self
										  cancelButtonTitle:@"Nooo"
										  otherButtonTitles:nil]; 
	[alert show];
	[alert release];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

/*////////////////////////////////////// Socket Network //////////////////////////////////////////////////////

- (void) OnReceive:(NSString*) msg {
	
//		rcvMsg.text = [rcvMsg.text stringByAppendingString:msg];
	NSLog(@"OnReceive in delegate [%@]", msg);
	
	if ([msg isEqualToString:@"damn it"] == YES) {
		[conn disconnect];
	}
}

- (void) OnError:(NSError*) err {
	NSLog(@"socket on error in delegate [%@]", [err description]);
	[conn disconnect];
}

- (void) OnConnected {
	NSLog(@"Connected... in delegate");	
	NSLog(@"onConnected: send data [%@]", token);
	[conn send:token];
	
//	return 0;
}
- (void) OnDisconnect {
	NSLog(@"Disconnected.... in delegate");
//	return 0;
}

*//////////////////////////////////////////////////////////////////////////////////////////////////////////////



- (void) reachabilityChanged {
	NSLog(@"reachability changed");
}




- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	//push alarm badge number to 0
	application.applicationIconBadgeNumber = 0;
	
	// background 에서 돌아올 때마다 새로 날씨 업데이트
	NSLog(@"delegate vc [%@]", self.viewController);
	[self.viewController performSelectorInBackground:@selector(getWeatherInformation) withObject:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	
//	[conn release];
	[coordinator release];
	[managedObjectContext release];
    
	[viewController release];
    [window release];
    [super dealloc];
}


@end
