//
//  TodayWeatherViewController.m
//
//  Created by eunkwang on 11. 5. 12..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TodayWeatherViewController.h"
//#import "NetworkUtility.h"
//#import "ClinetConnector.h"

@implementation TodayWeatherViewController

@synthesize settingViewController;


/******************************
//ClinetConnector *conn;

- (IBAction) connTestPressed:(UIBarButtonItem *)sender {
//	NSString * ip = [NetworkUtility getIPAddressForHost:@"sparcs.org"];
//	NSLog(@"conTest pressed: ip[%@]", ip);
//	
//	conn = [[ClinetConnector alloc] initWithIF:self];
//	[conn connect:ip port:18181];

}

- (IBAction) sendPressed:(UIBarButtonItem *)sender {
	
//	NSString* sendData = @"test data";
//	NSLog(@"send data [%@]", sendData);
//	[conn send:sendData];
}


- (IBAction) disconPressed:(UIBarButtonItem *)sender {
	
//	[conn disconnect];
}

- (void) OnReceive:(NSString*) msg {
	
	//		rcvMsg.text = [rcvMsg.text stringByAppendingString:msg];
	NSLog(@"OnReceive in VC [%@]", msg);
	
	//	return 0;
}
- (void) OnError:(NSError*) err {
	NSLog(@"socket on error in VC [%@]", [err description]);
	
	//	return 0;
}

- (void) OnConnected {
	NSLog(@"Connected... in VC");
	
	//	return 0;
}
- (void) OnDisconnect {
	NSLog(@"Disconnected.... in VC");
//	[conn release];
	//	return 0;
}
 
***************************************/



- (IBAction) settingPressed:(UIBarButtonItem *)sender
{	
//	[weatherImage setImage:[UIImage imageNamed:@"rainy.png"]];

//	[self.parentViewController 
//	SettingViewController *settingView = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:[NSBundle mainBundle]];
	
//	[self.view addSubview:settingView.view];
//	[self presentModalViewController:settingView animated:YES];
	
	// 아래에서 위로 slide in 하는거 어떻게 해야할지 모르게뜸 ㅋ 
	//settingViewController.view.frame = CGRectMake(0, 480, 20, 60);  
	settingViewController.view.frame = CGRectMake(0, 0, 320, 460);
	
	[UIView transitionWithView:self.view
                      duration:1
					   options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{[self.view addSubview:settingViewController.view];}
                    completion:^(BOOL finished){ }];
//	[UIView animateWithDuration:1 
//					 animations:^{settingViewController.view.frame = CGRectMake(0, 20, 320, 460);}
//					 completion:^(BOOL finished){ [self.view addSubview:settingViewController.view]; }];
}



/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

- (void) getWeatherInformation
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSDictionary *weatherInfo = [brain getWeatherInformation];
	
//	NSLog(@"view controller's get Weather info[%@]", weatherInfo);
	// display weather info
	[weatherDescription setText:[weatherInfo objectForKey:@"weatherDescription"]];
	NSString *imageName = [NSString stringWithFormat:@"%@.png", [weatherInfo objectForKey:@"weatherImage"]];
	[weatherImage setImage:[UIImage imageNamed:imageName]];
	
	[pool release];
}

 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad 
{
	[super viewDidLoad];
	
	// setting view alloc
	settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
	
    NSLog(@"brain alloc");
	// get weather info
	brain = [[TWBrain alloc] init];
//	[self getWeatherInformation];
	// 비동기 xml loading
//	[self performSelectorInBackground:@selector(getWeatherInformation) withObject:nil];
	
 }
 


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    NSLog(@"brain release");
	[brain release];
	[settingViewController release];
    [super dealloc];
}

@end
