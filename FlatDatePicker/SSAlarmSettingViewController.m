//
//  SSAlarmSettingViewController.m
//  FlatDatePicker
//
//  Created by Shen Steven on 7/10/13.
//  Copyright (c) 2013 theXingApp. All rights reserved.
//

#import "SSAlarmSettingViewController.h"
#import "SSFlatDatePicker.h"

@interface SSAlarmSettingViewController ()
@property (nonatomic, weak) IBOutlet SSFlatDatePicker *datePicker;
@end

@implementation SSAlarmSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.datePicker.datePickerMode = SSFlatDatePickerModeTime;
}

- (void) viewDidAppear:(BOOL)animated {
  
  [super viewDidAppear:animated];
  
  NSDate *date = self.alarm.alarmDate;
  if (date) {
    [self.datePicker setDate:date animated:YES];
  } else {
    NSDateComponents *dc = [[NSDateComponents alloc] init];
    dc.hour = 6;
    dc.minute = 0;
    dc.second = 0;
    date = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [self.datePicker setDate:date animated:YES];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (IBAction)dateChanged:(id)sender {

  SSFlatDatePicker *datePicker = (SSFlatDatePicker*)sender;
  NSDate *settingDate = self.alarm.alarmDate;

  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *dc = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSTimeZoneCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:settingDate];
  NSDateComponents *settingComponents = [calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSTimeZoneCalendarUnit fromDate:datePicker.date];
  dc.hour = settingComponents.hour;
  dc.minute = settingComponents.minute;
  self.alarm.alarmDate = [calendar dateFromComponents:dc];
  
}
@end
