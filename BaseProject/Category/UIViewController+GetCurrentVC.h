//
//  UIViewController+GetCurrentVC.h
//  century
//
//  Created by wangjing on 2018/12/19.
//  Copyright © 2018年 dadada. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (GetCurrentVC)

/// 获取window的根控制器
- (UIViewController*) getCurrentRootVC;
/// 获取当前控制器
- (UIViewController*) getCurrentUIVC;


@end

NS_ASSUME_NONNULL_END
