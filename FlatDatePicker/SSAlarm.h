//
//  SSAlarm.h
//  FlatDatePicker
//
//  Created by Shen Steven on 7/10/13.
//  Copyright (c) 2013 theXingApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSAlarm : NSObject

@property (nonatomic, strong) NSDate *alarmDate;
@property (nonatomic, readwrite) BOOL repeated;

@end
