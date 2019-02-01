//
//  WJUserManager.m
//  BaseProject
//
//  Created by wangjing on 2019/1/31.
//  Copyright © 2019年 JerryWang. All rights reserved.
//

#import "WJUserManager.h"
#import "WJUserInfo.h"
#import "WJAppManager.h"
#import "WJLoginViewController.h"
#import "HttpNetWorkTool.h"

#define WJUserManagerError(msg) [NSError errorWithDomain:@"WJUserManagerError" code:0 userInfo:@{NSLocalizedDescriptionKey : msg}]

static NSString *const kRespStatues = @"status";
static NSString *const kRespMsg = @"msg";
static NSString *const kRespData = @"data";
static NSString *const kLoginSessionId = @"LoginSessionId";

@interface WJUserManager()

@property (nonatomic,copy) NSString *userInfoDir;

@end

@implementation WJUserManager

+ (instancetype)sharedUserManager{
    
    static WJUserManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        // 被踢下线通知
        [kNotificationCenter addObserver:self selector:@selector(didBeKicked) name:WJUserManagerBeKickedNotification object:nil];
        
        // 监听网络连接断开的通知
        
        [kNotificationCenter addObserver:self selector:@selector(networkDisconnect) name:WJNetWorkDidNotReachableNotification object:nil];
        [kNotificationCenter addObserver:self selector:@selector(networkConnect) name:WJNetWorkDidReachableNotification object:nil];
        
        // 初始化用户数据
        
        // 加载用户信息
        [self initUserInfo];
    }
    
    return self;
}

// 初始化用户信息
- (void)initUserInfo{
    
    NSString *currentUserId = [kUserDefaults objectForKey:kWJCurrentLoginUserId];
    if (!currentUserId) {
        return ;
    }
    
    NSString *currentUserInfoPath = [self.userInfoDir stringByAppendingPathComponent:currentUserId];
    WJUserInfo *userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:currentUserInfoPath];
    _currentUser = userInfo;
}

// 是否能自动登录

- (BOOL)canAutoLogin{
    if (!self.currentUser) {
        return NO;
    }
    
    NSDate *lastLoginDate = [kUserDefaults objectForKey:kWJLastLoginDate];
    if (!lastLoginDate) {
        return NO;
    }
    NSInteger hasDays = [lastLoginDate daysAgo];
    if (hasDays > 15) {  // 超过15天后，需要手动登录
        return NO;
    }else{
        return YES;
    }
}

// 手动登录

- (void)loginForAccount:(NSString *)account password:(NSString *)password completion:(WJUserManagerLoginBlock)completion{
    
    NSDictionary *params = @{
                             @"username" : account,
                             @"password" : password,
                             };
    
    [MBProgressHUD showActivityMessageInView:@"正在登录..."];
    [self loginToServer:params completion:^(BOOL success, NSString *msg) {
        [MBProgressHUD hideHUD];
        if (success) {
            [MBProgressHUD showSuccessMessage:@"登录成功" completion:^{
                if (completion) {
                    completion();
                }
                // 记录上传手动登录时间
                [kUserDefaults setObject:[NSDate date] forKey:kWJLastLoginDate];
            }];
        }else{
            [MBProgressHUD showErrorMessage:msg];
        }
    }];
}

// 自动登录
- (void)autoLoginWithCompletion:(WJUserManagerLoginBlock)completion failure:(void(^)())failure{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *params = @{
                                 @"username" : self.currentUser.username,
                                 @"password" : self.currentUser.password
                                 };
        [self loginToServer:params completion:^(BOOL success, NSString *msg) {
            if (success && completion) {
                completion();
            }
            if (success) {
                NSLog(@"自动登录成功(%@)",URL_base);
            }else{
                NSLog(@"自动登录失败(%@)：%@",URL_base,msg);
                if (failure) {
                    failure();
                }
            }
        }];
    });
}

-(void)loginToServer:(NSDictionary *)params completion:(void(^)(BOOL success,NSString *msg))completion{
    
    [HttpNetWorkTool GET:NSURLFormat(URL_login) params:params success:^(WJError *error, id data, NSString *tipMsg) {
        
        if (error) {
            if (completion) {
                completion(NO,error.localizedDescription);
            }
            return ;
        }
        
        // 缓存并更新用户数据
        [self cacheUserInfoWithDic:data completion:^{
            [self loadUserInfoWithCompletion:^{
                if (completion) {
                    completion(YES,tipMsg);
                }
            }];
        }];
        
        // 记录token
        if (tipMsg.length) {
            [PPNetworkHelper setValue:tipMsg forHTTPHeaderField:@"Sessionid"];
        }
        
        _isLogged = YES;
        
    } failure:^(NSError *error) {
        if (completion) {
            completion(NO,error.localizedDescription);
        }
    }];
}

// 退出登录

- (void)logout:(WJUserManagerLoginBlock)completion{
    [MBProgressHUD showActivity];
    
    [HttpNetWorkTool GET:NSURLFormat(URL_logout) params:nil success:^(WJError *error, id data, NSString *tipMsg) {
        [MBProgressHUD hideHUD];
        if (error) {
            [MBProgressHUD showErrorMessage:error.localizedDescription];
            return ;
        }
        
        _isLogged = NO;
        _currentUser = nil;
        
        [kUserDefaults setObject:nil forKey:kWJCurrentLoginUserId];
        [kNotificationCenter postNotificationName:WJUserManagerDidLogoutNotification object:nil];
        
        if (completion) {
            completion();
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:error.localizedDescription];
    }];
}


// 上传头像

- (void)uploadUserAvatarImage:(UIImage *)image completion:(void (^)())completion{
    
    [MBProgressHUD showActivity];
    [HttpNetWorkTool uploadImagesWithURL:NSURLFormat(URL_uploadIcon) parameters:nil name:@"icon" images:@[image] fileNames:nil imageScale:1.0 imageType:nil progress:nil success:^(WJError *error, id data, NSString *tipMsg) {
        
        if (error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showErrorMessage:error.localizedDescription];
            return ;
        }
        
        // 缓存新信息
        [self cacheUserInfoWithDic:data completion:^{
            [self loadUserInfoWithCompletion:^{
                [kNotificationCenter postNotificationName:WJUserManagerUpdateUserInfoNotification object:nil];
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccessMessage:@"上传成功" completion:^{
                    if (completion) {
                        completion();
                    }
                }];
            }];
        }];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:error.localizedDescription];
    }];
}

// 修改用户名

- (void)updateUserInfo:(NSDictionary *)updateInfo completion:(void (^)())completion{
    
    [MBProgressHUD showActivity];
    [HttpNetWorkTool POST:NSURLFormat(URL_updateUserInfo) params:updateInfo success:^(WJError *error, id data, NSString *tipMsg) {
        
        if (error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showErrorMessage:error.localizedDescription];
            return ;
        }
        
        // 缓存新信息
        [self cacheUserInfoWithDic:data completion:^{
            [self loadUserInfoWithCompletion:^{
                [kNotificationCenter postNotificationName:WJUserManagerUpdateUserInfoNotification object:nil];
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccessMessage:@"修改成功" completion:^{
                    if (completion) {
                        completion();
                    }
                }];
            }];
        }];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:error.localizedDescription];
    }];
}

// 发送短信验证
- (void)sendSMSToTel:(NSString *)tel completion:(void (^)(NSString *code))completion{
    [MBProgressHUD showActivity];
    NSString *url = [NSURLFormat(URL_sendSMS) stringByAppendingPathComponent:tel];
    [HttpNetWorkTool GET:url params:nil success:^(WJError *error, id data, NSString *tipMsg) {
        if (error) {
            [MBProgressHUD showErrorMessage:error.localizedDescription];
            return ;
        }
        
        [MBProgressHUD showSuccessMessage:@"已发送"];
        if (completion) {
            completion([data stringValue]);
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:error.localizedDescription];
    }];
}

- (void)registerForInfo:(NSDictionary *)regInfo completion:(void (^)())completion{
    
    [MBProgressHUD showActivity];
    [HttpNetWorkTool POST:NSURLFormat(URL_regist) params:regInfo success:^(WJError *error, id data, NSString *tipMsg) {
        if (error) {
            [MBProgressHUD showErrorMessage:error.localizedDescription];
            return ;
        }
        
        [MBProgressHUD showSuccessMessage:@"注册成功"];
        if (completion) {
            completion();
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:error.localizedDescription];
    }];
}

- (void)modifyPasswordForInfo:(NSDictionary *)modifyInfo completion:(void (^)())completion{
    [MBProgressHUD showActivity];
    
    [HttpNetWorkTool GET:NSURLFormat(URL_updateUserPwd) params:modifyInfo success:^(WJError *error, id data, NSString *tipMsg) {
        if (error) {
            [MBProgressHUD showErrorMessage:error.localizedDescription];
            return ;
        }
        [MBProgressHUD showSuccessMessage:@"修改成功" completion:^{
            if (completion) {
                completion();
            }
        }];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:error.localizedDescription];
    }];
}

#pragma mark - private

// 缓存用户信息

- (void)cacheUserInfoWithDic:(NSDictionary *)dic completion:(void(^)())completion{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 缓存用户信息
        WJUserInfo *userInfo = [WJUserInfo modelWithJSONDic:dic];
        NSString *userId = @(userInfo.userId).stringValue;
        NSString *userPath = [self.userInfoDir stringByAppendingPathComponent:userId];
        BOOL success = [NSKeyedArchiver archiveRootObject:userInfo toFile:userPath];
        if (!success) {
            NSLog(@"用户数据缓存失败");
        }
        // 记录当前登录用户
        [kUserDefaults setObject:userId forKey:kWJCurrentLoginUserId];
        [kUserDefaults setObject:userInfo.username forKey:userId];
        [kUserDefaults synchronize];
        
        if (completion) {
            completion();
        }
    });
}

// 获取用户信息
- (void)loadUserInfoWithCompletion:(void(^)())completion{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *currentUserId = [kUserDefaults objectForKey:kWJCurrentLoginUserId];
        if (!currentUserId) {
            return ;
        }
        
        NSString *currentUserInfoPath = [self.userInfoDir stringByAppendingPathComponent:currentUserId];
        WJUserInfo *userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:currentUserInfoPath];
        _currentUser = userInfo;
        
        if (userInfo && completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

// 被踢下线
-(void)didBeKicked{
    [self logout:nil];
}

#pragma mark - 网络状态改变的通知

- (void)networkDisconnect{
    [MBProgressHUD showWarnMessage:@"网络被断开"];
}

- (void)networkConnect{
    
    //有用户数据 并且 未登录成功 重新来一次自动登录
    if (self.currentUser && !self.isLogged) {
        [self autoLoginWithCompletion:nil failure:^{
            [kWJAppManager changeRootVcForState:WJAppManagerRootVcStateLogout];
        }];
    }
}

#pragma mark - getter

- (NSString *)userInfoDir{
    if (!_userInfoDir) {
        
        NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
        NSString *rootDirName = [bundleId stringByAppendingString:@".userInfoDir"];
        NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
        NSString *rootDirPath = [libraryPath stringByAppendingPathComponent:rootDirName];
        
        _userInfoDir = rootDirPath;
    }
    return _userInfoDir;
}
@end
