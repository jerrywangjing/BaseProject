//
//  HMHealthRecordFormView.h
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/8/11.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat FormViewCellH = 50;

#define BTN_PLACEHOLDER_SELECT @"点击选择"
#define BTN_PLACEHOLDER_CHECK @"点击查看"

#define FORMVIEW_CUSTOM_KEY @"custom_key"
#define FORMVIEW_CUSTOM_TITLE @""


@class HMHealthRecordFormView;

typedef NS_ENUM(NSUInteger, FormViewState) {
    FormViewStateAdd,       // 添加
    FormViewStateModify,    // 修改
    FormViewStateCheck,     // 查看
};

typedef NS_ENUM(NSUInteger, HealthRecordFormCellType) {
    HealthRecordFormCellTypeField,      // 输入框样式  默认值
    HealthRecordFormCellTypeButton,     // btn样式
    HealthRecordFormCellTypeTextView,   // 文本框样式
    HealthRecordFormCellTypeCustom      // 自定义cell
};

@protocol HMHealthRecordFormViewDataSource <NSObject>

/* dataSource for formView */

// 返回模型的keys
- (NSArray *)modelKeysForHealthRecordFormView:(HMHealthRecordFormView *)formView;

@optional

- (UITableViewCell *)healthRecordFormView:(HMHealthRecordFormView *)formView customCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (HealthRecordFormCellType)formTypeOfRowsInHealthRecordFormView:(HMHealthRecordFormView *)fromView indePath:(NSIndexPath *)indexPath;
- (NSString *)healthRecordFormView:(HMHealthRecordFormView *)formView titleForHeaderInSection:(NSInteger)section;
- (NSString *)healthRecordFormView:(HMHealthRecordFormView *)formView titleForFooterInSection:(NSInteger)section;
- (CGFloat)healthRecordFormView:(HMHealthRecordFormView *)formView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol HMHealthRecordFormViewDelegate <NSObject>

@optional

- (void)configureInputField:(id)inputField ofCellType:(HealthRecordFormCellType)cellType indexPath:(NSIndexPath *)indexPath;
- (void)healthRecordFormView:(HMHealthRecordFormView *)formView didClickBtn:(UIButton *)btn;
- (void)healthRecordFormView:(HMHealthRecordFormView *)formView textFieldDidEndEditing:(UITextField *)textField;
- (void)healthRecordFormView:(HMHealthRecordFormView *)formView textViewDidEndEditing:(UITextView *)textView;

- (CGFloat)healthRecordFormView:(HMHealthRecordFormView *)formView heightForHeaderInSection:(NSInteger)section;
- (UIView *)healthRecordFormView:(HMHealthRecordFormView *)formView viewForHeaderInSection:(NSInteger)section;

- (CGFloat)healthRecordFormView:(HMHealthRecordFormView *)formView heightForFooterInSection:(NSInteger)section;
- (UIView *)healthRecordFormView:(HMHealthRecordFormView *)formView viewForFooterInSection:(NSInteger)section;

@end

@interface HMHealthRecordFormView : UIView

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleKey;         // 表单标题数据源

@property (nonatomic,strong) id dataModel;              // 自定义数据模型
@property (nonatomic,strong) NSDictionary *modelDic;    // 字典模型

@property (nonatomic,assign) BOOL showSeparator;        // 是否显示cell间隔线，默认：YES
@property (nonatomic,assign) BOOL canBounces;           // 是否开启弹跳效果 默认：YES
@property (nonatomic,assign) BOOL editEnable;           // 开启编辑状态，默认:NO

@property (nonatomic,weak) id<HMHealthRecordFormViewDelegate> delegate;
@property (nonatomic,weak) id<HMHealthRecordFormViewDataSource> dataSource;


- (void)reloadData;
/// 获取已输入的数据
- (NSMutableDictionary *)getInputData;
/// 根据输入框的索引，获取指定输入框中的值
- (NSString *)getFieldValueWithFieldIndex:(NSInteger)index fieldType:(HealthRecordFormCellType)type;

@end
