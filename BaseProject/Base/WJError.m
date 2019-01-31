//
//  WJError.m
//  BaseProject
//
//  Created by wangjing on 2019/1/31.
//  Copyright © 2019年 JerryWang. All rights reserved.
//

#import "WJError.h"

@implementation WJError

#pragma mark - convenience

+ (instancetype)errorWithCode:(WJErrorCode)code{
    return [self errorWithCode:code message:nil];
}

+ (instancetype)errorWithCode:(WJErrorCode)code message:(NSString *)msg{
    
    if (!msg) msg = @"未知的错误信息";
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : msg,};
    return  [self errorWithDomain:WJErrorDomain code:code userInfo:userInfo];
}


#pragma mark - private

@end
