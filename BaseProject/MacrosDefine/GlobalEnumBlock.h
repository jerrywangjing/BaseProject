//
//  GlobalEnumBlock.h
//  BaseProject
//
//  Created by JerryWang on 2018/3/29.
//  Copyright © 2018年 JerryWang. All rights reserved.
//

#ifndef GlobalEnumBlock_h
#define GlobalEnumBlock_h

// 这里定义全局的枚举和块

#pragma mark - 全局Enum

/// 性别定义
typedef NS_ENUM(NSUInteger, HMUserGender) {
    HMUserGenderMan = 1,
    HMUserGenderWoman = 2,
    HMUserGenderUnknown = 9,
};

#pragma mark - 全局block

typedef void(^Global_CompletionBlock)();
typedef void(^Global_updateBlock)(NSString *recordId);


#endif /* GlobalEnumBlock_h */
