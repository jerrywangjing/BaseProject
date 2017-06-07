//
//  WJAlertTableView.h
//  AlertTableView
//
//  Created by hjtc on 16/5/25.
//  Copyright © 2016年 hjtc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TelListData;
@protocol WJAlertTableViewDelegate <NSObject>
// 发送短信代理方法
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients;
@end

@interface WJAlertTableView:UIView

// 数据模型
@property (nonatomic,strong) TelListData * data;
// 代理对象
@property (nonatomic,weak) id<WJAlertTableViewDelegate> delegate;

// 弹出视图
-(void)popAlertView;
// 关闭视图
-(void)dismissAlertView;
@end
