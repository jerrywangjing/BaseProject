//
//  WJError.h
//  BaseProject
//
//  Created by wangjing on 2019/1/31.
//  Copyright © 2019年 JerryWang. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSErrorDomain const  WJErrorDomain = @"com.jerry.error";

// 错误代码定义
typedef NS_ENUM(NSInteger, WJErrorCode) {
    
    WJErrorCodeHttpRespAccountError = 400,      // 账号/密码错误
    WJErrorCodeHttpRespNeedLogin = 401,         // 需要重新登录
    WJErrorCodeHttpRespFailure = 500,           // 服务器端处理错误
};

@interface WJError : NSError

/**
 构造方法
 
 @param code 错误码，返回默认的错误描述信息
 @return 实例对象
 */
+ (instancetype)errorWithCode:(WJErrorCode)code;

/**
 构造方法
 
 @param code 错误码
 @param msg 错误描述，错误原因
 @return 实例
 */

+ (instancetype)errorWithCode:(WJErrorCode)code message:(NSString *)msg;

@end
