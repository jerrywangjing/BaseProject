//
//  UITextView+HKPlaceholder.h
//  century
//
//  Created by hooyking on 2018/11/21.
//  Copyright © 2018年 dadada. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (HKPlaceholder)

-(void)setPlaceholder:(NSString *)placeholdStr placeholdColor:(UIColor *)placeholdColor;

@end

NS_ASSUME_NONNULL_END
