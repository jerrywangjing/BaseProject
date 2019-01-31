//
//  WJUserManager.h
//  BaseProject
//
//  Created by wangjing on 2019/1/31.
//  Copyright © 2019年 JerryWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJUserInfo.h"

/*
用户登录逻辑：app启动后(启动图，新特性过后)，初始化用户数据(即获取本地存储的用户数据，以及距上次登录时间，超过15天则需要重新登录)，
根据初始化数据判断是需要手动登录(弹出登录页面)，还是直接进入(自动登录)，登录完成后存储登录数据(SWUserInfo)，修改上次登录时间
*/

#define kWJUserManager [WJUserManager sharedUserManager]

typedef NS_ENUM(NSInteger, WJUserLoginType){
    
    WJUserLoginTypeUnknown,     // 未知
    WJUserLoginTypeAccount,     // 账户密码登录
    WJUserLoginTypeWeChat,      // 微信登录
    WJUserLoginTypeQQ,          // QQ登录
};

// 相关通知
static NSNotificationName const WJUserManagerLoginStateChangedNotification = @"WJUserManagerLoginStateChangedNotification";
static NSNotificationName const WJUserManagerLoginSucceedNotification = @"WJUserManagerLoginSucceedNotification";
static NSNotificationName const WJUserManagerDidLogoutNotification = @"WJUserManagerDidLogoutNotification";
static NSNotificationName const WJUserManagerBeKickedNotification = @"WJUserManagerBeKickedNotification";
static NSNotificationName const WJUserManagerUpdateUserInfoNotification = @"WJUserManagerUpdateUserInfoNotification";

// 当前登录用户id，可以通过id来找用户名
static NSString *const kWJCurrentLoginUserId = @"kWJCurrentLoginUserId";
static NSString *const kWJLastLoginDate = @"kWJLastLoginDate";

typedef void(^WJUserManagerLoginBlock)();


@interface WJUserManager : NSObject

+ (instancetype)sharedUserManager;

@property (nonatomic, strong) WJUserInfo *currentUser;
@property (nonatomic, assign) WJUserLoginType loginType;
@property (nonatomic, assign) BOOL isLogged;

#pragma mark - 登录相关

/// 是否可以自动登录

- (BOOL)canAutoLogin;

/// 账号密码登录
- (void)loginForAccount:(NSString *)account password:(NSString *)password completion:(WJUserManagerLoginBlock)completion;

/// 自动登录
- (void)autoLoginWithCompletion:(WJUserManagerLoginBlock)completion failure:(void(^)())failure;

/// 退出登录
- (void)logout:(WJUserManagerLoginBlock)completion;

#pragma mark - 注册、找回密码、获取验证码

// 发送短信验证码
- (void)sendSMSToTel:(NSString *)tel completion:(void(^)(NSString *code))completion;

// 注册
- (void)registerForInfo:(NSDictionary *)regInfo completion:(void(^)())completion;
// 找回密码(修改密码)
- (void)modifyPasswordForInfo:(NSDictionary *)modifyInfo completion:(void(^)())completion;

#pragma mark - 修改用户信息相关

/// 上传头像
- (void)uploadUserAvatarImage:(UIImage *)image completion:(void(^)())completion;

/// 修改用户信息,updateInfo:仅仅包含需要修改的用户资料键值对即可
- (void)updateUserInfo:(NSDictionary *)updateInfo completion:(void(^)())completion;


@end
