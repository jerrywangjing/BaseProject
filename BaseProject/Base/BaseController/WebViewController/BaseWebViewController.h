//
//  BaseWebViewController.h
//
//  Created by JerryWang on 2017/9/29.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WKWebViewJavascriptBridge.h>

@protocol WebViewJSBridgeProtocol <NSObject>
@optional

// 跳转到xx页面
- (void)preJumpToXxxVCWithParams:(NSDictionary *)params;

@end

@interface BaseWebViewController : UIViewController

@property (nonatomic, strong) NSURL *url;
@property (nonatomic,strong,readonly) WKWebViewJavascriptBridge *bridge;   // 桥接对象

@property (nonatomic, assign) BOOL canPullRefresh;              // 默认：NO
@property (nonatomic, assign) CGRect webViewFrame;
@property (nonatomic,assign) BOOL isShowProgressBar;   // 默认：YES

/// 便利构造方法
- (instancetype)initWithUrl:(NSURL *)url;

#pragma mark - 与js交互接口

// 跳转到 k 线图页面
- (void)jumpToXxxVCWithParams:(NSDictionary *)data;

@end
