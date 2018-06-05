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
    
    // cell
    UIView *cell = [[UIView alloc] init];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:cell];

    // icon
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"icon_boy"];
    [cell addSubview:iconView];
    
    
    // name
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.text = @"Jerry";
    [cell addSubview:nameLabel];

    // nickname
    UILabel *nicknameLabel = [[UILabel alloc] init];
    nicknameLabel.textColor = [UIColor grayColor];
    nicknameLabel.font = [UIFont systemFontOfSize:14];
    nicknameLabel.text = @"a coder";
    [cell addSubview:nicknameLabel];
    
    // arrow view
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_icon"]];
    [cell addSubview:arrowView];
    
    // layout
    
    cell.sd_layout.leftEqualToView(self.view).topSpaceToView(self.view, NavBarH+15).rightEqualToView(self.view);
    
    iconView.sd_layout.centerYEqualToView(cell).leftSpaceToView(cell, 10).widthIs(60).heightEqualToWidth();
    
    arrowView.sd_layout.centerYEqualToView(cell).rightSpaceToView(cell, 15).heightIs(arrowView.image.size.height).widthIs(arrowView.image.size.height);
    
    nameLabel.sd_layout.topEqualToView(iconView).offset(5).leftSpaceToView(iconView, 10).rightSpaceToView(arrowView, 5).autoHeightRatio(0);
    [nameLabel setMaxNumberOfLinesToShow:1];
    nicknameLabel.sd_layout.leftEqualToView(nameLabel).bottomEqualToView(iconView).offset(-5).rightSpaceToView(arrowView, 20).autoHeightRatio(0);
    
}


@end
