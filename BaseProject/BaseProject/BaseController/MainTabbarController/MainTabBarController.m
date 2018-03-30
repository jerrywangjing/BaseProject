//
//  MainTabBarController.m
//  JWChat
//
//  Created by JerryWang on 2017/3/30.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainNavController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

-(void)loadView {

    [super loadView];
    //  init example

    [self setTabBarViewControllers:[UIViewController new] barItemTitle:@"主页" barItemImage:@"icon_home_normal" selectedImage:@"icon_home_highlight"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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

@end
