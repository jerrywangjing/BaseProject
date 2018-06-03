//
//  HMBaseModel.h
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/8/30.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject<YYModel>

+ (instancetype)modelWithJSONDic:(NSDictionary *)dic;

@end
