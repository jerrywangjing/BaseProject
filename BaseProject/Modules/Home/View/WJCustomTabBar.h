//
//  WJCustomTabBar.h
//  BaseProject
//
//  Created by JerryWang on 2018/6/5.
//  Copyright © 2018年 JerryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJCustomTabBar;

@protocol WJCustomTabBarDelegate <NSObject>

- (void)customTabBar:(WJCustomTabBar *)tabBar didClickItem:(id)item;

@end

@interface WJCustomTabBar : UITabBar

@property (nonatomic,weak) id<WJCustomTabBarDelegate> delegate;

@end
