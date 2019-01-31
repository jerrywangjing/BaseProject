//
//  WJUnArchiveTool.m
//  CloudStorageApp
//
//  Created by wangjing on 2018/8/9.
//  Copyright © 2018年 swzh. All rights reserved.

#import "WJUnArchiveTool.h"
#import <UnrarKit.h>
#import <SSZipArchive.h>
#import <LzmaSDK_ObjC/LzmaSDKObjC.h>

// 注意事项：<LzmaSDK_ObjC>库使用时需要导入支持ARM64的动态链接库即.framework，并导入c/c++库文件夹，然后配置search header path路径，并且需要在Build Phases 中手动添加Copy Files-> Destination选择framework->然后点击+号添加Lzma动态库

static NSString *const WJUnArchiveToolDomain = @"com.jerry.wjunarchivetool";

@interface WJUnArchiveTool ()<LzmaSDKObjCReaderDelegate>

@property (nonatomic,copy) NSString *filePath;
@property (nonatomic,assign) WJUnArchiveFileType fileType;
@property (nonatomic,copy) NSString *destPath;                   // 解压目标目录，默认解压到当前目录

@property (nonatomic,copy) WJUnArchiveProgressBlock z7Progress;  // 7z 文件解压进度block

@end

@implementation WJUnArchiveTool

#pragma mark - public

+ (void)decompressFile:(NSString *)filePath fileType:(WJUnArchiveFileType)fileType password:(WJUnArchivePasswordBlock)password progress:(WJUnArchiveProgressBlock)progress completion:(WJUnArchiveCompletinBlock)completion{
    [self decompressFile:filePath fileType:fileType destPath:nil password:password progress:progress completion:completion];
}

+ (void)decompressFile:(NSString *)filePath fileType:(WJUnArchiveFileType)fileType destPath:(NSString *)destPath password:(WJUnArchivePasswordBlock)password progress:(WJUnArchiveProgressBlock)progress completion:(WJUnArchiveCompletinBlock)completion{
    WJUnArchiveTool *tool = [[WJUnArchiveTool alloc] initWithFilePath:filePath fileType:fileType destPath:destPath];
    [tool decompressWithPassword:password Progress:progress completion:completion];
}


#pragma mark - init

- (instancetype)initWithFilePath:(NSString *)filePath fileType:(WJUnArchiveFileType)fileType destPath:(NSString *)destPath{
    
    if (self = [super init]) {
        _filePath = filePath;
        _fileType = fileType;
        _destPath = destPath ?: [filePath stringByDeletingLastPathComponent];  // 默认解压到当前文件夹
    }
    return self;
}

#pragma mark - compress tool

// 解压
- (void)decompressWithPassword:(WJUnArchivePasswordBlock)password Progress:(WJUnArchiveProgressBlock)progress completion:(WJUnArchiveCompletinBlock)completion{
    
    if (!_filePath || _filePath.length == 0 || [_filePath isEqual:[NSNull null]]) {
        if (completion) {
            NSError *error = [NSError errorWithDomain:WJUnArchiveToolDomain code:1001 userInfo:@{NSLocalizedDescriptionKey : @"文件路径为空"}];
            completion(error,nil);
        }
        return;
    }
    
    if (![self checkFileSize]) {
        if (completion) {
            NSError *error = [NSError errorWithDomain:WJUnArchiveToolDomain code:1002 userInfo:@{NSLocalizedDescriptionKey : @"只能解压200M以内的文件"}];
            completion(error,nil);
        }
        return;
    }
    
    // 开始解压
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        switch (_fileType) {
            case WJUnArchiveFileTypeRAR:{
                
                [self decompressFromRARWithPassword:password progress:progress completion:^(NSError *error, NSArray<NSString *> *filePaths) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion(error,filePaths);
                        }
                    });
                }];
            }
                break;
            case WJUnArchiveFileTypeZIP:{
             
                [self decompressFromZIPWithPassword:password progress:progress completion:^(NSError *error, NSArray<NSString *> *filePaths) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion(error,filePaths);
                        }
                    });
                }];
            }
                break;
            case WJUnArchiveFileType7z:{
             
                [self decompressFrom7zWithPassword:password progress:progress completion:^(NSError *error, NSArray<NSString *> *filePaths) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion(error,filePaths);
                        }
                    });
                }];
            }
                break;
            default:
                break;
        }
    });
}

- (void)decompressFromRARWithPassword:(WJUnArchivePasswordBlock)password progress:(WJUnArchiveProgressBlock)progress completion:(WJUnArchiveCompletinBlock)completion{
    
    NSError *archiveError = nil;
    URKArchive *archive = [[URKArchive alloc] initWithPath:_filePath error:&archiveError];
    
    if (archiveError && completion) {
        completion(archiveError,nil);
        return;
    }
    
    // 判断是否有密码
    
    if (archive.isPasswordProtected) {
        while (![archive validatePassword] && ![archive.password isEqualToString:WJUnArchiveToolCancel]){
            if (password) {
                archive.password = password();
            }
        }
        if ([archive.password isEqualToString:WJUnArchiveToolCancel]) {
            return;
        }
    }
    
    // 解压文件到指定目录
    
    NSError *extractError = nil;
    BOOL extractFilesSuccessful = [archive extractFilesTo:_destPath overwrite:YES progress:^(URKFileInfo * _Nonnull currentFile, CGFloat percentArchiveDecompressed) {
        if (progress) {
            progress(currentFile.filename,percentArchiveDecompressed);
        }
    } error:&extractError];
    
    if (!extractFilesSuccessful) {
        if (extractError && completion) {
            completion(extractError,nil);
        }else{
            NSError *error = [NSError errorWithDomain:WJUnArchiveToolDomain code:1003 userInfo:@{NSLocalizedDescriptionKey : @"文件解压失败"}];
            completion(error,nil);
        }
        return;
    }
    
    // 解压完成
    if (completion) {
        completion(nil,nil);
    }
}

- (void)decompressFromZIPWithPassword:(WJUnArchivePasswordBlock)password progress:(WJUnArchiveProgressBlock)progress completion:(WJUnArchiveCompletinBlock)completion{
    
    // 判断是否有密码保护
    
    if ([SSZipArchive isFilePasswordProtectedAtPath:_filePath]) {
        NSString *pwd = nil;
        while (![SSZipArchive isPasswordValidForArchiveAtPath:_filePath password:pwd error:nil]
               && ![pwd isEqualToString:WJUnArchiveToolCancel]) {
            if (password) {
                pwd = password();
            }
        }
        if ([pwd isEqualToString:WJUnArchiveToolCancel]) {
            return;
        }
    }
    
    // 解压
    BOOL success = [SSZipArchive unzipFileAtPath:_filePath toDestination:_destPath overwrite:YES password:nil progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
        CGFloat value = (entryNumber / (CGFloat)total);
        if (progress) {
            progress(entry,value);
        }
        
    } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
        if (completion) {
            completion(error,nil);
        }
    }];
    
    if (!success) {
        NSError *error = [NSError errorWithDomain:WJUnArchiveToolDomain code:1003 userInfo:@{NSLocalizedDescriptionKey : @"文件解压失败"}];
        completion(error,nil);
    }
}

- (void)decompressFrom7zWithPassword:(WJUnArchivePasswordBlock)password progress:(WJUnArchiveProgressBlock)progress completion:(WJUnArchiveCompletinBlock)completion{

    NSURL *fileUrl = [NSURL fileURLWithPath:_filePath];
    LzmaSDKObjCReader *reader = [[LzmaSDKObjCReader alloc] initWithFileURL:fileUrl andType:LzmaSDKObjCFileType7z];
    reader.delegate = self;
    reader.passwordGetter = ^NSString * _Nullable{
        if (password) {
           return password();
        }
        return nil;
    };
    
    NSError * error = nil;
    if (![reader open:&error]) {
        if (completion) {
            completion(error,nil);
        }
        return;
    }
    
    NSMutableArray *items = [NSMutableArray array];
    [reader iterateWithHandler:^BOOL(LzmaSDKObjCItem * _Nonnull item, NSError * _Nullable error) {
        if (item) {
            [items addObject:item];
        }else{
            if (error) {
                NSLog(@"a 7z item decompress failure:%@",error.localizedDescription);
            }
        }
        return YES;
    }];
    
    _z7Progress = progress;
    
    BOOL success = [reader extract:items toPath:_destPath withFullPaths:YES];
    
    if (!success) {
        if (completion) {
            NSError *error = [NSError errorWithDomain:WJUnArchiveToolDomain code:1003 userInfo:@{NSLocalizedDescriptionKey : @"文件解压失败"}];
            completion(error,nil);
            NSLog(@"7z decompress failure, error:%@",reader.lastError.localizedDescription);
        }
        return;
    }
    
    if (completion) {
        completion(nil,nil); // 成功的回调
    }
}


#pragma mark - LzmaSDKObjCReader delegate

- (void)onLzmaSDKObjCReader:(LzmaSDKObjCReader *)reader extractProgress:(float)progress{
    if (_z7Progress) {
        _z7Progress(reader.fileURL.lastPathComponent,progress);
    }
}

#pragma mark - private

- (BOOL)checkFileSize{
    NSDictionary *fileInfoDic = [[NSFileManager defaultManager] attributesOfItemAtPath:_filePath error:nil];
     unsigned long long  fileSize = fileInfoDic.fileSize;
    if (fileSize > 1024 * 1024 * 200) {  // 最大解压 200MB
        return NO;
    }
    return YES;
}


@end
