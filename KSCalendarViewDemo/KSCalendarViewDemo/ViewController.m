//
//  ViewController.m
//  KSCalendarViewDemo
//
//  Created by kong on 2016/11/4.
//  Copyright © 2016年 孔. All rights reserved.
//

#import "ViewController.h"
#import "KSCalendarView.h"

@interface ViewController ()<KSCalendarViewDelegate>
@property (nonatomic, strong) KSCalendarView* calendarView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, strong) IBOutlet UILabel* label2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat width = self.view.frame.size.width;
    CGFloat height = width * 0.8;
    
    _calendarView = [[KSCalendarView alloc] initWithFrame:CGRectMake(0, 70, width, height)];
    
    _calendarView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _calendarView.layer.borderWidth = 0.5;
    _calendarView.delegate = self;
    
    [self.view addSubview:_calendarView];
}


- (IBAction)nextYear:(id)sender {
  
    [_calendarView scrollMonths:12 animated:NO];
}

- (IBAction)lastYear:(id)sender {
    [_calendarView scrollMonths:-12 animated:NO];
}

- (IBAction)nextMonth:(id)sender {
    [_calendarView scrollMonths:1 animated:YES];
}

- (IBAction)lastMonth:(id)sender {
    [_calendarView scrollMonths:-1 animated:NO];
}

#pragma mark-
#pragma mark KSCalendarViewDelegate
- (void)k_c_calendarViewDidSelectDate:(NSDateComponents*)date{
    _label2.text = [NSString stringWithFormat:@"%ld年%ld月%ld日",(long)date.year,(long)date.month,(long)date.day];
}

- (void)k_c_calendarViewDidScollToDate:(NSDateComponents*)date{
    
    _label.text = [NSString stringWithFormat:@"%ld年%ld月",(long)date.year,(long)date.month];
}

- (KSCalendarCollectionViewCell*)k_c_calendarViewCell:(KSCalendarCollectionViewCell *)cell forDate:(KSDateComponents *)comp{
    
    
    //    UIView* view = [cell.contentView viewWithTag:100];
    //    if (!view) {
    //        view = [[UIView alloc] init];
    //        [cell.contentView addSubview:view];
    //        view.tag = 100;
    //    }
    //
    //    view.frame = CGRectMake(0, CGRectGetHeight(cell.bounds) - 10, CGRectGetWidth(cell.bounds), 10);
    //
    //    if (comp.isThisSection) {
    //        view.backgroundColor = [UIColor redColor];
    //    }else{
    //        view.backgroundColor = [UIColor clearColor];
    //    }
    
    return cell;
}


@end
