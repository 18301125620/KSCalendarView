//
//  KSCalendarView.h
//  test
//
//  Created by kong on 2016/10/25.
//  Copyright © 2016年 孔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSCalendarTool.h"
#import "KSCalendarWeekHeader.h"
#import "KSCalendarCollectionView.h"
#import "KSCalendarCollectionViewCell.h"

@protocol KSCalendarViewDelegate <NSObject>
@optional

/**
 当滚动到某个日期或者滚动到某个月份，这个方法将被调用
 this method will be called when the calendar did scolls to the date or month

 @param dateComp only use day,month,year
 */
- (void)k_c_calendarViewDidScollToDate:(NSDateComponents*)dateComp;

/**
 选择日期回调方法，当用户调用selectDate:animated方法时回调
 
 this method will be called when use method:selectDate:animated:

 @param dateComp only use day,month,year
 */
- (void)k_c_calendarViewDidSelectDate:(NSDateComponents*)dateComp;

- (KSCalendarCollectionViewCell*)k_c_calendarViewCell:(KSCalendarCollectionViewCell*)cell forDate:(NSDateComponents*)comp;

@end
@interface KSCalendarView : UIView

/**
 现在只能使用initWithFrame:初始化方法
 only use initWithFrame:
 @return <#return value description#>
 */
- (instancetype)init NS_UNAVAILABLE ;

@property (nonatomic,assign) id<KSCalendarViewDelegate> delegate;

/**
 选择并且滚动某个日期
 select and scroll this date
 @param date     date
 @param animated scroll with animated
 */
//- (void)selectDate:(NSDate*)date animated:(BOOL)animated;

/**
 滚动月份个数,
 比如你要滚动到下月months=1,
 滚动到上月months=-1,
 滚动到下年months=12,
 滚动到上年months=-12
 
 */
- (void)scrollMonths:(NSInteger)month animated:(BOOL)animated;
/**
 滚动到某个日期 ，但是不选中
 
 scroll to date but it's not select this date
 
 */
- (void)scrollToDate:(NSDate*)date animated:(BOOL)animated;

@end
