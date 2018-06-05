//
//  WJCustomTabBar.m
//  BaseProject
//
//  Created by JerryWang on 2018/6/5.
//  Copyright © 2018年 JerryWang. All rights reserved.
//

#import "WJCustomTabBar.h"

@interface WJCustomTabBar()<UITabBarDelegate>
@property (nonatomic,weak) UIButton *centerBtn;

@end

@implementation WJCustomTabBar

- (instancetype)init{
    if (self = [super init]) {
        [self setupCustomView];
    }
    return self;
}

- (void)setupCustomView{

    // 添加自定义按钮
    
    UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _centerBtn = centerBtn;
    centerBtn.frame = CGRectMake(0, 0, 50, 50);
    [centerBtn setBackgroundImage:[UIImage imageNamed:@"icon_boy"] forState:UIControlStateNormal];
    [centerBtn setBackgroundImage:[UIImage imageNamed:@"icon_boy"] forState:UIControlStateHighlighted];
    
    [self addSubview:centerBtn];
    
    [centerBtn addTarget:self action:@selector(centerBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 把 tabBarButton 取出来（把 tabBar 的 subViews 打印出来就明白了）
    NSMutableArray *tabBarButtonArray = [NSMutableArray array];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtonArray addObject:view];
        }
    }
    
    CGFloat barWidth = self.bounds.size.width;
    CGFloat barHeight = self.bounds.size.height;
    CGFloat centerBtnWidth = CGRectGetWidth(self.centerBtn.frame);
    CGFloat centerBtnHeight = CGRectGetHeight(self.centerBtn.frame);
    
    // 设置中间按钮的位置，居中，凸起一丢丢
    CGFloat offsetY = -5;
    self.centerBtn.center = CGPointMake(barWidth / 2, barHeight - centerBtnHeight/2 + offsetY);
    
    // 重新布局其他 tabBarItem
    // 平均分配其他 tabBarItem 的宽度
    CGFloat barItemWidth = (barWidth - centerBtnWidth) / tabBarButtonArray.count;
    // 逐个布局 tabBarItem，修改 UITabBarButton 的 frame
    [tabBarButtonArray enumerateObjectsUsingBlock:^(UIView *  _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect frame = view.frame;
        if (idx >= tabBarButtonArray.count / 2) {
            // 重新设置 x 坐标，如果排在中间按钮的右边需要加上中间按钮的宽度
            frame.origin.x = idx * barItemWidth + centerBtnWidth;
        } else {
            frame.origin.x = idx * barItemWidth;
        }
        // 重新设置宽度
        frame.size.width = barItemWidth;
        view.frame = frame;
    }];
}

#pragma mark - action

- (void)centerBtnDidClick:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customTabBar:didClickItem:)]) {
        [self.delegate customTabBar:self didClickItem:btn];
    }
}

#pragma mark - tabbar delegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customTabBar:didClickItem:)]) {
        [self.delegate customTabBar:self didClickItem:item];
    }
}

@end
