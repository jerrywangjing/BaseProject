//
//  WJAlertSheetView.m
//  JWChat
//
//  Created by JerryWang on 2017/4/26.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "WJAlertSheetView.h"

#define WJRGBAColor(r,g,b,a)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

static const CGFloat ButtonHeight = 50;
static const CGFloat GapHeight = 7;
static const CGFloat GapLineHeight = 0.5;
static const CGFloat TipsViewHeight = 60;


typedef NS_ENUM(NSUInteger, WJSheetStyle) {
    WJSheetStyleSingleSelect,   // 单选样式，默认
    WJSheetStyleMultiSelect,    // 多选样式
};

@interface WJAlertSheetView()

@property (nonatomic,assign) WJSheetStyle style;

@property (nonatomic,weak) UIScrollView *bottomScrollView;
@property (nonatomic,weak) UIVisualEffectView * blurView;
@property (nonatomic,weak) UIView * tipsView;
@property (nonatomic,assign) CGFloat blurViewHeight;
@property (nonatomic,strong) NSArray * items;
@property (nonatomic,strong) NSMutableArray *itemViews;     // 所有创建的可选按钮
@property (nonatomic,copy) NSString * tips;     // 提示语

@property (nonatomic,copy) SelectedBlock callback;
@property (nonatomic,copy) CancelBlock cancelBlock;
@property (nonatomic,copy) DoneBlock doneBlock;

@end

@implementation WJAlertSheetView

- (NSMutableArray *)itemViews{
    if (!_itemViews) {
        _itemViews = [NSMutableArray array];
    }
    return _itemViews;
}

- (instancetype)initWithFrame:(CGRect)frame tips:(NSString *)tips items:(NSArray<NSString *> *)items style:(WJSheetStyle)style{

    if (self = [super initWithFrame:frame]) {
        // init code
        _items = items;
        _tips = tips;
        _style = style;
        
        _blurViewHeight = ButtonHeight + GapHeight + items.count * ButtonHeight + (items.count -1) * GapLineHeight + (_tips ? TipsViewHeight+GapLineHeight : 0);
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{

    self.backgroundColor = [UIColor clearColor];
    
    // blurView
    
    CGFloat blurViewH = _blurViewHeight > SCREEN_HEIGHT ? SCREEN_HEIGHT : _blurViewHeight;
    
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView * blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, blurViewH);
    
    _blurView = blurView;
    
    [self addSubview:_blurView];

    // scrollView item 容器
    
    CGFloat scrollViewH = _blurViewHeight - ButtonHeight;
    CGFloat scrollViewY = 0;
    if (_blurViewHeight > SCREEN_HEIGHT) {
        scrollViewH = SCREEN_HEIGHT - ButtonHeight-GapHeight-20;
        scrollViewY = 20;
    }
    UIScrollView * bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollViewY, SCREEN_WIDTH, scrollViewH)];
    
    CGFloat scrollContentH = ButtonHeight *_items.count + GapLineHeight*(_items.count-1);
    if (_tips) {
        scrollContentH += TipsViewHeight+GapLineHeight;
    }
    bottomScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, scrollContentH);
    _bottomScrollView = bottomScrollView;
    
    [_blurView.contentView addSubview:bottomScrollView];
    
    // tips view
    
    if (_tips) {
        
        UIView * tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TipsViewHeight)];
        _tipsView = tipsView;
        tipsView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        [_bottomScrollView addSubview:tipsView];
        
        UILabel * tipsLabel = [[UILabel alloc] init];
        tipsLabel.text = _tips;
        tipsLabel.textColor = [UIColor lightGrayColor];
        tipsLabel.font = [UIFont systemFontOfSize:14];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.numberOfLines = 0;
        
        [tipsView addSubview:tipsLabel];
        
        // 布局
        
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(tipsView);
            make.left.equalTo(tipsView).offset(15);
            make.right.equalTo(tipsView).offset(-15);
        }];
    }

    // items view
    
    for (int i = 0 ; i<_items.count; i++) {
        
        CGFloat itemY = i * (ButtonHeight + GapLineHeight) + (_tips ? TipsViewHeight+GapLineHeight : 0);

        UIButton * item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.frame = CGRectMake(0, itemY, SCREEN_WIDTH, ButtonHeight);
        
        [item setTitle:_items[i] forState:UIControlStateNormal];
        [item setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:1.0 alpha:1.0]] forState:UIControlStateNormal];
        [item setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:1.0 alpha:0.5]] forState:UIControlStateHighlighted];
        [item setBackgroundImage:[UIImage imageNamed:@"mutilSheet_selected_bg"] forState:UIControlStateSelected];
        item.adjustsImageWhenHighlighted = NO;
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [item addTarget:self action:@selector(itemDidClick:) forControlEvents:UIControlEventTouchUpInside];
        item.tag = i+1;

        [self.itemViews addObject:item];
        [_bottomScrollView addSubview:item];
    }
    
    // done btn,include cancel or done
    
    UIButton * doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat doneBtnY = _blurViewHeight > SCREEN_HEIGHT ? SCREEN_HEIGHT-ButtonHeight : _blurViewHeight-ButtonHeight;
    
    doneBtn.frame = CGRectMake(0, doneBtnY, SCREEN_WIDTH, ButtonHeight);
    [doneBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:1.0 alpha:1.0]] forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:1.0 alpha:0.5]] forState:UIControlStateHighlighted];
    [doneBtn setTitle:@"取消" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    if (_style == WJSheetStyleMultiSelect) {
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [doneBtn setTitleColor:WJRGBAColor(72, 144, 0, 1) forState:UIControlStateNormal];
        doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    
    [doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_blurView.contentView addSubview:doneBtn];
    
}

#pragma actions

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    CGPoint point = [[touches anyObject] locationInView:self.blurView];
    if (CGRectContainsPoint(self.tipsView.frame, point)) { // 点击tipsView 不隐藏self
        return;
    }
    [self hideView];
}

- (void)doneBtnClick:(UIButton *)btn{

    switch (_style) {
        case WJSheetStyleSingleSelect:
            _cancelBlock(btn);
            break;
        case WJSheetStyleMultiSelect:{
            
            NSMutableArray *selectedItems = [NSMutableArray array];
            for (UIButton *item in self.itemViews) {
                if (item.selected) {
                    [selectedItems addObject:item.titleLabel.text];
                }
            }
            NSString *selectedItemValue = [selectedItems componentsJoinedByString:@","];
            _callback(selectedItemValue,0,nil);
        }
            break;
        default:
            break;
    }
    
    [self hideView];
}

- (void)itemDidClick:(UIButton *)btn{

    switch (_style) {
        case WJSheetStyleSingleSelect:
            _callback(btn.titleLabel.text,btn.tag,btn);
            [self hideView];
            break;
        case WJSheetStyleMultiSelect:
    
//            btn.adjustsImageWhenHighlighted = btn.selected ? NO:YES;
            btn.selected  = !btn.selected;
            break;
        default:
            break;
    }
    
}

#pragma mark - public

+ (void)showAlertSheetViewWithTips:(NSString *)tips items:(NSArray<NSString *> *)items cancel:(CancelBlock)cancle completion:(SelectedBlock)completion{

    if (items.count == 0) {
        NSLog(@"Error: item's count could not is zero in AlertSheetView");
        return;
    }
    
    WJAlertSheetView * sheetView = [[WJAlertSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds tips:tips items:items style:WJSheetStyleSingleSelect];

    sheetView.callback = ^(NSString *selectedValue, NSInteger index, UIButton *item) {
        if (completion) {
            completion(selectedValue,index,item);
        }
    };
    sheetView.cancelBlock = ^(UIButton *item) {
        if (cancle) {
            cancle(item);
        }
    };
    
    if ([[IQKeyboardManager sharedManager] isKeyboardShowing]) {
        [[IQKeyboardManager sharedManager] resignFirstResponder];
    }
    [sheetView showView];
}

+ (void)showAlertSheetViewWithTips:(NSString *)tips items:(NSArray<NSString *> *)items config:(id)config cancel:(CancelBlock)cancle completion:(SelectedBlock)completion{
    // 待完善
    
}
+ (void)showAlertMultiSheetViewWithTips:(NSString *)tips items:(NSArray<NSString *> *)items completion:(SelectedBlock)completion{
    
    if (items.count == 0) {
        NSLog(@"item's count could not is zero in AlertSheetView");
        return;
    }
    
    WJAlertSheetView * sheetView = [[WJAlertSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds tips:tips items:items style:WJSheetStyleMultiSelect];
    
    sheetView.callback = ^(NSString *selectedValue, NSInteger index, UIButton *item) {
        if (completion) {
            completion(selectedValue,index,item);
        }
    };
    
    if ([[IQKeyboardManager sharedManager] isKeyboardShowing]) {
        [[IQKeyboardManager sharedManager] resignFirstResponder];
    }
    [sheetView showView];
}

#pragma mark - private

- (void)showView{

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.backgroundColor = WJRGBAColor(0, 0, 0, 0.4);// apple 标准背景色
        CGFloat trasnlationH = _blurViewHeight > SCREEN_HEIGHT ? SCREEN_HEIGHT : _blurViewHeight;
        _blurView.transform = CGAffineTransformMakeTranslation(0, -trasnlationH);
        
    } completion:nil];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}

- (void)hideView{

    [UIView transitionWithView:_blurView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        self.backgroundColor = [UIColor clearColor];
        _blurView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
