//
//  AppDelegate+AppService.h
//  BaseProject
//
//  Created by JerryWang on 2017/5/30.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "AppDelegate.h"

/**
 将和appDelegate密切相关的启动逻辑，应用级响应放到这里处理， 包含第三方 和 应用内业务的实现，减轻入口代码压力，
 */
@interface AppDelegate (AppService)

+ (AppDelegate *)sharedAppDelegate;


/// 初始化window
-(void)initWindow;

/// 获取当前控制器view
- (UIViewController*)getCurrentVC;

- (UIViewController*)getCurrentUIVC;

@end
