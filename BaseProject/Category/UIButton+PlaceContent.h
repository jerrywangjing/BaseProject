//
//  UIButton+PlaceContent.h
//  CloudStorageApp
//
//  Created by wangjing on 2018/7/18.
//  Copyright © 2018年 swzh. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ZYButtonImagePosition) {
    /// 图片在左，文字在右
    ZYButtonImagePositionLeft,
    /// 图片在右，文字在左
    ZYButtonImagePositionRight,
    /// 图片在上，文字在下
    ZYButtonImagePositionTop,
    /// 图片在下，文字在上
    ZYButtonImagePositionBottom
};

@interface UIButton (PlaceContent)

/**
 重新摆放按钮的image和label  注意调用时机，按钮的大小确定之后再去调用
 
 @param position 图片的位置
 @param space 图片和文字之间的距离
 */
-(void)placeImageTitlePosition:(ZYButtonImagePosition)position space:(CGFloat)space;

@end
