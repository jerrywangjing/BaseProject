//
//  HMHealthRecordListView.h
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/7/15.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYSearch.h"

@class HMHealthRecordViewCell;
@class HMHealthRecordListView;
@class PYSearchViewController;

/// 数据刷新类型
typedef NS_ENUM(NSUInteger, DataType) {
    DataTypeNew,  // 加载新数据
    DataTypeMore, // 加载更多数据
};

typedef NS_ENUM(NSUInteger, TitleBarStyle) {
    TitleBarStyleDefault,   // 默认主题色样式
    TitleBarStyleLightGray, // 淡灰色样式
};

typedef NS_ENUM(NSUInteger, ListViewStyle) {
    
    ListViewStyleBasic,                 // 基本样式，不支持搜索、年份筛选、不可横向滚动
    ListViewStyleBasicScroll,           // 基本样式，不支持搜索和年份筛选，可横向滚动
    ListViewStyleNormal,                // 普通样式，不支持横向滚动样式  默认样式
    ListViewStyleNoSearchBar,           // 普通样式，不带搜索功能
    ListViewStyleHorizontal,            // 支持横向滚动的样式，带有搜索功能
    ListViewStyleHorizontalScroll,      // 支持横向滚动的样式，支持年份筛选功能
};

typedef NS_ENUM(NSUInteger, ListViewSearchMode) {
    ListViewSearchModeLocal,  // 本地搜索
    ListViewSearchModeRemote, // 后台搜索
};

typedef NS_ENUM(NSUInteger, SelectedPeriodType) {
    
    SelectedPeriodTypeOneYear,        // 近一年
    SelectedPeriodTypeThreeYear,      // 近三年
    SelectedPeriodTypeFiveYear,       // 近五年
    SelectedPeriodTypeAll             // 全部
};

@protocol HMHealthRecordListViewDataSource <NSObject>

/* dataSource for listView */
- (NSInteger)numberOfRowsInHealthRecordListView:(HMHealthRecordListView *)listView;
- (UITableViewCell *)healthRecordListView:(HMHealthRecordListView *)listView cellForRowAtIndexPath:(NSIndexPath *)indexPath searchResults:(NSArray *)results;

/* dataSource for search */
@optional

/* 只有当搜索模式设置为 ListViewSearchModeLocal 时才生效 */
- (NSString *)localSearchPropertyInHealthRecordListView:(HMHealthRecordListView *)listView;
- (NSArray *)localSearchDataSourceInHealthRecordListView:(HMHealthRecordListView *)listView;
/* 只有当搜索模式为 ListViewSearchModeRemote 时才生效，返回搜索热词*/
- (NSArray *)hotSearchesForRemoteSearchViewController;

@end

@protocol HMHealthRecordListViewDelegate <NSObject>

/* delegate for listView optional */

@optional

- (void)healthRecordListView:(HMHealthRecordListView *)listView didSelectRowAtIndexPath:(NSIndexPath *)indexPath searchResults:(NSArray *)results;
- (void)healthRecordListView:(HMHealthRecordListView *)listView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCellEditingStyle)healthRecordListView:(HMHealthRecordListView *)listView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)healthRecordListView:(HMHealthRecordListView *)listView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
// 自定义cell侧滑按钮
- (NSArray<UITableViewRowAction *> *)healthRecordListView:(HMHealthRecordListView *)listView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath;
/* delegate for load data from object that adapt this protocol */

- (void)healthRecordListView:(HMHealthRecordListView *)listView didLoadDataWithPage:(NSInteger)page ofYear:(NSInteger)year dataType:(DataType)dataType extraObject:(id)extra;

/* delegate for search function */

- (void)remoteSearchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(NSString *)searchText;
- (void)remoteSearchViewController:(PYSearchViewController *)searchViewController
              searchButtonDidClick:(NSString *)searchText
                              page:(NSInteger)page
                              year:(NSInteger)year
                          dataType:(DataType)dataType;

- (void)remoteSearchDidCancle;

@end

@interface HMHealthRecordListView : UIView

@property (nonatomic,strong,readonly) UITableView *tableView;

@property (nonatomic,strong) UIFont *titleFont;         // title 的字体大小 默认 15
@property (nonatomic,assign) TitleBarStyle titleStype;  // title bar 样式， 默认 default
@property (nonatomic,strong) NSArray *titleArr;         // 存放标题数据
@property (nonatomic,strong) NSArray *titleWidth;       // 存放title宽度
@property (nonatomic,assign) CGFloat titleMargin;       // title 的间距 默认：0

@property (nonatomic,assign,readonly) NSInteger currentSelectedYear;  // 当前选中的年份
@property (nonatomic,assign,readonly) NSInteger currentSelectedPage;  // 当前的page页码

@property (nonatomic,weak) id<HMHealthRecordListViewDelegate> delegate;
@property (nonatomic,weak) id<HMHealthRecordListViewDataSource> dataSource;

@property (nonatomic,assign) ListViewSearchMode searchMode; // 默认 ListViewSearchModeLocal
@property (nonatomic,assign) BOOL disablePullRefresh; // 默认 NO

/**
 convenience method for init listView

 @param frame the frame of listView
 @param style style for listView instance e.g: ListViewStyNormal or ListViewStyleHorizontal
 @return a instance
 */

- (instancetype)initWithFrame:(CGRect)frame style:(ListViewStyle)style;

- (void)noMoreData;
- (void)refreshData;
- (void)reloadData;
- (void)reloadRowsWithIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)resetTabelFooterView;

/// 滚动tableView到最左端
- (void)scrollToLeftEdge;
/// 给搜索框赋值搜索文字

- (void)startSearchingWithSearchText:(NSString *)text;
@end
