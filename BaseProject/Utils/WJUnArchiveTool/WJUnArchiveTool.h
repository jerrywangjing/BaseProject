//
//  WJUnArchiveTool.h
//  CloudStorageApp
//
//  Created by wangjing on 2018/8/9.
//  Copyright © 2018年 swzh. All rights reserved.
//
//  Jerry: 压缩文件解压工具，支持解压类型：.rar、.zip、.7z

// 注意事项：<LzmaSDK_ObjC/LzmaSDKObjC.h>库使用时需要导入支持ARM64的动态链接库即.framework，并导入c/c++库文件夹，然后配置search header path路径，并且需要在Build Phases 中手动添加Copy Files-> Destination选择framework->然后点击+号添加Lzma动态库

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WJUnArchiveFileType) {
    WJUnArchiveFileTypeRAR,
    WJUnArchiveFileTypeZIP,
    WJUnArchiveFileType7z,
};

typedef void(^WJUnArchiveCompletinBlock)(NSError *error, NSArray<NSString *> *filePaths);
typedef void(^WJUnArchiveProgressBlock)(NSString *currentfileName,CGFloat progress);
typedef NSString *(^WJUnArchivePasswordBlock)();

#define WJUnArchiveProgressFormart(displayName,progress) [NSString stringWithFormat:@"~/%@-->%.f%%",displayName,progress]

static NSString *const WJUnArchiveToolCancel = @"com.jerry.wjunarchivetool.cancel";

@interface WJUnArchiveTool : NSObject

@property (nonatomic,copy,readonly) NSString *filePath;
@property (nonatomic,assign,readonly) WJUnArchiveFileType fileType;
@property (nonatomic,copy,readonly) NSString *destPath;                   // 解压目标目录，默认解压到当前目录


/**
 解压缩文件，解压到当前文件

 @param filePath 压缩文件路径
 @param fileType 压缩文件类型
 @param password 解压密码
 @param completion 完成回调
 */
+ (void)decompressFile:(NSString *)filePath
              fileType:(WJUnArchiveFileType)fileType
              password:(WJUnArchivePasswordBlock)password
              progress:(WJUnArchiveProgressBlock)progress
            completion:(WJUnArchiveCompletinBlock)completion;

/**
 解压缩文件

 @param filePath 压缩文件路径
 @param fileType 压缩文件类型
 @param destPath 解压目标文件目录
 @param password 解压密码
 @param completion 完成回调
 */
+ (void)decompressFile:(NSString *)filePath
              fileType:(WJUnArchiveFileType)fileType
              destPath:(NSString *)destPath
              password:(WJUnArchivePasswordBlock)password
              progress:(WJUnArchiveProgressBlock)progress
            completion:(WJUnArchiveCompletinBlock)completion;


@end
