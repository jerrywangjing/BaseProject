//
//  NewFeatureViewController.m
//  XYTPatients
//
//  Created by jerry on 2017/5/2.
//  Copyright © 2017年 jerry. All rights reserved.
//

#import "NewFeatureViewController.h"

#define pageNumber 3
#define ThemeColor [UIColor colorWithRed:34/255.0f green:151/255.0f blue:254/255.0f alpha:1.0f]

@interface NewFeatureViewController ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIPageControl * pageCtrl;
@property (nonatomic,weak) UIButton *startBtn;
@property (nonatomic,weak) UIButton *stopBtn;

@end

@implementation NewFeatureViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    // container view
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(scrollView.width *pageNumber, scrollView.height);//这里的高度也可以设为0
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;// 重要属性
    scrollView.bounces = NO;// 关闭弹球效果
    [self.view addSubview:scrollView];
    
    // page control
    
    //    UIPageControl * pageCtl = [[UIPageControl alloc] init];
    //    _pageCtrl = pageCtl;
    //    _pageCtrl.centerX = self.view.centerX;
    //    _pageCtrl.y = SCREEN_HEIGHT * 0.85;
    //    _pageCtrl.numberOfPages = pageNumber;
    //    _pageCtrl.currentPageIndicatorTintColor = ThemeColor;
    //    _pageCtrl.pageIndicatorTintColor = [UIColor lightGrayColor];
    //    [_pageCtrl sizeForNumberOfPages:pageNumber];
    
    //    [self.view addSubview:_pageCtrl];  // 暂不使用
    //    [self.view bringSubviewToFront:_pageCtrl];
    
    
    // images
    
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    
    for (int i = 0; i<pageNumber; i++) {
        UIImageView * imgView = [[UIImageView alloc] init];
        imgView.userInteractionEnabled = YES;
        imgView.width = scrollW;
        imgView.height = scrollH;
        
        imgView.x = i  * imgView.width;
        if (iPhoneX) {
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"new_feature_X_%d",i+1]];
        }else{
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"new_feature_%d",i+1]];
        }
        
        [scrollView addSubview:imgView];
    }
    
    // startBtn
    
    UIButton * startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _startBtn = startBtn;
    startBtn.hidden = YES;
    [startBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [startBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-77);
    }];
    
    // close btn
    
    UIButton * stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _stopBtn = stopBtn;
    [stopBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [stopBtn setBackgroundColor:[UIColor lightGrayColor]];
    stopBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [stopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    stopBtn.layer.cornerRadius = 10;
    stopBtn.layer.masksToBounds = YES;
    
    [stopBtn addTarget:self action:@selector(stopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:stopBtn];
    
    [stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-15);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
}

// 启动按钮点击事件
-(void)startBtnClick:(UIButton *)btn{
    
    if (_didStartApp) {
        _didStartApp();
    }
}

- (void)stopBtnClick:(UIButton *)btn{
    if (_didStartApp) {
        _didStartApp();
    }
}


#pragma mark - scrollView delegate

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    int currentNum = (scrollView.contentOffset.x + scrollView.frame.size.width /2) /scrollView.frame.size.width;
//    self.pageCtrl.currentPage = currentNum;
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int currentNum = (scrollView.contentOffset.x + scrollView.frame.size.width /2) /scrollView.frame.size.width;
    if (currentNum == pageNumber-1) {
        self.startBtn.hidden = NO;
        self.stopBtn.hidden = YES;
    }else{
        self.startBtn.hidden = YES;
        self.stopBtn.hidden = NO;
    }
}

@end
