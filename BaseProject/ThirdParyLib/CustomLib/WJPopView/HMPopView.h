//
//  HMPopView.h
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/8/17.
//  Copyright © 2017年 华美医信. All rights reserved.
//

// Mark: 此类为抽象类，不能直接使用，请继承自此类实现其具体的行为

#import <UIKit/UIKit.h>


@class HMPopView;

@protocol HMPopViewDelegate<NSObject>

@optional
- (void)popViewDidShow;
- (void)popViewDidDismiss;

@end

@interface HMPopView : UIView

@property (nonatomic,weak) UILabel *titleLabel;                 // 标题文字
@property (nonatomic,weak) UIView *contentView;                 // 用于添加自定义内容
@property (nonatomic,assign) BOOL canHideByTapBgView;           // 是否可以通过点击背景关闭视图
@property (nonatomic,assign) BOOL showActivityIndicatorView;    // 等待指示器
@property (nonatomic,readonly) CGSize containerSize;
@property (nonatomic,weak) id<HMPopViewDelegate> delegate;

/**
 初始化

 @param frame frame
 @param containerSize 内容的frame
 @return instance
 */
- (instancetype)initWithFrame:(CGRect)frame containerViewFrame:(CGSize)containerSize;

- (void)showPopView;
- (void)hidePopView;

@end
