//
//  KSCalendarTool.h
//  test
//
//  Created by kong on 2016/10/29.
//  Copyright © 2016年 孔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSCalendarSetting.h"
#import <UIKit/UIKit.h>

@interface  KSDateComponents : NSDateComponents
@property (nonatomic,assign) BOOL isThisSection;
@property (nonatomic,assign) BOOL isToday;
@property (nonatomic,assign) BOOL isSelected;

@end

@interface KSCalendarTool : NSObject

/**
 根据section算当月占用几个周
 
 @param section KSCalendarCollectionView.section

 @return weeks
 */
+ (NSInteger)weeksOfSeciton:(NSInteger)section;

+ (CGSize)collectionView:(UICollectionView*)view cellSizeOfSection:(NSInteger)section;

+ (KSDateComponents*)compOfIndexPath:(NSIndexPath*)indexPath;

/**
 全局日历，单例

 @return NSCalendar
 */
+ (NSCalendar*)calendar;

+ (void)cleanMemory;

+ (void)setMaxCacheCount:(NSUInteger)maxCount;

@end
