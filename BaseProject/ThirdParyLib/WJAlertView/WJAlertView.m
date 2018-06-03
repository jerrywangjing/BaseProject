//
//  WJAlertView.m
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/7/3.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import "WJAlertView.h"
#import "UIViewController+WJExtension.h"

@implementation WJAlertView

#pragma mark - public

+ (void)showSystemConfirmAlertWithTitle:(NSString *)title message:(NSString *)msg confirmClick:(void (^)(UIAlertAction *))confirmCallback{
    
    if (!title) {
        title = @"提示";
    }
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *comfirm = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirmCallback) {
            confirmCallback(action);
        }
    }];

    [alertVc addAction:comfirm];
    [[self getCurrentViewController] presentViewController:alertVc animated:YES completion:nil];
}


+ (void)showSystemAlertWithTitle:(NSString *)title message:(NSString *)msg cancleClick:(void (^)(UIAlertAction *))cancleCallback confirmClick:(void(^)(UIAlertAction *))confirmCallback{
    [self showSystemAlertWithTitle:title message:msg cancelTitle:@"取消" confirmTitle:@"确定" cancleClick:^(UIAlertAction *action) {
        if (cancleCallback) {
            cancleCallback(action);
        }
    } confirmClick:^(UIAlertAction *action) {
        if (confirmCallback) {
            confirmCallback(action);
        }
    }];
}

+ (void)showSystemAlertWithTitle:(NSString *)title message:(NSString *)msg cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancleClick:(void (^)(UIAlertAction *))cancleCallback confirmClick:(void (^)(UIAlertAction *))confirmCallback{
    
    if (!title) {
        title = @"提示";
    }
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancleCallback) {
            cancleCallback(action);
        }
    }];
    UIAlertAction *comfirm = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (confirmCallback) {
            confirmCallback(action);
        }
    }];
    
    [alertVc addAction:cancle];
    [alertVc addAction:comfirm];
    
    
    [[self getCurrentViewController] presentViewController:alertVc animated:YES completion:nil];
}

+ (void)showSystemAlertField:(NSString *)title message:(NSString *)msg textFieldConfig:(void(^)(UITextField *textField))textFieldConfig cancleClick:(void (^)(UIAlertAction *action))cancleCallback confirmClick:(void(^)(UIAlertAction *action,UITextField *textField))completion{

    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    
        if (cancleCallback) {
            cancleCallback(action);
        }
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (completion) {
            completion(action,alertVc.textFields.firstObject);
        }
        
    }];
    [alertVc addAction:cancel];
    [alertVc addAction:confirm];
    [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        if (textFieldConfig) {
            textFieldConfig(textField);
        }
    }];
    
    [[self getCurrentViewController] presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark - private

// 获取当前控制器

+ (UIViewController *)getCurrentViewController{

    UIViewController *currentVc = [UIViewController getCurrentViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    return currentVc;
}
@end
