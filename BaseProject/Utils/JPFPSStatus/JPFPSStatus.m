//
//  JPFPSStatus.m
//  JPFPSStatus
//
//  Created by coderyi on 16/6/4.
//  Copyright © 2016年 http://coderyi.com . All rights reserved.
//  @ https://github.com/joggerplus/JPFPSStatus

#import "JPFPSStatus.h"

#define WJRGBAColor(r,g,b,a)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]


@interface JPFPSStatus (){
    CADisplayLink *displayLink;
    NSTimeInterval lastTime;
    NSUInteger count;
}
@property(nonatomic,copy) void (^fpsHandler)(NSInteger fpsValue);

@end

@implementation JPFPSStatus
@synthesize fpsLabel;

- (void)dealloc {
    [displayLink setPaused:YES];
    [displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

+ (JPFPSStatus *)sharedInstance {
    static JPFPSStatus *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JPFPSStatus alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationDidBecomeActiveNotification)
                                                     name: UIApplicationDidBecomeActiveNotification
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationWillResignActiveNotification)
                                                     name: UIApplicationWillResignActiveNotification
                                                   object: nil];
        
        // Track FPS using display link
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
        [displayLink setPaused:YES];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        // fpsLabel
        fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 50, 20)];
        fpsLabel.font=[UIFont boldSystemFontOfSize:12];
        fpsLabel.textColor=WJRGBAColor(69, 188, 61,1);
        fpsLabel.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.5];
        fpsLabel.textAlignment=NSTextAlignmentCenter;
        fpsLabel.layer.cornerRadius = 5;
        fpsLabel.layer.masksToBounds = YES;
        fpsLabel.tag=101;

    }
    return self;
}

- (void)displayLinkTick:(CADisplayLink *)link {
    if (lastTime == 0) {
        lastTime = link.timestamp;
        return;
    }
    
    count++;
    NSTimeInterval interval = link.timestamp - lastTime;
    if (interval < 1) return;
    lastTime = link.timestamp;
    float fps = count / interval;
    count = 0;
    
    NSString *text = [NSString stringWithFormat:@"%d FPS",(int)round(fps)];
    [fpsLabel setText: text];
    
    if (fps >= 55 && fps <= 60) {
        [fpsLabel setTextColor:WJRGBAColor(69, 188, 61, 1)];
    }else if (fps >= 50 && fps <= 55){
        [fpsLabel setTextColor:[UIColor orangeColor]];
    }else{
        [fpsLabel setTextColor:[UIColor redColor]];
    }

    if (_fpsHandler) {
        _fpsHandler((int)round(fps));
    }
    
}

- (void)open {
    
    NSArray *rootVCViewSubViews=[[UIApplication sharedApplication].delegate window].rootViewController.view.subviews;
    for (UIView *label in rootVCViewSubViews) {
        if ([label isKindOfClass:[UILabel class]]&& label.tag==101) {
            return;
        }
    }

    [displayLink setPaused:NO];
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:fpsLabel];
}

- (void)openWithHandler:(void (^)(NSInteger fpsValue))handler{
    [[JPFPSStatus sharedInstance] open];
    _fpsHandler=handler;
}

- (void)close {
    
    [displayLink setPaused:YES];

    NSArray *rootVCViewSubViews=[[UIApplication sharedApplication].delegate window].rootViewController.view.subviews;
    for (UIView *label in rootVCViewSubViews) {
        if ([label isKindOfClass:[UILabel class]]&& label.tag==101) {
            [label removeFromSuperview];
            return;
        }
    }
}

- (void)applicationDidBecomeActiveNotification {
    [displayLink setPaused:NO];
}

- (void)applicationWillResignActiveNotification {
    [displayLink setPaused:YES];
}

@end
