//
//  MainTabBarController.m
//  JWChat
//
//  Created by JerryWang on 2017/3/30.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainNavController.h"
#import "HomeViewController.h"
#import "UITabBar+CustomBadge.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup tabbar
    [self setupTabbar];
    
    // setup child vc
    
    [self addChildViewControllers];
    
    // configuration tabbar
    
}

- (void)setupTabbar{
    
    //设置背景色 去掉分割线
//    [self setValue:[XYTabBar new] forKey:@"tabBar"]; // 用于自定义tabbar
    
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setBackgroundImage:[UIImage new]];
    
    //通过这两个参数来调整badge位置
    //    [self.tabBar setTabIconWidth:29];
    //    [self.tabBar setBadgeTop:9];
    
}

- (void)addChildViewControllers{
    
    [self setTabBarViewControllers:[HomeViewController new] barItemTitle:@"主页" barItemImage:@"icon_home_normal" selectedImage:@"icon_home_highlight"];
    
    [self setTabBarViewControllers:[UIViewController new] barItemTitle:@"主页1" barItemImage:@"icon_home_normal" selectedImage:@"icon_home_highlight"];
}

#pragma mark - private

- (void)setTabBarViewControllers:(UIViewController * )viewController barItemTitle:(NSString *)title barItemImage:(NSString *)image selectedImage:(NSString *)selectedImage{

    viewController.title = title;
    viewController.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSDictionary * attsDic = @{NSForegroundColorAttributeName : RGB(120, 128, 144)};
    NSDictionary * selectedAtts = @{ NSForegroundColorAttributeName : [UIColor blackColor]};
    [viewController.tabBarItem setTitleTextAttributes:attsDic forState:UIControlStateNormal];
    [viewController.tabBarItem setTitleTextAttributes:selectedAtts forState:UIControlStateSelected];

    MainNavController * nav = [[MainNavController alloc] initWithRootViewController:viewController];
    
    [self addChildViewController:nav];
    
}

#pragma mark - public
// 设置小红点

-(void)setRedDotWithIndex:(NSInteger)index isShow:(BOOL)isShow{
    if (isShow) {
        [self.tabBar setBadgeStyle:kCustomBadgeStyleRedDot value:0 atIndex:index];
    }else{
        [self.tabBar setBadgeStyle:kCustomBadgeStyleNone value:0 atIndex:index];
    }
}

@end
