//
//  KSKSCalendarCollectionViewCell.m
//  test
//
//  Created by kong on 2016/10/25.
//  Copyright © 2016年 孔. All rights reserved.
//

#import "KSCalendarCollectionViewCell.h"

@interface KSCalendarCollectionViewCell ()
@property (nonatomic, strong) CALayer* backgroundLayer;

@end

@implementation KSCalendarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.dayLabel];
        [self.contentView.layer insertSublayer:self.backgroundLayer atIndex:0];
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    _dayLabel.textColor = k_c_day_other_month_textColor;
    _backgroundLayer.borderColor = [UIColor clearColor].CGColor;
    _backgroundLayer.backgroundColor = [UIColor whiteColor].CGColor;
}

#pragma mark-
#pragma mark setting

- (void)setComp:(KSDateComponents *)comp{
    _comp = comp;
    
    self.dayLabel.text = [NSString stringWithFormat:@"%ld",(long)comp.day];
    
    self.userInteractionEnabled = comp.isThisSection;
    self.selectDay = comp.isSelected;
    
}

- (void)setSelectDay:(BOOL)selectDay{
    if (!self.userInteractionEnabled) {
        //这天如果不可点击
        _dayLabel.textColor = k_c_day_other_month_textColor;
        _backgroundLayer.borderColor = [UIColor clearColor].CGColor;
        _backgroundLayer.backgroundColor = [UIColor whiteColor].CGColor;
        return;
    }
    
    if (!self.comp.isThisSection) {
        //如果这天不输入这个section(其他月份)
        _dayLabel.textColor = k_c_day_other_month_textColor;
        _backgroundLayer.borderColor = [UIColor clearColor].CGColor;
        _backgroundLayer.backgroundColor = [UIColor whiteColor].CGColor;
        return;
    }
        
    _selectDay = selectDay;
    
    _dayLabel.textColor = selectDay?k_c_day_select_textColor:k_c_day_default_textColor;
    _backgroundLayer.backgroundColor = selectDay?k_c_day_select_backColor.CGColor:[UIColor whiteColor].CGColor;
    _backgroundLayer.borderColor = selectDay?k_c_day_select_borderColor.CGColor:(_comp.isToday?k_c_today_borderColor.CGColor:[UIColor clearColor].CGColor);
    _backgroundLayer.borderWidth = selectDay?k_c_day_select_borderWidth:0.5;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _dayLabel.frame = self.contentView.bounds;
    CGFloat width = MIN(CGRectGetWidth(self.contentView.bounds),
                        CGRectGetHeight(self.contentView.bounds));
    
    _backgroundLayer.frame = CGRectMake((CGRectGetWidth(self.bounds) - width) / 2,
                                        (CGRectGetHeight(self.bounds) - width) / 2,
                                        width, width);
    _backgroundLayer.cornerRadius = width / 2;

}


#pragma mark-
#pragma mark lazy
-(UILabel *)dayLabel{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.font = [UIFont systemFontOfSize:k_c_day_default_textSize];
    }
    return _dayLabel;
}

-(CALayer *)backgroundLayer{
    if (!_backgroundLayer) {
        _backgroundLayer = [CALayer layer];
        
        
        _backgroundLayer.borderWidth = 0.5;
        _backgroundLayer.borderColor = [UIColor clearColor].CGColor;
    }
    return _backgroundLayer;
}
@end
