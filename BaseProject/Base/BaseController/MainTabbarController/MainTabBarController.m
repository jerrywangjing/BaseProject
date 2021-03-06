//
//  MainTabBarController.m
//  JWChat
//
//  Created by JerryWang on 2017/3/30.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "MainTabBarController.h"
#import "UITabBar+CustomBadge.h"
#import "WJCustomTabBar.h"
#import "RootNavigationController.h"
#import "WJProfileViewController.h"
#import "WJHomeViewController.h"

@interface MainTabBarController ()<WJCustomTabBarDelegate>

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
    
    // 使用自定义tabbar
    WJCustomTabBar *customTabBar = [[WJCustomTabBar alloc] init];
    customTabBar.customDelegate = self;
    [self setValue:customTabBar forKey:@"tabBar"];
    
    //设置背景色 去掉分割线
    
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setBackgroundImage:[UIImage new]];
    
    //通过这两个参数来调整badge位置
//        [self.tabBar setTabIconWidth:29];
//        [self.tabBar setBadgeTop:9];
    
    // 注意：解决ios 12.1 导航栏返回时tabbar Item跳动的问题，如果更版本的系统解决后，取消即可
    [[UITabBar appearance] setTranslucent:NO];
}

- (void)addChildViewControllers{
    
    [self setTabBarViewControllers:[WJHomeViewController new] barItemTitle:NSLocalizedString(@"首页", nil) barItemImage:@"icon_home_nor" selectedImage:@"icon_home_hlt"];
    
    [self setTabBarViewControllers:[WJProfileViewController new] barItemTitle:NSLocalizedString(@"测试1", nil) barItemImage:@"icon_record_nor" selectedImage:@"icon_record_hlt"];
    
    [self setTabBarViewControllers:[WJProfileViewController new] barItemTitle:NSLocalizedString(@"测试2", nil) barItemImage:@"icon_record_nor" selectedImage:@"icon_record_hlt"];
    [self setTabBarViewControllers:[WJProfileViewController new] barItemTitle:NSLocalizedString(@"我的", nil) barItemImage:@"icon_record_nor" selectedImage:@"icon_record_hlt"];
    
}

#pragma mark - tabBar delegate

- (void)customTabBar:(WJCustomTabBar *)tabBar didClickCenterItem:(id)item{
    NSLog(@"centerItem click :%@",item);
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
    
    RootNavigationController * nav = [[RootNavigationController alloc] initWithRootViewController:viewController];
    
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

#pragma mark - 旋转支持

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

@end
