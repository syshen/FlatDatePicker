//
//  SSAlarm.m
//  FlatDatePicker
//
//  Created by Shen Steven on 7/10/13.
//  Copyright (c) 2013 theXingApp. All rights reserved.
//

#import "SSAlarm.h"

static NSString *kSSAlarmKey = @"kSSAlarmDateKey";
static NSString *kSSAlarmRepeatKey = @"kSSAlarmRepeatKey";
@implementation SSAlarm

- (id)init {
  self = [super init];
  if (self) {
    _alarmDate = [[NSUserDefaults standardUserDefaults] valueForKey:kSSAlarmKey];
    _repeated = [[NSUserDefaults standardUserDefaults] boolForKey:kSSAlarmRepeatKey];
  }
  return self;
}

- (void) setAlarmDate:(NSDate *)alarmDate {
 
//  [self willChangeValueForKey:@"alarmDate"];
  _alarmDate = alarmDate;
//  [self didChangeValueForKey:@"alarmDate"];
  [[NSUserDefaults standardUserDefaults] setObject:alarmDate forKey:kSSAlarmKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
}

- (void) setRepeated:(BOOL)repeated {
  
//  [self willChangeValueForKey:@"repeated"];
  _repeated = repeated;
//  [self didChangeValueForKey:@"repeated"];
  [[NSUserDefaults standardUserDefaults] setBool:repeated forKey:kSSAlarmRepeatKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
}


@end
