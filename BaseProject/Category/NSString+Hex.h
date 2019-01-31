//
//  NSString+hex.h
//  CloudStorageApp
//
//  Created by JerryWang on 2018/6/15.
//  Copyright © 2018年 swzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Hex)

/**
 十六进制字符串转二进制字符串
 */
+ (NSString *)getBinaryByHex:(NSString *)hex;

/// 10进制转16进制字符串
+ (NSString *)ToHex:(long long int)tmpid;

@end
