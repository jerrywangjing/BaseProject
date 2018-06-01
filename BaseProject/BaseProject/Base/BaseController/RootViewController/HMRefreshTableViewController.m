//
//  HMRefreshTableViewController.m
//  everyoneIsHealthy
//
//  Created by JerryWang on 2018/3/15.
//  Copyright © 2018年 华美医信. All rights reserved.
//

#import "HMRefreshTableViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "LDRefresh.h"

@interface HMRefreshTableViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,assign) UITableViewStyle tableViewStyle;
@property (nonatomic,assign) NSInteger currentSelectedPage;
@property (nonatomic,strong) UILabel *noDataLabel;

@end

@implementation HMRefreshTableViewController


- (instancetype)initWithStyle:(UITableViewStyle)style{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _tableViewStyle = style;
    }
    return self;
}
- (instancetype)init{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _tableViewStyle = UITableViewStylePlain;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabelView];
}

- (void)setupTabelView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavBarH, SCREEN_WIDTH, SCREEN_HEIGHT-NavBarH) style:_tableViewStyle];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    
    // 添加下拉刷新 、上拉加载
    
    WeakSelf(weakSelf);
    _tableView.refreshHeader = [_tableView addRefreshHeaderWithHandler:^{
        [weakSelf pullNewData];
    }];
    
    _tableView.refreshFooter = [_tableView addRefreshFooterWithHandler:^{
        [weakSelf loadMoreData];
    }];
    
    [self.view addSubview:_tableView];
}

// 下拉刷新数据

- (void)pullNewData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.currentSelectedPage = 0; // 所有下拉刷新时，页数都从0开始
        
        // 加载数据
        if (_didRefreshData) {
            _didRefreshData(0);
        }
        [self.tableView.refreshHeader endRefresh];
        [self resetTabelFooterView];
    });
}

// 加载更多数据
- (void)loadMoreData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 加载更多数据
        if (_didLoadMoreData) {
            _didLoadMoreData(++_currentSelectedPage);
        }
        [self.tableView.refreshFooter endRefresh];
    });
}


#pragma mark - emptyDataView delegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"暂无数据" attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    
    return title;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"icon_emptyData"];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -NavBarH;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

// 点击empty view 空白处时的回调
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    //    [self refreshData];
}

#pragma mark - public

- (void)noMoreData{
    
    self.tableView.refreshFooter.loadMoreEnabled = NO;
    self.tableView.tableFooterView = self.noDataLabel;
}

- (void)refreshData{
    
}

#pragma mark - setter & getter

- (UILabel *)noDataLabel{
    
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        
        _noDataLabel.textColor = [UIColor lightGrayColor];
        _noDataLabel.text = @"没有更多数据了";
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.font = [UIFont systemFontOfSize:12];
    }
    return _noDataLabel;
}

#pragma mark - private

// 重置tableView的footer view

- (void)resetTabelFooterView{
    self.tableView.refreshFooter.loadMoreEnabled = YES;
    self.tableView.tableFooterView = [UIView new];
}


@end
