//
//  SSViewController.m
//  FlatDatePicker
//
//  Created by Shen Steven on 5/29/13.
//  Copyright (c) 2013 theXingApp. All rights reserved.
//

#import "SSViewController.h"
#import "SSFlatDatePicker.h"
#import "SSAlarmSettingViewController.h"
#import "SSAlarmScheduleViewController.h"
#import "SSAlarm.h"
#import <FlatUIKit/FlatUIKit.h>
#import "SSFlatSwitch.h"

@interface SSViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SSAlarm *alarm;
@property (nonatomic, strong) UILabel *alarmLabel;
@end

@implementation SSViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.alarm = [[SSAlarm alloc] init];
  
  [self.alarm addObserver:self
               forKeyPath:@"alarmDate"
                  options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
                  context:nil];
  
  [UIBarButtonItem configureFlatButtonsWithColor:[UIColor cloudsColor] highlightedColor:[UIColor grayColor] cornerRadius:3];
  [[UIBarButtonItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor blackColor], UITextAttributeTextShadowOffset: @(0)} forState:UIControlStateNormal];

  [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor whiteColor]];
  /*
  [[SSFlatDatePicker appearance] setFont:[UIFont fontWithName:@"Georgia-BoldItalic" size:18]];
  [[SSFlatDatePicker appearance] setTextColor:[UIColor blackColor]];
  [[SSFlatDatePicker appearance] setBackgroundColor:[UIColor grayColor]];
  [[SSFlatDatePicker appearance] setGradientColor:[UIColor whiteColor]];
*/
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.tableView reloadData];
}

- (void) dealloc {
  [self.alarm removeObserver:self forKeyPath:@"alarmDate"];
}

- (NSString*)formattedStringForDate:(NSDate*)date {
  static NSDateFormatter *formatter = nil;
  if (!formatter) {
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterMediumStyle;
  }
  
  if (!date)
    return @"--:-- --";
  return [formatter stringFromDate:date];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  if ([keyPath isEqualToString:@"alarmDate"]) {
    NSDate *newDate = change[NSKeyValueChangeNewKey];
    if (self.alarmLabel) {
      self.alarmLabel.text = [self formattedStringForDate:newDate];
    }
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 3;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:28];
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = [UIColor blackColor];
  label.text = [self formattedStringForDate:self.alarm.alarmDate];
  [headerView addSubview:label];
  headerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  
  self.alarmLabel = label;
  return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

  return 300;

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
  }
  
  cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
  if (indexPath.row == 0) {
    cell.textLabel.text = @"Enabled";
    cell.detailTextLabel.text = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SSFlatSwitch *enabledSwitch = [[SSFlatSwitch alloc] initWithFrame:CGRectMake(0, 0, 80, 34)];
    enabledSwitch.onLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    enabledSwitch.offLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    enabledSwitch.onColor = [UIColor midnightBlueColor];
    enabledSwitch.offColor = [UIColor silverColor];
    enabledSwitch.onBackgroundColor = [UIColor cloudsColor];
    enabledSwitch.offBackgroundColor = [UIColor cloudsColor];
    enabledSwitch.on = YES;
    cell.accessoryView = enabledSwitch;
  } else if(indexPath.row == 1) {
    cell.textLabel.text = @"Alarm time";
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    cell.detailTextLabel.text = [formatter stringFromDate:self.alarm.alarmDate];
  } else {
    cell.textLabel.text = @"Schedule";
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.alarm.repeated) {
      cell.detailTextLabel.text = @"Repeated";
    } else {
      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      formatter.dateStyle = NSDateFormatterShortStyle;
      formatter.timeStyle = NSDateFormatterNoStyle;
      cell.detailTextLabel.text = [formatter stringFromDate:self.alarm.alarmDate];
    }
  }
  
  return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.row == 1) {
    SSAlarmSettingViewController *vc = [[SSAlarmSettingViewController alloc] initWithNibName:@"SSAlarmSettingViewController" bundle:nil];
    vc.alarm = self.alarm;
    [self.navigationController pushViewController:vc animated:YES];
  } else if (indexPath.row == 2){
    SSAlarmScheduleViewController *vc = [[SSAlarmScheduleViewController alloc] initWithNibName:@"SSAlarmScheduleViewController" bundle:nil];
    vc.alarm = self.alarm;
    [self.navigationController pushViewController:vc animated:YES];
  }
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  
}
@end
