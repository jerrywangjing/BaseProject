//
//  WJNetworkSpeedMoniter.h
//  CloudStorageApp
//
//  Created by wangjing on 2018/8/17.
//  Copyright © 2018年 swzh. All rights reserved.

//  Jerry: 可以实时检测上行、下行网速

#import <Foundation/Foundation.h>

typedef void(^WJNetworkSpeedMoniterBlock)(NSString *speed);

#define  kWJNetworkSpeedMoniter [WJNetworkSpeedMoniter sharedInstance]

@interface WJNetworkSpeedMoniter : NSObject

@property (nonatomic, copy, readonly) NSString *downloadNetworkSpeed;
@property (nonatomic, copy, readonly) NSString *uploadNetworkSpeed;

@property (nonatomic,copy) WJNetworkSpeedMoniterBlock downloadSpeed;
@property (nonatomic,copy) WJNetworkSpeedMoniterBlock uploadSpeed;


+ (instancetype)sharedInstance;

- (void)start;
- (void)stop;

@end
