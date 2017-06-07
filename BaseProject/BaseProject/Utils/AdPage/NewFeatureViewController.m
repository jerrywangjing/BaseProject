//
//  NewFeatureViewController.m
//  XYTPatients
//
//  Created by jerry on 2017/5/2.
//  Copyright © 2017年 jerry. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "LoginViewController.h"

#define pageNumber 3
#define ThemeColor [UIColor colorWithRed:34/255.0f green:151/255.0f blue:254/255.0f alpha:1.0f]

@interface NewFeatureViewController ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIPageControl * pageCtrl;

@end

@implementation NewFeatureViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    // 1.创建一个scrollView
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(scrollView.width *pageNumber, scrollView.height);//这里的高度也可以设为0
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;// 重要属性
    scrollView.bounces = NO;// 关闭弹球效果
    [self.view addSubview:scrollView];
    
    UIPageControl * pageCtl = [[UIPageControl alloc] init];
    _pageCtrl = pageCtl;
    _pageCtrl.centerX = self.view.centerX;
    _pageCtrl.y = SCREEN_HEIGHT * 0.85;
    _pageCtrl.numberOfPages = pageNumber;
    _pageCtrl.currentPageIndicatorTintColor = ThemeColor;
    _pageCtrl.pageIndicatorTintColor = [UIColor lightGrayColor];
    [_pageCtrl sizeForNumberOfPages:pageNumber];
    
//    [self.view addSubview:_pageCtrl];  // 暂不使用
//    [self.view bringSubviewToFront:_pageCtrl];
    
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    
    for (int i = 0; i<pageNumber; i++) {
        UIImageView * imgView = [[UIImageView alloc] init];
        imgView.userInteractionEnabled = YES;
        imgView.width = scrollW;
        imgView.height = scrollH;
        
        imgView.x = i  * imgView.width;
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"new_feature_%d",i+1]];
        [scrollView addSubview:imgView];
        
        // 添加最后一个图片上的控制器切换按钮
        if (i == pageNumber - 1) {
            [self setupLastImageView:imgView];
        }
    }
}
-(void)setupLastImageView:(UIImageView *)imgView{
    
    // 启动按钮
    UIButton * startBtn = [[UIButton alloc] init];
    
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    [startBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    startBtn.size = startBtn.currentBackgroundImage.size;
    startBtn.centerX = imgView.width/2;
    startBtn.centerY = imgView.height * 0.93;
    [startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [imgView addSubview:startBtn];
    
}
// 启动按钮点击事件
-(void)startBtnClick:(UIButton *)btn{
    
    // 切换到WJTabBarViewController（这种方式可以销毁新特性控制器，被强指针指向的对象，如果引用者不再指向它时，它会立即销毁）
    LoginViewController * loginVc = [[LoginViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = loginVc;

}

#pragma mark - scrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int currentNum = (scrollView.contentOffset.x + scrollView.frame.size.width /2) /scrollView.frame.size.width;
    self.pageCtrl.currentPage = currentNum;
    
}


@end
