//
//  WJAppManager.h
//  BaseProject
//
//  Created by wangjing on 2019/1/31.
//  Copyright © 2019年 JerryWang. All rights reserved.

/**
 包含应用层的相关服务
 */

#import <Foundation/Foundation.h>

#define kWJAppManager [WJAppManager sharedInstance]

typedef NS_ENUM(NSUInteger, WJAppManagerRootVcState) {
    WJAppManagerRootVcStateAutoLogin,       // 自动登录
    WJAppManagerRootVcStateLogin,           // 登录，将登录页切换为主页面(MainTabbarVc)
    WJAppManagerRootVcStateLogout,          // 登出，将MainTabbarVc 切换为登录页
    WJAppManagerRootVcStateNewFeature,      // 新特性页
};

// 通知
static NSNotificationName const WJAppManagerDidLoginNotification = @"SWAppManagerDidLoginNotification";


@interface WJAppManager : NSObject

@property (nonatomic,copy) NSString *appId; // appStore 上线后分配的appId

+ (instancetype)sharedInstance;

/// 启动app
- (void)appStart;

/// 修改登录状态、及页面跳转
- (void)changeRootVcForState:(WJAppManagerRootVcState)state;

/// 开启 FPS 监测
- (void)openFPS;

/// 获取window的根控制器
-(UIViewController*) getCurrentRootVC;
/// 获取当前控制器
-(UIViewController*) getCurrentUIVC;

@end

