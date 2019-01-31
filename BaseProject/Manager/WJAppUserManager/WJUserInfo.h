//
//  WJUserInfo.h
//  BaseProject
//
//  Created by wangjing on 2019/1/31.
//  Copyright © 2019年 JerryWang. All rights reserved.
//

#import "BaseModel.h"

@interface WJUserInfo : BaseModel<NSCoding>

@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *password;

@property (nonatomic,copy) NSString *avatarUrl;
@property (nonatomic,copy) NSString *phoneNumber;
@property (nonatomic,copy) NSString *registerDate;

@property (nonatomic,assign) BOOL isCurrentUser;        // 是否当前登录用户

@end
