//
//  WJPopView.m
//  BaseProject
//
//  Created by JerryWang on 2017/8/17.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "WJPopView.h"

#define WJRGBAColor(r,g,b,a)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)];


@interface WJPopView ()

@property (nonatomic,weak) UIView *containerView;
@property (nonatomic,weak) UIButton *closeBtn;
@property (nonatomic,weak) UIActivityIndicatorView *activityView;

@property (nonatomic,assign) CGSize containerSize;
@property (nonatomic,strong) UIView *showView;
@property (nonatomic,strong) NSBundle *resourceBundle;   // 资源包

@end

@implementation WJPopView

- (instancetype)initWithContainerViewSize:(CGSize)containerSize{
    return [self initWithContainerViewSize:containerSize inView:nil];
}
- (instancetype)initWithContainerViewSize:(CGSize)containerSize inView:(UIView *)inView{
    return [self initWithFrame:[UIScreen mainScreen].bounds containerViewFrame:containerSize inView:inView];
}
- (instancetype)initWithFrame:(CGRect)frame containerViewFrame:(CGSize)containerSize inView:(UIView *)view{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _canHideByTapBgView = YES;
        _showCloseBtn = YES;
        _containerSize = containerSize;
        _showView = view;
        
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _canHideByTapBgView = YES;
        _showCloseBtn = YES;
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    
    if (CGSizeEqualToSize(_containerSize, CGSizeZero)) {
        _containerSize =  CGSizeMake(self.width, self.width);
    }
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _containerSize.width, _containerSize.height)];
    
    _containerView = containerView;
    _containerView.center = self.center;
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.cornerRadius = 10;
    _containerView.layer.masksToBounds = YES;
    
    [self addSubview:_containerView];
    // title label
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _containerView.width, 45)];
    _titleLabel = titleLabel;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.backgroundColor = [UIColor lightGrayColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // close btn
    
    UIButton *closeBtn = [[UIButton alloc] init];
    _closeBtn = closeBtn;
    closeBtn.frame = CGRectMake(_containerView.width-40, 5, 30, 30);
    
    UIImage *closeImage = [UIImage imageNamed:@"WJPopView.bundle/exit_nor"];
    [closeBtn setImage:closeImage forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_containerView addSubview:_titleLabel];
    [_containerView addSubview:_closeBtn];
    
    // contentView
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), _containerView.width, _containerView.height-titleLabel.height)];
    _contentView = contentView;
    
    [_containerView addSubview:_contentView];
    
    // activity view
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _activityView = activityView;
    activityView.center = _containerView.center;
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [activityView startAnimating];
    
}

#pragma mark - actions

- (void)closeBtnClick:(UIButton *)btn{
    [self hidePopView];
}

// 点击背景关闭视图
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.containerView.frame, point) && _canHideByTapBgView) {
        [self hidePopView];
    }
}

#pragma mark - setter

- (void)setShowCloseBtn:(BOOL)showCloseBtn{
    _showCloseBtn = showCloseBtn;
    self.closeBtn.hidden = !showCloseBtn;
}

#pragma mark - getter

- (NSBundle *)resourceBundle{
    if (!_resourceBundle) {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"WJPopView.bundle" ofType:nil];
        _resourceBundle = [NSBundle bundleWithPath:bundlePath];
    }
    return _resourceBundle;
}

#pragma mark - public

- (void)setShowActivityIndicatorView:(BOOL)showActivityIndicatorView{
    if (showActivityIndicatorView) {
        [_containerView addSubview:_activityView];
        [_containerView bringSubviewToFront:_activityView];
    }else{
        [_activityView removeFromSuperview];
    }
}
#pragma mark - private

- (void)showPopView{
    
    _containerView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    _containerView.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.backgroundColor = WJRGBAColor(0, 0, 0, 0.4);// apple 标准背景色
        _containerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        _containerView.alpha = 1;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(popViewDidShow)]) {
            [self.delegate popViewDidShow];
        }
    }];
    
    if (_showView) {
        [_showView addSubview:self];
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
}

- (void)hidePopView{
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.backgroundColor = [UIColor clearColor];
        _containerView.transform = CGAffineTransformMakeScale(0, 0);;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(popViewDidDismiss)]) {
            [self.delegate popViewDidDismiss];
        }
    }];
}

@end
