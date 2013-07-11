//
//  SSAlarmScheduleViewController.m
//  FlatDatePicker
//
//  Created by Shen Steven on 7/10/13.
//  Copyright (c) 2013 theXingApp. All rights reserved.
//

#import "SSAlarmScheduleViewController.h"
#import "SSFlatDatePicker.h"
#import "SSFlatSwitch.h"
#import <FlatUIKit/FlatUIKit.h>

@interface SSAlarmScheduleViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation SSAlarmScheduleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) repeatedChanged:(id)sender {
  SSFlatSwitch *fswitch = (SSFlatSwitch*)sender;
  self.alarm.repeated = fswitch.on;
  [self.tableView reloadData];
}

- (void) dateChanged:(id)sender {
  
  SSFlatDatePicker *datePicker = (SSFlatDatePicker*)sender;
  NSDate *settingDate = self.alarm.alarmDate;
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *dc = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSTimeZoneCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:settingDate];
  NSDateComponents *settingComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSTimeZoneCalendarUnit fromDate:datePicker.date];
  dc.year = settingComponents.year;
  dc.month = settingComponents.month;
  dc.day = settingComponents.day;
  self.alarm.alarmDate = [calendar dateFromComponents:dc];
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.alarm.repeated)
    return 1;
  else
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 1)
    return 151;
  return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.textLabel.text = @"Daily repeat";
    SSFlatSwitch *enabledSwitch = [[SSFlatSwitch alloc] initWithFrame:CGRectMake(0, 0, 80, 34)];
    enabledSwitch.onLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    enabledSwitch.offLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    enabledSwitch.onColor = [UIColor midnightBlueColor];
    enabledSwitch.offColor = [UIColor silverColor];
    enabledSwitch.onBackgroundColor = [UIColor cloudsColor];
    enabledSwitch.offBackgroundColor = [UIColor cloudsColor];
    enabledSwitch.on = self.alarm.repeated;
    [enabledSwitch addTarget:self action:@selector(repeatedChanged:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = enabledSwitch;

    return cell;

  } else {
    static NSString *pickerCell = @"PickerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pickerCell];
    if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pickerCell];
    }
    
    for (UIView *subView in cell.contentView.subviews) {
      if ([subView isKindOfClass:[SSFlatDatePicker class]])
        [subView removeFromSuperview];
    }
    
    SSFlatDatePicker *datePicker = [[SSFlatDatePicker alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, 150)];
    datePicker.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    datePicker.datePickerMode = SSFlatDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    dispatch_async(dispatch_get_main_queue(), ^{
      [datePicker setDate:self.alarm.alarmDate animated:YES];
    });

    [cell.contentView addSubview:datePicker];
    return cell;
    
  }
}
@end
