//
//  WJUserInfo.m
//  BaseProject
//
//  Created by wangjing on 2019/1/31.
//  Copyright © 2019年 JerryWang. All rights reserved.
//

#import "WJUserInfo.h"

@implementation WJUserInfo

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userId"  : @"id",
             @"avatarUrl"  : @"icon",
             @"phoneNumber" : @"tel",
             @"registerDate" : @"reg_time",
             };
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        _userId = [aDecoder decodeIntegerForKey:@"userId"];
        _username = [aDecoder decodeObjectForKey:@"username"];
        _password = [aDecoder decodeObjectForKey:@"password"];
        _avatarUrl = [aDecoder decodeObjectForKey:@"avatarUrl"];
        _phoneNumber = [aDecoder decodeObjectForKey:@"phoneNumber"];
        _registerDate = [aDecoder decodeObjectForKey:@"registerDate"];
        _isCurrentUser = [aDecoder decodeBoolForKey:@"isCurrentUser"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeInteger:_userId forKey:@"userId"];
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_password forKey:@"password"];
    [aCoder encodeObject:_avatarUrl forKey:@"avatarUrl"];
    [aCoder encodeObject:_phoneNumber forKey:@"phoneNumber"];
    [aCoder encodeObject:_registerDate forKey:@"registerDate"];
    [aCoder encodeBool:_isCurrentUser forKey:@"isCurrentUser"];
    
}

@end
