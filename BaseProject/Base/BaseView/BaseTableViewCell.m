//
//  HMBaseTableViewCell.m
//  BaseProject
//
//  Created by JerryWang on 2017/11/8.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell ()

@property (nonatomic,strong) NSArray *titleHeaderWidth; // header标题label的宽度
@property (nonatomic,strong) NSIndexPath *indexPath;

@end

@implementation BaseTableViewCell

+ (instancetype)cellWithTabelView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    return [self cellWithTabelView:tableView indexPath:indexPath sectionMaxRow:0 cellHeight:0];
}

+ (instancetype)cellWithTabelView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sectionMaxRow:(NSInteger)maxRow cellHeight:(CGFloat)cellHeight{
    
    static NSString *cellId;
    cellId = NSStringFromClass([self class]);
    
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId indexPath:indexPath sectionMaxRow:maxRow cellHeight:cellHeight];
        [cell configCell];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath sectionMaxRow:(NSInteger)maxRow cellHeight:(CGFloat)cellHeight{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // init code
        _indexPath = indexPath;
        
        [self setupRoundCornerMaskViewWithmaxRowCount:maxRow cellHeight:cellHeight];
        [self setupCellContentView];
    }
    return self;
}

// 配置cell

- (void)configCell{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
}

// 设置圆角背景图
- (void)setupRoundCornerMaskViewWithmaxRowCount:(NSInteger)maxRow cellHeight:(CGFloat)cellHeight{
    // 子类重写，根据indexPath来做判断
}

// 设置子控件
- (void)setupCellContentView{
    
    // 底部间隔线
    //    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
    //    line.backgroundColor = [UIColor lightGrayColor];
    
    //MARK: 重写此方法初始化子视图，需要调用[super setupCellContentView]来初始化共有的特性
}

// 布局子控件

// 设置数据

- (void)setModel:(id)model{
    _model = model;
    //MARK: 重写此方法给子控件赋值，子类必须调用【super setModel:】方法
}

@end
