//
//  SSFlatDatePicker.h
//  FlatDatePicker
//
//  Created by Shen Steven on 5/29/13.
//  Copyright (c) 2013 theXingApp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SSFlatDatePickerMode) {
  SSFlatDatePickerModeDate = 0,
  SSFlatDatePickerModeTime = 1,
  //  SSFlatDatePickerDateTimeMode = 2
};

@interface SSFlatDatePicker : UIControl

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) UIFont *font UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *gradientColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) SSFlatDatePickerMode datePickerMode;

- (void) setDate:(NSDate*)date animated:(BOOL)animated;

@end

