//
//  SettingViewController.h
//  TodayWeather
//
//  Created by eunkwang on 11. 5. 14..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate> {

	IBOutlet UIButton *buttonAlarmTime;
	IBOutlet UIButton *buttonRegion;
	IBOutlet UISwitch *switchAlarm;
}

- (IBAction) alarmPressed:(UISwitch *)sender;
- (IBAction) timeChangePressed:(UIButton *)sender;
- (IBAction) regionChangePressed:(UIButton *)sender;
- (IBAction) confirmPressed:(UIBarButtonItem *)sender;

@end
