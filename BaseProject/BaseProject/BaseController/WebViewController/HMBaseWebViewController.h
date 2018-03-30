//
//  HMBaseWebViewController.h
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/9/29.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebViewJavascriptBridge.h>

@interface HMBaseWebViewController : UIViewController

@property (nonatomic, strong,readonly) NSURL *url;
@property (nonatomic,strong,readonly) WebViewJavascriptBridge *bridge;   // 桥接对象

@property (nonatomic, assign) BOOL canPullRefresh;              // 默认：NO

/// 便利构造方法
- (instancetype)initWithUrl:(NSURL *)url;


@end
