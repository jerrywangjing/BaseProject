//
//  WJPopView.h
//  BaseProject
//
//  Created by JerryWang on 2017/8/17.
//  Copyright © 2017年 Jerry. All rights reserved.
//

// Mark: 此类为抽象类，不能直接使用，请继承自此类实现其具体的行为

#import <UIKit/UIKit.h>

@class WJPopView;

@protocol WJPopViewDelegate<NSObject>

@optional
- (void)popViewDidShow;
- (void)popViewDidDismiss;

@end

@interface WJPopView : UIView

@property (nonatomic,weak) UILabel *titleLabel;                 // 标题文字
@property (nonatomic,weak) UIView *contentView;                 // 用于添加自定义内容

@property (nonatomic,assign) BOOL canHideByTapBgView;           // 是否可以通过点击背景关闭视图  默认：YES
@property (nonatomic,assign) BOOL showActivityIndicatorView;    // 等待指示器，默认：NO
@property (nonatomic,assign) BOOL showCloseBtn;                 // 是否显示关闭按，默认：YES

@property (nonatomic,readonly) CGSize containerSize;
@property (nonatomic,weak) id<WJPopViewDelegate> delegate;


/// 初始化popView 并指定内容view的大小
- (instancetype)initWithContainerViewSize:(CGSize)containerSize;

/// 初始化popView 并指定内容view的大小，指定popView所添加到的父view
- (instancetype)initWithContainerViewSize:(CGSize)containerSize inView:(UIView *)inView;

/**
 初始化popView

 @param frame 整个PopView的frame 包括背景maskView,中间内容view
 @param containerSize 中间内容view的frame
 @param inView 需要添加到的父view
 @return 实例对象
 */
- (instancetype)initWithFrame:(CGRect)frame containerViewFrame:(CGSize)containerSize inView:(UIView *)inView;

- (void)showPopView;
- (void)hidePopView;

@end
