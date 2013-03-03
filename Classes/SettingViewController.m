//
//  SettingViewController.m
//  TodayWeather
//
//  Created by eunkwang on 11. 5. 14..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
//#import <CoreData/CoreData.h>
#import "TodayWeatherAppDelegate.h"
#import "setting.h"
#import "TWBrain.h"


@implementation SettingViewController


UIActionSheet *action;

//NSArray *regionList;
NSMutableArray *regionList;
NSString *AM;
NSString *PM;


- (NSString *) getLanguage {
	//아이폰 언어 설정 가져오기
	NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
	NSArray* languages = [defs objectForKey:@"AppleLanguages"];
	NSString* preferredLang = [languages objectAtIndex:0];
	NSLog(@"getLanguage:[%@]", preferredLang);
	
	return preferredLang;
}


- (IBAction) alarmPressed:(UISwitch *)sender
{
	/*
	UISwitch *onOff = (UISwitch *)sender;
	if (onOff.isOn == NO) {
	 
		 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"끄지마!"
														 message:@"알람설정이 이 앱의 핵심기능이라규!\n너 내일 우산안들고나왔는데 비와라!:P"
														delegate:self
											   cancelButtonTitle:@"Nooooo~~!!"
											   otherButtonTitles:nil]; 
		 [alert show];
		 [alert release];
	 }
	 */
}


- (void) doDatePickerDoneClick
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = @"h:mm a";
	
	UIDatePicker *tempDatePicker = (UIDatePicker *)[action viewWithTag:101];
	NSString *timestamp = [formatter stringFromDate:tempDatePicker.date];
 
	NSString *hour = [timestamp substringToIndex:[timestamp rangeOfString:@":"].location];
	NSString *min = [timestamp substringWithRange:NSMakeRange([timestamp rangeOfString:@":"].location + 1, 2)];
//	NSLog(@"doneClick: timestamp=[%@] hour [%@] min [%@] hour intvalue[%d]", timestamp, hour, min, [hour intValue]);
	
	if ([timestamp rangeOfString:PM].location != NSNotFound && [hour intValue] < 12) {
		hour = [NSString stringWithFormat:@"%d", [hour intValue] + 12];
	}
	else if ([timestamp rangeOfString:AM].location != NSNotFound && [hour intValue] == 12) {
		hour = [NSString stringWithString:@"0"];
	}
	timestamp = [NSString stringWithFormat:@"%@:%@", hour, min];
//	NSLog(@"doneClick: new timestamp=[%@] ", timestamp);
	
	[buttonAlarmTime setTitle:timestamp forState:UIControlStateNormal];
	[action dismissWithClickedButtonIndex:1 animated:YES];
//	[datePicker release];
	[action release];
	
	[UIView transitionWithView:self.view duration:0.3 options:0 animations:^{self.view.frame = CGRectMake(0, 0, 320, 460);} completion:^(BOOL finished) {}];
}


- (IBAction) timeChangePressed:(UIButton *)sender
{	
	UIDatePicker *datePicker;

	datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
	datePicker.datePickerMode = UIDatePickerModeTime;
	datePicker.tag = 101;
	datePicker.minuteInterval = 10;
	
	NSLog(@"titlelabel [%@]", buttonAlarmTime.titleLabel.text);
	NSString *hour = [buttonAlarmTime.titleLabel.text substringToIndex:[buttonAlarmTime.titleLabel.text rangeOfString:@":"].location];
	NSString *min = [buttonAlarmTime.titleLabel.text substringWithRange:NSMakeRange([buttonAlarmTime.titleLabel.text rangeOfString:@":"].location + 1, 2)];
//	if ([buttonAlarmTime.titleLabel.text rangeOfString:PM].location != NSNotFound && [hour intValue] < 12) {
//		hour = [NSString stringWithFormat:@"%d", [hour intValue] + 12];
//	}
//	else if ([buttonAlarmTime.titleLabel.text rangeOfString:AM].location != NSNotFound && [hour intValue] == 12) {
//		hour = [NSString stringWithString:@"0"];
//	}
	NSLog(@"hour[%@], min[%@]", hour, min);
	NSDateComponents *comp = [[NSDateComponents alloc] init];
	[comp setHour:[hour intValue]];
	[comp setMinute:[min intValue]];
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *defaultDate = [cal dateFromComponents:comp];
	NSLog(@"date [%@]", defaultDate);
	[comp release];
	[cal release];
	NSLog(@"date 2222 [%@]", defaultDate);
	
//	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
//	formatter.dateFormat = @"h:mm a";
//	NSDate *defaultDate = [formatter dateFromString:buttonAlarmTime.titleLabel.text];
	
//	NSLog(@"defaultDate [%@] formatter [%@]", defaultDate, [NSString string formatter);
	
	[datePicker setDate:defaultDate animated:YES];
	
	UIToolbar *datePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	datePickerToolbar.barStyle = UIBarStyleBlackOpaque;
	[datePickerToolbar sizeToFit];
	
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
	
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																				   target:self
																				   action:nil];
	[barItems addObject:flexibleSpace];
	[flexibleSpace release];
	
	UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																			  target:self
																			  action:@selector(doDatePickerDoneClick)];
	[barItems addObject:buttonDone];
	[buttonDone release];
	[datePickerToolbar setItems:barItems animated:YES];
	[barItems release];

	action = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	[action addSubview:datePickerToolbar];
	[action addSubview:datePicker];
	
	[datePicker release];
	[datePickerToolbar release];
	
	[action showInView:self.view];
	[action setBounds:CGRectMake(0, 0, 320, 500)];
	
	[UIView transitionWithView:self.view duration:0.3 options:0 animations:^{self.view.frame = CGRectMake(0, -30, 320, 460);} completion:^(BOOL finished) {}];
}





// pickerview delegate implementation
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	//wheel = 1
	return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [regionList count];
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{	
	return [regionList objectAtIndex:row];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// 현재 모습을 보여줌
	UIPickerView *regionPicker = (UIPickerView *)[actionSheet viewWithTag:101];
	self.title = [NSString  stringWithFormat:@"%@",[regionPicker selectedRowInComponent:0]];
}

- (void) doRegionPickerDoneClick
{
	UIPickerView *tempPicker = (UIPickerView *)[action viewWithTag:101];
	NSString *regionSelected = [regionList objectAtIndex:[tempPicker selectedRowInComponent:0]];
	NSLog(@"region selected =[%@]", regionSelected);
	
	[buttonRegion setTitle:regionSelected forState:UIControlStateNormal];
	[action dismissWithClickedButtonIndex:1 animated:YES];

	[action release];
	
	[UIView transitionWithView:self.view duration:0.3 options:0 animations:^{self.view.frame = CGRectMake(0, 0, 320, 460);} completion:^(BOOL finished) {}];
}

- (IBAction) regionChangePressed:(UIButton *)sender
{		
	action = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	[action showInView:self.view];
	
	
	UIToolbar *regionPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	regionPickerToolbar.barStyle = UIBarStyleBlackOpaque;
	[regionPickerToolbar sizeToFit];
	
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
	
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																				   target:self
																				   action:nil];
	[barItems addObject:flexibleSpace];
	[flexibleSpace release];
	
	UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																				target:self
																				action:@selector(doRegionPickerDoneClick)];
	[barItems addObject:buttonDone];
	[buttonDone release];
	[regionPickerToolbar setItems:barItems animated:YES];
	[barItems release];

	[action addSubview:regionPickerToolbar];
	[regionPickerToolbar release];
	
	UIPickerView *regionPicker = [[[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 0, 0)] autorelease];
	regionPicker.tag = 101;
	regionPicker.delegate = self;
	regionPicker.dataSource = self;
	regionPicker.showsSelectionIndicator=YES;

	[regionPicker selectRow:[regionList indexOfObject:buttonRegion.titleLabel.text] inComponent:0 animated:YES];
	[action addSubview:regionPicker];
	
	[action setBounds:CGRectMake(0, 0, 320, 500)];
	
	[UIView transitionWithView:self.view duration:0.3 options:0 animations:^{self.view.frame = CGRectMake(0, -90, 320, 460);} completion:^(BOOL finished) {}];
}






//- (void) removeWithAnimation {
//    [UIView transitionWithView:self.view 
//                      duration:1.0
//                       options:UIViewAnimationOptionTransitionCurlUp 
//                    animations:^{ [self.view removeFromSuperview]; }
//                    completion:NULL];
//}


- (IBAction) confirmPressed:(UIBarButtonItem *)sender
{
	NSManagedObjectContext *context = [(TodayWeatherAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"setting" inManagedObjectContext:context]];
	
	// DB에 데이터 변경
	NSError *error;
	NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
	setting *fetchedData = [result objectAtIndex:0];
	fetchedData.alarmSwitch = [NSNumber numberWithBool:switchAlarm.on];
	fetchedData.alarmTime = buttonAlarmTime.titleLabel.text;
	fetchedData.region = buttonRegion.titleLabel.text;
	
	NSLog(@"setting data update alarm[%@], time[%@], region[%@]", fetchedData.alarmSwitch, fetchedData.alarmTime, fetchedData.region);
	
	if ([context save:&error] == NO) {
		NSLog(@"confirmPressed::  nononono!!!!!!!!!! 데이터 저장 에러..T.T");
	}
	/*
	[context release];
	[fetchRequest release];
	[error release];
	[result release];
	[fetchedData release];*/

	// localNotification setting
	if ([switchAlarm isOn] == YES) {
		[TWBrain reserveLocalNotification:buttonAlarmTime.titleLabel.text];
	}
	else {
		NSLog(@"isOff.");
		// 알람 끄는 로직
		[[UIApplication sharedApplication] cancelAllLocalNotifications];
	}

	
	// XML 다시 읽어오기.
	TodayWeatherViewController *tt = (TodayWeatherViewController *)[self.view.superview nextResponder];
//	[tt getWeatherInformation];
	[tt performSelectorInBackground:@selector(getWeatherInformation) withObject:nil];
	NSLog(@"==== confirmpressed:: self's parentviewcontroller= [%@]", [self.view.superview nextResponder]);
	
	// 뷰 사라지는 애니메이션
	//	[self performSelector:@selector(removeWithAnimation) withObject:nil afterDelay:0.0];
	[UIView transitionFromView:self.view
						toView:self.parentViewController.view
					  duration:1
					   options:UIViewAnimationOptionTransitionFlipFromLeft
					completion:^(BOOL finished){ [self.view removeFromSuperview]; }];
	
//	[tt release];
	
//	[UIView transitionFromView:self.view
//					  duration:1 
//						options:UIViewAnimationOptionTransitionFlipFromLeft
//					animations:^{ }
//					 completion:^(BOOL finished){ [self.view removeFromSuperview]; }];

	//					 animations:^{self.view.frame = CGRectMake(0, 480, 320, 480);}
	
//	[UIView transitionWithView:self.view
//                      duration:1
//					   options:UIViewAnimationOptionTransitionFlipFromRight
//                    animations:^{[self.view addSubview:settingViewController.view];}
//                    completion:^(BOOL finished){ }];	
}



// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

	regionList = [[NSMutableArray alloc] initWithArray:[TWBrain regionList]];
//	NSLog(@"aaaaa[%@] count [%@]", [regionList objectAtIndex:19], [regionList objectAtIndex:1]);
//	for (NSString *str in regionList) {
//		NSLog(@"items [%@]", str);
//	}
	if ([[self getLanguage] isEqualToString:@"ko"]) {
		AM = [[NSString alloc] initWithString: @"오전"];
		PM = [[NSString alloc] initWithString: @"오후"];
	}
	else {
		AM = [[NSString alloc] initWithString: @"AM"];
		PM = [[NSString alloc] initWithString: @"PM"];
	}

	
	NSManagedObjectContext *context = [(TodayWeatherAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"setting" inManagedObjectContext:context]];
	
	NSError *error;
	BOOL alarmSwitch = NO;
	NSString *alarmTime = [NSString stringWithString:@"6:00"];
	NSString *region = [NSString stringWithString:@"서울특별시"];
	NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
	
    for (setting *e in result) {
		NSLog(@"entities count [%lu]", [result count]);
		alarmSwitch = [e.alarmSwitch boolValue];
		alarmTime = e.alarmTime;
		region = e.region;
		NSLog(@"on[%@] time[%@] region[%@]", e.alarmSwitch, e.alarmTime, e.region);
	}
//	alarmTime = @"0:10";

	[switchAlarm setOn:alarmSwitch];
	[buttonAlarmTime setTitle:alarmTime forState:UIControlStateNormal];
	[buttonRegion setTitle:region forState:UIControlStateNormal];
	
//	self.view.backgroundColor = [UIColor blueColor];
	
    [super viewDidLoad];

/*	[context release];
	[fetchRequest release];
	[error release];
	[alarmTime release];
	[region release];
	[result release];*/
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[AM release];
	[PM release];
	[regionList release];
    [super dealloc];
}


@end
