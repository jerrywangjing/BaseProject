//
//  MBProgressHUD+WJ.h
//  BaseProject
//
//  Created by JerryWang on 2017/5/29.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (WJ)

+ (void)showTipMessageInWindow:(NSString*)message;
+ (void)showTipMessageInView:(NSString*)message;
+ (void)showTipMessageInWindow:(NSString*)message afterDelay:(NSTimeInterval)delay;
+ (void)showTipMessageInView:(NSString*)message afterDelay:(NSTimeInterval)delay;

+ (void)showActivity;
+ (void)showActivityMessageInWindow:(NSString*)message;
+ (void)showActivityMessageInView:(NSString*)message;
+ (void)showActivityMessageInWindow:(NSString*)message afterDelay:(NSTimeInterval)delay;
+ (void)showActivityMessageInView:(NSString*)message afterDelay:(NSTimeInterval)delay;

+ (void)showSuccessMessage:(NSString *)Message;
+ (void)showSuccessMessageInView:(NSString *)Message;
+ (void)showSuccessMessage:(NSString *)Message completion:(void(^)())completion;

+ (void)showErrorMessage:(NSString *)Message;
+ (void)showErrorMessage:(NSString *)Message completion:(void (^)())completion;
+ (void)showInfoMessage:(NSString *)Message;

+ (void)showWarnMessage:(NSString *)Message;
+ (void)showWarnMessage:(NSString *)Message completion:(void(^)())completion;

+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message;
+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message;

+ (void)hideHUD;

//顶部弹出提示
+ (void)showTopTipMessage:(NSString *)msg;
+ (void)showTopTipMessage:(NSString *)msg isWindow:(BOOL) isWindow;

// 进度条
+ (instancetype)creatProgressHUD;
+ (instancetype)creatActivityHUD;

@end
