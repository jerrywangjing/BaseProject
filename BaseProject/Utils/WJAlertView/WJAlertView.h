//
//  WJAlertView.h
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/7/3.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJAlertView : NSObject

/// 弹出系统提示框
+ (void)showSystemConfirmAlertWithTitle:(NSString *)title message:(NSString *)msg
                    confirmClick:(void(^)(UIAlertAction *action))confirmCallback;
/// 弹出系统提示框
+ (void)showSystemAlertWithTitle:(NSString *)title message:(NSString *)msg
                     cancleClick:(void (^)(UIAlertAction *action))cancleCallback
                    confirmClick:(void(^)(UIAlertAction *action))confirmCallback;

/// 弹出系统提示框（可自定义按钮文字）
+ (void)showSystemAlertWithTitle:(NSString *)title message:(NSString *)msg
                     cancelTitle:(NSString *)cancelTitle
                    confirmTitle:(NSString *)confirmTitle
                     cancleClick:(void (^)(UIAlertAction *action))cancleCallback
                    confirmClick:(void(^)(UIAlertAction *action))confirmCallback;

/// 弹出系统带输入框的提示框
+ (void)showSystemAlertField:(NSString *)title message:(NSString *)msg
             textFieldConfig:(void(^)(UITextField *textField))textFieldConfig
            cancleClick:(void (^)(UIAlertAction *action))cancleCallback
            confirmClick:(void(^)(UIAlertAction *action,UITextField *textField))completion;

@end
