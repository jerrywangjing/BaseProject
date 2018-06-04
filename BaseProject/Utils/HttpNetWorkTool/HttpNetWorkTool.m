//
//  HttpNetWorkTool.h
//
//
//  Created by JerryWang on 16/8/15.
//  Copyright © 2016年 JerryWang. All rights reserved.
//

#import "HttpNetWorkTool.h"
#import <PPNetworkHelper.h>

@implementation HttpNetWorkTool

+ (void)GET:(NSString *)url params:(NSDictionary *)params success:(WJHttpRequestSuccess)success failure:(WJHttpRequestFailed)failure{
    [PPNetworkHelper GET:url parameters:params success:success failure:failure];
}
+ (void)GET:(NSString *)url params:(NSDictionary *)params responseCache:(WJHttpRequestCache)responseCache success:(WJHttpRequestSuccess)success failure:(WJHttpRequestFailed)failure{
    [PPNetworkHelper GET:url parameters:params responseCache:responseCache success:success failure:failure];
}

+ (void)POST:(NSString *)url params:(NSDictionary *)params success:(WJHttpRequestSuccess)success failure:(WJHttpRequestFailed)failure{
    [PPNetworkHelper POST:url parameters:params success:success failure:failure];
}
+ (void)POST:(NSString *)url params:(NSDictionary *)params responseCache:(WJHttpRequestCache)responseCache success:(WJHttpRequestSuccess)success failure:(WJHttpRequestFailed)failure{
    [PPNetworkHelper POST:url parameters:params responseCache:responseCache success:success failure:failure];
}

+ (NSURLSessionTask *)uploadFileWithURL:(NSString *)URL parameters:(id)parameters name:(NSString *)name filePath:(NSString *)filePath progress:(WJHttpProgress)progress success:(WJHttpRequestSuccess)success failure:(WJHttpRequestFailed)failure{
    return [PPNetworkHelper uploadFileWithURL:URL parameters:parameters name:name filePath:filePath progress:progress success:success failure:failure];
}
+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL parameters:(id)parameters name:(NSString *)name images:(NSArray<UIImage *> *)images fileNames:(NSArray<NSString *> *)fileNames imageScale:(CGFloat)imageScale imageType:(NSString *)imageType progress:(WJHttpProgress)progress success:(WJHttpRequestSuccess)success failure:(WJHttpRequestFailed)failure{
    
    return [PPNetworkHelper uploadImagesWithURL:URL parameters:parameters name:name images:images fileNames:fileNames imageScale:imageScale imageType:imageType progress:progress success:success failure:failure];
}
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL fileDir:(NSString *)fileDir progress:(WJHttpProgress)progress success:(void (^)(NSString *))success failure:(WJHttpRequestFailed)failure{
    return [PPNetworkHelper downloadWithURL:URL fileDir:fileDir progress:progress success:success failure:failure];
}

@end
