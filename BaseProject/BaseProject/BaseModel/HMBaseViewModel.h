//
//  HMBaseViewModel.h
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/11/15.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMBaseViewModel : NSObject

@property (nonatomic,strong) NSMutableArray *dataSource;    // 数据源
@property (nonatomic,strong) id dataModel;                  // 数据模型
@property (nonatomic,copy) NSString *userId;                // 用户id

/// 初始化接口
+ (instancetype)viewModel;

/// 配置已有数据
- (void)configureWithDataModel:(id)dataModel;

@end
