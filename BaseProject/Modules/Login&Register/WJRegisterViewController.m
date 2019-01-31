//
//  WJRegisterViewController.m
//  BaseProject
//
//  Created by wangjing on 2019/1/31.
//  Copyright © 2019年 JerryWang. All rights reserved.
//

#import "WJRegisterViewController.h"

#import "WJNumberCheck.h"
#import "WJUserManager.h"
#import "NSString+Hash.h"

static CGFloat InputFieldHeight = 35;
static CGFloat fieldMargin = 25;
static CGFloat distanceForTop = 160;

static NSInteger resetTimes = 60;

#define kOriginY(level) (InputFieldHeight * level + distanceForTop + level*fieldMargin)

@interface WJRegisterViewController ()

@property (nonatomic,weak) UITextField *usernameField;
@property (nonatomic,weak) UITextField *phoneNumberField;
@property (nonatomic,weak) UITextField *verifyCodeField;
@property (nonatomic,weak) UITextField *passwordField;
@property (nonatomic,weak) UITextField *confirmPasswordField;

@property (nonatomic,weak) UIButton *registerBtn;

@property (nonatomic,weak) UIButton *verifyBtn;
@property (nonatomic,strong) NSTimer *verifyTimer;
@property (nonatomic,copy) NSString *verifyCode;    // 记录后台返回的验证码

@end

@implementation WJRegisterViewController

- (void)dealloc{
    [kNotificationCenter removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [self.verifyTimer invalidate];
    self.verifyTimer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self conifgNavbar];
    [self setupSubviews];
    
    [kNotificationCenter addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 100;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    // 销毁定时器
    [self.verifyTimer invalidate];
    self.verifyTimer = nil;
    resetTimes = 60;
}

- (void)conifgNavbar{
    
    // 隐藏navbar
    self.isHiddenNavBar = YES;
    
    // back btn
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(25);
        make.size.mas_equalTo(CGSizeMake(35, 44));
    }];
}

- (void)setupSubviews{
    
    // title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"创建账号";
    titleLabel.textColor = WJFontColorTitle;
    titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(74);
    }];
    
    // fileds
    
    _usernameField = [self creatInputFieldForPlaceholder:@"请输入用户名" originY:160 index:0];
    _phoneNumberField = [self creatInputFieldForPlaceholder:@"请输入手机号" originY:kOriginY(1) index:1];
    _verifyCodeField = [self creatInputFieldForPlaceholder:@"请输入验证码" originY:kOriginY(2) index:2];
    _passwordField = [self creatInputFieldForPlaceholder:@"请输入密码" originY:kOriginY(3) index:3];
    _confirmPasswordField = [self creatInputFieldForPlaceholder:@"请再次输入密码" originY:kOriginY(4) index:4];
    
    // register btn
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerBtn = registerBtn;
    [registerBtn setTitle:@"确认注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setTitleColor:WJColorLightGray forState:UIControlStateDisabled];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"btn_background_blue"] forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"btn_background_gray"] forState:UIControlStateDisabled];
    [registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.layer.cornerRadius = 3;
    registerBtn.layer.masksToBounds = YES;
    registerBtn.titleLabel.font = WJFontSize_16;
    registerBtn.enabled = NO;
    
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_confirmPasswordField.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(60);
        make.right.equalTo(self.view).offset(-60);
        make.height.mas_equalTo(35);
    }];
}

// 创建输入框视图

- (UITextField *)creatInputFieldForPlaceholder:(NSString *)placeholder originY:(CGFloat)originY index:(NSInteger)index{
    
    CGFloat inputWidth = self.view.width - 120;
    CGFloat inputHeight = 35;
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, inputWidth, inputHeight)];
    inputView.centerX = self.view.centerX;
    [self.view addSubview:inputView];
    
    // textField
    UITextField *textField = [[UITextField alloc] init];
    textField.textColor = WJFontColorTitle;
    textField.font = WJFontSize_14;
    textField.placeholder = placeholder;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [inputView addSubview:textField];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(inputView);
        make.height.mas_equalTo(inputView.height-1);
    }];
    
    // line
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = WJColorSeparatorLine;
    [inputView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(inputView);
        make.size.mas_equalTo(CGSizeMake(inputView.width, 1));
        make.left.right.equalTo(inputView);
    }];
    
    
    // right view
    
    if (index == 2) { // 获取验证码按钮
        
        UIButton *verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _verifyBtn = verifyBtn;
        [verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [verifyBtn setTitleColor:WJColorLightGray forState:UIControlStateDisabled];
        verifyBtn.titleLabel.font = WJFontSize_12;
        [verifyBtn setBackgroundImage:[UIImage imageNamed:@"btn_background_blue"] forState:UIControlStateNormal];
        [verifyBtn setBackgroundImage:[UIImage imageNamed:@"btn_background_gray"] forState:UIControlStateDisabled];
        [verifyBtn addTarget:self action:@selector(verifyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [inputView addSubview:verifyBtn];
        
        // 布局
        
        [textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(inputView).offset(-100);
        }];
        [line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(textField);
        }];
        [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(inputView);
            make.bottom.equalTo(line);
            make.width.mas_equalTo(90);
            make.height.equalTo(inputView);
        }];
    }
    
    if (index == 3|| index == 4) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"login_showPwd"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"login_hiddenPwd"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [inputView addSubview:btn];
        btn.tag = index;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(textField);
            make.right.equalTo(line);
        }];
        [textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(inputView).offset(-20);
        }];
        
        textField.secureTextEntry = YES;
    }
    
    // 修改field键盘类型
    if (index == 1) {
        textField.keyboardType = UIKeyboardTypePhonePad;
    }else if (index == 2){
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    return textField;
}

#pragma mark - actions

// 返回
- (void)backBtnClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

// textField 输入变化通知

- (void)textFieldDidChange{
    if (_usernameField.text.length &&
        _phoneNumberField.text.length &&
        _verifyCodeField.text.length &&
        _passwordField.text.length &&
        _confirmPasswordField.text.length) {
        _registerBtn.enabled = YES;
    }else{
        _registerBtn.enabled = NO;
    }
}

// 验证码点击

- (void)verifyBtnClick:(UIButton *)btn{
    
    // 1. 验证手机号合法性
    
    if (!_phoneNumberField.text.length) {
        [MBProgressHUD showWarnMessage:@"请输入手机号"];
        return;
    }else if(![WJNumberCheck checkTelNumber:_phoneNumberField.text]) {
        [MBProgressHUD showWarnMessage:@"手机号不合法"];
        return;
    }
    
    // 2. 调验证码接口，等待返回后，启动倒计时
    
    [kWJUserManager sendSMSToTel:_phoneNumberField.text completion:^(NSString *code) {
        _verifyCode = code;
        
        // 3. 开启倒计时
        
        btn.enabled = NO;
        WeakSelf(weakSelf);
        _verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(didSetTimes) userInfo:nil repeats:YES];
        [_verifyTimer fire];
        
    }];
}

// 倒计时
- (void)didSetTimes{
    
    if (resetTimes == 0) {
        [_verifyTimer invalidate];
        _verifyTimer = nil;
        _verifyBtn.enabled = YES;
        [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        resetTimes = 60;
        return;
    }
    
    NSString *title = [NSString stringWithFormat:@"重新获取(%ld)",resetTimes--];
    [_verifyBtn setTitle:title forState:UIControlStateNormal];
    
}

// 隐藏密码按钮点击
- (void)rightBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.tag == 3) {
        _passwordField.secureTextEntry = !btn.selected;
    }else if (btn.tag == 4){
        _confirmPasswordField.secureTextEntry = !btn.selected;
    }
}

// 注册按钮点击

- (void)registerBtnClick:(UIButton *)btn{
    
    // 校验合法性
    
    if (!_usernameField.text.length) {
        [MBProgressHUD showWarnMessage:@"请输入用户名"];
        return;
    }else if(![WJNumberCheck checkUserName:_usernameField.text]) {
        [MBProgressHUD showWarnMessage:@"用户名需2-16位汉字字母数字或下划线"];
        return;
    }
    
    if (!_phoneNumberField.text.length) {
        [MBProgressHUD showWarnMessage:@"请输入手机号"];
        return;
    }else if(![WJNumberCheck checkTelNumber:_phoneNumberField.text]) {
        [MBProgressHUD showWarnMessage:@"手机号不合法"];
        return;
    }
    
    if (!_verifyCodeField.text.length) {
        [MBProgressHUD showWarnMessage:@"请输入验证码"];
        return;
    }else if(![_verifyCodeField.text isEqualToString:_verifyCode]) {
        [MBProgressHUD showWarnMessage:@"验证码错误，请稍后再试"];
        return;
    }
    
    if (!_passwordField.text.length) {
        [MBProgressHUD showWarnMessage:@"请输入密码"];
        return;
    }else if(![WJNumberCheck checkPassword:_passwordField.text]) {
        [MBProgressHUD showWarnMessage:@"密码需要6-18位字母数字组合"];
        return;
    }
    
    if (!_confirmPasswordField.text.length) {
        [MBProgressHUD showWarnMessage:@"请再次输入密码"];
        return;
    }else if(![_confirmPasswordField.text isEqualToString:_passwordField.text]) {
        [MBProgressHUD showWarnMessage:@"两次密码输入不一致"];
        return;
    }
    
    // 去注册
    [self toRegister];
}

// 执行注册
- (void)toRegister{
    
    NSDictionary *regInfo = @{
                              @"username": _usernameField.text,
                              @"tel": _phoneNumberField.text,
                              @"code" : @(_verifyCodeField.text.integerValue),
                              @"password": _passwordField.text.md5String,
                              };
    
    [kWJUserManager registerForInfo:regInfo completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


@end
