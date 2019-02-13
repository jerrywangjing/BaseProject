//
//  RootViewController.m
//  BaseProject
//
//  Created by JerryWang on 2017/5/30.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@property (nonatomic,strong) UIImageView* noDataView;

@end

@implementation RootViewController

#pragma mark - 系统状态栏

- (UIStatusBarStyle)preferredStatusBarStyle{
    return _statusBarStyle;
}

// 动态更新状态栏颜色
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle{
    _statusBarStyle = statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - init

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.tableView removeRefreshHeader];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WJColorBackground;
    
    // 默认配置
    
    self.isShowNavBackBtn = YES;
    self.statusBarStyle = UIStatusBarStyleDefault;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:_isHiddenNavBar animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)showLoadingActivity{
    [MBProgressHUD showActivityMessageInWindow:nil];
}
- (void)stopLoadingActivity{
    [MBProgressHUD hideHUD];
}

-(void)showNoDataImage
{
    _noDataView=[[UIImageView alloc] init];
    [_noDataView setImage:[UIImage imageNamed:@"generl_nodata"]];
    [self.view.subviews enumerateObjectsUsingBlock:^(UITableView* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            [_noDataView setFrame:CGRectMake(0, 0,obj.frame.size.width, obj.frame.size.height)];
            [obj addSubview:_noDataView];
        }
    }];
}

-(void)removeNoDataImage{
    if (_noDataView) {
        [_noDataView removeFromSuperview];
        _noDataView = nil;
    }
}

//取消请求
- (void)cancelAllRequest{
    [PPNetworkHelper cancelAllRequest];
}

/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */

- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        CGFloat navbarH = self.navigationController.navigationBarHidden ? 0:NavBarH;
        CGFloat height = self.tabBarController.tabBar.isHidden ? (SCREEN_HEIGHT-navbarH) : (SCREEN_HEIGHT-navbarH-TabBarH);
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navbarH, SCREEN_WIDTH,height) style:self.tableViewStyle];
        _tableView.backgroundColor = WJColorBackground;
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}

- (void)addRefreshForTableView{
    
    // 下拉刷新
    
    WeakSelf(weakSelf);
    _tableView.refreshHeader = [_tableView addRefreshHeader:[LDRefreshHeaderView new] handler:^{
        [weakSelf headerRereshing];
    }];
    
    // 上拉刷新(暂时不用)
    
//    LDRefreshFooterView *footerView = [LDRefreshFooterView new];
//    footerView.autoLoadMore = NO;
//    _tableView.refreshFooter = [_tableView addRefreshFooter:footerView handler:^{
//        [weakSelf footerRereshing];
//    }];
    
}

/**
 *  懒加载collectionView
 *
 *  @return collectionView
 */
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        
        CGFloat navbarH = self.navigationController.navigationBarHidden ? 0:NavBarH;
        CGFloat height = self.tabBarController.tabBar.isHidden ? (SCREEN_HEIGHT-navbarH) : (SCREEN_HEIGHT-navbarH-TabBarH);
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, navbarH, SCREEN_WIDTH , height) collectionViewLayout:flow];
        _collectionView.backgroundColor = WJColorBackground;
        
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
        } else {
            // Fallback on earlier versions
        }
    }
    return _collectionView;
}

- (void)addRefreshForCollectionView{
    
    // 下拉刷新
    
    WeakSelf(weakSelf);
    _collectionView.refreshHeader = [_collectionView addRefreshHeader:[LDRefreshHeaderView new] handler:^{
        [weakSelf headerRereshing];
    }];
    
//    LDRefreshFooterView *footerView = [LDRefreshFooterView new];
//    footerView.autoLoadMore = NO;
//    _collectionView.refreshFooter = [_collectionView addRefreshFooter:footerView handler:^{
//        [weakSelf footerRereshing];
//    }];
    
}

// 上拉刷新，下拉加载回调（子类重写实现）
- (void)headerRereshing{
}

- (void)footerRereshing{
}


- (void)endRefreshForTableView{
    [self.tableView.refreshHeader endRefresh];
    [self.tableView.refreshFooter endRefresh];
}

- (void)endRefreshForCollectionView{
    [self.collectionView.refreshHeader endRefresh];
    [self.collectionView.refreshFooter endRefresh];
}

/**
 *  是否显示返回按钮
 */

- (void)setIsShowNavBackBtn:(BOOL)isShowNavBackBtn{
    _isShowNavBackBtn = isShowNavBackBtn;

    NSInteger VCCount = self.navigationController.viewControllers.count;
    
    //下面判断的意义是 当VC所在的导航控制器中的VC个数大于1 或者 是present出来的VC时，才展示返回按钮，其他情况不展示
    
    if (isShowNavBackBtn && ( VCCount > 1 || self.navigationController.presentingViewController != nil)) {
        UIBarButtonItem *back = [self createNavbarBackItem];
//        UIBarButtonItem *leftSpace = [self createNavbarBackLeftSpaceFixedItem];
        
        self.navigationItem.leftBarButtonItem = back;
        
    } else {
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem * NULLBar=[[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
        self.navigationItem.leftBarButtonItem = NULLBar;
    }
}

- (UIBarButtonItem *)createNavbarBackItem{
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, NavBarH);
    [btn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return item;
}

- (UIBarButtonItem *)createNavbarBackLeftSpaceFixedItem{
    // 创建一个固定空间item，来修改左边导航栏偏移的20个点
    UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftSpace.width = -20;
    return leftSpace;
}

// 返回按钮点击回调

- (void)backBtnDidClick{
    
    if (self.presentingViewController && !self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else if(self.presentationController && self.navigationController){
        
        if (self.navigationController.viewControllers.count == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ————— 添加导航栏按钮 —————

- (UIBarButtonItem *)creatNavbarItemWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:WJFontColorTitle forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return item;
}


- (UIBarButtonItem *)creatNavbarItemWithImage:(NSString *)image target:(id)target action:(SEL)action{
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)]; // 调整item的位置
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return item;
}


#pragma mark ————— 导航栏 添加文字按钮 —————

- (void)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    
    NSMutableArray * items = [[NSMutableArray alloc] init];
    
    NSMutableArray * buttonArray = [NSMutableArray array];
    NSInteger i = 0;
    for (NSString * title in titles) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:WJFontColorTitle forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        btn.tag = [tags[i++] integerValue];
        [btn sizeToFit];
        
        //设置偏移
        if (isLeft) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        }else{
//            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        }
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        [buttonArray addObject:btn];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}

#pragma mark -  屏幕旋转

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //当前支持的旋转类型
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    // 是否支持旋转
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    // 默认进去类型
    return UIInterfaceOrientationPortrait;
}

@end
