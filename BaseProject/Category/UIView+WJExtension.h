//
//  UIView+WJExtension.h
//  sinaWeibo_dome
//
//  Created by JerryWang on 16/5/21.
//  Copyright © 2016年 JerryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WJExtension)

@property (nonatomic,assign) CGFloat  x;
@property (nonatomic,assign) CGFloat  y;

@property (nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height

@property (nonatomic,assign) CGFloat  width;
@property (nonatomic,assign) CGFloat  height;

@property (nonatomic,assign) CGSize   size;
@property (nonatomic,assign) CGPoint  origin;

@property (nonatomic,assign) CGFloat  centerX;
@property (nonatomic,assign) CGFloat  centerY;

+ (UIView *)cellTopBorderView;
+ (UIView *)cellBottomBorderView:(CGFloat)cellHeight;

/// UIView 圆角矩形
- (void)makeRoundedRectWithRadius:(float)radius;

/// UIView 局部圆角
- (void)makeRoundedRectWithRadius:(float)radius RoundingCorners:(UIRectCorner)roundingCorners;

/// 获取当前view的截图
- (UIImage *)snapshotImage;

/**
 添加渐变层

 @param startColor 起始颜色
 @param endColor  末尾颜色
 */
- (void)addGradientLayerWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;

@end
