//
//  HMRefreshTableViewController.h
//  everyoneIsHealthy
//
//  Created by JerryWang on 2018/3/15.
//  Copyright © 2018年 华美医信. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshNewDataBlock)(NSInteger page);
typedef void(^LoadMoreDataBlock)(NSInteger page);

@interface HMRefreshTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,copy) RefreshNewDataBlock didRefreshData;
@property (nonatomic,copy) LoadMoreDataBlock didLoadMoreData;


- (instancetype)initWithStyle:(UITableViewStyle)style;
- (void)noMoreData;
- (void)refreshData;

@end
