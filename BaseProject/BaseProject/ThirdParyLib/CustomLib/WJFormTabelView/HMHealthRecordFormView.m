//
//  HMHealthRecordFormView.m
//  everyoneIsHealthy
//
//  Created by JerryWang on 2017/8/11.
//  Copyright © 2017年 华美医信. All rights reserved.
//

#import "HMHealthRecordFormView.h"
#import "NSString+WJExtension.h"

#define TitleFont 16
#define ValueFont 15

@interface HMHealthRecordFormView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate>

@property (nonatomic,strong) NSMutableArray *textFields;  // 存放cell中初始化的textField
@property (nonatomic,assign) CGFloat maxTitleWidth;       // 最大的标题宽度
@property (nonatomic,copy) NSString *pageTitle;           // 页面标题
@property (nonatomic,strong) NSArray *modelKeys;          // 数据模型的key

@end

@implementation HMHealthRecordFormView

#pragma mark - getter

- (NSArray *)titleKey{
    if (!_titleKey) {
        _titleKey = [NSArray array];
    }
    return _titleKey;
}

- (NSArray *)modelKeys{
    if (!_modelKeys) {
        
        if ([self.dataSource respondsToSelector:@selector(modelKeysForHealthRecordFormView:)]) {
            _modelKeys = [self.dataSource modelKeysForHealthRecordFormView:self];
            
        }else{
            _modelKeys = [NSArray array];
        }
    }
    return _modelKeys;
}

- (NSMutableArray *)textFields{
    if (!_textFields) {
        _textFields = [NSMutableArray array];
    }
    return _textFields;
}

- (CGFloat)maxTitleWidth{
    if (_maxTitleWidth == 0) {
        
        // 动态计算title的宽度
        NSMutableArray *titleWidthArr = [NSMutableArray array];
        
        for (NSString *title in self.titleKey) {
            CGSize titleSize = [title sizeWithMaxSize:CGSizeMake(SCREEN_WIDTH/2, 50) fontSize:TitleFont];
            [titleWidthArr addObject:[NSNumber numberWithFloat:titleSize.width]];
        }
        
        _maxTitleWidth = [[titleWidthArr valueForKeyPath:@"@max.floatValue"] integerValue] + 10;
    }
    return _maxTitleWidth;
}

- (NSDictionary *)modelDic{
    if (!_modelDic) {
        _modelDic = [_dataModel yy_modelToJSONObject];
    }
    return _modelDic;
}

#pragma mark - setter

- (void)setEditEnable:(BOOL)editEnable{
    _editEnable = editEnable;
    if (editEnable) {
        for (UIView *field in _textFields) {
            if ([field isKindOfClass:[UIControl class]]) {
                UIControl *actionField = (UIControl *)field;
                actionField.enabled = YES;
            }
            if ([field isKindOfClass:[UITextView class]]) {
                UITextView *textView = (UITextView *)field;
                textView.editable = YES;
            }
        }
        UITextField *firstField = _textFields.firstObject;
        [firstField becomeFirstResponder];
        // 这里要处理一下代理的特殊处理
        [self.tableView reloadData];
    }else{
        for (UIView *field in _textFields) {
            if ([field isKindOfClass:[UIControl class]]) {
                UIControl *actionField = (UIControl *)field;
                actionField.enabled = NO;
            }
            if ([field isKindOfClass:[UITextView class]]) {
                UITextView *textView = (UITextView *)field;
                textView.editable = NO;
            }
        }
    }
}

- (void)setDataModel:(id)dataModel{
    _dataModel = dataModel;
    [self.tableView reloadData];
}

#pragma mark - init

- (void)dealloc{
    [self removePropertyObserver];
    [kNotificationCenter removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _canBounces = YES;
        _showSeparator = YES;
        
        [self setupTabelView];
        
        [kNotificationCenter addObserver:self selector:@selector(keyboardDidHideNoti) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

- (void)setupTabelView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor colorWithWhite:0.8 alpha:1];
    _tableView.bounces = _canBounces;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.tableFooterView = [UIView new];
    
    [self addSubview:_tableView];
}


- (void)setCanBounces:(BOOL)canBounces{
    _canBounces = canBounces;
    if (canBounces) {
        _tableView.bounces = YES;
    }else{
        _tableView.bounces = NO;
    }
}

- (void)setShowSeparator:(BOOL)showSeparator{
    _showSeparator = showSeparator;
    if (showSeparator) {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _tableView.frame = self.bounds;
}

#pragma mark - actions

- (void)keyboardDidHideNoti{
    NSDictionary *dic = [self getInputData]; // 刷新数据
    if (dic) {
        _modelDic = dic;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (_dataModel) {
        return;
    }
    if ([object isKindOfClass:[UILabel class]] && [keyPath isEqualToString:@"text"]) {
        NSDictionary *dic = [self getInputData];
        if (dic) {
            _modelDic = dic;
        }
    }
}

#pragma mark - public

- (void)reloadData{
    
    _modelDic = [_dataModel yy_modelToJSONObject];
    [self.tableView reloadData];
}
    
- (NSMutableDictionary *)getInputData{
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    
    for (NSInteger i = 0; i<self.modelKeys.count; i++) {
        
        NSString *key = self.modelKeys[i];
        
        NSString *value = @"";
        
        id valueField = nil;
        
        if (i < self.textFields.count) { // 保护
            valueField = self.textFields[i];
        }else{
            break;
        }
        
        if ([valueField isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)valueField;
            if ([btn.titleLabel.text isEqualToString:BTN_PLACEHOLDER_SELECT] ||
                [btn.titleLabel.text isEqualToString:BTN_PLACEHOLDER_CHECK]) {
                value = @"";
            }else{
                value = btn.titleLabel.text;
            }
        }
        if ([valueField isKindOfClass:[UITextField class]]) {
            UITextField *field = (UITextField *)valueField;
            value = field.text;
        }
        if ([valueField isKindOfClass:[UITextView class]]) {
            UITextView *textView = (UITextView *)valueField;
            value = textView.text;
        }
        if (![key isEqualToString:FORMVIEW_CUSTOM_KEY]) {
            [dataDic setObject:value forKey:key];
        }
    }
    
    // 校验是否所填字段都为空
    
    return dataDic;
}

- (NSString *)getFieldValueWithFieldIndex:(NSInteger)index fieldType:(HealthRecordFormCellType)type{
    
    if (index == NSNotFound) {
        return nil;
    }
    
    if (type == HealthRecordFormCellTypeButton) {
        UIButton *field = (UIButton *)self.textFields[index];
        return field.currentTitle;
    }
    
    if (type == HealthRecordFormCellTypeField) {
        UITextField *field = (UITextField *)self.textFields[index];
        return field.text;
    }
    
    if (type == HealthRecordFormCellTypeTextView) {
        UITextView *field = (UITextView *)self.textFields[index];
        return field.text;
    }
    return nil;
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleKey.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // cell type
    HealthRecordFormCellType cellType = HealthRecordFormCellTypeField;
    
    if ([self.dataSource respondsToSelector:@selector(formTypeOfRowsInHealthRecordFormView:indePath:)]) {
         cellType = [self.dataSource formTypeOfRowsInHealthRecordFormView:self indePath:indexPath];
        
    }
    
    // cell
    UITableViewCell *cell = nil;

    switch (cellType) {
        case HealthRecordFormCellTypeField:
            cell = [self creatTextFieldCellWithTitle:self.titleKey[indexPath.row] index:indexPath.row];
            break;
        case HealthRecordFormCellTypeButton:
            cell = [self creatBtnCellWithTitle:self.titleKey[indexPath.row] index:indexPath.row];
            break;
        case HealthRecordFormCellTypeTextView:
            cell = [self creatTextViewCellWithTitle:self.titleKey[indexPath.row] index:indexPath.row];
            break;
        case HealthRecordFormCellTypeCustom:{
            if ([self.dataSource respondsToSelector:@selector(healthRecordFormView:customCellForRowAtIndexPath:)]) {
                cell = [self.dataSource healthRecordFormView:self customCellForRowAtIndexPath:indexPath];
                [self.textFields addObject:[NSObject new]];// 当是自定义cell时这里需要添加一个占位对象，不然获取数据时会错乱
            }
        }
            
            break;
        default:
            cell = [UITableViewCell new];
            break;
    }
    
    // 配置cell 子控件属性
    if ([self.delegate respondsToSelector:@selector(configureInputField:ofCellType:indexPath:)]) {
        [self.delegate configureInputField:self.textFields[indexPath.row] ofCellType:cellType indexPath:indexPath];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([self.dataSource respondsToSelector:@selector(healthRecordFormView:titleForHeaderInSection:)]) {
        return [self.dataSource healthRecordFormView:self titleForHeaderInSection:section];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    
    if ([self.dataSource respondsToSelector:@selector(healthRecordFormView:titleForFooterInSection:)]) {
        return [self.dataSource healthRecordFormView:self titleForFooterInSection:section];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.dataSource respondsToSelector:@selector(healthRecordFormView:heightForRowAtIndexPath:)]) {
        return [self.dataSource healthRecordFormView:self heightForRowAtIndexPath:indexPath];
    }
    return FormViewCellH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(healthRecordFormView:heightForHeaderInSection:)]) {
        return [self.delegate healthRecordFormView:self heightForHeaderInSection:section];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(healthRecordFormView:heightForFooterInSection:)]) {
        return [self.delegate healthRecordFormView:self heightForFooterInSection:section];
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(healthRecordFormView:viewForHeaderInSection:)]) {
        return [self.delegate healthRecordFormView:self viewForHeaderInSection:section];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(healthRecordFormView:viewForFooterInSection:)]) {
        return [self.delegate healthRecordFormView:self viewForFooterInSection:section];
    }
    return nil;
}

// cell分割线边缘对齐

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

#pragma mark - textField delegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([self.delegate respondsToSelector:@selector(healthRecordFormView:textFieldDidEndEditing:)]) {
        [self.delegate healthRecordFormView:self textFieldDidEndEditing:textField];
    }
}

#pragma mark - textView delegate

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(healthRecordFormView:textFieldDidEndEditing:)]) {
        [self.delegate healthRecordFormView:self textViewDidEndEditing:textView];
    }
}

#pragma mark - private


- (UITableViewCell *)creatTextFieldCellWithTitle:(NSString *)title index:(NSInteger)index{
    
    static NSString *textFieldCellId = @"textFieldCellId";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:textFieldCellId];
    
    UITextField *textField = nil;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textFieldCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // title
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = title;
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:titleLabel];
        
        // layout
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(10);
            make.width.mas_equalTo(self.maxTitleWidth);
            make.centerY.equalTo(cell.contentView);
        }];
        
        // textField
        
        textField = [[UITextField alloc] init];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = @"点击输入";
        textField.textAlignment = NSTextAlignmentCenter;
        textField.tag = index;
        textField.font = [UIFont systemFontOfSize:ValueFont];
        textField.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 5;
        textField.layer.masksToBounds = YES;
        textField.delegate = self;
        textField.enabled = _editEnable ? YES:NO;
        [cell.contentView addSubview:textField];
        [self.textFields addObject:textField];
        
        // layout
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(5);
            make.right.equalTo(cell.contentView).offset(-15);
            make.centerY.equalTo(cell.contentView);
            make.height.mas_equalTo(35);
        }];
    }
    
    // 如果已有模型时，需要赋值（查看和修改模式下）
    NSString *key = self.modelKeys[index];
    NSString *value = self.modelKeys ? self.modelDic[key] : nil;
    
    if (!textField) {   // 先创建视图再赋值的情况时
        textField = self.textFields[index];
    }
    textField.text = value;
    
    return cell;
}

- (UITableViewCell *)creatTextViewCellWithTitle:(NSString *)title index:(NSInteger)index{
    
    static NSString *textViewCellId = @"textViewCellId";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:textViewCellId];
    
    UITextView *textView = nil;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textViewCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // title
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = title;
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:titleLabel];
        
        // layout
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(10);
            make.width.mas_equalTo(self.maxTitleWidth);
            make.centerY.equalTo(cell.contentView);
        }];
        
        // textField
        
        textView = [[UITextView alloc] init];
        textView.tag = index;
        textView.font = [UIFont systemFontOfSize:ValueFont];
        textView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        textView.layer.borderWidth = 1;
        textView.layer.cornerRadius = 5;
        textView.layer.masksToBounds = YES;
        textView.delegate = self;
        textView.editable = _editEnable ? YES:NO;
        
        [cell.contentView addSubview:textView];
        [self.textFields addObject:textView];
        
        // layout
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(5);
            make.right.equalTo(cell.contentView).offset(-15);
            make.topMargin.mas_equalTo(10);
            make.bottomMargin.mas_equalTo(-10);
        }];
    }
    
    // 如果已有模型时，需要赋值（查看和修改模式下）
    NSString *key = self.modelKeys[index];
    NSString *value = self.modelKeys ? self.modelDic[key] : nil;
    if (!textView) {   // 先创建视图再赋值的情况时
        textView = self.textFields[index];
    }
    textView.text = value;
    
    return cell;
}

- (UITableViewCell *)creatBtnCellWithTitle:(NSString *)title index:(NSInteger)index{
    
    static NSString *btnCellId = @"btnCellId";
    
    UIButton *btn = nil;
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:btnCellId];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:btnCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // title
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = title;
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:titleLabel];
        
        // layout
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(10);
            make.width.mas_equalTo(self.maxTitleWidth);
            make.centerY.equalTo(cell.contentView);
        }];
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setTitle:BTN_PLACEHOLDER_SELECT forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:ValueFont];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        btn.layer.borderWidth = 1.0;
        btn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.tag = index;
        
        btn.enabled = _editEnable ? YES:NO;
        [cell.contentView addSubview:btn];
        [self.textFields addObject:btn];
        
        // layout
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(5);
            make.right.equalTo(cell.contentView).offset(-15);
            make.centerY.equalTo(cell.contentView);
            make.height.mas_equalTo(35);
        }];
    }
    
    // 如果已有模型时，需要赋值（查看和修改模式下）
    NSString *key = self.modelKeys[index];
    NSString *value = self.modelKeys ? self.modelDic[key] : nil;
    
    if (!btn) {   // 先创建视图再赋值的情况时
        btn = self.textFields[index];
    }
    
    if (value.length > 0) {
        [btn setTitle:value forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        [btn setTitle:BTN_PLACEHOLDER_SELECT forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(healthRecordFormView:didClickBtn:)]) {
        [self.delegate healthRecordFormView:self didClickBtn:btn];
    }
}

// 移除属性观察者

- (void)removePropertyObserver{
    
    for (UIControl *field in self.textFields) {
        if ([field isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)field;
            [btn.titleLabel removeObserver:self forKeyPath:@"text"];
        }
    }
}
@end
