//
//  BaseModel.m
//
//  Created by JerryWang on 2017/8/30.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

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
