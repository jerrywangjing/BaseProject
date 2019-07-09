//
//  UIView+WJExtension.m
//  sinaWeibo_dome
//
//  Created by JerryWang on 16/5/21.
//  Copyright © 2016年 JerryWang. All rights reserved.
//

#import "UIView+WJExtension.h"

@implementation UIView (WJExtension)

/**
 *  setter方法
 */
-(void)setX:(CGFloat)x{

    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(void)setY:(CGFloat)y{

    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(void)setWidth:(CGFloat)width{
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(void)setHeight:(CGFloat)height{
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(void)setSize:(CGSize)size{

    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

-(void)setOrigin:(CGPoint)origin{

    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
-(void)setCenterX:(CGFloat)centerX{

    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
-(CGFloat)centerX{

    return self.center.x;
}
-(void)setCenterY:(CGFloat)centerY{

    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
-(CGFloat)centerY{

    return self.center.y;
}
/**
 *  getter方法
 */
-(CGFloat)x{

    return  self.frame.origin.x;
}

-(CGFloat)y{

    return self.frame.origin.y;
}

-(CGFloat)width{

    return self.frame.size.width;
}

-(CGFloat)height{

    return self.frame.size.height;
}

-(CGSize)size{

    return self.frame.size;
}

-(CGPoint)origin{

    return self.frame.origin;
}
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


// cell borderView
+ (UIView *)cellTopBorderView{
    
    UIView * view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    view.backgroundColor = [UIColor lightGrayColor];
    return view;
}

+ (UIView *)cellBottomBorderView:(CGFloat)cellHeight{

    UIView * view  = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight-0.5, SCREEN_WIDTH, 0.5)];
    view.backgroundColor = [UIColor lightGrayColor];
    return view;
}

/// UIImageView 圆角矩形

- (void)makeRoundedRectWithRadius:(float)radius{
    
    [self makeRoundedRectWithRadius:radius RoundingCorners:UIRectCornerAllCorners];
}

- (void)makeRoundedRectWithRadius:(float)radius RoundingCorners:(UIRectCorner)roundingCorners{
    
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    
    // 防止圆角半径小于0，或者大于宽/高中较小值的一半。
    if (radius < 0)
        radius = 0;
    else if (radius > MIN(w/2, h/2))
        radius = MIN(w, h) / 2.;
    
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:roundingCorners cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
    
}

- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (void)addGradientLayerWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor{
    
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer addSublayer:gradientLayer];
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设置颜色数组
    
    gradientLayer.colors = @[(__bridge id)startColor.CGColor,
                             (__bridge id)endColor.CGColor];
    
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    
}

@end
