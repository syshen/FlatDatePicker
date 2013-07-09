//
//  SSFlatDatePicker.h
//  FlatDatePicker
//
//  Created by Shen Steven on 5/29/13.
//  Copyright (c) 2013 theXingApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSFlatDatePicker : UIControl

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) UIFont *font UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *gradientColor UI_APPEARANCE_SELECTOR;

- (void) setDate:(NSDate*)date animated:(BOOL)animated;

@end

/*
@interface SSFlatTimePicker : UIControl

@property (nonatomic, strong) NSDate *date;
- (void) setDate:(NSDate*)date animated:(BOOL)animated;

@end
*/