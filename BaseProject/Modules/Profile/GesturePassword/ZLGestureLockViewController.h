//
//  ZLGestureLockViewController.h
//  GestureLockDemo
//
//  Created by ZL on 2017/4/5.
//  Copyright © 2017年 ZL. All rights reserved.
//  手势密码界面 控制器

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZLUnlockType) {
    ZLUnlockTypeCreatePsw,          // 创建手势密码
    ZLUnlockTypeValidatePsw,        // 校验手势密码
    ZLUnlockTypeModifyPsw,          // 修改手势密码
    ZLUnlockTypeValidClosePsw,      // 校验关闭手势密码
};

typedef void(^ZLGestureViewVerifyResultBlock)(BOOL isVaild);
typedef void(^ZLGestureViewExitBlock)();
typedef void(^ZLGestureViewCreatBlock)();
typedef void(^ZLGestureViewInputCountLimitBlock)();

@interface ZLGestureLockViewController : UIViewController

@property (nonatomic,copy) ZLGestureViewVerifyResultBlock didVerifyCompletion;
@property (nonatomic,copy) ZLGestureViewExitBlock didExited;
@property (nonatomic,copy) ZLGestureViewCreatBlock didCreatSuccess;
@property (nonatomic,copy) ZLGestureViewInputCountLimitBlock didLimitInputCount;

+ (BOOL)isSetGesturesPassword;          // 是否设置了手势密码
+ (void)deleteGesturesPassword;         // 删除手势密码
+ (NSString *)getGesturesPassword;      // 获取手势密码

- (instancetype)initWithUnlockType:(ZLUnlockType)unlockType;

@end
