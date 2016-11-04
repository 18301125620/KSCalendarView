//
//  KSCalendarWeekHeader.m
//  test
//
//  Created by kong on 2016/10/27.
//  Copyright © 2016年 孔. All rights reserved.
//

#import "KSCalendarWeekHeader.h"

@interface KSCalendarWeekHeader ()
@property (nonatomic, strong) NSArray* names;
@end

@implementation KSCalendarWeekHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    for (int i = 0; i < self.names.count; i ++) {
        CGFloat width = CGRectGetWidth(self.bounds) / self.names.count;
        CGFloat height = CGRectGetHeight(self.bounds);
        CGFloat x = width * i;
        CGFloat y = 0;
        UILabel* label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, y, width, height);
        label.textColor = k_c_week_font_color;
        label.font = [UIFont systemFontOfSize:k_c_week_font_size];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.names[i];
        [self addSubview:label];
    }
}

- (NSArray *)names{
    if (!_names) {
        _names = [NSArray arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
    }
    return _names;
}
@end
