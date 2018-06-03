//
//  MBProgressHUD+CustomView.m
//  JWChat
//
//  Created by jerry on 17/4/1.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "MBProgressHUD+CustomView.h"

@implementation MBProgressHUD (CustomView)

#pragma mark - 等待指示器hud

+ (void)showHUD{

    [self showHUDWithTitle:nil];
}
+ (void)hideHUD{
    
    [self hideHUDFromView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - 带文字的等待指示器hud

+ (void)showHUDWithTitle:(NSString *)title{

    [self showHUDWithTitle:title toView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showHUDWithTitle:(NSString *)title toView:(UIView *)view{

    if (!view) return;
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.frame = CGRectMake(0, NavBarH, SCREEN_WIDTH, SCREEN_HEIGHT);
    hud.label.text = title;
    hud.mode = MBProgressHUDModeIndeterminate;      // 默认指示器样式
    hud.animationType = MBProgressHUDAnimationFade; // 动画样式
    
    hud.label.textColor = [UIColor whiteColor];     // 设置字体颜色
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.8];     // hud背景颜色
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;   // hud背景样式
    hud.offset = CGPointMake(0, -NavBarH);
    hud.userInteractionEnabled = YES; // YES: 不可点击hub外控件，NO：可点击hub外控件

    
//    hud.contentColor = [UIColor whiteColor]; // 可修改指示器和hud背景的颜色
//    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    
    // hud.bezelView // hud的背景视图
//     hud.backgroundView // hud的蒙版视图
    // hud.customView  // 自定义视图
    
}

+ (void)hideHUDFromView:(UIView *)view{
    
    if (!view) return;
    [MBProgressHUD hideHUDForView:view animated:YES];
}

#pragma mark - 文本hud

+ (void)showLabelWithText:(NSString *)text{

    [self showLabelWithText:text delay:1.f toView:[UIApplication sharedApplication].keyWindow completion:nil];
}

+ (void)showLabelWithText:(NSString *)text delay:(NSTimeInterval)delay{
    [self showLabelWithText:text delay:delay toView:[UIApplication sharedApplication].keyWindow completion:nil];
}

+ (void)showLabelWithText:(NSString *)text delay:(NSTimeInterval)delay completion:(void (^)())completion{
    [self showLabelWithText:text delay:delay toView:[UIApplication sharedApplication].keyWindow completion:^{
        if (completion) {
            completion();
        };
    }];
}
+ (void)showLabelWithText:(NSString *)text completion:(void(^)())completion{
    [self showLabelWithText:text delay:1.f toView:[UIApplication sharedApplication].keyWindow completion:^{
        if (completion) {
            completion();
        }
    }];
}

+ (void)showLabelWithText:(NSString *)text toView:(UIView *)view{
    [self showLabelWithText:text delay:1.f toView:view completion:nil];
}

+ (void)showLabelWithText:(NSString *)text toView:(UIView *)view completion:(void (^)())completion{
    [self showLabelWithText:text delay:1.f toView:view completion:^{
        if (completion) {
            completion();
        }
    }];
}

+ (void)showLabelWithText:(NSString *)text delay:(NSTimeInterval)delay toView:(UIView *)view completion:(void(^)())completion{

    if (!view) return;
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;           // 注意： 这里要先设置hud的mode属性，才能改变字体的颜色
    hud.animationType = MBProgressHUDAnimationFade;
    
    hud.label.text = text;
    hud.label.textColor = [UIColor whiteColor];  // 设置字体颜色
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.8]; // hud背景颜色
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    [hud hideAnimated:YES afterDelay:delay];
    hud.completionBlock = ^{
        if (completion) {
            completion();
        }
    };
}

#pragma mark - 进度指示hud

+ (void)showProgressHUD:(void (^)(CGFloat value))progress{

    [self showProgressHUDToView:[UIApplication sharedApplication].keyWindow progress:^(CGFloat value) {
        progress(value);
    }];
}

+ (void)showProgressHUDWithProgress:(void (^)(CGFloat value))progress{
    [self showProgressHUDToView:[UIApplication sharedApplication].keyWindow progress:^(CGFloat value) {
        if (progress) {
            progress(value);
        }
    }];
}
+ (void)showProgressHUDToView:(UIView *)view progress:(void (^)(CGFloat value))progress{
    if (!view) return;
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.animationType = MBProgressHUDAnimationFade;
    progress(hud.progress);

}

#pragma mark - 自定义指示器hud


+ (void)showSuccessWithText:(NSString *)text{

    [self showCustomHUDWithImage:@"success.png" text:text];
}

+ (void)showErrorWithText:(NSString *)text{

    [self showCustomHUDWithImage:@"error" text:text];
}

+ (void)showCustomHUDWithImage:(NSString *)image text:(NSString *)text{

    UIView * view = [UIApplication sharedApplication].keyWindow;
    UIImageView * indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    
    [self showHUDToView:view indicatorView:indicatorView title:text];
}

+ (void)showHUDToView:(UIView *)view indicatorView:(UIView *)indicatorView title:(NSString *)title{

    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo: view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.customView = indicatorView;
    hud.label.text = title;
    
    [hud hideAnimated:YES afterDelay:1.0f];
}
@end
