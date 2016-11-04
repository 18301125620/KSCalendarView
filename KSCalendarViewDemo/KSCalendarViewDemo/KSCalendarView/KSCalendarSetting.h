//
//  KSCalendarSetting.h
//  test
//
//  Created by kong on 2016/11/3.
//  Copyright © 2016年 孔. All rights reserved.
//

#ifndef KSCalendarSetting_h
#define KSCalendarSetting_h
/**
 日历开始的年份
 
 the start year of calendar
 */
#define k_c_start_year                      2015
/**
 日历的结束年份
 
 the end year of calendar ， it can impact performance if the difference betwee start year and end year is large,
 so it's a bug,but i will repair it.
 */
#define k_c_end_year                        2025

/**
 选择日的文字颜色
 
 the text color of select day
 */
#define k_c_day_select_textColor            [UIColor whiteColor]
/**
 选择日的背景颜色
 
 the background color of select day
 */
#define k_c_day_select_backColor            [UIColor redColor]
/**
 选择日的边框颜色
 
 the border color of select day
 */
#define k_c_day_select_borderColor          [UIColor blueColor]
/**
 选择日的边框宽度
 
 the width color of select day
 */
#define k_c_day_select_borderWidth          2.

/**
 默认日字体大小
 
 the text size of default day
 */
#define k_c_day_default_textSize            16
/**
 默认日文字颜色
 
 the text color of default day
 */
#define k_c_day_default_textColor           [UIColor blackColor]

/**
 其他月份的文字颜色
 
 the text color of other month
 */
#define k_c_day_other_month_textColor       [UIColor clearColor]

/**
 今天文字颜色
 
 the text color of today
 */
#define k_c_today_textColor                 [UIColor blackColor]
/**
 今天边框颜色
 
 the border color of today
 */
#define k_c_today_borderColor               [UIColor redColor]

/**
 周文字大小
 
 the font size of week
 */
#define k_c_week_font_size                  14
/**
 周文字颜色
 
 the font color of week
 */
#define k_c_week_font_color                 [UIColor lightGrayColor]


/**
 日历方向,设置1为水平滑动，设置0为竖直滑动
 
 the calendar of direction,eg:  set 1 is horizontal and set 0 is vertical
 */
#define k_c_calendar_direction              1

#define k_c_iOS9                            ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

#endif /* KSCalendarSetting_h */
