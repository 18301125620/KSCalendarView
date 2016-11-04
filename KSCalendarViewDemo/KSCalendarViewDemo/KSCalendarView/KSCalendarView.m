//
//  KSCalendarView.m
//  test
//
//  Created by kong on 2016/10/25.
//  Copyright © 2016年 孔. All rights reserved.
//

#import "KSCalendarView.h"

@interface KSCalendarView ()<KSCalendarCollectionViewSource>

@property (nonatomic, strong) KSCalendarCollectionView* collectionView;
@property (nonatomic, strong) KSCalendarWeekHeader* weekHeader;
@property (nonatomic, strong) NSIndexPath* selectIndexPath;

@end

@implementation KSCalendarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.weekHeader];
        [self addSubview:self.collectionView];
    }
    return self;
}
- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {
        [self scrollToDate:[NSDate date] animated:YES];
    }
}

- (void)selectDate:(NSDate *)date animated:(BOOL)animated{
    [self scrollToDate:date animated:animated selected:YES];
}

- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated{
    [self scrollToDate:date animated:animated selected:NO];
}

- (void)scrollToDate:(NSDate*)date animated:(BOOL)animated selected:(BOOL)selected{
    NSDate* startDate = nil;
    [KSCalendarTool.calendar rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:nil forDate:date];
    
    NSDateComponents* comp = [KSCalendarTool.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    NSInteger m = comp.month;                                                               //月(1-12)
    NSInteger y = comp.year;                                                               //年
    NSInteger d = comp.day;                                                             //日（1-31）
    
    CGFloat offset_x = ((y - k_c_start_year) * 12 + m -1) * _collectionView.collectionView.frame.size.width;
    NSInteger section = (int)offset_x / _collectionView.collectionView.frame.size.width;
    
    NSInteger w = [KSCalendarTool.calendar component:NSCalendarUnitWeekday fromDate:startDate];       //开始周(1-7)
    NSInteger l = ((d + w - 2) / 7 ) ;                                                  //所在行数(0-5)
    NSInteger item = [KSCalendarTool weeksOfSeciton:section] * (w - 1) + l + (d - l *7 - 1) * [KSCalendarTool weeksOfSeciton:section];                                  //item所在位置(0-41)
    
    [_collectionView.collectionView setContentOffset:CGPointMake(offset_x,_collectionView.collectionView.contentOffset.y) animated:animated];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (selected) {
            [self k_c_collectionView:_collectionView.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
        }
    });
    
}

- (void)scrollMonths:(NSInteger)month animated:(BOOL)animated{
    [self scrollWithMonthCount:month animated:animated];
}

//根据月份个数滚动到相应位置，负数为向后滚动
- (void)scrollWithMonthCount:(NSInteger)count animated:(BOOL)animated{
    
    //bug # 快速更换月份，会导致滚动停止之后，停留位置不准确
    CGFloat content_ofset_x = _collectionView.collectionView.contentOffset.x + CGRectGetWidth(_collectionView.collectionView.bounds) * count;

    CGFloat content_ofset_y = _collectionView.collectionView.contentOffset.y;
    
    if (k_c_calendar_direction == 0) {
        content_ofset_x = _collectionView.collectionView.contentOffset.x;
        
        content_ofset_y = _collectionView.collectionView.contentOffset.y + CGRectGetHeight(_collectionView.collectionView.bounds) * count;
    }
    
    CGFloat content_size_w = _collectionView.collectionView.contentSize.width;
    
    if (content_ofset_x >= 0 && content_ofset_x < content_size_w) { //判断已经到了最开始或者最终的月份
        [_collectionView.collectionView setContentOffset:CGPointMake(content_ofset_x, content_ofset_y) animated:animated];
        if (!animated) {    //当animated=NO时候，需要手动走回调方法
            [self k_c_scrollViewDidEndScroll:_collectionView.collectionView];
        }
    }
}


#pragma mark-
#pragma mark KSCalendarCollectionViewSource
- (NSInteger)k_c_numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return (k_c_end_year - k_c_start_year + 1) * 12;
}

- (UICollectionViewCell *)k_c_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KSCalendarCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:KSCalendarCollectionViewCellIdentifier forIndexPath:indexPath];
    KSDateComponents* comp = [KSCalendarTool compOfIndexPath:indexPath];
    cell.comp = comp;
    
    if ( self.delegate && [self.delegate respondsToSelector:@selector(k_c_calendarViewCell:forDate:)]) {
        cell = [self.delegate k_c_calendarViewCell:cell forDate:comp];
    }
    
    return cell;
}

- (void)k_c_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    KSCalendarCollectionViewCell* cell = (KSCalendarCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    KSDateComponents* comp = [KSCalendarTool compOfIndexPath:indexPath];
    
    comp.isSelected = YES;
    cell.comp = comp;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(k_c_calendarViewDidSelectDate:)]) {
        [self.delegate k_c_calendarViewDidSelectDate:comp];
    }
}

- (void)k_c_collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    KSCalendarCollectionViewCell* cell = (KSCalendarCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [KSCalendarTool compOfIndexPath:indexPath].isSelected = NO;
    cell.comp = [KSCalendarTool compOfIndexPath:indexPath];
    
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];

}

- (void)k_c_scrollViewDidEndScroll:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds);
    
    if (k_c_calendar_direction == 0) {
        index = scrollView.contentOffset.y / CGRectGetHeight(scrollView.bounds);
    }
    
    NSInteger year = k_c_start_year + (index ) / 12 ;
    NSInteger month = index % 12 + 1;

    if (self.delegate && [self.delegate respondsToSelector:@selector(k_c_calendarViewDidScollToDate:)]) {
        NSDateComponents* comp = [[NSDateComponents alloc] init];
        comp.year = year;
        comp.month = month;
        
        [self.delegate k_c_calendarViewDidScollToDate:comp];
    }
}

#pragma mark-
#pragma mark lazy
- (KSCalendarCollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[KSCalendarCollectionView alloc]
                           initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 20)
                           direction:k_c_calendar_direction
                           cellClass:KSCalendarCollectionViewCell.class];
        _collectionView.collectDateSource = self;
    }
    return _collectionView;
}

- (KSCalendarWeekHeader *)weekHeader{
    if (!_weekHeader) {
        _weekHeader = [[KSCalendarWeekHeader alloc] initWithFrame:
                       CGRectMake(0, 0, CGRectGetWidth(self.bounds), 20)];
    }
    return _weekHeader;
}
@end
