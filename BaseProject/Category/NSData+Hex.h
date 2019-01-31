//
//  NSData+Hex.h
//  CloudStorageApp
//
//  Created by JerryWang on 2018/6/21.
//  Copyright © 2018年 swzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Hex)

+ (NSData*)dataWithHexString:(NSString*)str;
+ (NSString*)hexStringWithData:(NSData*)data;

@end
