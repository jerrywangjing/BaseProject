//
//  ProfileViewController.m
//  BaseProject
//
//  Created by JerryWang on 2018/6/4.
//  Copyright © 2018年 JerryWang. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人中心";
    [self setupView];
}

- (void)setupView{
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    label.text = @"测试文字";
    label.textColor = [UIColor redColor];
    
    [self.view addSubview:label];
}


@end
