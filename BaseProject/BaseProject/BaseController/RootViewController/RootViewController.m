//
//  RootViewController.m
//  BaseProject
//
//  Created by JerryWang on 2017/5/30.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@property (nonatomic,strong) UIImageView* noDataView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //是否显示返回按钮
    self.isShowLiftBack = YES;
}
#pragma mark ————— 跳转登录界面 —————
- (void)goLogin
{
    // 跳转到登录页面
}


- (void)showShouldLoginPoint{
    
}

- (void)showLoadingAnimation
{
    
}

- (void)stopLoadingAnimation
{
    
}

-(void)showNoDataImage
{
    _noDataView=[[UIImageView alloc] init];
    [_noDataView setImage:[UIImage imageNamed:@"generl_nodata"]];
    [self.view.subviews enumerateObjectsUsingBlock:^(UITableView* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            [_noDataView setFrame:CGRectMake(0, 0,obj.frame.size.width, obj.frame.size.height)];
            [obj addSubview:_noDataView];
        }
    }];
}

-(void)removeNoDataImage{
    if (_noDataView) {
        [_noDataView removeFromSuperview];
        _noDataView = nil;
    }
}

/**
 *  是否显示返回按钮
 */
- (void) setIsShowLiftBack:(BOOL)isShowLiftBack
{
    _isShowLiftBack = isShowLiftBack;
    if (isShowLiftBack) {
        //        [self.navigationItem setHidesBackButton:YES];
        //        [self.navigationItem.backBarButtonItem setTitle:@""];
        
        [self addNavigationItemWithTitles:@[@"返回"] isLeft:YES target:self action:@selector(backBtnClicked) tags:nil];
        
        //        [self addNavigationItemWithImageNames:@[@"quanju_return"] isLeft:YES target:self action:@selector(backBtnClicked) tags:nil];
        
    } else {
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem * NULLBar=[[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
        self.navigationItem.leftBarButtonItem = NULLBar;
    }
}
- (void)backBtnClicked
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    NSMutableArray * items = [[NSMutableArray alloc] init];
    NSInteger i = 0;
    for (NSString * imageName in imageNames) {
        //        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        //        backView.backgroundColor=RedColor;
        //        backView.userInteractionEnabled=YES;
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [backView addSubview:btn];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 30, 30);
        if(isLeft){
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        }else{
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
            
        }
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        btn.tag = [tags[i++] integerValue];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}

- (void)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    NSMutableArray * items = [[NSMutableArray alloc] init];
    
    NSInteger i = 0;
    for (NSString * title in titles) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, 0, 30, 20);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.tag = [tags[i++] integerValue];
        [btn sizeToFit];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}

//取消请求
- (void)cancelRequest
{
    
}

- (void)dealloc
{
    [self cancelRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
