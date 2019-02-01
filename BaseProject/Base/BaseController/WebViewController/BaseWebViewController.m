//
//  BaseWebViewController.m
//
//  Created by JerryWang on 2017/9/29.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "BaseWebViewController.h"
#import <WebKit/WebKit.h>

#define WJRGBColor(R,G,B)  [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1.0f]

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define NAVI_HEIGHT (iPhoneX ? 88.f : 64.f)

@interface BaseWebViewController ()<UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) WKWebView *wk_WebView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *closeBarButtonItem;
@property (nonatomic, weak)   id <UIGestureRecognizerDelegate>delegate;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIProgressView *loadingProgressView;
@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic,strong) WKWebViewJavascriptBridge *bridge;   // 桥接对象

@end

@implementation BaseWebViewController

- (instancetype)initWithUrl:(NSURL *)url{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _url = url;
        _isShowProgressBar = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (CGRectEqualToRect(_webViewFrame, CGRectZero) || CGRectEqualToRect(_webViewFrame, CGRectNull)) {
        
        CGFloat y = self.navigationController ? NavBarH : 0;
        
        CGFloat height = self.navigationController.viewControllers.count > 1 ? self.view.bounds.size.height - y : self.view.bounds.size.height-y-TabBarH;
        _webViewFrame = CGRectMake(0, y, self.view.bounds.size.width,height);
    }
    
    [self createWebView];
    [self createNaviItem];
    [self createJSBridge]; // 设置桥接库
    
    [self setupAndShowIndicatorView];
    
    // 加载web请求
    [self loadRequest];
    
}

- (void)setupAndShowIndicatorView{
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView = indicator;
    [self.view addSubview:indicator];
    [self.view bringSubviewToFront:indicator];
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    // start
    [indicator startAnimating];
}

#pragma mark 版本适配

- (void)createWebView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.reloadButton];
    
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0) {
        [self.view addSubview:self.wk_WebView];
        if (_isShowProgressBar) {
            [self.view addSubview:self.loadingProgressView];
        }
    } else {
        [self.view addSubview:self.webView];
    }
}

- (UIWebView*)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:_webViewFrame];
        _webView.delegate = self;
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 10.0 && _canPullRefresh) {
            if (@available(iOS 10.0, *)) {
                _webView.scrollView.refreshControl = self.refreshControl;
            } else {
                // Fallback on earlier versions
            };
        }
    }
    return _webView;
}

- (WKWebView*)wk_WebView {
    if (!_wk_WebView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        config.preferences = [[WKPreferences alloc]init];
        config.userContentController = [[WKUserContentController alloc]init];
        _wk_WebView = [[WKWebView alloc]initWithFrame:_webViewFrame configuration:config];
        _wk_WebView.navigationDelegate = self;
        _wk_WebView.UIDelegate = self;
        //添加此属性可触发侧滑返回上一网页与下一网页操作
        _wk_WebView.allowsBackForwardNavigationGestures = YES;
        //下拉刷新
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 10.0 && _canPullRefresh) {
            if (@available(iOS 10.0, *)) {
                _wk_WebView.scrollView.refreshControl = self.refreshControl;
            } else {
                // Fallback on earlier versions
            }
        }
        //进度监听
        [_wk_WebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        
        // 添加代理标识
        
        NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *version = infoDic[@"CFBundleShortVersionString"];
        
        // Native_iOS Native_BundleId:xxx Native_V1.0
        
        _wk_WebView.customUserAgent = [NSString stringWithFormat:@"iphone Native_iOS Native_BundleId:%@ Native_V%@",bundleId,version];
    }
    return _wk_WebView;
}

// 监听的网页进度值变化回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        CGFloat progress = [change[NSKeyValueChangeNewKey] floatValue];
        [_loadingProgressView setProgress:progress animated:YES];
        
        if (_loadingProgressView.progress == 1.0) {
            
            [UIView animateWithDuration:0.3 animations:^{
                self.loadingProgressView.alpha = 0;
                
            } completion:^(BOOL finished) {
                _loadingProgressView.hidden = YES;
                _loadingProgressView.progress = 0.0f;
            }];
        }
    }
}

- (void)dealloc {
    
    [_wk_WebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_wk_WebView stopLoading];
    [_webView stopLoading];
    _wk_WebView.UIDelegate = nil;
    _wk_WebView.navigationDelegate = nil;
    _webView.delegate = nil;
    
    if ([UIApplication sharedApplication].isNetworkActivityIndicatorVisible) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}


- (UIProgressView*)loadingProgressView {
    if (!_loadingProgressView) {
        _loadingProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, self.view.bounds.size.width, 2)];
        _loadingProgressView.progressViewStyle = UIProgressViewStyleBar;    //进度条的宽度是根据样式来变化的，设置width无效
        _loadingProgressView.progressTintColor = WJRGBColor(0, 190, 17);    // 进度值背景颜色
        _loadingProgressView.trackTintColor = [UIColor clearColor];         // 进度条背景颜色
    }
    return _loadingProgressView;
}

- (UIRefreshControl*)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc]init];
        [_refreshControl addTarget:self action:@selector(webViewReload) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (void)webViewReload {
    [_webView reload];
    [_wk_WebView reload];
}

- (UIButton*)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.frame = CGRectMake(0, 0, 50, 50);
        _reloadButton.center = self.view.center;
        
        [_reloadButton setBackgroundImage:[UIImage imageNamed:@"no_network_icon"] forState:UIControlStateNormal];
        [_reloadButton setTitle:@"网页地址或网络异常，请进行相关检查" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_reloadButton setTitleEdgeInsets:UIEdgeInsetsMake(130, -50, 0, -50)];
        _reloadButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _reloadButton.titleLabel.numberOfLines = 0;
        _reloadButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        CGRect rect = _reloadButton.frame;
        rect.origin.y -= 100;
        _reloadButton.frame = rect;
        _reloadButton.enabled = NO;
    }
    return _reloadButton;
}

- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView = indicator;
        indicator.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        [self.view addSubview:indicator];
        //        [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.center.equalTo(self.view);
        //        }];
    }
    return _indicatorView;
}

#pragma mark 导航按钮
- (void)createNaviItem {
    
    [self showLeftBarButtonItem];
    [self showRightBarButtonItem];
}

- (void)showLeftBarButtonItem {
    
    if ([_webView canGoBack] || [_wk_WebView canGoBack] || self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = self.backBarButtonItem;
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)showRightBarButtonItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(webViewReload)];
}

- (UIBarButtonItem*)backBarButtonItem {
    if (!_backBarButtonItem) {
        
        _backBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navbar_back"]style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem*)closeBarButtonItem {
    if (!_closeBarButtonItem) {
        _closeBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
    }
    return _closeBarButtonItem;
}

- (void)back:(UIBarButtonItem*)item {
    if ([_webView canGoBack] || [_wk_WebView canGoBack]) {
        [_webView goBack];
        [_wk_WebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)close:(UIBarButtonItem*)item {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 自定义导航按钮支持侧滑手势处理

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count > 1) {
        
        self.delegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    if (self.navigationController.navigationBar.isHidden) {
        [self.navigationController setNavigationBarHidden:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self.delegate;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

#pragma mark 加载请求
- (void)loadRequest {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        [_wk_WebView loadRequest:request];
    } else {
        [_webView loadRequest:request];
    }
}

#pragma mark - 初始化桥接对象

- (void)createJSBridge{
    
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wk_WebView];
    [WKWebViewJavascriptBridge enableLogging];
    [_bridge setWebViewDelegate:self];
    
    
    // 注册js方法
    // 测试js方法： jumpToNativeKlineVc
    
    [self.bridge registerHandler:@"jumpToNativeKlineVc" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"js response kline: %@", data);
        [self jumpToXxxVCWithParams:data];
        if (responseCallback) { // 反馈给JS
            responseCallback(@{@"state": @"200"});
        }
    }];
}

// 子类实现具体功能逻辑

- (void)jumpToXxxVCWithParams:(NSDictionary *)data{
    NSLog(@"base jump kline");
    
    
    // 测试 买入，卖出 逻辑
    
    //    CGCoinInfoModel *coinInfo = [CGCoinInfoModel new];
    //    coinInfo.coinName = @"btc_usdt";
    //    coinInfo.coinDisplayName = @"BTC/USDT";
    //
    //    WeakSelf(weakSelf);
    //
    //    KLineVC *kline = [[KLineVC alloc] init];
    //    kline.coinInfo = coinInfo;
    //    kline.didClickBuyBtn = ^(NSString *coinName) {
    //
    //        NSLog(@"buy click:%@",coinName);
    //        [weakSelf.bridge callHandler:@"clickBuy" data:@{@"coinName" : @"btc_usdt"} responseCallback:^(id responseData) {
    //            NSLog(@"buy 返回：%@",responseData);
    //        }];
    //    };
    //    kline.didClickSellBtn = ^(NSString *coinName) {
    //
    //        NSLog(@"sell click:%@",coinName);
    //        [weakSelf.bridge callHandler:@"clickSell" data:@{@"coinName" : @"btc_usdt"} responseCallback:^(id responseData) {
    //            NSLog(@"sell 返回：%@",responseData);
    //        }];
    //    };
    //
    //    RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:kline];
    //    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark WebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    webView.hidden = NO;
    // 不加载空白网址
    if ([request.URL.scheme isEqual:@"about"]) {
        webView.hidden = YES;
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //导航栏配置
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self showLeftBarButtonItem];
    [_refreshControl endRefreshing];
    
    [self.indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    webView.hidden = YES;
    [self.indicatorView stopAnimating];
}

#pragma mark WKNavigationDelegate

#pragma mark 加载状态回调

//页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    webView.hidden = NO;
    _loadingProgressView.hidden = NO;
    _loadingProgressView.alpha = 1.0;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if ([webView.URL.scheme isEqual:@"about"]) {
        webView.hidden = YES;
    }
}

//页面加载完成

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    // 设置导航栏标题
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        self.navigationItem.title = title;
    }];
    
    // 更新网络状态
    [self showLeftBarButtonItem];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [_refreshControl endRefreshing];
    
    [self.indicatorView stopAnimating];
}

//页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    webView.hidden = YES;
    [self.indicatorView stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//HTTPS认证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

// 当js要弹出alert 警告框时会回调这个方法

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

// 当js要弹出确认框时会回调这个方法

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 当js要弹出文本输入框时会回调这个方法

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
