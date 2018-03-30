//
//  HMBaseModel.m
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/8/30.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import "HMBaseModel.h"

@implementation HMBaseModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
        [self yy_modelSetWithDictionary:dic];
    }
    return self;
}

+ (instancetype)modelWithJSONDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}

@end
