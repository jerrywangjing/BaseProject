//
//  NSData+XOR.m
//  CloudStorageApp
//
//  Created by wangjing on 2018/10/30.
//  Copyright © 2018年 swzh. All rights reserved.
//

#import "NSData+XOR.h"

@implementation NSData (XOR)

+ (NSData *)encodeData:(NSData *)sourceData withKeyData:(NSData *)keyData {
    
    Byte *keyBytes = (Byte *)[keyData bytes];           // 取关键字的Byte数组, keyBytes一直指向头部
    Byte *sourceDataPoint = (Byte *)[sourceData bytes];  //取需要加密的数据的Byte数组
    
    for (long i = 0; i < [sourceData length]; i++) {
        sourceDataPoint[i] = sourceDataPoint[i] ^ keyBytes[(i % [keyData length])]; //然后按位进行异或运算
    }
    
    return sourceData;
}

@end
