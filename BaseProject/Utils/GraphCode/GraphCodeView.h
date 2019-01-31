//
//  GraphCodeView.h
//  GraphCodeView-demo
//
//  Created by xjw on 16/4/11.
//  Copyright © 2016年 xjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphCodeView;

@protocol GraphCodeViewDelegate <NSObject>

//点击图形验证码
- (void)didTapGraphCodeView:(GraphCodeView *)graphCodeView;

@end

@interface GraphCodeView : UIView
@property (nonatomic,assign) BOOL isAutoGen;            // 是否自动生成 默认：YES；
@property (nonatomic,strong) NSString *codeStr;         // 接收外部传的code
@property (nonatomic,assign) id<GraphCodeViewDelegate> delegate;

@end
