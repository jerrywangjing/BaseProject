//
//  HomeViewController.m
//  BaseProject
//
//  Created by JerryWang on 2018/3/28.
//  Copyright © 2018年 JerryWang. All rights reserved.
//

#import "HomeViewController.h"
#import "WJAlertSheetView.h"
#import "BaseWebViewController.h"
#import "WJSysDatePickerView.h"
#import "HMPopView.h"
#import "TestViewController.h"

typedef NS_ENUM(NSUInteger, ShowViewType) {
    ShowViewTypeAlertSheetView,
    ShowViewTypeAlertSheetMultiView,
    ShowViewTypePopView,
    ShowViewTypeWebview,
    ShowViewTypeDatePickerView,
    ShowViewTypeTest
};


@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"主页";
    
    [self setupSubviews];
    [self loadData];
}

- (void)setupSubviews{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    
    [self.view addSubview:self.tableView];
}

- (void)loadData{
    _dataSource = @[@"AlertSheetView",@"AlertMultiSheetView",@"PopView",@"WebView",@"DataPickerView",@"TestBtn"];
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case ShowViewTypeAlertSheetView:
            [WJAlertSheetView showAlertSheetViewWithTips:nil items:@[@"item1",@"item2",@"item3"] cancel:nil completion:^(NSString *selectedValue, NSInteger index, UIButton *item) {
                NSLog(@"点击了:%@",selectedValue);
            }];
            break;
        case ShowViewTypeAlertSheetMultiView:
            [WJAlertSheetView showAlertMultiSheetViewWithTips:nil items:@[@"多选1",@"多选2",@"多选3",@"多选4"] completion:^(NSString *selectedValue, NSInteger index, UIButton *item) {
                NSLog(@"选择了：%@",selectedValue);
            }];
            break;
        case ShowViewTypePopView:{
            HMPopView *popView = [[HMPopView alloc] initWithFrame:self.view.bounds containerViewFrame:CGSizeMake(self.view.width, 250)];
            popView.titleLabel.text = @"提示popView";
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
            label.text = @"自定义内容请在这里添加...";
            label.center = popView.center;
            
            [popView.contentView addSubview:label];
            
            [popView showPopView];
            
        }
            break;
        case ShowViewTypeWebview:{
         
            BaseWebViewController *webview  = [[BaseWebViewController alloc] initWithUrl:[NSURL URLWithString:@"https://www.baidu.com"]];
            
            [self.navigationController pushViewController:webview animated:YES];
        }
            break;
        case ShowViewTypeDatePickerView:
            [WJSysDatePickerView showSystemDatePickerViewWithMode:UIDatePickerModeDate confirmCallBack:nil cancelCallback:nil];
            break;
        case ShowViewTypeTest:
            [self.navigationController pushViewController:[TestViewController new] animated:YES];
            self.statusBarStyle = !self.statusBarStyle;
            
        default:
            break;
    }
}


@end