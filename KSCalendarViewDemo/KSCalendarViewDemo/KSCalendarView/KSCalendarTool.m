//
//  KSCalendarTool.m
//  test
//
//  Created by kong on 2016/10/29.
//  Copyright © 2016年 孔. All rights reserved.
//

#import "KSCalendarTool.h"
#import <objc/runtime.h>

@interface KSCalendarTool ()
@property (nonatomic, strong) NSCalendar* calendar;
//cache
@property (nonatomic, assign) NSUInteger maxCacheCount;
@property (nonatomic, strong) NSMutableDictionary<NSNumber*,NSNumber*>* weeksOfSecCache;
@property (nonatomic, strong) NSMutableDictionary<NSNumber*,NSNumber*>* daysOfSecCache;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath*,KSDateComponents*>* compOfIndexPath;
@property (nonatomic, strong) NSMutableDictionary<NSNumber*,NSValue*>* sizeOfSecCache;

@end

@implementation KSCalendarTool

+ (instancetype)shareTool{
    
    static KSCalendarTool* tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[KSCalendarTool alloc] init];
        
        tool.maxCacheCount = 5000;
        
        tool.weeksOfSecCache = [NSMutableDictionary dictionary];
        tool.daysOfSecCache = [NSMutableDictionary dictionary];
        tool.compOfIndexPath = [NSMutableDictionary dictionary];
        tool.sizeOfSecCache = [NSMutableDictionary dictionary];

        tool.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        tool.calendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    });
    return tool;
}

+ (NSInteger)weeksOfSeciton:(NSInteger)section{
    
    NSNumber* weeksCache = [KSCalendarTool shareTool].weeksOfSecCache[@(section)];
    if (weeksCache) {
        return weeksCache.integerValue;
    }
    
    NSDateComponents* comp = [[NSDateComponents alloc] init];

    comp.year = section / 12 + k_c_start_year;
    comp.month = section % 12 + 1;

    NSDate* date = [self.calendar dateFromComponents:comp];
    
    NSInteger number = [self.calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:date].length;
    
    //保存cache
    [self setObject:@(number) forKey:@(section) atCache:[KSCalendarTool shareTool].weeksOfSecCache];

    return number;
}

+ (CGSize)collectionView:(UICollectionView*)view cellSizeOfSection:(NSInteger)section{
    
    NSValue* sizeValue = [[KSCalendarTool shareTool].sizeOfSecCache objectForKey:@(section)];
    if(sizeValue) {
        return sizeValue.CGSizeValue;
    }
    
    CGSize size = CGSizeMake(CGRectGetWidth(view.frame)/7,
                             CGRectGetHeight(view.frame)/[KSCalendarTool weeksOfSeciton:section]);
    [[KSCalendarTool shareTool].sizeOfSecCache setObject:[NSValue valueWithCGSize:size] forKey:@(section)];
    
    return size;
}
                      
+ (NSInteger)daysOfSection:(NSInteger)section{
    NSNumber* daysCache = [KSCalendarTool shareTool].daysOfSecCache[@(section)];
    if (daysCache) {
        return daysCache.integerValue;
    }
    
    NSDateComponents* comp = [[NSDateComponents alloc] init];
    comp.month = section % 12 + 1;
    comp.year = k_c_start_year + section / 12 ;
    
    NSDate* startDate = [self.calendar dateFromComponents:comp];

    NSInteger days = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:startDate].length;

    //保存到cache
    [self setObject:@(days) forKey:@(section) atCache:[KSCalendarTool shareTool].daysOfSecCache];

    return days;
}

+ (KSDateComponents*)compOfIndexPath:(NSIndexPath *)indexPath{
    
    KSDateComponents* compCache = [KSCalendarTool shareTool].compOfIndexPath[indexPath];
    if (compCache) {

        return compCache;
    }
    
    KSDateComponents* comp = [[KSDateComponents alloc] init];
    comp.month = indexPath.section % 12 + 1;
    comp.year = k_c_start_year + indexPath.section / 12 ;
    comp.day = 1;
    
    NSInteger day = indexPath.row + 1;

    if (k_c_calendar_direction == UICollectionViewScrollDirectionHorizontal) {
        day = indexPath.row / [self weeksOfSeciton:indexPath.section] + 7 * (indexPath.row % [self weeksOfSeciton:indexPath.section]) + 1;
    }
    
    //获取当月天数
    NSInteger days = [self daysOfSection:indexPath.section];
    
    //获取1号是周几(范围:1-7 周日为1)
    NSDate* startDate = [self.calendar dateFromComponents:comp];
    comp.weekday = [self.calendar components:NSCalendarUnitWeekday fromDate:startDate].weekday;
    
    if (day < comp.weekday) {
        //上个月
        comp.month = comp.month - 1 <= 0 ? 12 : comp.month - 1;
        
        comp.year = comp.month - 1 <= 0 ? comp.year - 1:comp.year;
        
        comp.day = [self daysOfSection:indexPath.section - 1] + day - comp.weekday + 1;
        
        comp.isThisSection = NO;
        
    }else if(day > days + comp.weekday - 1){
        //下个月
        comp.month = comp.month + 1 > 12 ? 1 : comp.month + 1;
        
        comp.year = comp.month + 1 > 12 ? comp.year + 1 : comp.year;
        
        comp.day = day - days - comp.weekday + 1;
        
        comp.isThisSection = NO;

    }else{
        //本月
        comp.month = comp.month;
        
        comp.year = comp.year;
        
        comp.day = comp.day - comp.weekday + day;
        
        comp.isThisSection = YES;
        
    }
    comp.isToday = [[self calendar] isDateInToday:[[self calendar] dateFromComponents:comp]];
    
    comp.weekday = -1;
    
    //保存到cache
    [self setObject:comp forKey:indexPath atCache:[KSCalendarTool shareTool].compOfIndexPath];
    
    return comp;
}

+ (NSIndexPath*)indexPathForOldIndexPath:(NSIndexPath*)indexPath{
    
    int row = (int)indexPath.item;
    if (k_c_calendar_direction == UICollectionViewScrollDirectionHorizontal && k_c_iOS9) {
        NSInteger weeks = [KSCalendarTool weeksOfSeciton:indexPath.section];
        row = row / weeks + 7 * (row % weeks);
    }
    
    NSIndexPath* index = [NSIndexPath indexPathForItem:row inSection:indexPath.section];
    
    return index;
}

+ (NSCalendar *)calendar{
    return [KSCalendarTool shareTool].calendar;
}

+ (void)cleanMemory{
    [[KSCalendarTool shareTool].weeksOfSecCache removeAllObjects];
    [[KSCalendarTool shareTool].daysOfSecCache removeAllObjects];
    [[KSCalendarTool shareTool].compOfIndexPath removeAllObjects];
}

+ (void)setObject:(id)obj forKey:(id)key atCache:(NSMutableDictionary*)cache{
    NSUInteger macCount = [KSCalendarTool shareTool].maxCacheCount;
    
    if (cache.count >= macCount) {
        id key = [cache allKeys].firstObject;
        [cache removeObjectForKey:key];
    }
    
    [cache setObject:obj forKey:key];

}

+ (void)setMaxCacheCount:(NSUInteger)maxCount{
    [KSCalendarTool shareTool].maxCacheCount = maxCount;
}

- (void)dealloc{
    [KSCalendarTool cleanMemory];
}

@end


@implementation KSDateComponents
@end
