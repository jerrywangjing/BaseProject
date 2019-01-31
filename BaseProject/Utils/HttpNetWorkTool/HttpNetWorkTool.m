//
//  HttpNetWorkTool.h
//
//
//  Created by JerryWang on 16/8/15.
//  Copyright © 2016年 JerryWang. All rights reserved.
//

#import "HttpNetWorkTool.h"
#import "WJAppManager.h"
#import "WJUserManager.h"

@implementation HttpNetWorkTool

#pragma mark - tools

+ (BOOL)isNetworkReachable{
    return [PPNetworkHelper isNetwork];
}
+ (BOOL)isWiFiNetwork{
    return [PPNetworkHelper isWiFiNetwork];
}
+ (void)cancelRequestWithURL:(NSString *)URL{
    [PPNetworkHelper cancelRequestWithURL:URL];
}
+ (void)cancelAllRequest{
    [PPNetworkHelper cancelAllRequest];
}

#pragma mark - request methods

+ (void)GET:(NSString *)url params:(id)params success:(WJHttpRequestSuccess)success failure:(WJHttpRequestFailed)failure{
    [PPNetworkHelper GET:url parameters:params success:^(id responseObject) {
        [self handleHttpResponse:responseObject completion:success];
    } failure:failure];
}
+ (void)GET:(NSString *)url params:(id)params responseCache:(WJHttpRequestCache)responseCache success:(WJHttpRequestSuccess)success failure:(WJHttpRequestFailed)failure{
    [PPNetworkHelper GET:url parameters:params responseCache:responseCache success:^(id responseObject) {
        [self handleHttpResponse:responseObject completion:success];
    } failure:failure];
}

+ (void)POST:(NSString *)url params:(id)params success:(WJHttpRequestSuccess)success failure:(WJHttpRequestFailed)failure{
    [PPNetworkHelper POST:url parameters:params success:^(id responseObject) {
        [self handleHttpResponse:responseObject completion:success];
    } failure:failure];
}
+ (void)POST:(NSString *)url params:(id)params responseCache:(WJHttpRequestCache)responseCache success:(WJHttpRequestSuccess)success failure:(WJHttpRequestFailed)failure{
    [PPNetworkHelper POST:url parameters:params responseCache:responseCache success:^(id responseObject) {
        [self handleHttpResponse:responseObject completion:success];
    } failure:failure];
}

#pragma mark - upload/download methods

+ (NSURLSessionTask *)uploadFileWithURL:(NSString *)URL parameters:(id)parameters name:(NSString *)name fileUrl:(NSURL *)fileUrl fileName:(NSString *)fileName fileData:(NSData *)fileData progress:(WJHttpProgress)progress success:(WJHttpRequestSuccess)success failure:(WJHttpRequestFailed)failure{

    return [PPNetworkHelper uploadFileWithURL:URL parameters:parameters name:name fileUrl:fileUrl fileName:fileName fileData:fileData progress:progress success:^(id responseObject) {
        [self handleHttpResponse:responseObject completion:success];
    } failure:failure];
}

+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL parameters:(id)parameters name:(NSString *)name images:(NSArray<UIImage *> *)images fileNames:(NSArray<NSString *> *)fileNames imageScale:(CGFloat)imageScale imageType:(NSString *)imageType progress:(WJHttpProgress)progress success:(WJHttpRequestSuccess)success failure:(WJHttpRequestFailed)failure{
    
    return [PPNetworkHelper uploadImagesWithURL:URL parameters:parameters name:name images:images fileNames:fileNames imageScale:imageScale imageType:imageType progress:progress success:^(id responseObject) {
        [self handleHttpResponse:responseObject completion:success];
    } failure:failure];
}
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL fileDir:(NSString *)fileDir progress:(WJHttpProgress)progress success:(void (^)(NSString *))success failure:(WJHttpRequestFailed)failure{
    return [PPNetworkHelper downloadWithURL:URL fileDir:fileDir progress:progress success:success failure:failure];
}

#pragma mark - private

// 服务器返回数据的预处理

+ (void)handleHttpResponse:(id)responseObj completion:(WJHttpRequestSuccess)completion{
    
    // **注意**：当前为主线程
    
    NSInteger code = [responseObj[@"status"] integerValue];
    NSString *msg = responseObj[@"msg"];
    id data = responseObj[@"data"];
    
    if (code == 200) {
        if (completion) completion(nil,data,msg);
        return;
    }
    
    WJError *error = [WJError errorWithCode:code message:msg];
    
    if (error.code == WJErrorCodeHttpRespNeedLogin) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showWarnMessage:msg completion:^{
            [kWJUserManager logout:^{
                [kWJAppManager changeRootVcForState:WJAppManagerRootVcStateLogout];
            }];
        }];
        return;
    }
    
    if (completion) {
        completion(error,nil,nil);
    }
}

@end
