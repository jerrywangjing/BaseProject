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
NSString * const URL_base = @"https://www.oijiankang.com";
#elif TestSever
/** 测试服务器 */
NSString * const URL_base = @"http://chengdu.server.chinamedcom.com:52003";
#elif ProductSever
/** 生产服务器 */
NSString * const URL_base = @"";
#endif

// =========================== 各模块接口 ============================== //

#pragma mark - 登录注册

/** 登录 */
NSString * const URL_login = @"/appAuth/login";
/** 注册 */
NSString * const URL_regist = @"/appAuth/registe";
