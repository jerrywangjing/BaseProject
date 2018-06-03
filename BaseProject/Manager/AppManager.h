//
//  AppManager.h
//  BaseProject
//
//  Created by JerryWang on 2017/5/29.
//  Copyright © 2017年 JerryWang. All rights reserved.
//



#import <Foundation/Foundation.h>

/**
 包含应用层的相关服务
 */

@interface AppManager : NSObject

#pragma mark ————— APP启动接口 —————
+(void)appStart;

#pragma mark ————— FPS 监测 —————
+(void)showFPS;

@end
