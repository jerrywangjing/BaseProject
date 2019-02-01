//
//  MBProgressHUD+WJ.m
//  BaseProject
//
//  Created by JerryWang on 2017/5/29.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "MBProgressHUD+WJ.h"

const NSInteger hideTime = 1.5;



@implementation MBProgressHUD (XY)

+ (MBProgressHUD*)createMBProgressHUDviewWithMessage:(NSString*)message isWindiw:(BOOL)isWindow
{
    UIView  *view = isWindow? (UIView*)[UIApplication sharedApplication].delegate.window:[kWJAppManager getCurrentUIVC].view;
    MBProgressHUD * hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
    }else{
        [hud showAnimated:YES];
    }
    
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.textColor = [UIColor whiteColor];
    hud.label.numberOfLines = 0;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.8];
    hud.removeFromSuperViewOnHide = YES;
    [hud setContentColor:[UIColor whiteColor]];
    
    return hud;
}

+ (instancetype)creatActivityHUD{
    MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:nil isWindiw:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    return hud;
}

#pragma mark-------------------- show Tip----------------------------

+ (void)showTipMessageInWindow:(NSString*)message
{
    [self showTipMessage:message isWindow:YES timer:hideTime];
}
+ (void)showTipMessageInView:(NSString*)message
{
    [self showTipMessage:message isWindow:NO timer:hideTime];
}
+ (void)showTipMessageInWindow:(NSString *)message afterDelay:(NSTimeInterval)delay
{
    [self showTipMessage:message isWindow:YES timer:delay];
}
+ (void)showTipMessageInView:(NSString*)message afterDelay:(NSTimeInterval)delay
{
    [self showTipMessage:message isWindow:NO timer:delay];
}
+ (void)showTipMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer
{
    MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    hud.userInteractionEnabled = isWindow?YES:NO;
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:hideTime];
}

#pragma mark-------------------- show Activity----------------------------

+ (void)showActivity{
    [self showActivityMessageInWindow:nil];
}
+ (void)showActivityMessageInWindow:(NSString*)message
{
    [self showActivityMessage:message isWindow:YES timer:0];
}
+ (void)showActivityMessageInView:(NSString*)message
{
    [self showActivityMessage:message isWindow:NO timer:0];
}
+ (void)showActivityMessageInWindow:(NSString*)message afterDelay:(NSTimeInterval)delay
{
    [self showActivityMessage:message isWindow:YES timer:delay];
}
+ (void)showActivityMessageInView:(NSString*)message afterDelay:(NSTimeInterval)delay
{
    [self showActivityMessage:message isWindow:NO timer:delay];
}
+ (void)showActivityMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer
{
    MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    hud.mode = MBProgressHUDModeIndeterminate;
    if (aTimer>0) {
        [hud hideAnimated:YES afterDelay:aTimer];
    }
}

#pragma mark-------------------- show Image----------------------------

+ (void)showSuccessMessage:(NSString *)Message
{
    [self showSuccessMessage:Message isWindow:YES completion:nil];
}
+ (void)showSuccessMessageInView:(NSString *)Message{
    [self showSuccessMessage:Message isWindow:NO completion:nil];
}
+ (void)showSuccessMessage:(NSString *)Message completion:(void (^)())completion{
    [self showSuccessMessage:Message isWindow:YES completion:completion];
}
+ (void)showSuccessMessage:(NSString *)Message isWindow:(BOOL)isWindow completion:(void(^)())completion
{
    [self showCustomIconInWindow:@"MBHUD_Success" message:Message isWindow:isWindow completion:completion];
}

+ (void)showErrorMessage:(NSString *)Message
{
    [self showCustomIconInWindow:@"MBHUD_Error" message:Message isWindow:YES completion:nil];
}
+ (void)showErrorMessage:(NSString *)Message completion:(void (^)())completion{
    [self showCustomIconInWindow:@"MBHUD_Error" message:Message isWindow:YES completion:completion];
}

+ (void)showInfoMessage:(NSString *)Message
{
    [self showCustomIconInWindow:@"MBHUD_Info" message:Message isWindow:YES completion:nil];
}
+ (void)showWarnMessage:(NSString *)Message
{
    [self showWarnMessage:Message completion:nil];
}
+ (void)showWarnMessage:(NSString *)Message completion:(void (^)())completion{
    [self showCustomIconInWindow:@"MBHUD_Warn" message:Message isWindow:NO completion:completion];
}
+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message isWindow:(BOOL)isWindow completion:(void(^)())completion
{
    [self showCustomIcon:iconName message:message isWindow:isWindow completion:completion];
    
}
+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message
{
    [self showCustomIcon:iconName message:message isWindow:NO completion:nil];
}
+ (void)showCustomIcon:(NSString *)iconName message:(NSString *)message isWindow:(BOOL)isWindow completion:(void(^)())completion
{
    MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    
    NSString *iconPath = [@"MBProgressHUD.bundle" stringByAppendingPathComponent:iconName];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconPath]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.userInteractionEnabled = isWindow?YES:NO;
    [hud hideAnimated:YES afterDelay:hideTime];
    hud.completionBlock = ^{
        if (completion) {
            completion();
        }
    };
}

+ (void)hideHUD{
    
    UIView  *winView = [UIApplication sharedApplication].delegate.window;
    [self hideHUDForView:winView animated:YES];
    [self hideHUDForView:[kWJAppManager getCurrentUIVC].view animated:YES];
}

#pragma mark ————— 顶部tip —————
+ (void)showTopTipMessage:(NSString *)msg {
    [self showTopTipMessage:msg isWindow:NO];
}
+ (void)showTopTipMessage:(NSString *)msg isWindow:(BOOL) isWindow{
    CGFloat padding = 10;
    
    YYLabel *label = [YYLabel new];
    label.text = msg;
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.033 green:0.685 blue:0.978 alpha:0.8];
    label.width = SCREEN_WIDTH;
    label.textContainerInset = UIEdgeInsetsMake(padding+padding, padding, 0, padding);
    
    if (isWindow) {
        label.height = NavBarH;
        label.bottom = 0;
        [kAppWindow addSubview:label];
        
        [UIView animateWithDuration:0.3 animations:^{
            label.y = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                label.bottom = 0;
            } completion:^(BOOL finished) {
                [label removeFromSuperview];
            }];
        }];
        
    }else{
        label.height = [msg sizeWithMaxSize:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX) fontSize:label.font.pointSize].height + 2 *padding;
        label.bottom = (IOS7_LATER ? 64 : 0);
        
//        [[kSWAppManager getCurrentUIVC].view addSubview:label];
        
        [UIView animateWithDuration:0.3 animations:^{
            label.y = (IOS7_LATER ? 64 : 0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                label.bottom = (IOS7_LATER ? 64 : 0);
            } completion:^(BOOL finished) {
                [label removeFromSuperview];
            }];
        }];
        
    }
    
}

#pragma mark ————— 进度条 —————

+ (instancetype)creatProgressHUD{
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.animationType = MBProgressHUDAnimationFade;
    return hud;
}

@end
