//
//  HMBaseViewModel.m
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/11/15.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import "HMBaseViewModel.h"

@implementation HMBaseViewModel

#pragma mark - getter

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - setter

#pragma init

+ (instancetype)viewModel{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)configureWithDataModel:(id)dataModel{
    _dataModel = dataModel;
    // 配置数据模型
}

#pragma mark - load data

@end
