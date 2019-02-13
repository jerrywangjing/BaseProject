//
//  RootViewController.h
//  BaseProject
//
//  Created by JerryWang on 2017/5/30.
//  Copyright © 2017年 JerryWang. All rights reserved.
//  基类

#import <UIKit/UIKit.h>
#import "LDRefresh.h"

@interface RootViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) UITableViewStyle tableViewStyle;   // tableView 样式，需要提前设置，默认：plain

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UICollectionView * collectionView;

/// empty dataSource
@property (nonatomic,strong) UIImage *emptyViewImage;
@property (nonatomic,copy) NSString *emptyViewTitle;


/// 显示没有数据页面
-(void)showNoDataImage;

 /// 移除无数据页面
-(void)removeNoDataImage;

/// 加载等待视图
- (void)showLoadingActivity;

/// 停止加载
- (void)stopLoadingActivity;

// 上拉刷新，下拉加载

- (void)addRefreshForTableView;
- (void)addRefreshForCollectionView;

- (void)endRefreshForTableView;
- (void)endRefreshForCollectionView;

/**
 *  是否显示返回按钮
 */
@property (nonatomic, assign) BOOL isShowNavBackBtn;        // 默认：YES

/**
 是否隐藏导航栏
 */
@property (nonatomic, assign) BOOL isHiddenNavBar;          // 默认：NO



/**
 创建导航栏文本按钮

 @param title 按钮名称
 @param target 代理对象
 @param action 响应时间
 @return item对象
 */
- (UIBarButtonItem *)creatNavbarItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;


/**
 创建导航栏图片按钮

 @param image 图片的名称
 @param target 目标
 @param action 时间
 @return item对象
 */

- (UIBarButtonItem *)creatNavbarItemWithImage:(NSString *)image target:(id)target action:(SEL)action;


/**
 *  默认返回按钮的点击事件，默认是返回，子类可重写
 */
- (void)backBtnDidClick;

//取消所有网络请求
- (void)cancelAllRequest;

@end
