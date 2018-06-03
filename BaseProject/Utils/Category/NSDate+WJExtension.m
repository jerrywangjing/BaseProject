//
//  NSDate+WJExtension.m
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/6/16.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import "NSDate+WJExtension.h"

@implementation NSDate (WJExtension)

- (NSString *)getNormalFormatedTimeString{
    return [self formatedTimeStringWithFormart:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)getHourMinFormatedTimeString{
    return [self formatedTimeStringWithFormart:@"yyyy-MM-dd HH:mm"];
}

- (NSString *)getYearMonthDayFormatedTimeString{
    return [self formatedTimeStringWithFormart:@"yyyy-MM-dd"];
}

- (NSString *)formatedTimeStringWithFormart:(NSString *)formart{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"BeiJing"];
    formatter.timeZone = timeZone;
    formatter.dateFormat = formart;
    
    NSString * formatedStr = [formatter stringFromDate:self];
    
    return formatedStr;
}

+ (NSString *)formattedDateWithTimeStamp:(NSString *)timeStamp formart:(NSString *)format{
    
    NSTimeInterval timeInterval = timeStamp.doubleValue/1000;  // 毫秒转为秒
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *formattedTime = [date formattedDateWithFormat:format timeZone:[NSTimeZone timeZoneWithName:@"BeiJing"]];
    
    return formattedTime;
}

- (NSString *)getLocalWeekday{
    
    NSString *week = nil;
    switch (self.weekday) {
        case 1:
            week = @"星期日";
            break;
        case 2:
            week = @"星期一";
            break;
        case 3:
            week = @"星期二";
            break;
        case 4:
            week = @"星期三";
            break;
        case 5:
            week = @"星期四";
            break;
        case 6:
            week = @"星期五";
            break;
        case 7:
            week = @"星期六";
            break;
        default:
            break;
    }
    return week;
}

- (NSString *)getLunarDate{
    
    // 年
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    // 月
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    // 日
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:self];
    
//    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@%@",m_str,d_str];
    
    return chineseCal_str;
}

- (NSString *)getUTCTimeString{
    
    NSString * timeStr = [self formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss" timeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    return timeStr;
}

@end
