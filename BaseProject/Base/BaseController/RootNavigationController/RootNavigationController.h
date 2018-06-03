//
//  RootNavigationController.h
//  BaseProject
//
//  Created by JerryWang on 2018/6/1.
//  Copyright © 2018年 JerryWang. All rights reserved.
//

// 导航控制器基类

#import <UIKit/UIKit.h>

@interface RootNavigationController : UINavigationController

/*!
 *  返回到指定的类视图
 *
 *  @param ClassName 类名
 *  @param animated  是否动画
 */
-(BOOL)popToAppointViewController:(NSString *)ClassName animated:(BOOL)animated;

@end
