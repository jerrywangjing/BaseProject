//
//  NSDate+WJExtension.h
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/6/16.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WJExtension)


/**
 获取普通形式的格式化时间字符串

 @return 时间字符串
 */
- (NSString *)getNormalFormatedTimeString;

/**
 获取已小时和分钟组成的格式化时间
 @return 时间字符串
 */
- (NSString *)getHourMinFormatedTimeString;

/**
 获取仅有年月日组成的格式化时间

 @return 时间字符串
 */
- (NSString *)getYearMonthDayFormatedTimeString;

/**
 通过时间戳字符串返回格式化的字符串

 @param timeStamp 时间戳<NSString>
 @param format 格式字符串
 @return 格式化字符串
 */
+ (NSString *)formattedDateWithTimeStamp:(NSString *)timeStamp formart:(NSString *)format;


/// 获取星期

- (NSString *)getLocalWeekday;

/// 获取农历
- (NSString *)getLunarDate;

/// 获取UTC时间字符串
- (NSString *)getUTCTimeString;

@end
