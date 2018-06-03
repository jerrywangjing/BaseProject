//
//  BaseCellModel.h
//  BaseProject
//
//  Created by JerryWang on 2018/6/1.
//  Copyright © 2018年 JerryWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseCellModel : NSObject

// 这个基本属性需要cell子类重写getter 方法来实现

@property (nonatomic, assign,readonly) NSInteger identifier;     ///<唯一标识符(更新会用到)
@property (nonatomic, assign,readonly) UITableViewCellSelectionStyle selectionStyle;    //选中cell效果
@property (nonatomic, assign,readonly) CGFloat cellHeight;       ///<cell高度(默认有高度)
@property (nonatomic, assign,readonly) BOOL isShowArrow;         //是否显示右箭头

@property (nonatomic, copy) NSString *title;            ///<cell标题(默认左边)
@property (nonatomic, copy) NSString *detailText;       ///右边详细文本


//@property (nonatomic,  copy)   NSString   *cellClass;  ///<该模型绑定的cell类名
//@property (nonatomic, assign)  CGFloat separateHeight;  ///<分割线高度
//@property (nonatomic, strong)  UIColor *separateColor;  ///<分割线颜色
//@property (nonatomic, assign)  CGFloat separateOffset;  ///<分割线左边间距(默认为0)
//@property (nonatomic,  copy)   ClickActionBlock actionBlock;///<cell点击事件


@end

