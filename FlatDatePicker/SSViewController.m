//
//  SSViewController.m
//  FlatDatePicker
//
//  Created by Shen Steven on 5/29/13.
//  Copyright (c) 2013 theXingApp. All rights reserved.
//

#import "SSViewController.h"
#import "SSFlatDatePicker.h"

@interface SSViewController ()
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet SSFlatDatePicker *datePicker;
@end

@implementation SSViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  /*
  [[SSFlatDatePicker appearance] setFont:[UIFont fontWithName:@"Georgia-BoldItalic" size:22]];
  [[SSFlatDatePicker appearance] setTextColor:[UIColor blackColor]];
  [[SSFlatDatePicker appearance] setBackgroundColor:[UIColor blackColor]];
  [[SSFlatDatePicker appearance] setGradientColor:[UIColor grayColor]];
   */
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self.datePicker setDate:[NSDate date] animated:YES];
  [self datePickerValueDidChange:self.datePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) datePickerValueDidChange:(id)sender {
  
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateStyle = NSDateFormatterMediumStyle;
  formatter.timeStyle = NSDateFormatterNoStyle;
  
  self.dateLabel.text = [formatter stringFromDate:self.datePicker.date];
  
}

@end
