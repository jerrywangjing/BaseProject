//
//  HttpNetWorkTool.h
//
//  Created by JerryWang on 16/8/15.
//  Copyright © 2016年 JerryWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>


@class WJError;

/*
 * 网络库应用层封装，可以处理应用级相关的逻辑，比如对数据的特殊处理
 */

/** 请求成功的Block */
typedef void(^WJHttpRequestSuccess)(WJError *error,id data,NSString *tipMsg); // tipMsg:后台返回的提示语
/** 请求失败的Block */
typedef void(^WJHttpRequestFailed)(NSError *error);
/** 缓存的Block */
typedef void(^WJHttpRequestCache)(id responseCache);

/// 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小
typedef void (^WJHttpProgress)(NSProgress *progress);


typedef NS_ENUM(NSUInteger, WJHttpRespState) {
    
    WJHttpRespStateSuccess = 200,
    WJHttpRespStateAccountError = 400,
    WJHttpRespStateLogout = 401,
    WJHttpRespStateFailure = 500,
};


@interface HttpNetWorkTool : NSObject

/// 有网络:YES, 反之:NO
+ (BOOL)isNetworkReachable;
/// WiFi网络:YES, 反之:NO
+ (BOOL)isWiFiNetwork;
/// 取消指定URL的HTTP请求
+ (void)cancelRequestWithURL:(NSString *)URL;
/// 取消所有HTTP请求
+ (void)cancelAllRequest;


/// GET, 无缓存
+ (void)GET:(NSString *)url params:(id)params success:(WJHttpRequestSuccess)success failure:(WJHttpRequestFailed)failure;
/// GET, 自动缓存
+ (void)GET:(NSString *)url params:(id)params responseCache:(WJHttpRequestCache)responseCache success:(WJHttpRequestSuccess)success failure:(WJHttpRequestFailed)failure;


/// POST, 无缓存
+ (void)POST:(NSString *)url params:(id)params success:(WJHttpRequestSuccess)success failure:(WJHttpRequestFailed)failure;
/// POST, 自动缓存
+ (void)POST:(NSString *)url params:(id)params responseCache:(WJHttpRequestCache)responseCache success:(WJHttpRequestSuccess)success failure:(WJHttpRequestFailed)failure;


/**
 *  上传文件
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param name       文件对应服务器上的字段
 *  @param fileUrl    本地文件路径
 *  @param fileName   本地文件名称
 *  @param fileData   文件数据
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)uploadFileWithURL:(NSString *)URL
                                      parameters:(id)parameters
                                            name:(NSString *)name
                                         fileUrl:(NSURL *)fileUrl
                                        fileName:(NSString *)fileName
                                        fileData:(NSData *)fileData
                                        progress:(WJHttpProgress)progress
                                         success:(WJHttpRequestSuccess)success
                                         failure:(WJHttpRequestFailed)failure;

/**
 *  上传单/多张图片
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param name       图片对应服务器上的字段
 *  @param images     图片数组
 *  @param fileNames  图片文件名数组, 可以为nil, 数组内的文件名默认为当前日期时间"yyyyMMddHHmmss"
 *  @param imageScale 图片文件压缩比 范围 (0.f ~ 1.f)
 *  @param imageType  图片文件的类型,例:png、jpg(默认类型)....
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                                        parameters:(id)parameters
                                              name:(NSString *)name
                                            images:(NSArray<UIImage *> *)images
                                         fileNames:(NSArray<NSString *> *)fileNames
                                        imageScale:(CGFloat)imageScale
                                         imageType:(NSString *)imageType
                                          progress:(WJHttpProgress)progress
                                           success:(WJHttpRequestSuccess)success
                                           failure:(WJHttpRequestFailed)failure;

/**
 *  下载文件
 *
 *  @param URL      请求地址
 *  @param fileDir  文件存储目录(默认存储目录为Download)
 *  @param progress 文件下载的进度信息
 *  @param success  下载成功的回调(回调参数filePath:文件的路径)
 *  @param failure  下载失败的回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
+ (__kindof NSURLSessionTask *)downloadWithURL:(NSString *)URL
                                       fileDir:(NSString *)fileDir
                                      progress:(WJHttpProgress)progress
                                       success:(void(^)(NSString *filePath))success
                                       failure:(WJHttpRequestFailed)failure;

@end
