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
@property (nonatomic, strong) SSFlatDatePicker *datePicker;
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
  [self.datePicker setDate:[NSDate date] animated:YES];
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
  return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 1)
    return 150;
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
    enabledSwitch.on = YES;
    cell.accessoryView = enabledSwitch;

    return cell;

  } else {
    static NSString *pickerCell = @"PickerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pickerCell];
    if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pickerCell];
    }
    
    self.datePicker = [[SSFlatDatePicker alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
    self.datePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.datePicker.datePickerMode = SSFlatDatePickerModeDate;

    [cell.contentView addSubview:self.datePicker];
    return cell;
    
  }
}
@end
