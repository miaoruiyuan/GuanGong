//
//  NSDate+Common.h
//  Coding_iOS
//
//  Created by 王 原闯 on 14-8-16.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Helper.h"
#import "NSDate+convenience.h"

@interface NSDate (Common)

- (BOOL)isSameDay:(NSDate*)anotherDate;

- (NSInteger)secondsAgo;
- (NSInteger)minutesAgo;
- (NSInteger)hoursAgo;
- (NSInteger)monthsAgo;
- (NSInteger)yearsAgo;
- (NSInteger)leftDayCount;


- (NSString *)string_yyyy_MM_dd_EEE;//@"yyyy-MM-dd EEE" + (今天/昨天)
- (NSString *)string_yyyy_MM_dd;//@"yyyy-MM-dd"
- (NSString *)stringDisplay_HHmm;//n秒前 / 今天 HH:mm
- (NSString *)stringDisplay_MMdd;//n庙前 / 今天 / MM/dd
- (NSString *)stringDisplay_DDHHmm;
- (NSString *)stringDisplay_MM_dd;

+ (NSString *)convertStr_yyyy_MM_ddToDisplay:(NSString *)str_yyyy_MM_dd;//(今天、明天) / MM月dd日 / yyyy年MM月dd日

- (NSString *)stringTimesAgo;//代码更新时间





/**
 *  时间戳转时间，只到日期不到时分秒
 *
 *  @param str str description
 *
 *  @return return value description
 */
+(NSString *)dateWithDateIntreval:(NSString *)str;
/**
 *  时间戳转时间
 *
 *  @param str
 *
 *  @return return value description
 */
+ (NSString *)dateWithTimeIntreval:(NSString *)str;

@end
