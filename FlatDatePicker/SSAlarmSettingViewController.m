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
  
  [self.alarm setAlarmDate:self.datePicker.date];
  
}
@end
