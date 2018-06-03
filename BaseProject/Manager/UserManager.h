//
//  UserManager.h
//  BaseProject
//
//  Created by JerryWang on 2017/5/30.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo;

/**
 包含用户相关服务
 */

typedef NS_ENUM(NSInteger, UserLoginStatus){
    kUserLoginStatusThird = 0x01 << 0,//第三方登录
    kUserLoginStatusPwd = 0x01 << 1,///账号登录,自己
};


@interface UserManager : NSObject

+ (instancetype)sharedManager;

//当前用户
@property (nonatomic, strong) UserInfo *curUserInfo;
@property (nonatomic, assign) UserLoginStatus loginStatus;
@property (nonatomic, assign) BOOL isLogined;

@end
