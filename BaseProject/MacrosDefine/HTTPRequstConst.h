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
UIKIT_EXTERN NSString * const API_Server;

#pragma mark - 详细接口地址

// 登录注册

/** 登录 */
UIKIT_EXTERN NSString * const API_Login;
/** 注册 */
UIKIT_EXTERN NSString * const API_Regist;
