//
//  UITextView+HKPlaceholder.m
//  century
//
//  Created by hooyking on 2018/11/21.
//  Copyright © 2018年 dadada. All rights reserved.
//

#import "UITextView+HKPlaceholder.h"

@implementation UITextView (HKPlaceholder)

-(void)setPlaceholder:(NSString *)placeholdStr placeholdColor:(UIColor *)placeholdColor
{
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.frame = CGRectMake(0, 0, self.bounds.size.width, 20);
    placeHolderLabel.text = placeholdStr;
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = placeholdColor;
    placeHolderLabel.font = [UIFont systemFontOfSize:14];
    [placeHolderLabel sizeToFit];
    
    if (@available(iOS 8.3, *)) {
        UILabel *placeholder = [self valueForKey:@"_placeholderLabel"];
        if (placeholder) {
            return;
        }
        [self addSubview:placeHolderLabel];
        [self setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
}

@end
