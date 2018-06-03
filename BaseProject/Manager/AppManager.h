//
//  AppManager.h
//  BaseProject
//
//  Created by JerryWang on 2017/5/29.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

/**
    包含应用层的相关服务
 */

#import <Foundation/Foundation.h>

@interface AppManager : NSObject

/// 启动app
+(void)appStart;

/// 开启网络监控
+ (void)monitorNetworkStatus;

@end
