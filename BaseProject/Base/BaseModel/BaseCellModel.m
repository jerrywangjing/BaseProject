//
//  BaseCellModel.m
//  BaseProject
//
//  Created by JerryWang on 2018/6/1.
//  Copyright © 2018年 JerryWang. All rights reserved.
//

#import "BaseCellModel.h"

@implementation BaseCellModel

- (instancetype)init{
    if (self = [super init]) {
        // 设置全局cell默认值
        
        _cellHeight = 44;
        _selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
