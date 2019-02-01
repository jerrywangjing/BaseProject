//
//  BaseTableViewCell.h
//  BaseProject
//
//  Created by JerryWang on 2017/11/8.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat CellFontSize_14 = 14;
static const CGFloat CellFontSize_13 = 13;

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic,strong) id model;
@property (nonatomic,strong,readonly) NSIndexPath *indexPath;

/**
 实例化cell
 
 @param tableView 所在的tableView
 @return cell实例
 */
+ (instancetype)cellWithTabelView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
+ (instancetype)cellWithTabelView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sectionMaxRow:(NSInteger)maxRow cellHeight:(CGFloat)cellHeight;


// 配置cell
- (void)configCell;
// 设置子控件
- (void)setupCellContentView;
// 设置圆角背景图
- (void)setupRoundCornerMaskViewWithmaxRowCount:(NSInteger)maxRow cellHeight:(CGFloat)cellHeight;

@end
