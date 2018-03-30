//
//  WJSysDatePickerView.h
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/7/8.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DatePickerCallback)(NSDate *date);
typedef void(^CancelCallback)();


@interface WJSysDatePickerView : UIView

/// 封装系统datePicker


/**
 普通时间选择器

 @param mode 选择器模式
 @param confirmCallback 确认回调
 @param cancelCallback 取消回调
 */
+ (void)showSystemDatePickerViewWithMode:(UIDatePickerMode)mode
                         confirmCallBack:(DatePickerCallback)confirmCallback
                          cancelCallback:(CancelCallback)cancelCallback;


/**
 时间选择器(可设置当前时间)

 @param mode 选择器模式
 @param date 当前显示的日期
 @param confirmCallback 确认回调
 @param cancelCallback 取消回调
 */
+ (void)showSystemDatePickerViewWithMode:(UIDatePickerMode)mode
                                    date:(NSDate *)date
                         confirmCallBack:(DatePickerCallback)confirmCallback
                          cancelCallback:(CancelCallback)cancelCallback;


/**
 时间选择器(可设置时间选择范围)

 @param mode 选择器模式
 @param date 当前显示日期
 @param minDate 最小选择日期
 @param maxDate 最大选择日期
 @param confirmCallback 确认回调
 @param cancelCallback 取消回调
 */
+ (void)showSystemDatePickerViewWithMode:(UIDatePickerMode)mode
                                    date:(NSDate *)date
                                 minDate:(NSDate *)minDate
                                 maxDate:(NSDate *)maxDate
                         confirmCallBack:(DatePickerCallback)confirmCallback
                          cancelCallback:(CancelCallback)cancelCallback;

@end
