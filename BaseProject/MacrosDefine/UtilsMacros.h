//
//  macros.h
//  AppForTemplate
//
//  Created by jerry on 2017/5/26.
//  Copyright © 2017年 jerry. All rights reserved.
// note : 通用宏定义

//应用级单例对象

#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kAppDelegate        [AppDelegate sharedAppDelegate]
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

// 屏幕宽高

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define SCREEN_BOUNDS   [UIScreen mainScreen].bounds
#define WIDTH_RATE (kScreenWidth/375)   // 宽高系数（以4.7英寸为基准）
#define HEIGHT_RATE (kScreenHeight/667)

// iPhoneX 适配相关代码
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define NavBarH (iPhoneX ? 88.f : 64.f)
// tabBar高度
#define TabBarH (iPhoneX ? (49.f+34.f) : 49.f)
// home indicator 高度
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)

#define iPhoneXTopMargin 24         // 相对其他机型顶部高出来的距离
#define iPhoneXBottomMargin  34     // 相对其他机型底部高出来的距离
#define SearchBarH 56

// 机型、系统版本判断

#define IPhone4_0       [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f

#define IPhone4_7       [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f

#define IPhone5_5        [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f


#define IOS7_LATER       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define IOS8_LATER      ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define IOS9_LATER      ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

#define IOS10_LATER     ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

#define CurrentSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]       // 获取当前系统版本

#define CurrentLanguage (NSLocale preferredLanguages] objectAtIndex:0])//当前语言

// 强、弱引用

#define WeakSelf(weakSelf) __weak typeof(&*self) weakSelf = self;
#define StrongSelf(strongSelf) __strong typeof(&*self) strongSelf = weakSelf;

// 日志打印

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"class:%s line:%d msg:%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

// 字体

#define BOLD_FONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEM_FONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define CUSTOM_FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]

// 颜色
#define RGB(r,g,b)      RGBA(r,g,b,1.0f)
#define RGBA(r,g,b,a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define HexRGB(c)       HexRGBA(c,1.0f)
#define HexRGBA(c,a)     [UIColor colorWithRed:((c>>16)&0xFF)/256.0  green:((c>>8)&0xFF)/256.0   blue:((c)&0xFF)/256.0   alpha:a] // 16进制色值
#define RandomColor     [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]

// 判断真机还是模拟器

#if TARGET_OS_IPHONE
// iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
// iPhone Simulator
#endif

// 数据保护

#define SafeStr(f) (ValidStr(f) ? f : @"")
#define SafeArr(f) (ValidArray(f) ? f : @[])
#define SafeDic(f) (ValidDict(f) ? f :@{})

// 数据验证

#define ValidStr(f) (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define ValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]])
#define ValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]])
#define ValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
#define ValidData(f) (f!=nil && [f isKindOfClass:[NSData class]])

// 格式化字符串
#define NSURLFormat(path) [URL_base stringByAppendingString:path]
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

