//
//  WJLoginViewController.h
//  BaseProject
//
//  Created by wangjing on 2019/1/31.
//  Copyright © 2019年 JerryWang. All rights reserved.
//

#import "RootViewController.h"

typedef void(^WJLoginCompleteBlock)(NSString *account,NSString *password);
@interface WJLoginViewController : RootViewController

@property (nonatomic,copy) WJLoginCompleteBlock didLoginCompletion;

@end

