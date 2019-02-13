//
//  SocketRocketManager.h
//  century
//
//  Created by hooyking on 2018/12/5.
//  Copyright © 2018年 dadada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket.h>


#define kSocketRocketManager [SocketRocketManager defaultManager]

@class SocketRocketManager;

extern NSString * const kNeedPayOrderNote;
extern NSString * const kWebSocketDidOpenNote;
extern NSString * const kWebSocketDidCloseNote;
extern NSString * const kWebSocketdidReceiveMessageNote;

typedef void (^WebSocketDidOpenBlock)(SocketRocketManager *manager);
typedef void (^WebSocketMessageBlock)(NSData *message);

@interface SocketRocketManager : NSObject

@property (nonatomic,copy)WebSocketDidOpenBlock didOpenBlock;
@property (nonatomic,copy)WebSocketMessageBlock messageBlock;
@property (nonatomic,assign,readonly) SRReadyState socketReadyState;


/**
 初始化webSocket

 @return 管理对象
 */
+ (SocketRocketManager *)defaultManager;


/// 创建webSokcet
- (void)creatWebSocketWithUrl:(NSString *)url;

/**
 建立连接

 @param url 连接地址
 @param didOpenBlock 连接成功回调
 @param messageBlock 消息接收回调
 */
- (void)creatWebSocketWithUrl:(NSString *)url didOpen:(WebSocketDidOpenBlock)didOpenBlock ReceiveMessage:(WebSocketMessageBlock)messageBlock;


/**
 关闭当前webSocket
 */

- (void)closeWebSocket;

/**
 发送数据
 
 @param data utf-8字符串或者data字节
 */
- (void)sendData:(id)data;

#pragma mark - kLine

@end

