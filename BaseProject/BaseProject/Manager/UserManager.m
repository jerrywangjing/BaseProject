//
//  UserManager.m
//  BaseProject
//
//  Created by JerryWang on 2017/5/30.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

+ (instancetype)sharedManager{
    
    static UserManager * manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}


@end
