//
//  TestViewController.m
//  BaseProject
//
//  Created by JerryWang on 2018/6/1.
//  Copyright © 2018年 JerryWang. All rights reserved.
//

#import "TestViewController.h"
#import "WJAlertView.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"测试页面";
    
}

- (void)backBtnDidClick{

    [WJAlertView showSystemAlertWithTitle:nil message:@"确认返回?" cancleClick:nil confirmClick:^(UIAlertAction *action) {
        [super backBtnDidClick];
    }];
}

@end
