//
//  HMWebSocketManager.m
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/6/29.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import "HMWebSocketManager.h"
#import <SocketRocket.h>

static NSString * const kSocketConnectedStatus = @"SocketConnectedStatus";
static NSString * const kForegroundState = @"ForegroundState";
static NSString * const kBackgroundState = @"BackgroundState";

static NSString * const Url = @"http://127.0.0.1:8899/";

#define Timeout -1

@interface HMWebSocketManager ()<SRWebSocketDelegate>

@property(nonatomic,strong) SRWebSocket *socket;

//断开重连定时器
@property(nonatomic,strong) NSTimer *reconnectTimer;
//心跳包发送定时器
@property (nonatomic,strong) NSTimer *heartbeatTimer;
//重连次数
@property(nonatomic,assign) NSInteger reconnectCount;

@end

@implementation HMWebSocketManager

//全局访问点
+ (instancetype)sharedManager {
    
    static HMWebSocketManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

// 初始化操作
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
    
    self.socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:Url]]];

    self.socket.delegate = self;
    [self.socket open];
}

#pragma mark-  websocket delegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{

    NSLog(@"socket 连接成功");
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

// 接收到心跳数据
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{

    NSLog(@"websocket接收到了pong");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{

    NSLog(@"websocket连接失败：error：%@",error.localizedDescription);
    
    NSString *currentStatu = [kUserDefaults objectForKey:kSocketConnectedStatus];
    
    if ([currentStatu isEqualToString:kForegroundState]) {    // 程序在前台才进行重连

        //重连次数
        self.reconnectCount++;

        if (self.reconnectCount > 30) {
            [self disConnectSocket];
            NSLog(@"重连超过30次已断开连接");
            return;
        }
        //如果连接失败 累加1秒重新连接 减少服务器压力
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 * self.reconnectCount target:self selector:@selector(reconnectServer) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

        self.reconnectTimer = timer;
    }
}

// 接收到了服务端数据

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{

    NSLog(@"websocket接收到了消息：length：%@",message);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{

    NSLog(@"websocket连接被终止，code：%ld,reason:%@,wasClean:%d",code,reason,wasClean);
    [self disConnectSocket];
}

// 发送步数数据到服务器

- (void)sendDataToServer{

    // 如果有历史数据需要先发送历史数据
    
//    NSDate *historyDate = [kUserDefaults objectForKey:kEnterBackgroundDate];
//    NSDate *nowDate = [NSDate date];
//
//    if ([nowDate compare:historyDate] == NSOrderedDescending) { // 当前时间大于历史时间时才发送历史数据
//        [[HMHealthDataManager sharedManager] sampleQueryWithStartDate:historyDate endDate:normal completionHanlder:^(BOOL success, NSArray *stepDataArr) {
//
//            if (success) {
//                // 步数转json 发送
//                NSLog(@"步数：%@",stepDataArr);
//                [self.socket send:@"stepCounts"];
//
//            }else{
//
//                NSLog(@"历史数据获取失败");
//            }
//        }];
//    }
    
    [self sendStepCountToServer];
}
- (void)sendStepCountToServer{
    
    // 发送实时数据
//    [[HMHealthDataManager sharedManager] queryRealTimeTotleStepWithCompletion:^(BOOL success, NSInteger stepCount) {
//
//        if (success) {
//            //TODO: 发送的数据协议需要和后台商定
//
//            NSString *totleStep = [NSString stringWithFormat:@"%ld",stepCount];
//            [self.socket send:totleStep];
//            NSLog(@"socket步数数据发送成功");
//        }else{
//
//            NSLog(@"步数获取失败");
//        }
//    }];
}

#pragma mark - 发送心跳包

- (void)sendHeartbeats{
 
    // 创建定时器（此种创建方式只能在主线程中运行）
    self.heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"发送心跳");
        [self.socket sendPing:nil];
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:self.heartbeatTimer forMode:NSRunLoopCommonModes];
}

//如果连接失败,5秒后重新连接
- (void)reconnectServer {
    [self connectToServer];
}

#pragma mark 断开连接

//切断连接
- (void)disConnectSocket{
    
    NSLog(@"socket断开连接");
    
    self.reconnectCount = 0;
    
    [self.reconnectTimer invalidate];
    self.reconnectTimer = nil;
    
    [self.heartbeatTimer invalidate];
    self.heartbeatTimer = nil;
    
    [kNotificationCenter removeObserver:self];
    
    [self.socket close];
    
    self.socket = nil;
}


@end
