//
//  APIRequest.h
//  BaseProject
//
//  Created by JerryWang on 2018/6/10.
//  Copyright © 2018年 JerryWang. All rights reserved.

//注意：这里可以做为请求api封装的基类，具体的模块使用不同的APIRequest子类来实现，这一层可以做业务相关的处理

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(void);
typedef void(^FailureBlock)(void);

@interface APIRequest : NSObject

// 发出请求
- (void)startRequestWithApi:(NSString *)api params:(id)params success:(SuccessBlock)success failure:(FailureBlock)failure;

// 获取列表数据的api
// 关注的api3
// 点赞的api
// ...

@end
