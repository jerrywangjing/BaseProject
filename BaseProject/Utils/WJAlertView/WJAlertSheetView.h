//
//  WJAlertSheetView.h
//  JWChat
//
//  Created by JerryWang on 2017/4/26.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(NSString *selectedValue, NSInteger index,UIButton *item);
typedef void(^CancelBlock)(UIButton *item);
typedef void(^DoneBlock)(UIButton *item);

@interface WJAlertSheetView : UIView

#pragma mark - 单选样式

/**
 WJAlertView 单选样式

 @param tips 弹出框中的提示语
 @param items 按钮,注意：取消按钮的index = 0，其他的item index值从1开始算起
 @param cancle 取消回调
 @param completion 确定回调
 */

+ (void)showAlertSheetViewWithTips:(NSString *)tips
                             items:(NSArray<NSString *> *)items
                            cancel:(CancelBlock)cancle
                        completion:(SelectedBlock)completion;

/**
 WJAlertView 单选样式(可配置属性)
 
 @param tips 弹出框中的提示语
 @param items 按钮,注意：取消按钮的index = 0，其他的item index值从1开始算起
 @param config 自定义配置控件属性
 @param cancle 取消回调
 @param completion 确定回调
 */
+ (void)showAlertSheetViewWithTips:(NSString *)tips
                             items:(NSArray<NSString *> *)items
                            config:(id)config
                            cancel:(CancelBlock)cancle
                        completion:(SelectedBlock)completion;

#pragma mark - 多选样式


/**
 WJAlertView 多选样式

 @param tips 提示语
 @param items 按钮
 @param completion 回调
 */
+ (void)showAlertMultiSheetViewWithTips:(NSString *)tips
                             items:(NSArray<NSString *> *)items
                        completion:(SelectedBlock)completion;

@end
