//
//  HMHealthRecordListView.m
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/7/15.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import "HMHealthRecordListView.h"
#import "ZYPinYinSearch.h"
#import "MainNavController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "LDRefresh.h"
#import "HMSearchBar.h"
#import "MBProgressHUD+WJ.h"

#define TitleLabelH 30 // 标题视图高度

static const CGFloat HRTopTabbarH = 30;
static const CGFloat HRSearchBarH = 44;

@interface HMHealthRecordListView ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,PYSearchViewControllerDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,HMSearchBarDelegate>

@property (nonatomic,strong) UIView *topTabbar;
@property (nonatomic,weak) UIView *indicator;                   // 底部指示器view
@property (nonatomic,strong) UIScrollView *bottomScrollView;    // 底部横向滑动view
@property (nonatomic,weak) UIButton *lastSelectedBtn;           // 记录上次选中的item按钮
@property (nonatomic,strong) UILabel *noDataLabel;

@property (nonatomic,assign) ListViewStyle style;

@property (nonatomic,strong) UISearchBar *searchBar;              // 本地搜索为UISeachbar
@property (nonatomic,weak) HMSearchBar *remoteSearchBar;         // 远程搜索searchBar
@property (nonatomic,assign) BOOL isSearching;

@property (nonatomic,strong) NSMutableArray *searchData;
@property (nonatomic,copy) NSString *searchingText;             // 搜索关键字

@property (nonatomic,assign) NSInteger currentSelectedYear;  // 当前选中的年份
@property (nonatomic,assign) NSInteger currentSelectedPage;  // 当前的page页码

@property (nonatomic,strong) NSMutableArray *topBarItems;    // 顶部筛选按钮缓存
@end

@implementation HMHealthRecordListView

- (NSMutableArray *)topBarItems{
    if (!_topBarItems) {
        _topBarItems = [NSMutableArray array];
    }
    return _topBarItems;
}

- (NSMutableArray *)searchData{
    if (!_searchData) {
        _searchData = [NSMutableArray array];
    }
    return _searchData;
}

- (UILabel *)noDataLabel{
    
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        
        _noDataLabel.textColor = [UIColor lightGrayColor];
        _noDataLabel.text = @"没有更多数据了";
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.font = [UIFont systemFontOfSize:12];
    }
    return _noDataLabel;
}

- (void)setTitleWidth:(NSArray *)titleWidth{
    _titleWidth = titleWidth;
    [self layoutSubviews];
}

- (void)dealloc{
    [_tableView removeRefreshHeader];
}

- (instancetype)initWithFrame:(CGRect)frame style:(ListViewStyle)style{
 
    if (self = [super initWithFrame:frame]) {
        
        _currentSelectedPage = 0;
        _currentSelectedYear = 1;
        _titleMargin = 0;
        _titleFont = [UIFont boldSystemFontOfSize:14];
        _style = style;
        
        // 初始化子视图
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    
    switch (_style) {
        case ListViewStyleBasic:
        case ListViewStyleBasicScroll:
            [self setupTableView];
            break;
        case ListViewStyleNormal:
        case ListViewStyleHorizontalScroll:
            [self setupSearchbar];
            [self setupTopTabbar];
            [self setupTableView];
            break;
        case ListViewStyleHorizontal:
            [self setupSearchbar];
            [self setupTableView];
            break;
        case ListViewStyleNoSearchBar:
            [self setupTopTabbar];
            [self setupTableView];
            break;
        default:
            break;
    }
}

- (void)setupSearchbar{
    
    // search bar
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.width, SearchBarH)];
    
    _searchBar.tintColor = [UIColor grayColor]; // 文字渲染色
    _searchBar.placeholder = @"搜索";
    _searchBar.backgroundImage = [UIImage createImageWithColor:[UIColor groupTableViewBackgroundColor]];
    _searchBar.delegate = self;
    [_searchBar sizeToFit];
    
    [self addSubview:_searchBar];
    
    HMSearchBar *searchBar = [[HMSearchBar alloc] initWithFrame:_searchBar.frame];
    _remoteSearchBar = searchBar;
    _remoteSearchBar.delegate = self;
    _remoteSearchBar.hidden = YES;
    
    [self addSubview:_remoteSearchBar];
}

- (void)setupTopTabbar{
    
    // top tool bar
    
    _topTabbar = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchBar.frame), self.width, HRTopTabbarH)];
    _topTabbar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // tabbarItems
    NSArray *itemsTitle = @[@"近一年",@"近三年",@"近五年",@"全部"];
    CGFloat itemW = SCREEN_WIDTH/4;
    
    // items 按钮
    for (NSInteger i = 0; i<itemsTitle.count; i++) {
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.tag = i;
        item.frame = CGRectMake(i*itemW, 0, itemW, CGRectGetHeight(_topTabbar.frame));
        [item setTitle:itemsTitle[i] forState:UIControlStateNormal];
        item.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [item setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [item setTitleColor: [UIColor redColor] forState:UIControlStateSelected];
        item.adjustsImageWhenHighlighted = NO;
        [item addTarget:self action:@selector(barItemDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 设置初始值
        if (i == 0) {
            item.selected = YES;
            self.lastSelectedBtn = item;
        }
        [self.topBarItems addObject:item];
        [_topTabbar addSubview:item];
    }
    
    // separate line 分割线
    
    CGFloat lineH = HRTopTabbarH * 0.5;
    
    for (NSInteger i = 0; i<itemsTitle.count-1; i++) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        line.frame = CGRectMake((i+1)*itemW, (HRTopTabbarH-lineH)/2, 0.5, lineH);
        [_topTabbar addSubview:line];
    }
    
    // bottom indicator view
    
    UIView *indicator = [[UIView alloc] initWithFrame:CGRectMake(0, HRTopTabbarH-2, itemW*0.7, 2)];
    _indicator = indicator;
    indicator.centerX = itemW/2;
    indicator.layer.cornerRadius = 1;
    indicator.layer.masksToBounds = YES;
    indicator.backgroundColor = [UIColor redColor];
    
    [_topTabbar addSubview:indicator];
    [self addSubview:_topTabbar];
}

- (void)setupTableView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    // bottomScorllView
    
    if (_style == ListViewStyleHorizontal ||
        _style == ListViewStyleBasicScroll ||
        _style == ListViewStyleHorizontalScroll) {
        
        CGFloat scrollViewY = CGRectGetMaxY(_searchBar.frame);
        if (_topTabbar) {
            scrollViewY = CGRectGetMaxY(_topTabbar.frame);
        }
        
        CGFloat scrollViewH = self.height-_searchBar.height;
        if (_topTabbar) {
            scrollViewH = self.height -CGRectGetMaxY(_topTabbar.frame);
        }
        
        _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollViewY, self.width, scrollViewH)];
        
        // tableView
        CGFloat tableViewW = self.width;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, tableViewW, _bottomScrollView.height) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.contentSize = CGSizeMake(tableViewW, 0);
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        _bottomScrollView.contentSize = CGSizeMake(tableViewW, 0);
        [_bottomScrollView addSubview:_tableView];
        [self addSubview:_bottomScrollView];
        
    }else{
        // tableView
        CGFloat tableViewW = self.width;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topTabbar.frame), self.width, self.height-CGRectGetMaxY(_topTabbar.frame)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.contentSize = CGSizeMake(tableViewW, 0);
        _tableView.emptyDataSetSource = self;
        
        [self addSubview:_tableView];
    }
    
    // 添加下拉刷新 、上拉加载
    
    WeakSelf(weakSelf);
    _tableView.refreshHeader = [_tableView addRefreshHeaderWithHandler:^{
        [weakSelf pullNewData];
    }];

    _tableView.refreshFooter = [_tableView addRefreshFooterWithHandler:^{
        [weakSelf loadMoreData];
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_style == ListViewStyleHorizontal ||
        _style == ListViewStyleBasicScroll ||
        _style == ListViewStyleHorizontalScroll) {
        
        CGFloat tableViewW = [self calculateTableViewWidth];
        
        _tableView.frame = CGRectMake(0, 0, tableViewW, CGRectGetHeight(_bottomScrollView.frame));
        _bottomScrollView.contentSize = CGSizeMake(tableViewW, 0);
        _tableView.contentSize = CGSizeMake(tableViewW, 0);
        
    }else{
        
        _tableView.frame = CGRectMake(0, CGRectGetMaxY(_topTabbar.frame), self.width, self.height-CGRectGetMaxY(_topTabbar.frame));
    }
}

#pragma mark - setter

- (void)setDisablePullRefresh:(BOOL)disablePullRefresh{
    _disablePullRefresh = disablePullRefresh;
    if (disablePullRefresh) {
        _tableView.refreshHeader = nil;
        _tableView.refreshFooter = nil;
    }else{
        WeakSelf(weakSelf);
        _tableView.refreshHeader = [_tableView addRefreshHeaderWithHandler:^{
            [weakSelf pullNewData];
        }];
        
        _tableView.refreshFooter = [_tableView addRefreshFooterWithHandler:^{
            [weakSelf loadMoreData];
        }];
    }
}

- (void)setSearchMode:(ListViewSearchMode)searchMode{
    _searchMode = searchMode;
    if (_searchMode == ListViewSearchModeRemote) {
        self.remoteSearchBar.hidden = NO;
        self.searchBar.hidden = YES;
    }
}

//- (void)setCurrentSelectedYear:(NSInteger)currentSelectedYear{
//    if (_isSearching) {
//
//        UIButton * defaultBtn = self.topBarItems.firstObject;
//        defaultBtn.selected = YES;
//        self.lastSelectedBtn = defaultBtn;
//
//        // 移动indicatorView
//        [UIView animateWithDuration:0.3 animations:^{
//            self.indicator.transform = CGAffineTransformMakeTranslation(0, 0);
//        }];
//    }
//}

#pragma mark - actions

// 顶部tabbar item 点击

- (void)barItemDidClick:(UIButton *)btn{
    
    if (![self.delegate respondsToSelector:@selector(healthRecordListView:didLoadDataWithPage:ofYear:dataType:extraObject:)]) {
        NSLog(@"error:未能响应数据加载代理");
        return;
    }
    
    self.lastSelectedBtn.selected = NO;
    btn.selected = YES;
    
    switch (btn.tag) {
        case SelectedPeriodTypeOneYear:
            _currentSelectedYear = 1;
            _currentSelectedPage = 0;
            break;
        case SelectedPeriodTypeThreeYear:
            _currentSelectedYear = 3;
            _currentSelectedPage = 0;
            break;
        case SelectedPeriodTypeFiveYear:
            _currentSelectedYear = 5;
            _currentSelectedPage = 0;
            break;
        case SelectedPeriodTypeAll:
            _currentSelectedYear = NSNotFound; // NSNotFound 表示获取全部数据,从 1970-01-01 00:00:00 算起
            _currentSelectedPage = 0;
            
            break;
        default:
            break;
    }
    
    // 移动indicatorView
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.indicator.transform = CGAffineTransformMakeTranslation(btn.tag*btn.width, 0);
    }];

    // 回调代理请求数据
    if (_isSearching && _searchMode == ListViewSearchModeRemote) {
        
        [self.delegate remoteSearchViewController:nil searchButtonDidClick:self.searchingText page:self.currentSelectedPage year:self.currentSelectedYear dataType:DataTypeNew];
        
    }else{
        
        [self.delegate healthRecordListView:self didLoadDataWithPage:self.currentSelectedPage ofYear:self.currentSelectedYear dataType:DataTypeNew extraObject:nil];
    }
    
    // 重置tablefooter 视图
    if (self.noDataLabel) {
        [self resetTabelFooterView];
    }
    
    self.lastSelectedBtn = btn;
}


// 下拉刷新数据

- (void)pullNewData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // load data and refresh tableView
        
        if (self.isSearching && _searchMode == ListViewSearchModeRemote) {
            
            _currentSelectedPage = 0; // 所有下拉刷新时，页数都从0开始
            
            if ([self.delegate respondsToSelector:@selector(remoteSearchViewController:searchButtonDidClick:page:year:dataType:)]) {
                
                [self.delegate remoteSearchViewController:nil searchButtonDidClick:_searchingText page:self.currentSelectedPage year:self.currentSelectedYear dataType:DataTypeNew];
            }
            
        }else{
         
            if ([self.delegate respondsToSelector:@selector(healthRecordListView:didLoadDataWithPage:ofYear:dataType:extraObject:)]) {
                _currentSelectedPage = 0; // 所有下拉刷新时，页数都从0开始
                [self.delegate healthRecordListView:self didLoadDataWithPage:self.currentSelectedPage ofYear:self.currentSelectedYear dataType:DataTypeNew extraObject:nil];
            }
        }
        
        [self.tableView.refreshHeader endRefresh];
        [self resetTabelFooterView];
    });
}

// 加载更多数据
- (void)loadMoreData{
    
    if (self.isSearching && _searchMode == ListViewSearchModeRemote) {
        
        [self.delegate remoteSearchViewController:nil searchButtonDidClick:_searchingText page:++_currentSelectedPage year:self.currentSelectedYear dataType:DataTypeMore];
    }else{
    
        if ([self.delegate respondsToSelector:@selector(healthRecordListView:didLoadDataWithPage:ofYear:dataType:extraObject:)]) {
            [self.delegate healthRecordListView:self didLoadDataWithPage:++_currentSelectedPage ofYear:self.currentSelectedYear dataType:DataTypeMore extraObject:nil];
        }
    }
    
    [self.tableView.refreshFooter endRefresh];
}

#pragma mark - tableView delegate

// 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.dataSource respondsToSelector:@selector(numberOfRowsInHealthRecordListView:)]) {
        if (_isSearching && _searchMode == ListViewSearchModeLocal) {
            return self.searchData.count;
        }else{
        
            return [self.dataSource numberOfRowsInHealthRecordListView:self];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.dataSource respondsToSelector:@selector(healthRecordListView:cellForRowAtIndexPath:searchResults:)]) {
        if (_isSearching && self.searchData.count > 0) {
            return [self.dataSource healthRecordListView:self cellForRowAtIndexPath:indexPath searchResults:self.searchData];
        }
        return [self.dataSource healthRecordListView:self cellForRowAtIndexPath:indexPath searchResults:nil];
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return TitleLabelH;
}

// title view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.titleArr.count == 0) {
        return nil;
    }
    
    UIColor *titleBgColor = ThemeColor;
    UIColor *titleColor = [UIColor whiteColor];
    
    if (_titleStype == TitleBarStyleLightGray) {
        titleBgColor = [UIColor groupTableViewBackgroundColor];
        titleColor = [UIColor blackColor];
    }
    
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = titleBgColor;
    
    CGFloat titleX = 0;
    
    for (NSInteger i = 0; i<self.titleArr.count; i++) {
        
        CGFloat titleWidth = [self.titleWidth[i] floatValue];
        if (i == 0) {
            titleX = 0;
        }else{
            
            titleX += [self.titleWidth[i-1] floatValue] + _titleMargin;
        }
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(titleX, 0, titleWidth, TitleLabelH)];
        title.text = self.titleArr[i];
        title.font = _titleFont;
        title.textColor = titleColor;
        title.textAlignment = NSTextAlignmentCenter;
        
        [titleView addSubview:title];
    }
    
    return titleView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(healthRecordListView:didSelectRowAtIndexPath:searchResults:)]) {
        if (_isSearching && _searchMode == ListViewSearchModeLocal) {
            [self.delegate healthRecordListView:self didSelectRowAtIndexPath:indexPath searchResults:self.searchData];
        }else{
            [self.delegate healthRecordListView:self didSelectRowAtIndexPath:indexPath searchResults:nil];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(healthRecordListView:didDeselectRowAtIndexPath:)]) {
        [self.delegate healthRecordListView:self didDeselectRowAtIndexPath:indexPath];
    }
}
// tableView 编辑相关

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(healthRecordListView:editingStyleForRowAtIndexPath:)]) {
        return [self.delegate healthRecordListView:self editingStyleForRowAtIndexPath:indexPath];
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(healthRecordListView:commitEditingStyle:forRowAtIndexPath:)]) {
        [self.delegate healthRecordListView:self commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(healthRecordListView:editActionsForRowAtIndexPath:)]) {
        return [self.delegate healthRecordListView:self editActionsForRowAtIndexPath:indexPath];
    }
    return nil;
}

// cell分割线边缘对齐

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([cell respondsToSelector:@selector(setSeparatorInset:)]){
        if (tableView.editing) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }else{
            
            [cell setSeparatorInset:UIEdgeInsetsMake(0, -206.5, 0, -206.5)];// 206.5是矫正系统的cell间隔线数值，可通过视图调试得知
        }
    }
    
    if([cell respondsToSelector:@selector(setLayoutMargins:)]){
        if (tableView.editing) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }else{
            
            [cell setLayoutMargins:UIEdgeInsetsMake(0, -206.5, 0, -206.5)];
        }
    }
}

#pragma mark - emptyDataView delegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"暂无数据，点击此处刷新" attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    
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
    [self refreshData];
}

#pragma mark - search bar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    // 开启本地搜索
    [searchBar setShowsCancelButton:YES animated:YES];
    self.isSearching = YES;
    
    return YES;
}

// 执行搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (_searchMode == ListViewSearchModeRemote) return;
    
    self.isSearching = YES;
    
    // 在这里处理搜索结果
    
    NSString *searchProperty = nil;
    NSArray *searchDataSource = nil;
    
    if ([self.dataSource respondsToSelector:@selector(localSearchPropertyInHealthRecordListView:)]) {
         searchProperty = [self.dataSource localSearchPropertyInHealthRecordListView:self];
    }
    if ([self.dataSource respondsToSelector:@selector(localSearchDataSourceInHealthRecordListView:)]) {
        searchDataSource = [self.dataSource localSearchDataSourceInHealthRecordListView:self];
    }
    
    if (searchDataSource && searchProperty) {
        NSArray * resultArr = [ZYPinYinSearch searchWithOriginalArray: searchDataSource andSearchText:searchBar.text andSearchByPropertyName:searchProperty];
        
        if (searchBar.text.length == 0) {
            
            [self.searchData removeAllObjects];
            [self.searchData addObjectsFromArray:searchDataSource];
            
        }else{
            [self.searchData removeAllObjects];
            [self.searchData addObjectsFromArray:resultArr];
        }
        
        [self.tableView reloadData];
    }else{
        [MBProgressHUD showTipMessageInWindow:@"搜索失败"];
    }
}

// 退出本地搜索模式的回调
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    self.isSearching = NO;
    [searchBar setShowsCancelButton:NO animated:NO];
    
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    self.isSearching = NO;
    [searchBar setShowsCancelButton:NO animated:NO];
    [searchBar resignFirstResponder];
    
    [self refreshData];
}

#pragma mark - remote seachBar delegate

- (void)hmSearchBarShouldBeginSearching:(HMSearchBar *)searchBar{
    
    // 开启远程搜索
    
    // NSArray *hotSearchTags = @[@"心脏病",@"糖尿病",@"心血管",@"肩周炎",@"腰腿痛"]; // 默认值
    NSArray *hotSearchTags = nil;
    if ([self.dataSource respondsToSelector:@selector(hotSearchesForRemoteSearchViewController)]) {
        hotSearchTags = [self.dataSource hotSearchesForRemoteSearchViewController];
    }
    
    PYSearchViewController *searchVc = [PYSearchViewController searchViewControllerWithHotSearches: hotSearchTags searchBarPlaceholder:@"请输入搜索关键字"];
    searchVc.delegate = self;
    searchVc.searchHistoryStyle = PYSearchHistoryStyleBorderTag;
    searchVc.hotSearchStyle = PYHotSearchStyleARCBorderTag;
    
    MainNavController *nav = [[MainNavController alloc] initWithRootViewController:searchVc];
    [(UIViewController *)self.delegate presentViewController:nav  animated:NO completion:nil];
    
}

- (void)hmSearchBarDidClickCancle:(HMSearchBar *)searchBar{
    self.isSearching = NO;
    self.searchingText = nil;
    
    if ([self.delegate respondsToSelector:@selector(remoteSearchDidCancle)]) {
        [self.delegate remoteSearchDidCancle];
    }
    
    // 返回到未搜索状态
    self.currentSelectedPage = 0;
    [self.delegate healthRecordListView:self didLoadDataWithPage:self.currentSelectedPage ofYear:self.currentSelectedYear dataType:DataTypeNew extraObject:nil];
    
}

#pragma mark PySearch delegate

- (BOOL)searchViewControllerShouldBeginSearching:(UISearchBar *)searchBar{
    if (_searchBar.text.length > 0) {
        searchBar.text = _searchBar.text;
    }
    return YES;
}

// 搜索框文本变化时，显示的搜索建议通过searchViewController的searchSuggestions赋值即可

- (void)searchViewController:(PYSearchViewController *)searchViewController  searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText{
    
    if ([self.delegate respondsToSelector:@selector(remoteSearchViewController:searchTextDidChange:)]) {
        [self.delegate remoteSearchViewController:searchViewController searchTextDidChange:searchText];
    }
}

// 点击搜索按钮时调用
- (void)searchViewController:(PYSearchViewController *)searchViewController didSearchWithsearchBar:(UISearchBar *)searchBar searchText:(NSString *)searchText{

    [(UIViewController *)self.delegate dismissViewControllerAnimated:searchViewController.navigationController completion:^{
        if ([self.delegate respondsToSelector:@selector(remoteSearchViewController:searchButtonDidClick:page:year:dataType:)]) {
            
            self.currentSelectedPage = 0;
            self.searchingText = searchText;
            self.isSearching = YES;
            self.remoteSearchBar.searchText = searchText;
            [self.remoteSearchBar startSearching];
            
            [self.delegate remoteSearchViewController:searchViewController searchButtonDidClick:searchText page:self.currentSelectedPage year:self.currentSelectedYear dataType:DataTypeNew];
        }
    }];
}

// 点击取消时调用
- (void)didClickCancel:(PYSearchViewController *)searchViewController{
    
    [(UIViewController *)self.delegate dismissViewControllerAnimated:searchViewController.navigationController completion:nil];
}

#pragma mark - public

- (void)noMoreData{

    self.tableView.refreshFooter.loadMoreEnabled = NO;
    self.tableView.tableFooterView = self.noDataLabel;
}

- (void)reloadData{
    [self.tableView reloadData];
}

- (void)reloadRowsWithIndexPaths:(nonnull NSArray<NSIndexPath *> *)indexPaths{
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)scrollToLeftEdge{
    
    CGFloat currentOffsetX = _bottomScrollView.contentOffset.x;
    
    if (currentOffsetX > 0) {
        [_bottomScrollView setContentOffset:CGPointMake(0, _bottomScrollView.contentOffset.y) animated:YES];
    }
}

- (void)refreshData{
    
    if (_isSearching && _searchMode == ListViewSearchModeRemote) {
        if ([self.delegate respondsToSelector:@selector(remoteSearchViewController:searchButtonDidClick:page:year:dataType:)]) {
            
            _currentSelectedPage = 0; // 所有下拉刷新时，页数都从0开始
            [self.delegate remoteSearchViewController:nil searchButtonDidClick:_searchingText page:_currentSelectedPage year:_currentSelectedYear dataType:DataTypeNew];
        }
    }else{
        
        if ([self.delegate respondsToSelector:@selector(healthRecordListView:didLoadDataWithPage:ofYear:dataType:extraObject:)]) {
            _currentSelectedPage = 0; // 所有下拉刷新时，页数都从0开始
            [self.delegate healthRecordListView:self didLoadDataWithPage:self.currentSelectedPage ofYear:self.currentSelectedYear dataType:DataTypeNew extraObject:nil];
        }
    }
}

// 重置tableView的footer view

- (void)resetTabelFooterView{
    self.tableView.refreshFooter.loadMoreEnabled = YES;
    self.tableView.tableFooterView = [UIView new];
}

// 给搜索框赋值文字

- (void)startSearchingWithSearchText:(NSString *)text{
    
    if (_searchMode == ListViewSearchModeRemote) {
        self.remoteSearchBar.searchText = text;
        [self.remoteSearchBar startSearching];
        
    }else{
        self.isSearching = YES;
        self.searchBar.text = text;
    }
}


#pragma mark - private

- (CGFloat)calculateTableViewWidth{
    
    CGFloat width = 0;
    for (NSNumber *value in self.titleWidth){
        
        CGFloat floatValue = (CGFloat)[value floatValue];
        width += floatValue;
    }
    
    width += (self.titleWidth.count-1) * _titleMargin;
    
    return width;
}

@end
