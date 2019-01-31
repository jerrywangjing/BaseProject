//
//  ZLGestureLockViewController.m
//  GestureLockDemo
//
//  Created by ZL on 2017/4/5.
//  Copyright © 2017年 ZL. All rights reserved.
//

#import "ZLGestureLockViewController.h"
#import "ZLGestureLockView.h"
#import "ZLGestureLockIndicator.h"
#import "WJAlertView.h"
#import <SAMKeychain.h>
#import "WJUserManager.h"
#import <UIImageView+WebCache.h>


static NSString *const kGesturesPasswordSaveService = @"kGesturesPasswordSaveService";
static NSString *const kGesturesPasswordAccount = @"kGesturesPasswordAccount";

@interface ZLGestureLockViewController () <ZLGestureLockDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) ZLGestureLockView *gestureLockView;
@property (weak, nonatomic) ZLGestureLockIndicator *gestureLockIndicator;

// 手势状态栏提示label
@property (weak, nonatomic) UILabel *statusLabel;
// 账户名
@property (weak, nonatomic) UILabel *nameLabel;
// 账户头像
@property (weak, nonatomic) UIImageView *headIcon;

// 其他账户登录按钮
@property (weak, nonatomic) UIButton *otherAcountBtn;
// 重新绘制按钮
@property (weak, nonatomic) UIButton *resetPswBtn;
// 忘记手势密码按钮
@property (weak, nonatomic) UIButton *forgetPswBtn;
@property (nonatomic,weak) UIButton *exitBtn;
// 创建的手势密码
@property (nonatomic, copy) NSString *lastGesturePsw;    // 上次绘制的手势密码

@property (nonatomic) ZLUnlockType unlockType;

@end


@implementation ZLGestureLockViewController

#pragma mark - 类方法

+ (void)deleteGesturesPassword {
    [SAMKeychain deletePasswordForService:kGesturesPasswordSaveService account:kGesturesPasswordAccount];
}

+ (void)setNewGesturesPassword:(NSString *)gesturesPassword {
    [SAMKeychain setPassword:gesturesPassword forService:kGesturesPasswordSaveService account:kGesturesPasswordAccount];
}

+ (NSString *)getGesturesPassword {
    return [SAMKeychain passwordForService:kGesturesPasswordSaveService account:kGesturesPasswordAccount];
}


+ (BOOL)isSetGesturesPassword{
    
    NSString *password = [self getGesturesPassword];
    if (password && password.length > 0) {
        return YES;
    }
    return NO;
}


#pragma mark - init

- (instancetype)initWithUnlockType:(ZLUnlockType)unlockType {
    if (self = [super init]) {
        _unlockType = unlockType;
    }
    return self;
}

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupMainUI];
    
    self.gestureLockView.delegate = self;
    self.resetPswBtn.hidden = YES;
    
    switch (_unlockType) {
        case ZLUnlockTypeCreatePsw:
        {
            self.gestureLockIndicator.hidden = NO;
            self.otherAcountBtn.hidden = self.forgetPswBtn.hidden = YES;
        }
            break;
        case ZLUnlockTypeValidatePsw:
        {
            self.gestureLockIndicator.hidden = YES;
            self.otherAcountBtn.hidden = self.forgetPswBtn.hidden = self.nameLabel.hidden = self.headIcon.hidden = NO;
            self.exitBtn.hidden = YES;
        }
            break;
        case ZLUnlockTypeModifyPsw:{
            self.gestureLockIndicator.hidden = NO;
            self.otherAcountBtn.hidden = self.forgetPswBtn.hidden = self.nameLabel.hidden = self.headIcon.hidden = NO;
            self.statusLabel.text = @"请输入原手势密码";
        }
        case ZLUnlockTypeValidClosePsw:{
            self.gestureLockIndicator.hidden = YES;
            self.otherAcountBtn.hidden = self.forgetPswBtn.hidden = self.nameLabel.hidden = self.headIcon.hidden = NO;
            self.exitBtn.hidden = NO;
            self.statusLabel.text = @"请输入原手势密码";
        }
            
        default:
            break;
    }
    
    // 赋值用户信息
    _nameLabel.text = kWJUserManager.currentUser.username;
    NSURL *iconUrl = [NSURL URLWithString:NSURLFormat(kWJUserManager.currentUser.avatarUrl)];
    [self.headIcon sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"profile_avatar_placeholder"]];
}


// 创建界面
- (void)setupMainUI {
    
    CGFloat maginX = 15;
    CGFloat magin = 5;
    CGFloat btnW = ([UIScreen mainScreen].bounds.size.width - maginX * 2 - magin * 2) / 3;
    CGFloat btnH = 30;
    
    // 退出按钮
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _exitBtn = exitBtn;
    [exitBtn setImage:[UIImage imageNamed:@"add_close_icon"] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(STATUS_BAR_HEIGHT + 15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    
    // 账户头像
    UIImageView *headIcon = [[UIImageView alloc] init];
    _headIcon = headIcon;
    headIcon.contentMode = UIViewContentModeScaleAspectFill;
    headIcon.layer.cornerRadius = 5;
    headIcon.layer.masksToBounds = YES;
    
    [self.view addSubview:headIcon];
    [headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(exitBtn.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    // 账户名
    UILabel *nameLabel = [[UILabel alloc] init];
    _nameLabel = nameLabel;
    _statusLabel = nameLabel;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"未知用户";
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textColor = [UIColor blackColor];
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(headIcon.mas_bottom).offset(10);
    }];
    
    [self.view layoutIfNeeded];
    
    // 九宫格指示器 小图
    
    ZLGestureLockIndicator *gestureLockIndicator = [[ZLGestureLockIndicator alloc] initWithFrame:CGRectMake((self.view.width - 60) * 0.5, CGRectGetMaxY(nameLabel.frame)+10, 60, 60)];
    _gestureLockIndicator = gestureLockIndicator;
    
    [self.view addSubview:gestureLockIndicator];
    
    // 手势状态栏提示label
    
    UILabel *statusLabel = [[UILabel alloc] init];
    _statusLabel = statusLabel;
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.text = @"请输入手势密码";
    statusLabel.font = [UIFont systemFontOfSize:12];
    statusLabel.textColor = [UIColor redColor];
    [self.view addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(gestureLockIndicator.mas_bottom).offset(10);
    }];
    
    // 九宫格 手势密码页面
    
    ZLGestureLockView *gestureLockView = [[ZLGestureLockView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - self.view.frame.size.width - 50 - btnH, self.view.frame.size.width, self.view.frame.size.width)];
    _gestureLockView = gestureLockView;
    gestureLockView.delegate = self;
    
    [self.view addSubview:gestureLockView];
    
    // 底部三个按钮
    
    // 其他账户登录按钮
    UIButton *otherAcountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _otherAcountBtn = otherAcountBtn;
    otherAcountBtn.frame = CGRectMake(maginX, self.view.frame.size.height - 20 - btnH, btnW, btnH);
    otherAcountBtn.backgroundColor = [UIColor clearColor];
    [otherAcountBtn setTitle:@"其他账户" forState:UIControlStateNormal];
    otherAcountBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [otherAcountBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    [otherAcountBtn addTarget:self action:@selector(otherAccountLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    // 重新绘制按钮
    UIButton *resetPswBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetPswBtn.frame = CGRectMake(CGRectGetMaxX(otherAcountBtn.frame) + magin, otherAcountBtn.frame.origin.y, btnW, btnH);
    resetPswBtn.backgroundColor = otherAcountBtn.backgroundColor;
    [resetPswBtn setTitle:@"重新绘制" forState:UIControlStateNormal];
    resetPswBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [resetPswBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    [resetPswBtn addTarget:self action:@selector(resetGesturePassword:) forControlEvents:UIControlEventTouchUpInside];
    _resetPswBtn = resetPswBtn;
    [self.view addSubview:resetPswBtn];
    
    
    // 忘记手势密码按钮
    UIButton *forgetPswBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    forgetPswBtn.backgroundColor = otherAcountBtn.backgroundColor;
    [forgetPswBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetPswBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [forgetPswBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [forgetPswBtn addTarget:self action:@selector(forgetGesturesPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPswBtn];
    _forgetPswBtn = forgetPswBtn;
    [forgetPswBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-20);
    }];
}


#pragma mark - private

//  创建手势密码
- (void)createGesturesPassword:(NSMutableString *)gesturesPassword {
    
    if (gesturesPassword.length < 4) {
        self.statusLabel.text = @"最少连接4个点，请重新输入";
        [self shakeAnimationForView:self.statusLabel];
        [self.gestureLockView clearLockView];
        
        return;
    }
    
    // 第一次绘制
    if (self.lastGesturePsw.length == 0) {
        
        if (self.resetPswBtn.hidden == YES) {
            self.resetPswBtn.hidden = NO;
        }
        
        self.lastGesturePsw = gesturesPassword;
        [self.gestureLockIndicator setGesturePassword:gesturesPassword];
        self.statusLabel.text = @"请再次绘制手势密码";
        [self.gestureLockView clearLockView];
        
        return;
    }
    
    // 确认绘制
    
    if ([gesturesPassword isEqualToString:self.lastGesturePsw]) {
        // 保存手势密码
        [ZLGestureLockViewController setNewGesturesPassword:gesturesPassword];
        [MBProgressHUD showSuccessMessage:@"创建成功" completion:^{
            [self dismissViewControllerAnimated:YES completion:^{
                if (_didCreatSuccess) {
                    _didCreatSuccess();
                }
            }];
        }];
        
    }else {
        
        self.statusLabel.text = @"两次输入的手势密码不一致，请重新输入";
        [self shakeAnimationForView:self.statusLabel];
        
        [self.gestureLockIndicator setGesturePassword:nil];
        [self.gestureLockView clearLockView];
    }
}


// 验证手势密码

- (BOOL)validateGesturesPassword:(NSMutableString *)gesturesPassword {
    
    static int errorCount = 5;
    
    if ([gesturesPassword isEqualToString:[ZLGestureLockViewController getGesturesPassword]]) { // 验证成功
        errorCount = 5;
        if (_didVerifyCompletion) {
            _didVerifyCompletion(YES);
        }
        return YES;
        
    } else {
        
        if (errorCount - 1 == 0) {  // 你已经输错五次了！ 退出重新登陆！
            
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:^{
                    if (_didLimitInputCount) {
                        _didLimitInputCount();
                    }
                }];
            }else{
                if (_didLimitInputCount) {
                    _didLimitInputCount();
                }
            }
            errorCount = 5;
            return NO;
        }
        
        self.statusLabel.text = [NSString stringWithFormat:@"密码错误，还有%d次机会",--errorCount];
        [self shakeAnimationForView:self.statusLabel];
        [self.gestureLockView clearLockView];
        
    }
    return NO;
}


// 重置密码

- (void)modifyGesturePassword:(NSMutableString *)gesturesPassword {
    
    // 首先验证旧密码
    BOOL success = [self validateGesturesPassword:gesturesPassword];
    
    // 创建新密码
    
    if (success) {
        self.statusLabel.text = @"请绘制新的手势密码";
        self.unlockType = ZLUnlockTypeCreatePsw;
        self.forgetPswBtn.hidden = YES;
        self.gestureLockIndicator.hidden = NO;
        [self.gestureLockView clearLockView];
    }
}

// 抖动动画
- (void)shakeAnimationForView:(UIView *)view {
    
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    
    [viewLayer addAnimation:animation forKey:nil];
}


#pragma mark - 按钮点击事件 Anction

// 点击重新绘制按钮
- (void)resetGesturePassword:(id)sender {
    
    self.lastGesturePsw = nil;
    self.statusLabel.text = @"请绘制手势密码";
    self.resetPswBtn.hidden = YES;
    [self.gestureLockIndicator setGesturePassword:@""];
}

// 点击忘记手势密码按钮
- (void)forgetGesturesPassword:(id)sender {
    NSLog(@"忘记密码");
}

- (void)otherAccountLogin:(id)sender{
}

- (void)exitBtnClick:(UIButton *)btn{
    if (_didExited) {
        _didExited();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ZLgestureLockViewDelegate

- (void)gestureLockView:(ZLGestureLockView *)lockView drawRectFinished:(NSMutableString *)gesturePassword {
    
    switch (_unlockType) {
        case ZLUnlockTypeCreatePsw: // 创建手势密码
        {
            [self createGesturesPassword:gesturePassword];
        }
            break;
        case ZLUnlockTypeValidatePsw: // 校验手势密码
        case ZLUnlockTypeValidClosePsw:
        {
            BOOL success = [self validateGesturesPassword:gesturePassword];
            if (success) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
            break;
        case ZLUnlockTypeModifyPsw:{    // 修改手势密码
            [self modifyGesturePassword:gesturePassword];
        }
        default:
            break;
    }
}

@end
