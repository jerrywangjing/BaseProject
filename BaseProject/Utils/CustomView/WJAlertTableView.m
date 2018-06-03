//
//  WJAlertTableView.m
//  AlertTableView
//
//  Created by hjtc on 16/5/25.
//  Copyright © 2016年 hjtc. All rights reserved.
//

#import "WJAlertTableView.h"
#import "MBProgressHUD+WJ.h"
#import "XunYiTongV2_0-Swift.h"  // 引入swift类时，需要导入模块名(Product Module Name)在（ setting Building 中设置）

@interface WJAlertTableView ()<UITextViewDelegate>

@property (nonatomic,weak) UIView * backgroudView;
@property (nonatomic,weak) UIView * contentView;
@property (nonatomic,weak) UIButton * closeBtn;
@property (nonatomic,weak) UIImageView * contentBg;
@property (nonatomic,weak) UITextView * textView;
@property (nonatomic,weak) UILabel * placeholder;
@property (nonatomic,weak) UIButton * smsBtn;

@property (nonatomic,weak) UILabel * title;
@property (nonatomic,weak) UILabel * smsLab;
@property (nonatomic,weak) UILabel * longTelLab;
@property (nonatomic,weak) UILabel * shortTelLab;
@property (nonatomic,weak) UILabel * homeTelLab;


@end
    //Cannot synthesize weak property in file using manual reference counting
@implementation WJAlertTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景视图
        UIView * backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroudView = backgroundView;
        _backgroudView.backgroundColor = WJRGBAColor(0, 0, 0, 0.4);
        
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTouch)];
        
        [_backgroudView addGestureRecognizer:gesture];

        [self addSubview:_backgroudView];
        
        // 内容视图
        CGFloat contentW = 280;
        CGFloat contentH = 380;
        
        UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-contentW)/2,(SCREEN_HEIGHT-contentH)/2, contentW, contentH)];
        _contentView = contentView;
            // 添加圆角
        _contentView.layer.cornerRadius = 6;
        _contentView.layer.masksToBounds = YES;
            // 设置背景色
        _contentView.backgroundColor = WJRGBColor(226, 237, 246);

            // 添加子控件
        [self setupContentSubviews];
        
        //[_contentView addSubview:_contentBg];
        [self addSubview:_contentView];
        
        
        // 关闭按钮
        UIButton * btn = [[UIButton alloc] init];
        _closeBtn = btn;
        [_closeBtn setImage:[UIImage imageNamed:@"exit_nor"] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"exit_hlt"] forState:UIControlStateHighlighted];
        
        CGFloat margin = 5; // 间距
        CGFloat btnW = 30;
        CGFloat btnH = 30;
        CGFloat btnX =_contentView.frame.size.width - (btnW + margin);
        CGFloat btnY = margin;
        //_closeBtn.backgroundColor = [UIColor redColor];
        _closeBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [_closeBtn addTarget:self action:@selector(closeBtnTouch) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_closeBtn];
    }
    
    return self;
}

// 添加内容视图 子控件

-(void)setupContentSubviews{
    
    CGFloat contentW = self.contentView.frame.size.width;
    //CGFloat contentH = self.contentView.frame.size.width;
    
    // 1.设置标题视图
    UIView * titleBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentW, 40)];
    titleBg.backgroundColor = ThemeColor;
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0,(titleBg.frame.size.height-20)/2 , contentW, 20)];
    _title = title;
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    
    [titleBg addSubview:title];
    [self.contentView addSubview:titleBg];
    
    // 2. 短信输入框
    
    CGFloat textFiledX = 10;
    CGFloat textFiledY = CGRectGetMaxY(titleBg.frame) + 20;
    CGFloat textFiledW = contentW - 20;
    CGFloat textFiledH = 80;
    
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(textFiledX, textFiledY, textFiledW, textFiledH)];
    _textView = textView;
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = ThemeColor.CGColor;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.layer.cornerRadius = 6;
    _textView.layer.masksToBounds = YES;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeySend;
        // placeholder
    UILabel * placeholder = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 120, 20)];
    _placeholder = placeholder;
    _placeholder.text = @"请输入短信内容...";
    _placeholder.textColor = [UIColor lightGrayColor];
    _placeholder.font = _textView.font;
    [self.textView addSubview:_placeholder];
    [self.contentView addSubview:_textView];
    
    // 3.发短信按钮
    CGFloat margin = 10;
    CGFloat smsBtnY = CGRectGetMaxY(_textView.frame) + margin;
    UIButton * smsBtn = [self setupButtonsWithImgNor:@"sms_nor" andHlt:@"sms_hlt" title:@"发短信：" BtnY:smsBtnY];
    _smsBtn = smsBtn;
    _smsLab = smsBtn.subviews.lastObject;

    [smsBtn addTarget:self action:@selector(sendSMSClick:) forControlEvents:UIControlEventTouchUpInside];
    // 4. 手机号按钮
    CGFloat longTelBtnY = CGRectGetMaxY(smsBtn.frame) + margin;
    UIButton * longTelBtn = [self setupButtonsWithImgNor:@"phone_nor" andHlt:@"phone_hlt" title:@"手机号：" BtnY:longTelBtnY];
    _longTelLab = longTelBtn.subviews.lastObject;
    [longTelBtn addTarget:self action:@selector(longTelClick:) forControlEvents:UIControlEventTouchUpInside];
    // 5.短号按钮
    CGFloat shortTelBtnY = CGRectGetMaxY(longTelBtn.frame) + margin;
    
    UIButton * shortTelBtn = [self setupButtonsWithImgNor:@"shortTel_nor" andHlt:@"shortTel_hlt" title:@"拨短号：" BtnY:shortTelBtnY];
    _shortTelLab = shortTelBtn.subviews.lastObject;
    
    [shortTelBtn addTarget:self action:@selector(shortTelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    // 6. 座机号按钮
    CGFloat homeTelBtnY = CGRectGetMaxY(shortTelBtn.frame) + margin;
    UIButton * homeTelBtn = [self setupButtonsWithImgNor:@"tel_nor" andHlt:@"tel_hlt" title:@"座机号：" BtnY:homeTelBtnY];
    _homeTelLab = homeTelBtn.subviews.lastObject;
    [homeTelBtn addTarget:self action:@selector(homeTelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    // 7.复制按钮
    CGFloat copyBtnY = CGRectGetMaxY(homeTelBtn.frame) + margin;
    NSString * testCopyBtn = @"复制";
    
    UIButton * copyBtn = [self setupButtonsWithImgNor:@"copy_nor" andHlt:@"copy_hlt" title:testCopyBtn BtnY:copyBtnY];
    
    copyBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -150, 0, 0);
    copyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -130, 0, 0);
    
    [copyBtn addTarget:self action:@selector(copyBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}
#pragma mark - textView 代理方法
-(void)textViewDidChange:(UITextView *)textView{

    if (textView.text.length > 0) {
        
        [self.placeholder removeFromSuperview];
    }else{
    
        [textView addSubview:self.placeholder];
    }
}
// 获取键盘 返回键 点击事件
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if ([text isEqualToString:@"\n"]) {
        if ([textView.text  isEqual: @""]) {
            [MBProgressHUD showLabel:@"请输入短信内容"];
            return NO;
        }else{
        
            [self endEditing:YES];
            [self sendSMSClick:_smsBtn];
        }
    }
    
    return YES;
}

#pragma mark - 创建按钮
// 创建按钮.
-(UIButton *)setupButtonsWithImgNor:(NSString *)imgNor andHlt:(NSString *)imgHlt title:(NSString *)title BtnY:(CGFloat)btnY{
    
    CGFloat textFiledX = self.textView.frame.origin.x;
    CGFloat textFiledW = self.textView.frame.size.width;
    CGFloat btnH = 35;

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(textFiledX,btnY, textFiledW, btnH);
    [btn setBackgroundImage:[UIImage imageNamed:@"info_but_bg_hlt"] forState:UIControlStateHighlighted];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.cornerRadius = 17;
    btn.layer.masksToBounds = YES;
    
    [btn setImage:[UIImage imageNamed:imgNor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imgHlt] forState:UIControlStateHighlighted];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -120, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -90, 0, 0);
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if (![title isEqual: @"复制"]) {
        UILabel * numLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 0, 120, btnH)];
        numLabel.font = [UIFont systemFontOfSize:16];
        [btn addSubview:numLabel];
        
    }
    
    [self.contentView addSubview:btn];
    return btn;

}

-(void)sendSMSClick:(UIButton *)btn{

    //跳转到系统发短信页面
//    NSString * phoneNum = @"13987787656";
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",phoneNum]]];
    // 自定义内容短信发送
    NSString * phoneNum = self.data.mobile;
    NSArray * Arr = [NSArray arrayWithObject:phoneNum];
    if ([self.delegate respondsToSelector:@selector(sendSMS:recipientList:)]) {
        [self.delegate sendSMS:self.textView.text recipientList:Arr];
    }else{
    
        NSLog(@"代理未响应方法");
    }
    
}
-(void)longTelClick:(UIButton *)btn{
    //NSLog(@"拨打电话");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.data.mobile]]];
    
}
-(void)shortTelBtnClick:(UIButton *)btn{

    //NSLog(@"拨打短号");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.data.shortMobile]]];
}
-(void)homeTelBtnClick:(UIButton *)btn{

    //NSLog(@"打座机号");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.data.tel]]];
}
-(void)copyBtnClick:(UIButton *)btn{

    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    TelListData * copyData = self.data;
    NSString * copyStr = [NSString stringWithFormat:@"科室：%@\n姓名：%@\n性别：%@\n手机号：%@\n短号：%@\n座机号：%@",copyData.typeName,copyData.name,copyData.sex,copyData.mobile,copyData.shortMobile,copyData.tel];
    paste.string = copyStr;
    
    if ([paste.string isEqualToString:copyStr]) {
        [MBProgressHUD showLabel:@"复制成功"];
    }else{
    
        [MBProgressHUD showLabel:@"复制失败"];
    }
}

#pragma mark - 给子控件赋值
-(void)setData:(TelListData *)data{

    _data = data; // 这里多次忘记编写：一定要记住，不然data模型中为nil
    self.title.text = [NSString stringWithFormat:@"%@【%@】",data.typeName,data.name];
    self.longTelLab.text = data.mobile;
    self.shortTelLab.text = data.shortMobile;
    self.homeTelLab.text = data.tel;
    self.smsLab.text = data.mobile;
}


#pragma mark - AlertView Operations

-(void)closeBtnTouch{
    
    [self endEditing:YES];
    [self dismissAlertView];
}
-(void)backgroundViewTouch{ 
    [self endEditing:YES];
}
-(void)popAlertView{

    // 1. 在主窗口上显示alert视图
    UIWindow * currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:self];
    // 2.给alertView添加动画效果
    self.contentView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.contentView.alpha = 0;
    self.backgroudView.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        // 处理动画效果
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.contentView.alpha = 1.0;
        self.backgroudView.alpha = 1.0;
        
    } completion:nil];
    
}
-(void)dismissAlertView{

    // 退出视图动画
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        self.contentView.alpha = 0;
        self.backgroudView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

@end
