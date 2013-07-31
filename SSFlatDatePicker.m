//
//  SSFlatDatePicker.m
//  FlatDatePicker
//
//  Created by Shen Steven on 5/29/13.
//  Copyright (c) 2013 theXingApp. All rights reserved.
//

#import "SSFlatDatePicker.h"
#import <QuartzCore/QuartzCore.h>

@class SSFlatDatePickerCollectionView;

#pragma mark - SSDatePickerLayoutAttriutes
@interface SSDatePickerLayoutAttributes : UICollectionViewLayoutAttributes
@property (nonatomic, strong) CAGradientLayer *gradient;
@end

@implementation SSDatePickerLayoutAttributes

- (id)copyWithZone:(NSZone *)zone {
  
  SSDatePickerLayoutAttributes *attributes = [super copyWithZone:zone];
  attributes.gradient = _gradient;
  return attributes;
  
}
@end

#pragma mark - SSFlatDatePickerFlowLayout
@interface SSFlatDatePickerFlowLayout : UICollectionViewFlowLayout
@end

@implementation SSFlatDatePickerFlowLayout

- (void)prepareLayout {
  
  self.scrollDirection = UICollectionViewScrollDirectionVertical;
  self.minimumInteritemSpacing = 0;
  self.minimumLineSpacing = 0;
  self.itemSize = CGSizeMake(self.collectionView.frame.size.width, ((CGFloat)(self.collectionView.frame.size.height)/5.0f));
  
  CGFloat h = (CGFloat)self.collectionView.frame.size.height/2.0f - (CGFloat)self.itemSize.height/2.0f;
  self.sectionInset = UIEdgeInsetsMake(h, 0, h, 0);

}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
  NSMutableArray *array = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
 
  for (SSDatePickerLayoutAttributes *attr in array) {
    [self applyAttributes:attr];
  }

  return array;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  SSDatePickerLayoutAttributes *attributes = (SSDatePickerLayoutAttributes*)[super layoutAttributesForItemAtIndexPath:indexPath];
  [self applyAttributes:attributes];
  return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
  
  NSInteger page = roundf(self.collectionView.contentOffset.y / self.itemSize.height);
  return CGPointMake(proposedContentOffset.x, page * self.itemSize.height);
  
}

- (void) applyAttributes:(SSDatePickerLayoutAttributes*)attributes {
  
  CGRect visibleRect;
  
  visibleRect.origin = self.collectionView.contentOffset;
  visibleRect.size = self.collectionView.frame.size;
  
  CGFloat distance = CGRectGetMidY(visibleRect) - attributes.center.y;
  if (distance < self.itemSize.height/2 && distance > -(self.itemSize.height/2)) {
    attributes.gradient = nil;
    return;
  }
  
  UICollectionView *collectionView = (UICollectionView*)(self.collectionView);
  UIColor *color = collectionView.backgroundColor;
  
  CAGradientLayer *graident = [CAGradientLayer layer];
  graident.frame = (CGRect) {CGPointZero, self.itemSize};
  if (distance < 0 ) {
    if (distance >= -((self.itemSize.height*3)/2)) {
      graident.colors = @[
                          (id)[[color colorWithAlphaComponent:0.3] CGColor],
                          (id)[[color colorWithAlphaComponent:0.5] CGColor],
                          (id)[[color colorWithAlphaComponent:0.6] CGColor]
                          ];
    } else {
      graident.colors = @[
                          (id)[[color colorWithAlphaComponent:0.6] CGColor],
                          (id)[[color colorWithAlphaComponent:0.7] CGColor]
                          ];
    }
  } else {
    if (distance <= (self.itemSize.height*3/2)) {
      graident.colors = @[
                          (id)[[color colorWithAlphaComponent:0.6] CGColor],
                          (id)[[color colorWithAlphaComponent:0.5] CGColor],
                          (id)[[color colorWithAlphaComponent:0.3] CGColor]
                          ];
    } else {
      graident.colors = @[
                          (id)[[color colorWithAlphaComponent:0.7] CGColor],
                          (id)[[color colorWithAlphaComponent:0.6] CGColor]
                          ];
    }
  }
  
  attributes.gradient = graident;

}

+(Class) layoutAttributesClass {
  
  return [SSDatePickerLayoutAttributes class];
  
}

@end

#pragma mark - SSFlatDateViewCell
@interface SSFlatDateViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation SSFlatDateViewCell

- (void)initialization {
  self.backgroundColor = [UIColor clearColor];
  self.textLabel = [[UILabel alloc] initWithFrame:(CGRect){CGPointZero, self.frame.size}];
  self.textLabel.backgroundColor = [UIColor clearColor];
  self.textLabel.textAlignment = NSTextAlignmentCenter;
  self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self addSubview:self.textLabel];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self initialization];
  }
  return self;
}

- (void) applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
  [super applyLayoutAttributes:layoutAttributes];
  
  SSDatePickerLayoutAttributes *attributes = (SSDatePickerLayoutAttributes *)layoutAttributes;
  
  if (self.gradientLayer) {
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = nil;
  }

  if (attributes.gradient) {
    [self.textLabel.layer insertSublayer:attributes.gradient atIndex:0];
    self.gradientLayer = attributes.gradient;
  }
  
}


@end

@interface SSFlatDatePickerCollectionView : UICollectionView

@property (nonatomic, readonly) NSIndexPath *currentSelectedIndexPath;

@end

@implementation SSFlatDatePickerCollectionView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
  self = [super initWithFrame:frame collectionViewLayout:layout];
  if (self) {
    self.showsVerticalScrollIndicator = NO;
    self.alwaysBounceVertical = NO;
    self.bounces = NO;
    [self registerClass:[SSFlatDateViewCell class] forCellWithReuseIdentifier:@"datePickerCell"];
  }
  return self;
}

- (NSIndexPath*)currentSelectedIndexPath {
  
  CGSize itemSize = [(SSFlatDatePickerFlowLayout*)self.collectionViewLayout itemSize];
  NSInteger row = round(self.contentOffset.y / itemSize.height);
  return [NSIndexPath indexPathForRow:row inSection:0];
  
}

@end

#pragma mark - SSFlatDatePicker
@interface SSFlatDatePicker () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) SSFlatDatePickerCollectionView *scrollerYear;
@property (nonatomic, strong) SSFlatDatePickerCollectionView *scrollerMonth;
@property (nonatomic, strong) SSFlatDatePickerCollectionView *scrollerDay;

@property (nonatomic, strong) SSFlatDatePickerCollectionView *scrollerHour;
@property (nonatomic, strong) SSFlatDatePickerCollectionView *scrollerMinute;
@property (nonatomic, strong) SSFlatDatePickerCollectionView *scrollerAPM;


@property (nonatomic, strong) NSDate *today;
@property (nonatomic, assign) NSRange yearRange;
@end

@implementation SSFlatDatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      // default setting
      _font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
      _textColor = [UIColor whiteColor];
      _gradientColor = [UIColor blackColor];
    }
    return self;
}

- (void) awakeFromNib {
  // default setting
  _font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
  _textColor = [UIColor whiteColor];
  _gradientColor = [UIColor blackColor];

}

- (void)initialize {
  CGFloat _separatorWidth = 2;

  
  CGFloat _longWidth, _shortWidth;
  _longWidth = 0.35 * (self.frame.size.width - _separatorWidth * 2);
  _shortWidth = 0.3 * (self.frame.size.width - _separatorWidth * 2);
  
  NSAssert(self.frame.size.height >= 80, @"Height of date picker should be at least 80 points");

  SSFlatDatePickerFlowLayout *flowLayout1 = [[SSFlatDatePickerFlowLayout alloc] init];
  SSFlatDatePickerFlowLayout *flowLayout2 = [[SSFlatDatePickerFlowLayout alloc] init];
  SSFlatDatePickerFlowLayout *flowLayout3 = [[SSFlatDatePickerFlowLayout alloc] init];

  if (_datePickerMode == SSFlatDatePickerModeDate) {
    if (!_scrollerYear) {
      self.scrollerYear = [[SSFlatDatePickerCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout1 ];
      self.scrollerYear.delegate = self;
      self.scrollerYear.dataSource = self;
      [self addSubview:self.scrollerYear];
    }
    self.scrollerYear.frame = CGRectMake(0, 0, _longWidth, self.frame.size.height);
    
    if (!_scrollerMonth) {
      self.scrollerMonth = [[SSFlatDatePickerCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout2];
      self.scrollerMonth.delegate = self;
      self.scrollerMonth.dataSource = self;
      [self addSubview:self.scrollerMonth];
    }
    self.scrollerMonth.frame = CGRectMake(_separatorWidth + _longWidth, 0, _longWidth, self.frame.size.height);
    
    if (!_scrollerDay) {
      self.scrollerDay = [[SSFlatDatePickerCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout3];
      self.scrollerDay.delegate = self;
      self.scrollerDay.dataSource = self;
      [self addSubview:self.scrollerDay];
    }
    self.scrollerDay.frame = CGRectMake(_separatorWidth*2 + _longWidth*2, 0, _shortWidth, self.frame.size.height);
    
  } else if (_datePickerMode == SSFlatDatePickerModeTime) {
    if (!_scrollerHour) {
      self.scrollerHour = [[SSFlatDatePickerCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout1];
      self.scrollerHour.delegate = self;
      self.scrollerHour.dataSource = self;
      [self addSubview:self.scrollerHour];
    }
    self.scrollerHour.frame = CGRectMake(0, 0, _longWidth, self.frame.size.height);
    
    if (!_scrollerMinute) {
      self.scrollerMinute = [[SSFlatDatePickerCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout2];
      self.scrollerMinute.delegate = self;
      self.scrollerMinute.dataSource = self;
      [self addSubview:self.scrollerMinute];
    }
    self.scrollerMinute.frame = CGRectMake(_separatorWidth + _longWidth, 0, _longWidth, self.frame.size.height);
    
    if (!_scrollerAPM) {
      self.scrollerAPM = [[SSFlatDatePickerCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout3];
      self.scrollerAPM.delegate = self;
      self.scrollerAPM.dataSource = self;
      [self addSubview:self.scrollerAPM];
    }
    self.scrollerAPM.frame = CGRectMake(_separatorWidth*2 + _longWidth*2, 0, _shortWidth, self.frame.size.height);
  }
  
  self.today = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSTimeZoneCalendarUnit)
                                                 fromDate:self.today];
  
  NSRange range;
  range.location = dateComponents.year - 100;
  range.length = 200;
  self.yearRange = range;
  
  self.layer.cornerRadius = 5.0f;
  
  self.clipsToBounds = YES;
  self.layer.cornerRadius = 5;
  
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  [self initialize];
  
  CAGradientLayer *(^createGradient) (CGRect) = ^CAGradientLayer*(CGRect frame){
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = @[
                        //                        (id)[[UIColor colorWithWhite:0 alpha:0.8] CGColor],
                        (id)[[self.gradientColor colorWithAlphaComponent:0.7] CGColor],
                        (id)[[self.gradientColor colorWithAlphaComponent:0.5] CGColor],
                        (id)[[self.gradientColor colorWithAlphaComponent:0.3] CGColor],
                        (id)[[self.gradientColor colorWithAlphaComponent:0] CGColor],
                        (id)[[self.gradientColor colorWithAlphaComponent:0.3] CGColor],
                        (id)[[self.gradientColor colorWithAlphaComponent:0.5] CGColor],
                        (id)[[self.gradientColor colorWithAlphaComponent:0.7] CGColor],
                        //                        (id)[[UIColor colorWithWhite:0 alpha:0.8] CGColor]
                        ];
    
    gradient.frame = frame;
    return gradient;
  };
  
  CAGradientLayer *gradientForHolder = createGradient((CGRect){CGPointZero, self.frame.size});
  
  for (CALayer *layer in self.layer.sublayers) {
    if ([layer isKindOfClass:[CAGradientLayer class]]) {
      [layer removeFromSuperlayer];
      break;
    }
  }
  [self.layer addSublayer:gradientForHolder];

  
  self.scrollerYear.backgroundColor = self.gradientColor;
  self.scrollerMonth.backgroundColor = self.gradientColor;
  self.scrollerDay.backgroundColor = self.gradientColor;
  self.scrollerMinute.backgroundColor = self.gradientColor;
  self.scrollerHour.backgroundColor = self.gradientColor;
  self.scrollerAPM.backgroundColor = self.gradientColor;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  
  return 1;
  
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  if (collectionView == self.scrollerYear) {
    
    return self.yearRange.length;
    
  } else if (collectionView == self.scrollerMonth) {
    
    return 12;
    
  } else if (collectionView == self.scrollerDay) {
    if (self.date) {
      NSRange dayRange = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.date];
      return dayRange.length;
    }
    
    return 31;
  } else if (collectionView == self.scrollerHour) {
    
    return 12;
    
  } else if (collectionView == self.scrollerMinute) {
    
    return 59;
    
  } else if (collectionView == self.scrollerAPM) {
    
    return 2;
    
  }

}


- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  SSFlatDateViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"datePickerCell" forIndexPath:indexPath];
  
  cell.textLabel.font = self.font;
  cell.textLabel.textColor = self.textColor;

  if (collectionView == self.scrollerYear) {
    cell.textLabel.text = [NSString stringWithFormat:@"%d", (self.yearRange.location + indexPath.row)];
  } else if (collectionView == self.scrollerMonth) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [formatter.shortMonthSymbols objectAtIndex:indexPath.row]];
  } else if (collectionView == self.scrollerDay) {
    cell.textLabel.text = [NSString stringWithFormat:@"%d", (indexPath.row +1)];
  } else if (collectionView == self.scrollerHour) {
    cell.textLabel.text = [NSString stringWithFormat:@"%02d", indexPath.row + 1];
  } else if (collectionView == self.scrollerMinute) {
    cell.textLabel.text = [NSString stringWithFormat:@"%02d", indexPath.row];
  } else {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    if (indexPath.row == 0)
      cell.textLabel.text = formatter.AMSymbol;
    else
      cell.textLabel.text = formatter.PMSymbol;
  }

  return cell;
  
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

  if (!decelerate)
    [self endScrollForScrollView:scrollView];

}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  
  [self endScrollForScrollView:scrollView];

}

- (void) endScrollForScrollView:(UIScrollView*)scrollView {
  if (scrollView == self.scrollerYear) {
    [self.scrollerDay reloadData];
  } else if (scrollView == self.scrollerMonth) {
    [self.scrollerDay reloadData];
  } else if (scrollView == self.scrollerDay) {
    // nothing
    
  } else if (scrollView == self.scrollerHour) {
    NSIndexPath *indexPath = [self.scrollerHour currentSelectedIndexPath];
    if (indexPath.row == 11) {
      NSIndexPath *apmIndexPath = [self.scrollerAPM currentSelectedIndexPath];
      NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:!apmIndexPath.row inSection:0];
      [self.scrollerAPM scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    }
  }
  
  [self sendActionsForControlEvents:UIControlEventValueChanged];
  
}


- (void) setDate:(NSDate *)date {
  
  [self setDate:date animated:NO];

}

- (void) setDate:(NSDate *)date animated:(BOOL)animated {

  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit |NSTimeZoneCalendarUnit)
                                                 fromDate:date];
  NSInteger yIndex = dateComponents.year - self.yearRange.location;
  NSInteger currentYearIndex = [self.scrollerYear currentSelectedIndexPath].row;
  if (yIndex != currentYearIndex) {
    [self.scrollerYear scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:yIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:animated];
  }
  
  NSInteger currentMonthIndex = [self.scrollerMonth currentSelectedIndexPath].row;
  if (dateComponents.month != currentMonthIndex) {
    [self.scrollerMonth scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:dateComponents.month-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:animated];
  }

  NSInteger currentDayIndex = [self.scrollerDay currentSelectedIndexPath].row;
  if (dateComponents.day != currentDayIndex) {
    [self.scrollerDay scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:dateComponents.day-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:animated];
  }
  
  
  NSInteger currentHourIndex = [self.scrollerHour currentSelectedIndexPath].row;
  NSInteger hour = (dateComponents.hour % 12);
  if (hour != (currentHourIndex+1)) {
    if (hour == 0)
      hour = 11;
    else
      hour = hour - 1;
    [self.scrollerHour scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:hour inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:animated];
  }
  
  NSInteger currentMinIndex = [self.scrollerMinute currentSelectedIndexPath].row;
  if (dateComponents.minute != currentMinIndex) {
    [self.scrollerMinute scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:dateComponents.minute inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:animated];
  }
  
  NSInteger currentAPMIndex = [self.scrollerAPM currentSelectedIndexPath].row;
  NSInteger APM =  0;
  if (dateComponents.hour > 11)
    APM = 1;
  if (APM != currentAPMIndex) {
    [self.scrollerAPM scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:APM inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:animated];
  }


}

- (NSDate*)date {
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *dComps = [[NSDateComponents alloc] init];
  
  NSInteger currentYearIndex = [self.scrollerYear currentSelectedIndexPath].row;
  NSInteger currentMonthIndex = [self.scrollerMonth currentSelectedIndexPath].row;
  NSInteger currentDayIndex = [self.scrollerDay currentSelectedIndexPath].row;
    
    if (currentMonthIndex == 1) {
        NSInteger year = currentYearIndex + self.yearRange.location;
        BOOL isLeapYear = ((year % 100 != 0) && (year % 4 == 0)) || (year % 400 == 0);
        NSInteger days = isLeapYear ? 29 : 28;
        if (currentDayIndex+1 > days) {
            currentDayIndex = days - 1;
        }
    }else if(currentMonthIndex==1 || currentMonthIndex==3 || currentMonthIndex==5 || currentMonthIndex==8 || currentMonthIndex==10){
        if (currentDayIndex+1 > 30) {
            currentDayIndex = 29;
        }
    }
    
  dComps.year = currentYearIndex + self.yearRange.location;
  dComps.month = currentMonthIndex + 1;
  dComps.day = currentDayIndex + 1;
  
  NSInteger currentHourIndex = [self.scrollerHour currentSelectedIndexPath].row;
  NSInteger currentMinIndex = [self.scrollerMinute currentSelectedIndexPath].row;
  NSInteger currentAPMIndex = [self.scrollerAPM currentSelectedIndexPath].row;
  dComps.hour = (currentAPMIndex==0) ? (currentHourIndex+1):(currentHourIndex+13);
  dComps.minute = currentMinIndex;

  dComps.timeZone = [NSTimeZone systemTimeZone];
  
  return [calendar dateFromComponents:dComps];

}

@end

