//
//  HMBaseTableViewCell.m
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/11/8.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell ()

@property (nonatomic,strong) NSArray *titleHeaderWidth; // header标题label的宽度

@end

@implementation BaseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    return [self cellWithTabelView:tableView titleWidth:nil];
}

+ (instancetype)cellWithTabelView:(UITableView *)tableView titleWidth:(NSArray *)titleWidth{
    
    static NSString *cellId;
    cellId = NSStringFromClass([self class]);
    
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId titleWidth:titleWidth];
        [cell configCell];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier titleWidth:(NSArray *)titleWidth{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // init code
        _titleHeaderWidth = titleWidth;
        [self setupCellContentView];
    }
    return self;
}

// 配置cell

- (void)configCell{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
