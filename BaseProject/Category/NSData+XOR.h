//
//  NSData+XOR.h
//  CloudStorageApp
//
//  Created by wangjing on 2018/10/30.
//  Copyright © 2018年 swzh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (XOR)


/**
 异或运算

 @param sourceData 源数据
 @param keyData 需要异或的值
 @return 结果数据
 */
+ (NSData *)encodeData:(NSData *)sourceData withKeyData:(NSData *)keyData;
    
@end

NS_ASSUME_NONNULL_END
