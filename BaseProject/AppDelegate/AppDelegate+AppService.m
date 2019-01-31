//
//  AppDelegate+AppService.m
//  BaseProject
//
//  Created by JerryWang on 2017/5/30.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "AppDelegate+AppService.h"

#import <AFNetworking.h>

@implementation AppDelegate (AppService)

+ (AppDelegate *)sharedAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - ——————— 初始化window ————————

- (void)initWindow{
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
}

#pragma mark ————— 初始化服务 —————
-(void)initService{
    
    // UI配置
    [[UIButton appearance] setExclusiveTouch:YES];  // 按钮的排他性设置，开启后，view同一时间只能响应一个按钮的点击事件
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];    // 设置MBProgressHUD中的IndicatorView的颜色为白色
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
    }
    
    // 初始化网络配置
    [self initNetWorkConfig];
    
    // 配置三方平台服务
    [self configThirdPartService];
}

#pragma mark ————— 初始化网络配置 —————

-(void)initNetWorkConfig{
    
    // 配置 PPNetworkHelper 相关参数
    [PPNetworkHelper setAFHTTPSessionManagerProperty:^(AFHTTPSessionManager *sessionManager) {
        
        // 请求类型
        [sessionManager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"content-type"];
        [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        [sessionManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        //        [sessionManager.requestSerializer setHTTPMethodsEncodingParametersInURI:[NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]]];
        
        // 可接收的数据类型
        sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html",@"text/xml", @"text/plain",nil];
        
    }];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper setRequestTimeoutInterval:30];
    
    // 监听网络状态
    [self monitorNetworkStatus];
}

// 网络状态监听

- (void)monitorNetworkStatus {
    // 网络状态改变一次, networkStatusWithBlock就会响应一次
    [PPNetworkHelper networkStatusWithBlock:^(PPNetworkStatusType networkStatus) {
        
        switch (networkStatus) {
                // 未知网络
            case PPNetworkStatusUnknown:
                NSLog(@"网络环境：未知网络");
                // 无网络
            case PPNetworkStatusNotReachable:
                NSLog(@"网络环境：无网络");
                [kNotificationCenter postNotificationName:WJNetWorkDidNotReachableNotification object:nil];
                break;
                // 手机网络
            case PPNetworkStatusReachableViaWWAN:
                NSLog(@"网络环境：手机自带网络");
                // 无线网络
            case PPNetworkStatusReachableViaWiFi:
                NSLog(@"网络环境：WiFi");
                [kNotificationCenter postNotificationName:WJNetWorkDidReachableNotification object:nil];
                break;
        }
    }];
}

#pragma mark - 三方平台服务配置

- (void)configThirdPartService{
    
    // 键盘管理配置
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

@end
