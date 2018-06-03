//
//  WJNumberCheck.h
//  LoginView_wj
//
//  Created by jerry on 16/5/30.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJNumberCheck : NSObject

/**
 *  正则表达式匹配手机号
 */
+ (BOOL)checkTelNumber:(NSString *) telNumber;
/**
 *  正则表达式匹配用户密码6-18位数字和字母组合
 */
+ (BOOL)checkPassword:(NSString *) password;
/**
 *  正则表达式匹配用户姓名,20位的中文或英文
 */
+ (BOOL)checkUserName : (NSString *) userName;
/**
 *  正则表达式匹配用户身份证号
 */
+ (BOOL)checkUserIdCard: (NSString *) idCard;
/**
 *  正则表达式正则匹配URL
 */
+ (BOOL)checkURL : (NSString *) url;
@end
