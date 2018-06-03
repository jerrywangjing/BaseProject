//
//  HMWebSocketManager.h
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/6/29.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HMWebSocketManager : NSObject

/// 创建socket 单例
+ (instancetype)sharedManager;

/// 建立 socket 连接
- (void)connectToServer;

/// 断开 socket连接

- (void)disConnectSocket;


@end
