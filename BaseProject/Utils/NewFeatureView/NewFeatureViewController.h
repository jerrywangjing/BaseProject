//
//  NewFeatureViewController.h
//  XYTPatients
//
//  Created by jerry on 2017/5/2.
//  Copyright © 2017年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NewFeatureStartBlock)();

@interface NewFeatureViewController : UIViewController
@property (nonatomic,copy) NewFeatureStartBlock didStartApp;

@end
