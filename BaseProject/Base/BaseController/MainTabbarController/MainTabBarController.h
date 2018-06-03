//
//  MainTabBarController.h
//  JWChat
//
//  Created by JerryWang on 2017/3/30.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarController : UITabBarController

/**
 设置小红点
 
 @param index tabbar下标
 @param isShow 是显示还是隐藏
 */
-(void)setRedDotWithIndex:(NSInteger)index isShow:(BOOL)isShow;

@end
