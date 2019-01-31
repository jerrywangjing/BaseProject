//
//  Y_StockChartSegmentView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/5/2.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_StockChartSegmentView.h"
#import "Masonry.h"
#import "UIColor+Y_StockChart.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue &0xFF00) >>8))/255.0 blue:((float)(rgbValue &0xFF))/255.0 alpha:1.0]

static NSInteger const Y_StockChartSegmentStartTag = 2000;

//static CGFloat const Y_StockChartSegmentIndicatorViewHeight = 2;
//
//static CGFloat const Y_StockChartSegmentIndicatorViewWidth = 40;

@interface Y_StockChartSegmentView()

@property (nonatomic, strong) UIButton *selectedBtn;  // 当前选中的btn

@property (nonatomic,strong) UIStackView *itemStackView;    // 分时k线栈视图
@property (nonatomic, strong) UIStackView *indicatorView;   // 指标点击后弹出的,指标选择按钮

@property (nonatomic, strong) UIButton *secondLevelSelectedBtn1; // 指标按钮1

@property (nonatomic, strong) UIButton *secondLevelSelectedBtn2; // 指标按钮2

@property (nonatomic,assign) Y_StockChartSegmentLayout layoutType;

@end

@implementation Y_StockChartSegmentView

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super initWithFrame:CGRectZero];
    if(self)
    {
        self.items = items;
    }
    return self;
}

- (instancetype)initWithLayoutType:(Y_StockChartSegmentLayout)layoutType{
    if (self = [super init]) {
        _layoutType = layoutType;
        self.backgroundColor = UIColorFromRGB(0X1F2437);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor assistBackgroundColor];
    }
    return self;
}


- (UIStackView *)indicatorView{
    if (!_indicatorView) {
        
        // 创建btns
        
        NSArray *titleArr = @[@"MACD",@"KDJ",@"关闭",@"MA",@"EMA",@"BOLL",@"关闭"];
        NSInteger index = 0;
        
        NSMutableArray *btns = [NSMutableArray array];
        
        for (NSString *title in titleArr) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:[UIColor mainTextColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor ma30Color] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.tag = Y_StockChartSegmentStartTag + 100 + index;
            [btn addTarget:self action:@selector(event_segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:title forState:UIControlStateNormal];
            [btns addObject:btn];
            index++;
        }
        
        // 创建stackViews
        
        _indicatorView = [[UIStackView alloc] initWithArrangedSubviews:btns];
        _indicatorView.backgroundColor = [UIColor assistBackgroundColor];
        _indicatorView.axis = _layoutType == Y_StockChartSegmentLayoutHorizon ? UILayoutConstraintAxisHorizontal:UILayoutConstraintAxisVertical;
        _indicatorView.alignment = UIStackViewAlignmentCenter;
        _indicatorView.distribution = UIStackViewDistributionFillEqually; // stackView中的控件都是等宽的
//        _indicatorView.backgroundColor = UIColorFromRGB(0X1F2437);
            // 配置按钮
        UIButton *firstBtn = _indicatorView.arrangedSubviews[0];
        [firstBtn setSelected:YES];
        _secondLevelSelectedBtn1 = firstBtn;
        
        UIButton *firstBtn2 = _indicatorView.arrangedSubviews[6];
        [firstBtn2 setSelected:YES];
        _secondLevelSelectedBtn2 = firstBtn2;
        
        [self addSubview:_indicatorView];
        
        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.itemStackView.mas_bottom);
            make.left.right.equalTo(self);
            make.height.equalTo(self.itemStackView);
        }];
        
    }
    return _indicatorView;
}


//- (UIView *)indicatorView
//{
//    if(!_indicatorView)
//    {
//
//        NSArray *titleArr = @[@"MACD",@"KDJ",@"关闭",@"MA",@"EMA",@"BOLL",@"关闭"];
//        NSInteger index = 0;
//        // 创建btns
//        NSMutableArray *btns = [NSMutableArray array];
//
//        for (NSString *title in titleArr) {
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [btn setTitleColor:[UIColor mainTextColor] forState:UIControlStateNormal];
//            [btn setTitleColor:[UIColor ma30Color] forState:UIControlStateSelected];
//            btn.titleLabel.font = [UIFont systemFontOfSize:13];
//            btn.tag = Y_StockChartSegmentStartTag + 100 + index;
//            [btn addTarget:self action:@selector(event_segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//            [btn setTitle:title forState:UIControlStateNormal];
//            [btns addObject:btn];
//            index++;
//        }
//
////        [titleArr enumerateObjectsUsingBlock:^(NSString*  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
////
////            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
////            [btn setTitleColor:[UIColor mainTextColor] forState:UIControlStateNormal];
////            [btn setTitleColor:[UIColor ma30Color] forState:UIControlStateSelected];
////            btn.titleLabel.font = [UIFont systemFontOfSize:13];
////            btn.tag = Y_StockChartSegmentStartTag + 100 + idx;
////            [btn addTarget:self action:@selector(event_segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
////            [btn setTitle:title forState:UIControlStateNormal];
////
//////            [self->_indicatorView addSubview:btn];
////
////            [btns addObject:btn];
//
//            // 布局
////            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
////
////                make.height.equalTo(self->_indicatorView).multipliedBy(1.0f/titleArr.count);
////                make.width.equalTo(self->_indicatorView);
////                make.left.equalTo(self->_indicatorView);
////
////                if(preBtn)
////                {
////                    make.top.equalTo(preBtn.mas_bottom);
////                } else {
////                    make.top.equalTo(self->_indicatorView);
////                }
////            }];
////            UIView *view = [UIView new];
////            view.backgroundColor = [UIColor colorWithRed:52.f/255.f green:56.f/255.f blue:67/255.f alpha:1];
////            [self->_indicatorView addSubview:view];
////            [view mas_makeConstraints:^(MASConstraintMaker *make) {
////                make.left.right.equalTo(btn);
////                make.top.equalTo(btn.mas_bottom);
////                make.height.equalTo(@0.5);
////            }];
////            preBtn = btn;
////        }];
//
//
//        _indicatorView = [[UIStackView alloc] initWithArrangedSubviews:btns];
//        _indicatorView.backgroundColor = [UIColor assistBackgroundColor];
//        _indicatorView.axis = UILayoutConstraintAxisVertical;
//        _indicatorView.alignment = UIStackViewAlignmentCenter;
//        _indicatorView.distribution = UIStackViewDistributionFillEqually; // stackView中的控件都是等宽的
//
//
//        UIButton *firstBtn = _indicatorView.subviews[0];
//        [firstBtn setSelected:YES];
//        _secondLevelSelectedBtn1 = firstBtn;
//        UIButton *firstBtn2 = _indicatorView.subviews[6];
//        [firstBtn2 setSelected:YES];
//        _secondLevelSelectedBtn2 = firstBtn2;
//        [self addSubview:_indicatorView];
//
//        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(self);
//            make.bottom.equalTo(self);
//            make.width.equalTo(self);
//            make.right.equalTo(self.mas_left);
//        }];
//    }
//    return _indicatorView;
//}

- (void)setItems:(NSArray *)items
{
    _items = items;
    if(items.count == 0 || !items) return;
    
    NSInteger index = 0;
    
    // 创建items
    NSMutableArray *btns = [NSMutableArray array];
    for (NSString *title in items) {
        UIButton *btn = [self private_createButtonWithTitle:title tag:Y_StockChartSegmentStartTag+index];
        [btns addObject:btn];
        index++;
    }
    
    // segment stackView
    
    _itemStackView = [[UIStackView alloc] initWithArrangedSubviews:btns];
    _itemStackView.axis = _layoutType == Y_StockChartSegmentLayoutHorizon ? UILayoutConstraintAxisHorizontal:UILayoutConstraintAxisVertical;
    _itemStackView.alignment = UIStackViewAlignmentCenter;
    _itemStackView.distribution = UIStackViewDistributionFillEqually;
    
    [self addSubview:_itemStackView];

    [_itemStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(self);
    }];

}

#pragma mark 设置底部按钮index

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    UIButton *btn = (UIButton *)[self viewWithTag:Y_StockChartSegmentStartTag + selectedIndex];
    NSAssert(btn, @"按钮初始化出错");
    [self event_segmentButtonClicked:btn];
}

- (void)setSelectedBtn:(UIButton *)selectedBtn
{
    if(_selectedBtn == selectedBtn)
    {
        if(selectedBtn.tag != Y_StockChartSegmentStartTag)
        {
            return;
        }
    }
    
    if(selectedBtn.tag >= 2100 && selectedBtn.tag < 2103)
    {
        [_secondLevelSelectedBtn1 setSelected:NO];
        [selectedBtn setSelected:YES];
        _secondLevelSelectedBtn1 = selectedBtn;
        
    } else if(selectedBtn.tag >= 2103) {
        [_secondLevelSelectedBtn2 setSelected:NO];
        [selectedBtn setSelected:YES];
        _secondLevelSelectedBtn2 = selectedBtn;
    } else if(selectedBtn.tag != Y_StockChartSegmentStartTag){
        [_selectedBtn setSelected:NO];
        [selectedBtn setSelected:YES];
        _selectedBtn = selectedBtn;
    }

    _selectedIndex = selectedBtn.tag - Y_StockChartSegmentStartTag;
    
    if(_selectedIndex == 0 && self.indicatorView.frame.origin.x < 0)
    {
        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(self);
        }];
        
        self.itemStackView.hidden = YES;
        [self layoutIfNeeded];
        
    } else {
        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_left);
            make.bottom.equalTo(self);
            make.width.height.equalTo(self);
        }];
        
        self.itemStackView.hidden = NO;
        [self layoutIfNeeded];
    }
    
    [self layoutIfNeeded];
}

#pragma mark - 私有方法
#pragma mark 创建底部按钮
- (UIButton *)private_createButtonWithTitle:(NSString *)title tag:(NSInteger)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor mainTextColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor ma30Color] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.tag = tag;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn addTarget:self action:@selector(event_segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    
    return btn;
}

#pragma mark 底部按钮点击事件
- (void)event_segmentButtonClicked:(UIButton *)btn
{
    self.selectedBtn = btn;
    
    if(btn.tag == Y_StockChartSegmentStartTag)
    {
        return;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(y_StockChartSegmentView:clickSegmentButtonIndex:)])
    {
        [self.delegate y_StockChartSegmentView:self clickSegmentButtonIndex: btn.tag-Y_StockChartSegmentStartTag];
    }
}

@end
