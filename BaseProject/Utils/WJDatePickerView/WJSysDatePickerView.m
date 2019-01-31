//
//  WJSysDatePickerView.m
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/7/8.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import "WJSysDatePickerView.h"

#define ContainerH 250
#define ToolbarH 40

@interface WJSysDatePickerView ()

@property (nonatomic,weak) UIView *toolbar;
@property (nonatomic,weak) UIView *pickerContainer;

@property (nonatomic,weak) UIDatePicker *datePickerView;
@property (nonatomic,assign) UIDatePickerMode datePikerMode;

@property (nonatomic,copy) DatePickerCallback confirmCallback;
@property (nonatomic,copy) CancelCallback cancleCallback;


// 是否允许点击背景关闭视图 默认开启
@property (nonatomic,assign) BOOL allowDismissByTapBackgroudView;

@end

@implementation WJSysDatePickerView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self initData];
        [self initSubviews];
        // 设置初始默认值
        self.allowDismissByTapBackgroudView = YES;
//        self.datePikerMode = UIDatePickerModeDate;
    }
    return self;
}

- (void)initData{
    
}

- (void)initSubviews{
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, SCREEN_WIDTH, ContainerH)];
    _pickerContainer = container;
    _pickerContainer.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pickerContainer];
    
    // toolbar
    UIView *toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ToolbarH)];
    toolbar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _toolbar = toolbar;
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // bar tipLabel
    UILabel *barLabel = [[UILabel alloc] init];
    barLabel.text = @"";
    barLabel.textColor = [UIColor lightGrayColor];
    barLabel.font = [UIFont systemFontOfSize:13];
    barLabel.textAlignment = NSTextAlignmentCenter;
    
    [toolbar addSubview:barLabel];
    [toolbar addSubview:cancelBtn];
    [toolbar addSubview:confirmBtn];
    
    // 布局按钮
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolbar);
        make.left.equalTo(toolbar).offset(10);
        
    }];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolbar);
        make.right.equalTo(toolbar).offset(-10);
    }];
    
    [barLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(toolbar);
    }];
    [_pickerContainer addSubview:toolbar];
    
    // tip Label
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(toolbar.frame)+10, SCREEN_WIDTH, 35)];
    tipLabel.text = @"";
    tipLabel.textColor = [UIColor darkGrayColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    [_pickerContainer addSubview:tipLabel];
    
    // picker view
    
    UIDatePicker *pickerView = [[UIDatePicker alloc] init];
    _datePickerView = pickerView;
    _datePickerView.timeZone = [NSTimeZone timeZoneWithName:@"BeiJing"];
    _datePickerView.datePickerMode = UIDatePickerModeDate;
    
    [_pickerContainer addSubview:_datePickerView];
    
    [_datePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_pickerContainer);
        make.top.equalTo(tipLabel);
    }];
}


#pragma mark - action

- (void)cancleBtnClick:(UIButton *)btn{
    
    [self hidePickerView];
    _cancleCallback();
}
- (void)confirmBtnClick:(UIButton *)btn{
    [self hidePickerView];
    _confirmCallback(_datePickerView.date);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (!_allowDismissByTapBackgroudView) {
        return;
    }
    
    CGPoint point = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.pickerContainer.frame, point)) {
        return;
    }
    [self hidePickerView];
}
#pragma mark - public

+ (void)showSystemDatePickerViewWithMode:(UIDatePickerMode)mode confirmCallBack:(DatePickerCallback)confirmCallback cancelCallback:(CancelCallback)cancelCallback{
    
    [self showSystemDatePickerViewWithMode:mode date:[NSDate date] minDate:nil maxDate:nil confirmCallBack:^(NSDate *date) {
        
        if (confirmCallback) {
            confirmCallback(date);
        }
        
    } cancelCallback:^{
        
        if (cancelCallback) {
            cancelCallback();
        }
    }];
}

+ (void)showSystemDatePickerViewWithMode:(UIDatePickerMode)mode date:(NSDate *)date confirmCallBack:(DatePickerCallback)confirmCallback cancelCallback:(CancelCallback)cancelCallback{
    
    [self showSystemDatePickerViewWithMode:mode date:date minDate:nil maxDate:nil confirmCallBack:^(NSDate *date) {
        
        if (confirmCallback) {
            confirmCallback(date);
        }
        
    } cancelCallback:^{
        
        if (cancelCallback) {
            cancelCallback();
        }
    }];
}


+ (void)showSystemDatePickerViewWithMode:(UIDatePickerMode)mode date:(NSDate *)date minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate confirmCallBack:(DatePickerCallback)confirmCallback cancelCallback:(CancelCallback)cancelCallback{
    
    WJSysDatePickerView *datePicker = [[WJSysDatePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    if (date) {
        datePicker.datePickerView.date = date;
    }
    
    if (minDate) {
        datePicker.datePickerView.minimumDate = minDate;
    }
    
    if (maxDate) {
        datePicker.datePickerView.maximumDate = maxDate;
    }
    
    datePicker.datePikerMode = mode;
    datePicker.confirmCallback = ^(NSDate *date){
        
        if (confirmCallback) {
            confirmCallback(date);
        }
    };
    datePicker.cancleCallback = ^{
        
        if (cancelCallback) {
            cancelCallback();
        }
    };
    
    if ([[IQKeyboardManager sharedManager] isKeyboardShowing]) {
        [[IQKeyboardManager sharedManager] resignFirstResponder];
    }
    
    [datePicker showPickerView];
    
}
#pragma mark - private

- (void)showPickerView{
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.4);// apple 标准背景色
        _pickerContainer.transform = CGAffineTransformMakeTranslation(0, -ContainerH);
        
    } completion:nil];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hidePickerView{
    
    [UIView transitionWithView:_pickerContainer duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        self.backgroundColor = [UIColor clearColor];
        _pickerContainer.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

