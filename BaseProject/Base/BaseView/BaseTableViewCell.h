//
//  HMBaseTableViewCell.h
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/11/8.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat CellFontSize_14 = 14;
static const CGFloat CellFontSize_13 = 13;

@interface BaseTableViewCell : UITableViewCell

// header标题label的宽度
@property (nonatomic,strong,readonly) NSArray *titleHeaderWidth;
@property (nonatomic,strong) id model;


/// 自定义样式cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 初始化方法(网格列表样式cell)

 @param tableView 所属的tableView
 @param titleWidth table 标题的宽度
 @return 实例对象
 */
+ (instancetype)cellWithTabelView:(UITableView *)tableView titleWidth:(NSArray *)titleWidth;

// 配置cell
- (void)configCell;
// 设置子控件
- (void)setupCellContentView;

@end
