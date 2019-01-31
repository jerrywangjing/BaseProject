//
//  WJAppManager.m
//  BaseProject
//
//  Created by wangjing on 2019/1/31.
//  Copyright © 2019年 JerryWang. All rights reserved.
//

#import "WJAppManager.h"
#import "WJUserManager.h"
#import "WJLoginViewController.h"
#import "NewFeatureViewController.h"
#import "ZLGestureLockViewController.h"
#import "JPFPSStatus.h"

static NSString *const kIsShowNewFeature = @"kIsShowNewFeature";
static NSString *const kAppID = @"";

@implementation WJAppManager

+ (instancetype)sharedInstance{
    
    static WJAppManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        _appId = kAppID;
    }
    return self;
}

// 启动app

- (void)appStart{
    
    // 启动依次顺畅：广告页->新特性->登录
    
    // 展示广告页
    
    [self showADViewControllerWithCompletion:^{
        
        // 展示新特性
        [self showNewFeatureViewWithCompletion:^{
            
            // 初始化用户系统
            [self initUserManager];
            
        }];
    }];
}

#pragma mark - 广告页

- (void)showADViewControllerWithCompletion:(void(^)())completion{
    
    // 加载广告
    //
    //    AdPageView *adView = [[AdPageView alloc] initWithFrame:SCREEN_BOUNDS withTapBlock:^{
    //        RootNavigationController *loginNavi =[[RootNavigationController alloc] initWithRootViewController:[[RootWebViewController alloc] initWithUrl:@"http://www.hao123.com"]];
    //        [kRootViewController presentViewController:loginNavi animated:YES completion:nil];
    //    }];
    //    adView = adView;
    
    if (completion) {
        completion();
    }
}

#pragma mark - 新特性页

- (void)showNewFeatureViewWithCompletion:(void(^)())completion{
    
    // 判断是否需要展示新特性页
    
    BOOL showNewFeature = [kUserDefaults boolForKey:kIsShowNewFeature];
    
    if (showNewFeature) {
        if (completion) {
            completion();
        }
        return;
    }
    
    NewFeatureViewController *newFeatureVc = [[NewFeatureViewController alloc] init];
    newFeatureVc.didStartApp = ^{
        [kUserDefaults setBool:YES forKey:kIsShowNewFeature];
        
        if (completion) {
            completion();
        }
    };
    
    kAppDelegate.window.rootViewController = newFeatureVc;
    // 转场动画
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 0.3f;
    [kAppDelegate.window.layer addAnimation:transition forKey:@"fadeAnimation"];
}

#pragma mark - 用户文件系统配置

- (void)configUserFileSystem{
    // 初始化本地文件管理系统
}

#pragma mark - 用户登录/注册相关

-(void)initUserManager{
    
    // 测试
    
    [self changeRootVcForState:WJAppManagerRootVcStateLogin];
    return;
    
    // 正式
    if([kWJUserManager canAutoLogin]){   // 自动登录
        
        // 判断是否开启了手势密码
        [self vefifyGesturePasswordWithCompletion:^(BOOL success) {
            
            if (success) {
                // 切换主页面
                [self changeRootVcForState:WJAppManagerRootVcStateLogin];
                [kWJUserManager autoLoginWithCompletion:^{
                    // 初始化文件系统
                    [self configUserFileSystem];
                    
                    // 发出登录成功通知
                    [kNotificationCenter postNotificationName:WJUserManagerLoginSucceedNotification object:nil];
                    
                } failure:^{
                    // 手动登录
                    [self changeRootVcForState:WJAppManagerRootVcStateLogout];
                }];
            }else{
                // 手动登录
                [self changeRootVcForState:WJAppManagerRootVcStateLogout];
            }
        }];
        
    }else{  // 手动登录
        [self changeRootVcForState:WJAppManagerRootVcStateLogout];
    }
}


// 切换app代理根页面

- (void)changeRootVcForState:(WJAppManagerRootVcState)state{
    
    if (state == WJAppManagerRootVcStateLogin) {
        MainTabBarController *mainTabbar = [MainTabBarController new];
        
        kAppDelegate.mainTabBar = mainTabbar;
        kAppDelegate.window.rootViewController = mainTabbar;
        
        // 初始化socket等其他任务
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self mainTabbarDidAppearCallback];
        });
        
    }else if (state == WJAppManagerRootVcStateLogout){
        
        WJLoginViewController *loginVc = [WJLoginViewController new];
        RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:loginVc];
        
        loginVc.didLoginCompletion = ^(NSString *account, NSString *password) {
            [kWJUserManager loginForAccount:account password:password completion:^{
                
                // 初始化文件系统
                [self configUserFileSystem];
                [self changeRootVcForState:WJAppManagerRootVcStateLogin];
            }];
        };
        
        kAppDelegate.window.rootViewController = nav;
    }
    
    // 转场动画
    
    CATransition *anima = [CATransition animation];
    anima.type = @"cube" ; // 设置动画的类型
    anima.subtype = state == WJAppManagerRootVcStateLogin ? kCATransitionFromRight : kCATransitionFromLeft ; //设置动画的方向
    anima.duration = 0.3f;
    
    [kAppDelegate.window.layer addAnimation:anima forKey:@"cubeAnimation"];
    
}

// 登录成功，并且mainTabbar 视图已经显示完成后的回调，处理其他任务

- (void)mainTabbarDidAppearCallback{
}

#pragma mark - 其他服务

// 验证手势密码

- (void)vefifyGesturePasswordWithCompletion:(void(^)(BOOL success))completion{
    if (![ZLGestureLockViewController isSetGesturesPassword]) {
        if (completion) {
            completion(YES);
        }
        return;
    }
    
    ZLGestureLockViewController *gesPwd = [[ZLGestureLockViewController alloc] initWithUnlockType:ZLUnlockTypeValidatePsw];
    
    gesPwd.didVerifyCompletion = ^(BOOL isVaild) {
        if (completion) {
            completion(isVaild);
        }
    };
    gesPwd.didLimitInputCount = ^{
        [MBProgressHUD showWarnMessage:@"输入次数超限，请手动登录" completion:^{
            if (completion) {
                completion(NO);
            }
        }];
    };
    
    kAppDelegate.window.rootViewController = gesPwd;
}

// 打开帧率显示

- (void)openFPS{
    [[JPFPSStatus sharedInstance] open];
}

#pragma mark - 获取当前控制器

- (UIViewController *)getCurrentRootVC{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentRootVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}

@end
