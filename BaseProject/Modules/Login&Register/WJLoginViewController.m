//
//  WJLoginViewController.m
//  BaseProject
//
//  Created by wangjing on 2019/1/31.
//  Copyright © 2019年 JerryWang. All rights reserved.
//

#import "WJLoginViewController.h"
#import "UIButton+PlaceContent.h"
#import "WJUserManager.h"
#import "BaseWebViewController.h"
#import "WJRegisterViewController.h"
#import "WJFindPasswordViewController.h"

@interface WJLoginViewController ()<UITextFieldDelegate>

@property (nonatomic,weak) UIImageView *logoView;
@property (nonatomic,weak) UIView *accountView;
@property (nonatomic,weak) UIView *passwordView;

@property (nonatomic,weak) UITextField *accountField;
@property (nonatomic,weak) UITextField *passwordField;

@property (nonatomic,weak) UIButton *servieceBtn;
@property (nonatomic,weak) UIButton *loginBtn;

@end

@implementation WJLoginViewController

- (void)dealloc{
    [kNotificationCenter removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self conifgNavbar];
    [self setupSubviews];
    
    [kNotificationCenter addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    // 加载已登录过的用户名
    NSString *userId = [kUserDefaults objectForKey:kWJCurrentLoginUserId];
    if (userId) {
        _accountField.text = [kUserDefaults objectForKey:userId];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 80;
}
- (void)viewWillDisappear:(BOOL)animated{
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10;
}

- (void)conifgNavbar{
//    self.isHiddenNavBar = YES;
}

- (void)setupSubviews{
    
    // logo
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo"]];
    _logoView = logoView;
    logoView.frame = CGRectMake(0, 120, logoView.image.size.width, logoView.image.size.height);
    logoView.centerX = self.view.centerX;
    
    [self.view addSubview:logoView];
    
    // inputviews
    
    [self creatAccountInputField];
    [self creatPasswordInputField];
    
    // find password
    
    UIButton *findPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [findPasswordBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [findPasswordBtn setTitleColor:WJFontColorTitle forState:UIControlStateNormal];
    [findPasswordBtn setTitleColor:WJFontColorSubtitle forState:UIControlStateHighlighted];
    findPasswordBtn.titleLabel.font = WJFontSize_14;
    [findPasswordBtn addTarget:self action:@selector(findPasswordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:findPasswordBtn];
    [findPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordView.mas_bottom).offset(15);
        make.left.equalTo(_passwordView);
    }];
    
    // create account
    
    UIButton *createAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [createAccountBtn setTitle:@"创建账号" forState:UIControlStateNormal];
    [createAccountBtn setTitleColor:WJFontColorTitle forState:UIControlStateNormal];
    [createAccountBtn setTitleColor:WJFontColorSubtitle forState:UIControlStateHighlighted];
    createAccountBtn.titleLabel.font = WJFontSize_14;
    [createAccountBtn addTarget:self action:@selector(createAccountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createAccountBtn];
    [createAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordView.mas_bottom).offset(15);
        make.right.equalTo(_passwordView);
    }];
    
    // login btn
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn = loginBtn;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:WJColorLightGray forState:UIControlStateDisabled];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_background_blue"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_background_gray"] forState:UIControlStateDisabled];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.cornerRadius = 3;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.titleLabel.font = WJFontSize_16;
    loginBtn.enabled = NO;
    
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(findPasswordBtn.mas_bottom).offset(50);
        make.left.right.equalTo(_passwordView);
        make.height.mas_equalTo(35);
    }];
    
    // read/accept btn
    
    UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _servieceBtn = serviceBtn;
    [serviceBtn setTitle:@"阅读并接受" forState:UIControlStateNormal];
    [serviceBtn setTitleColor:WJFontColorSubtitle forState:UIControlStateNormal];
    serviceBtn.titleLabel.font = WJFontSize_12;
    [serviceBtn setImage:[UIImage imageNamed:@"cell_select_normal"] forState:UIControlStateNormal];
    [serviceBtn setImage:[UIImage imageNamed:@"cell_select_selected"] forState:UIControlStateSelected];
    [serviceBtn addTarget:self action:@selector(serviceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [serviceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    serviceBtn.selected = YES;
    
    [self.view addSubview:serviceBtn];
    [serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).offset(17);
        make.left.equalTo(loginBtn).offset(35);
    }];
    
    // protocol btn
    
    UIButton *protocolBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [protocolBtn setTitle:@"BaseProject《服务协议》" forState:UIControlStateNormal];
    protocolBtn.titleLabel.font = WJFontSize_12;
    [protocolBtn addTarget:self action:@selector(protocolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:protocolBtn];
    [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(serviceBtn);
        make.left.equalTo(serviceBtn.mas_right);
    }];
}

- (void)creatAccountInputField{
    
    // inputView
    
    CGFloat inputWidth = self.view.width - 120;
    CGFloat inputHeight = 35;
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_logoView.frame)+64, inputWidth, inputHeight)];
    inputView.centerX = self.view.centerX;
    
    _accountView = inputView;
    [self.view addSubview:inputView];
    
    // textField
    UITextField *textField = [[UITextField alloc] init];
    _accountField = textField;
    textField.textColor = WJFontColorTitle;
    textField.font = WJFontSize_14;
    textField.placeholder = @"请输入用户名/手机号";
    textField.delegate = self;
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
    
}

- (void)creatPasswordInputField{
    
    // inputView
    
    CGFloat inputWidth = self.view.width - 120;
    CGFloat inputHeight = 35;
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_accountView.frame)+15, inputWidth, inputHeight)];
    inputView.centerX = self.view.centerX;
    _passwordView = inputView;
    [self.view addSubview:inputView];
    
    // textField
    UITextField *textField = [[UITextField alloc] init];
    _passwordField = textField;
    textField.textColor = WJFontColorTitle;
    textField.font = WJFontSize_14;
    textField.placeholder = @"请输入密码";
    textField.delegate = self;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.secureTextEntry = YES;
    [inputView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(inputView);
        make.right.equalTo(inputView).offset(-20);
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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"login_showPwd"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"login_hiddenPwd"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(textField);
        make.right.equalTo(line);
    }];
}

#pragma mark - actions

- (void)rightBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    _passwordField.secureTextEntry = !btn.selected;
}

- (void)textFieldDidChange{
    if (_accountField.text.length && _passwordField.text.length) {
        _loginBtn.enabled = YES;
    }else{
        _loginBtn.enabled = NO;
    }
}

// 找回密码
- (void)findPasswordBtnClick:(UIButton *)btn{
    WJFindPasswordViewController *findPwdVc = [WJFindPasswordViewController new];
    [self.navigationController pushViewController:findPwdVc animated:YES];
}

// 创建账号
- (void)createAccountBtnClick:(UIButton *)btn{
    WJRegisterViewController *registerVc = [WJRegisterViewController new];
    [self.navigationController pushViewController:registerVc animated:YES];
}

// 阅读接受协议

- (void)serviceBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
}

// 查看服务协议
- (void)protocolBtnClick:(UIButton *)btn{

    [MBProgressHUD showWarnMessage:@"还没有内容呢!"];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"服务协议" ofType:@"html"];
//    NSURL *url = [NSURL fileURLWithPath:path];
//    BaseWebViewController *privatePage = [[BaseWebViewController alloc] initWithUrl:url];
//    privatePage.title = @"服务协议";
//    [self.navigationController pushViewController:privatePage animated:YES];
}

// 登录

- (void)loginBtnClick:(UIButton *)btn{
    if (!_servieceBtn.selected) {
        [MBProgressHUD showWarnMessage:@"请勾选服务协议"];
        return;
    }
    
    // 执行登录
    if (self.didLoginCompletion) {
        self.didLoginCompletion(_accountField.text, _passwordField.text);
    }
}


#pragma mark - textField delegate

@end
