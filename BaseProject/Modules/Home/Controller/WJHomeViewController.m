//
//  HomeViewController.m
//  BaseProject
//
//  Created by JerryWang on 2018/3/28.
//  Copyright © 2018年 JerryWang. All rights reserved.
//

#import "WJHomeViewController.h"
#import "WJAlertSheetView.h"
#import "BaseWebViewController.h"
#import "WJSysDatePickerView.h"
#import "WJPopView.h"
#import "WJProfileViewController.h"
#import "WJLoginViewController.h"
#import "JRSwizzle.h"

typedef NS_ENUM(NSUInteger, ShowViewType) {
    ShowViewTypeAlertSheetView,
    ShowViewTypeAlertSheetMultiView,
    ShowViewTypePopView,
    ShowViewTypeWebview,
    ShowViewTypeDatePickerView,
    ShowViewTypeTest
};

typedef void(^NeedEndLoadMore)(BOOL noMoreData);
typedef void(^NeedEndRefresh)();

@interface WJHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *dataSource;

@property (nonatomic,copy) NeedEndLoadMore endLoadMore;
@property (nonatomic,copy) NeedEndRefresh endRefresh;

@end

@implementation WJHomeViewController

+ (void)load{
    /* Method Swizzling 测试代码 */
    
    // 由于只希望method swizzling 只执行一次，所以需要使用dispatch_once（）。
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSError *error = nil;
        [WJHomeViewController jr_swizzleMethod:@selector(viewDidAppear:) withMethod:@selector(wj_viewWillAppear:) error:&error];
    });
    
}

//- (void)viewWillAppear:(BOOL)animated{
//    NSLog(@"old methed invoke");
//}

- (void)wj_viewWillAppear:(BOOL)animated{
    NSLog(@"wj method invoke");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavbar];
    [self setupSubviews];
    [self loadData];
}

- (void)configNavbar{
    UIBarButtonItem *login_btn_navbar = [self creatNavbarItemWithTitle:@"登录" target:self action:@selector(loginBtnClick)];
    self.navigationItem.rightBarButtonItem = login_btn_navbar;
}

- (void)setupSubviews{
    
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 上拉，下拉刷新
    WeakSelf(weakSelf);
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf pullNewData];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    self.tableView.mj_header = refreshHeader;
    self.tableView.mj_footer = refreshFooter;
    
    [self.view addSubview:self.tableView];
}

- (void)loadData{
    _dataSource = @[@"AlertSheetView",@"AlertMultiSheetView",@"PopView",@"WebView",@"DataPickerView",@"TestBtn"];
    
    // ... if is refreshData call self.endRefresh(), if is loadMoreData call self.endLoadMore(BOOL), the param is defined for Whether the loading is completed.
}

#pragma mark - actions

- (void)loginBtnClick{
    WJLoginViewController *loginVc = [WJLoginViewController new];
    loginVc.title = @"登录";
    RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:loginVc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 刷新、加载更多
- (void)pullNewData{
    WeakSelf(weakSelf);
    self.endRefresh = ^{
        [weakSelf.tableView.mj_footer resetNoMoreData];
        [weakSelf.tableView.mj_header endRefreshing];;
    };
    
    // ... load new data
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.endRefresh();
    });
}
- (void)loadMoreData{
    WeakSelf(weakSelf);
    self.endLoadMore = ^(BOOL noMoreData) {
        if (noMoreData) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    };
    
    // ... load more data
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.endLoadMore(YES);
    });
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case ShowViewTypeAlertSheetView:
            [WJAlertSheetView showAlertSheetViewWithTips:nil items:@[@"item1",@"item2",@"item3"] cancel:nil completion:^(NSString *selectedValue, NSInteger index, UIButton *item) {
                NSLog(@"点击了:%@",selectedValue);
            }];
            break;
        case ShowViewTypeAlertSheetMultiView:
            [WJAlertSheetView showAlertMultiSheetViewWithTips:nil items:@[@"多选1",@"多选2",@"多选3",@"多选4"] completion:^(NSString *selectedValue, NSInteger index, UIButton *item) {
                NSLog(@"选择了：%@",selectedValue);
            }];
            break;
        case ShowViewTypePopView:{
            WJPopView *popView = [[WJPopView alloc] initWithContainerViewSize:CGSizeMake(self.view.width*0.8, 200)];
            popView.titleLabel.text = @"提示popView";
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
            label.text = @"自定义内容请在这里添加...";
            label.center = popView.center;
            
            [popView.contentView addSubview:label];
            
            [popView showPopView];
            
        }
            break;
        case ShowViewTypeWebview:{
         
            BaseWebViewController *webview  = [[BaseWebViewController alloc] initWithUrl:[NSURL URLWithString:@"https://www.baidu.com"]];
            
            [self.navigationController pushViewController:webview animated:YES];
        }
            break;
        case ShowViewTypeDatePickerView:
            [WJSysDatePickerView showSystemDatePickerViewWithMode:UIDatePickerModeDate confirmCallBack:nil cancelCallback:nil];
            break;
        case ShowViewTypeTest:
            
            [MBProgressHUD showSuccessMessage:@"提示哈哈哈"];
//            [self.navigationController pushViewController:[WJProfileViewController new] animated:YES];
            
        default:
            break;
    }
}


@end
