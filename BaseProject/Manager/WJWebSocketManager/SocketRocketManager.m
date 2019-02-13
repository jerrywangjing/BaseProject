//
//  SocketRocketManager.m
//  century
//
//  Created by hooyking on 2018/12/5.
//  Copyright © 2018年 dadada. All rights reserved.
//

#import "SocketRocketManager.h"

// 为了保证线程安全，避免死锁
#ifndef dispatch_queue_async_safe
#define dispatch_queue_async_safe(queue, block)\
if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(queue)) {\
block();\
} else {\
dispatch_async(queue, block);\
}
#endif

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block) dispatch_queue_async_safe(dispatch_get_main_queue(), block)
#endif


NSString * const kNeedPayOrderNote               = @"kNeedPayOrderNote";
NSString * const kWebSocketDidOpenNote           = @"kWebSocketdidReceiveMessageNote";
NSString * const kWebSocketDidCloseNote          = @"kWebSocketDidCloseNote";
NSString * const kWebSocketdidReceiveMessageNote = @"kWebSocketdidReceiveMessageNote";


@interface SocketRocketManager()<SRWebSocketDelegate>
{
    int _index;
    NSTimer * heartBeat;
    NSTimeInterval reConnectTime;
}

@property (nonatomic,strong) SRWebSocket *socket;
@property (nonatomic,copy) NSString *urlString;

@end

@implementation SocketRocketManager

#pragma mark - init

+(SocketRocketManager *)defaultManager{
    static SocketRocketManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[SocketRocketManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    if (self = [super init]) {
        // init
        [kNotificationCenter addObserver:self selector:@selector(networkDidLost) name:WJNetWorkDidNotReachableNotification object:nil];
        [kNotificationCenter addObserver:self selector:@selector(networkDidConnect) name:WJNetWorkDidReachableNotification object:nil];
    }
    return self;
}

#pragma mark - getter
- (SRReadyState)socketReadyState{
    return self.socket.readyState;
}

#pragma mark - public methods

// 创建webSocket

- (void)creatWebSocketWithUrl:(NSString *)url{
    if (!url.length) {
        return;
    }
    
    self.urlString = url;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    self.socket = [[SRWebSocket alloc] initWithURLRequest: request];
    self.socket.delegate = self;
    [self.socket open];
    
}

- (void)creatWebSocketWithUrl:(NSString *)url didOpen:(WebSocketDidOpenBlock)didOpenBlock ReceiveMessage:(WebSocketMessageBlock)messageBlock{
    //如果是同一个url return
    if (self.socket) {
        return;
    }
    if (!url) {
        return;
    }
    
    self.urlString = url;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    self.socket = [[SRWebSocket alloc] initWithURLRequest:request];
    self.socket.delegate = self;
    [self.socket open];     //开始连接
    
    _didOpenBlock = didOpenBlock;
    _messageBlock = messageBlock;
    
    NSLog(@"正在连接webSocket:%@",url);
}

// 关闭webSocket

- (void)closeWebSocket{
    if (self.socket.readyState != SR_CLOSED) {
        [self.socket close];
        self.socket = nil;
        [self destoryHeartBeat];
    }
}

// 发送数据

- (void)sendData:(id)data {
    WeakSelf(weakSelf);
    dispatch_queue_t queue =  dispatch_queue_create("zy", NULL);
    dispatch_async(queue, ^{
        if (weakSelf.socket != nil) {
            // 只有 SR_OPEN 开启状态才能调 send 方法啊，不然要崩
            if (weakSelf.socket.readyState == SR_OPEN) {
                [weakSelf.socket send:data];    // 发送数据
            } else if (weakSelf.socket.readyState == SR_CONNECTING) {
                NSLog(@"正在连接中，重连后其他方法会去自动同步数据");
                // 每隔2秒检测一次 socket.readyState 状态，检测 10 次左右
                // 只要有一次状态是 SR_OPEN 的就调用 [ws.socket send:data] 发送数据
                // 如果 10 次都还是没连上的，那这个发送请求就丢失了，这种情况是服务器的问题了，小概率的
                [self reConnect];
            } else if (weakSelf.socket.readyState == SR_CLOSING || weakSelf.socket.readyState == SR_CLOSED) {
                // websocket 断开了，调用 reConnect 方法重连
                NSLog(@"正在重连...");
                [self reConnect];
            }
        } else {
            NSLog(@"没网络，发送失败");
        }
    });
}


#pragma mark - noti

- (void)networkDidLost{
    [self closeWebSocket];
}

- (void)networkDidConnect{
    [self creatWebSocketWithUrl:self.urlString];
}

#pragma mark - socket tools

//重连机制
- (void)reConnect {
    
    [self closeWebSocket];
    
    //超过一分钟就不再重连 所以只会重连5次 2^5 = 64
    if (reConnectTime > 64) {
        //您的网络状况不是很好，请检查网络后重试
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.socket = nil;
        [self creatWebSocketWithUrl:self.urlString];
        NSLog(@"正在重连...");
    });
    if (reConnectTime == 0) {
        reConnectTime = 2;
    }else{
        reConnectTime *= 2;
    }
}

//取消心跳
- (void)destoryHeartBeat {
    dispatch_main_async_safe(^{
        if (self->heartBeat) {
            if ([self->heartBeat respondsToSelector:@selector(isValid)]){
                if ([self->heartBeat isValid]){
                    [self->heartBeat invalidate];
                    self->heartBeat = nil;
                }
            }
        }
    })
}

//初始化心跳
- (void)initHeartBeat
{
    dispatch_main_async_safe(^{
        [self destoryHeartBeat];
        self->heartBeat = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(sentheart) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self->heartBeat forMode:NSRunLoopCommonModes];
    })
}

-(void)sentheart{
    [self ping];
}

- (void)ping{
    if (self.socket.readyState == SR_OPEN) {
        [self.socket sendPing:nil];
    }
}


#pragma mark - socket delegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    //每次正常连接的时候清零重连时间
    reConnectTime = 0;
    //开启心跳
    [self initHeartBeat];
    
    // 回调
    
    if (_didOpenBlock) {
        _didOpenBlock(self);
    }
    
    NSLog(@"Socket 连接成功:%@",webSocket.url.absoluteString);
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"Socket 连接失败:%@",error.localizedDescription);
    
    _socket = nil;
    [self reConnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    
    NSLog(@"Socket连接断开，code:%ld,reason:%@,wasClean:%d",(long)code,reason,wasClean);
    [self closeWebSocket];
}

-(void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
//    NSLog(@"reveived pong");
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {
    
    if (!message) {
        return;
    }
    
//    NSLog(@"接收到了返回消息：%@",message);
    
    NSData *msgData = message;
    if ([message isKindOfClass:[NSString class]]) {
        msgData = [message dataUsingEncoding:NSUTF8StringEncoding];
    }
    if (self.messageBlock) {
        self.messageBlock(msgData);
    }
}

#pragma mark - private



@end

