//
//  macros.h
//  AppForTemplate
//
//  Created by jerry on 2017/5/26.
//  Copyright © 2017年 jerry. All rights reserved.
//

#ifndef PathMacros_h
#define PathMacros_h

// 沙盒目录

#define kPathTemp                   NSTemporaryDirectory()
#define kPathDocument               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kPathCache                  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

// 业务相关沙盒文件目录

// 例如：
//#define kPathSearch                 [kPathDocument stringByAppendingPathComponent:@"Search.plist"]
//
//#define kPathMagazine               [kPathDocument stringByAppendingPathComponent:@"Magazine"]
//#define kPathDownloadedMgzs         [kPathMagazine stringByAppendingPathComponent:@"DownloadedMgz.plist"]


#endif /* PathMacros_h */
