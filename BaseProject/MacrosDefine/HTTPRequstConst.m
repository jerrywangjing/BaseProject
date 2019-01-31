//
//  HTTPRequstConst.m
//  BaseProject
//
//  Created by JerryWang on 2017/7/23.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "HTTPRequstConst.h"

#pragma mark - Server

#if DevelopSever
/** 开发服务器 */
NSString * const URL_base = @"";
#elif TestSever
/** 测试服务器 */
NSString * const URL_base = @"";
#elif ProductSever
/** 生产服务器 */
NSString * const URL_base = @"";
#endif

// =========================== 各模块接口 ============================== //

#pragma mark - 用户管理

NSString * const URL_login = @"";
NSString * const URL_logout = @"";
NSString * const URL_regist = @"";
NSString * const URL_uploadIcon = @"";
NSString * const URL_sendSMS = @"";
NSString * const URL_updateUserInfo = @"";
NSString * const URL_updateUserPwd = @"";
