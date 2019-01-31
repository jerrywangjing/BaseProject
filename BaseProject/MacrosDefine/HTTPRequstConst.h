//
//  HTTPRequstConst.h
//  BaseProject
//
//  Created by JerryWang on 2017/7/23.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

// 通过对于宏置1 表示使用对于服务器，置0 表示未使用

#define DevelopSever 1
#define TestSever    0
#define ProductSever 0

/** 服务器域名 */
UIKIT_EXTERN NSString * const URL_base;

#pragma mark - 详细接口地址

// 登录/注册接口

UIKIT_EXTERN NSString * const URL_login;                        // 登录
UIKIT_EXTERN NSString * const URL_logout;                       // 登出
UIKIT_EXTERN NSString * const URL_regist;                       // 注册
UIKIT_EXTERN NSString * const URL_uploadIcon;                   // 上传头像
UIKIT_EXTERN NSString * const URL_sendSMS;                      // 发送验证码
UIKIT_EXTERN NSString * const URL_updateUserInfo;               // 修改用户信息
UIKIT_EXTERN NSString * const URL_updateUserPwd;                // 修改用户密码
