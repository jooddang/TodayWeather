//
//  TodayWeatherViewController.h
//
//  Created by eunkwang on 11. 5. 12..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWBrain.h"
#import "SettingViewController.h"

@interface TodayWeatherViewController : UIViewController {

	TWBrain *brain;
	IBOutlet UILabel *weatherDescription;
	IBOutlet UIImageView *weatherImage;
	
	SettingViewController *settingViewController;
}

@property (nonatomic, retain) SettingViewController *settingViewController;

- (IBAction) settingPressed:(UIBarButtonItem *)sender;
- (void) getWeatherInformation;

//- (IBAction) connTestPressed:(UIBarButtonItem *)sender;
//- (IBAction) disconPressed:(UIBarButtonItem *)sender;
//- (IBAction) sendPressed:(UIBarButtonItem *)sender;

@end
