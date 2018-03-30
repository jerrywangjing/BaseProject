//
//  HMGCDSocketManager.m
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/6/29.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import "HMGCDSocketManager.h"
#import <GCDAsyncSocket.h>
//#import "HMHealthDataManager.h"b

static NSString * const SocketHost = @"127.0.0.1";   // 服务器
static NSString * const kSocketConnectedStatus = @"SocketConnectedStatus";
static NSString * const kForegroundState = @"ForegroundState";
static NSString * const kBackgroundState = @"BackgroundState";

static const uint16_t SocketPort = 8899;    // 服务器监听端口

#define Timeout -1

@interface HMGCDSocketManager ()<GCDAsyncSocketDelegate>

@property(nonatomic,strong) GCDAsyncSocket *socket;

//握手次数
@property(nonatomic,assign) NSInteger pushCount;

//断开重连定时器
@property(nonatomic,strong) NSTimer *reconnectTimer;
//心跳包发送定时器
@property (nonatomic,strong) NSTimer *heartbeatTimer;
//重连次数
@property(nonatomic,assign) NSInteger reconnectCount;

@end

@implementation HMGCDSocketManager

//全局访问点
+ (instancetype)sharedManager {
    
    static HMGCDSocketManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

//可以在这里做一些初始化操作
- (instancetype)init
{
    self = [super init];
    if (self) {
        // init code
    }
    return self;
}

#pragma mark 请求连接
// 建立连接
- (void)connectToServer {
    self.pushCount = 0;
    
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];

    NSError *error = nil;
    [self.socket connectToHost:SocketHost onPort:SocketPort error:&error];
    
    if (error) {
        NSLog(@"SocketConnectError:%@",error);
    }
}

#pragma mark 连接成功 delegate

// 连接成功的回调
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"socket连接成功");
    
    if ([self.reconnectTimer isValid]) { // 如果重连成功，销毁重连定时器
        [self.reconnectTimer invalidate];
        self.reconnectTimer = nil;
    }
    
    // 发送心跳包
    if (![self.heartbeatTimer isValid] || !self.heartbeatTimer) {
        [self sendHeartbeats];
    }
    
    // 发送数据
    [self sendDataToServer];
    
    // 监听步数变化
//    [kNotificationCenter addObserver:self selector:@selector(sendStepCountToServer) name:HKStepDidChangedNotification object:nil];
}

//连接成功后向服务器发送数据
- (void)sendDataToServer {
    
    [self sendStepCountToServer];
    
    //发送（-1 表示不设超时时间，1 表示发送数据的标识）
    [self.socket writeData:[NSData data] withTimeout:Timeout tag:SocketTagWrite];
    
    //读取数据（200 表示读取数据的标识）
    [self.socket readDataWithTimeout:Timeout tag:SocketTagRead];
}

//连接成功向服务器发送数据后,服务器会有响应
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    // 主动接受服务器发来的信息
    [self.socket readDataWithTimeout:Timeout tag:SocketTagRead];
    NSLog(@"接受到服务器端数据：length：%ld",data.length);
    
    //服务器推送次数
    self.pushCount++;
    
    //在这里进行校验操作,情况分为成功和失败两种,成功的操作一般都是拉取数据
}

// 发送步数数据到服务器

- (void)sendStepCountToServer{
    
//    [[HMHealthDataManager sharedManager] queryRealTimeTotleStepWithCompletion:^(BOOL success, NSInteger stepCount) {
//
//        if (success) {
//            //TODO: 发送的数据协议需要和后台商定
//
//            NSData *stepData = [[NSData alloc] initWithBytes:&stepCount length:sizeof(stepCount)];
////            [self.socket writeData:stepData withTimeout:Timeout tag:SocketTagWrite];
//            NSLog(@"socket步数数据发送成功");
//        }else{
//
//            NSLog(@"步数获取失败");
//        }
//    }];
}

#pragma mark - 发送心跳包

- (void)sendHeartbeats{
    
    NSString *heartbeat = @"iphoneClient";
    NSData *heartbeatData = [heartbeat dataUsingEncoding:NSUTF8StringEncoding];
    
    // 创建定时器（此种创建方式不能再子线程运行，只有这种可以，+ (NSTimer *)timerWithTimeInterval:）
    self.heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
//        [self.socket writeData:heartbeatData withTimeout:Timeout tag:SocketTagHeartbeat];
        NSLog(@"发送心跳");
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:self.heartbeatTimer forMode:NSRunLoopCommonModes];
}

#pragma mark 连接失败
//连接失败的回调
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"Socket连接失败:error:%@",err.localizedDescription);
    
    self.pushCount = 0;
    
    NSString *currentStatu = [kUserDefaults objectForKey:kSocketConnectedStatus];
    
    //程序在前台才进行重连
    if ([currentStatu isEqualToString:kForegroundState]) {
        
        //重连次数
        self.reconnectCount++;
        
        //如果连接失败 累加1秒重新连接 减少服务器压力
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 * self.reconnectCount target:self selector:@selector(reconnectServer) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        self.reconnectTimer = timer;
    }
}

//如果连接失败,5秒后重新连接
- (void)reconnectServer {
    
    self.pushCount = 0;
    
    self.reconnectCount = 0;
    
    //连接失败重新连接
    NSError *error = nil;
    [self.socket connectToHost:SocketHost onPort:SocketPort error:&error];
    if (error) {
        NSLog(@"SocektConnectError:%@",error);
    }
}

#pragma mark 断开连接

//切断连接
- (void)disConnectSocket{
    
    NSLog(@"socket断开连接");
    
    self.pushCount = 0;
    
    self.reconnectCount = 0;
    
    [self.reconnectTimer invalidate];
    self.reconnectTimer = nil;
    
    [self.heartbeatTimer invalidate];
    self.heartbeatTimer = nil;
    
    [kNotificationCenter removeObserver:self];
    
    [self.socket disconnect];

}

@end
