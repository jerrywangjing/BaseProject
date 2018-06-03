//
//  GlobalConst.h
//  BaseProject
//
//  Created by JerryWang on 2018/3/29.
//  Copyright © 2018年 JerryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

// 在这里定义全局常量，全局通知名称定义

#pragma mark - 全局常量

UIKIT_EXTERN NSString * const kAccount;

#pragma mark - 全局通知

UIKIT_EXTERN NSNotificationName const kOpenLeftSlideViewNotification;
UIKIT_EXTERN NSNotificationName const kLoginStateChangeNotification;


#pragma mark - ——————— 用户相关 ————————
//登录状态改变通知
#define KNotificationLoginStateChange @"loginStateChange"

//自动登录成功
#define KNotificationAutoLoginSuccess @"KNotificationAutoLoginSuccess"

//被踢下线
#define KNotificationOnKick @"KNotificationOnKick"

//用户信息缓存 名称
#define KUserCacheName @"KUserCacheName"

//用户model缓存
#define KUserModelCache @"KUserModelCache"



#pragma mark - ——————— 网络状态相关 ————————

//网络状态变化
#define KNotificationNetWorkStateChange @"KNotificationNetWorkStateChange"
