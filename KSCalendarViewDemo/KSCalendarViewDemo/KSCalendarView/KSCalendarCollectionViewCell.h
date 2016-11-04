//
//  KSCalendarCollectionViewCell.h
//  test
//
//  Created by kong on 2016/10/25.
//  Copyright © 2016年 孔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSCalendarTool.h"

@interface KSCalendarCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel* dayLabel;
@property (nonatomic, assign) BOOL selectDay;

@property (nonatomic, strong) KSDateComponents* comp;

@end

