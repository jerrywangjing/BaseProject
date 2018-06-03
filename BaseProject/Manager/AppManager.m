//
//  AppManager.m
//  BaseProject
//
//  Created by JerryWang on 2017/5/29.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "AppManager.h"
#import "JPFPSStatus.h"

@implementation AppManager

+(void)appStart{
    //加载广告
//    AdPageView *adView = [[AdPageView alloc] initWithFrame:SCREEN_BOUNDS withTapBlock:^{
//        RootNavigationController *loginNavi =[[RootNavigationController alloc] initWithRootViewController:[[RootWebViewController alloc] initWithUrl:@"http://www.hao123.com"]];
//        [kRootViewController presentViewController:loginNavi animated:YES completion:nil];
//    }];
//    adView = adView;
}

#pragma mark ————— FPS 监测 —————
+(void)showFPS{
    [[JPFPSStatus sharedInstance] open];
}

@end
