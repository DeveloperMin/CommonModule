//
//  TXBYInputCell.m
//  TXBYKit
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYInputCell.h"
#import "TXBYInputItem.h"
#import "TXBYInputLabelItem.h"
#import "TXBYInputFieldItem.h"
#import "TXBYInputDateItem.h"
#import "TXBYInputPickerItem.h"
#import "TXBYAccessoryView.h"
#import "TXBYCategory.h"
#import "TXBYTextField.h"

@interface TXBYInputCell () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

/**
 *  标题
 */
@property (nonatomic, weak) UILabel *titleLabel;

/**
 *  子标题（普通文本）
 */
@property (nonatomic, weak) UILabel *subtitleLabel;

/**
 *  子标题（输入框）
 */
@property (nonatomic, weak) UITextField *textField;

/**
 *  子标题（下拉选择）
 */
@property (nonatomic, weak) TXBYTextField *selectField;

/**
 *  子标题（日期选择）
 */
@property (nonatomic, weak) TXBYTextField *dateField;

/**
 *  箭头视图
 */
@property (nonatomic, strong) UIImageView *arrowView;

/**
 *  日期选择
 */
@property (nonatomic, strong) UIDatePicker *datePicker;

/**
 *  日期选择工具条
 */
@property (nonatomic, strong) TXBYAccessoryView *dateToolbar;

/**
 *  选择框
 */
@property (nonatomic, strong) UIPickerView *pickerView;

/**
 *  选择框工具条
 */
@property (nonatomic, strong) TXBYAccessoryView *pickerToolBar;

/**
 *  记录UIPickerView中component的选中索引
 *  0 第一个component索引
 *  1 第二个component索引
 *  n 第n个component索引
 */
@property (nonatomic, strong) NSMutableArray *pickerIndexs;

/**
 *  根据item中的code是否在数据源中找到相同的code
 */
@property (nonatomic, assign) BOOL find;

@end

@implementation TXBYInputCell

#pragma mark - getters
/**
 *  component的选中索引
 */
- (NSMutableArray *)pickerIndexs {
    if (!_pickerIndexs) {
        _pickerIndexs = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            _pickerIndexs[i] = @0;
        }
    }
    return _pickerIndexs;
}

/**
 *  日期选择工具条
 */
- (TXBYAccessoryView *)dateToolbar {
    if (!_dateToolbar) {
        _dateToolbar = [TXBYAccessoryView accessoryViewWithTarget:self action:@selector(dateClick:)];
    }
    return _dateToolbar;
}

/**
 *  日期选择
 */
- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, 0, 0)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.backgroundColor = [UIColor whiteColor];
    }
    return _datePicker;
}

/**
 *  选择框工具条
 */
- (TXBYAccessoryView *)pickerToolBar {
    if (!_pickerToolBar) {
        _pickerToolBar = [TXBYAccessoryView accessoryViewWithTarget:self action:@selector(buttonClick:)];
    }
    return _pickerToolBar;
}

/**
 *  选择框
 */
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView= [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

/**
 *  获取标题
 */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [UILabel txby_label];
        [self.contentView addSubview:titleLabel];
        titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

/**
 *  获取子标题(普通文本)
 */
- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        UILabel *subtitleLabel = [UILabel txby_label];
        [self.contentView addSubview:subtitleLabel];
        subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel = subtitleLabel;
    }
    return _subtitleLabel;
}

/**
 *  获取子标题（输入框）
 */
- (UITextField *)textField {
    if (!_textField) {
        UITextField *textField = [[UITextField alloc] init];
        [self.contentView addSubview:textField];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        [textField addTarget:self action:@selector(change:) forControlEvents:UIControlEventEditingChanged];
        _textField = textField;
    }
    return _textField;
}

/**
 *  获取子标题（下拉选择）
 */
- (TXBYTextField *)selectField {
    if (!_selectField) {
        TXBYTextField *selectField = [[TXBYTextField alloc] init];
        _selectField = selectField;
        [self.contentView addSubview:selectField];
        selectField.delegate = self;
        selectField.clearButtonMode = UITextFieldViewModeNever;
    }
    return _selectField;
}

/**
 *  获取子标题（日期选择）
 */
- (TXBYTextField *)dateField {
    if (!_dateField) {
        TXBYTextField *dateField = [[TXBYTextField alloc] init];
        _dateField = dateField;
        [self.contentView addSubview:dateField];
        dateField.delegate = self;
        dateField.clearButtonMode = UITextFieldViewModeNever;
    }
    return _dateField;
}

/**
 *  获取arrowView
 */
- (UIImageView *)arrowView {
    if (!_arrowView) {
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TXBYInput.bundle/common_icon_arrow"]];
        _arrowView = arrowView;
    }
    return _arrowView;
}

#pragma mark - init
/**
 *  创建cell
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

#pragma mark - public
/**
 *  cell中的输入框成为第一响应者
 */
- (void)becomeFirst {
    // 子标题
    if ([self.item isKindOfClass:[TXBYInputFieldItem class]]) { // 输入框
        [self.textField becomeFirstResponder];
    } else if([self.item isKindOfClass:[TXBYInputDateItem class]]) { // 日期选择
        [self.dateField becomeFirstResponder];
    } else if([self.item isKindOfClass:[TXBYInputPickerItem class]]) { // 选择框
        [self.selectField becomeFirstResponder];
    }
}

/**
 *  设置item
 */
- (void)setItem:(TXBYInputItem *)item {
    _item = item;
    _pickerView = nil;
    _pickerIndexs = nil;
    _pickerToolBar = nil;
    _datePicker = nil;
    _dateField = nil;
    _dateToolbar = nil;
    _arrowView = nil;
    // 标题
    self.titleLabel.text = item.title;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.size.equalTo(item.titleFrame.size);
        make.left.equalTo(item.titleFrame.origin.x);
    }];
    self.titleLabel.textColor = item.titleColor;
    self.titleLabel.font = item.titleFont;
    
    // 子标题
    if ([item isKindOfClass:[TXBYInputLabelItem class]]) { // 普通文本
        [self label];
    } else if ([item isKindOfClass:[TXBYInputFieldItem class]]) { // 输入框
        [self field];
    } else if([item isKindOfClass:[TXBYInputDateItem class]]) { // 日期选择
        [self date];
    } else if([item isKindOfClass:[TXBYInputPickerItem class]]) { // 选择框
        [self select];
    }
}

#pragma mark - 私有方法
/**
 *  文本框文字改变
 */
- (void)change:(UITextField *)textField
{
    // 设置模型中的subtitle值
    self.item.subtitle = textField.text;
    
    if ([self.item isKindOfClass:[TXBYInputFieldItem class]]) { // 输入框
        
        TXBYInputFieldItem *fieldItem = (TXBYInputFieldItem *)self.item;
        // 如果有回调
        if (fieldItem.operationValueChange) {
            fieldItem.operationValueChange(self.item.subtitle);
        }
    }
}

/**
 *  设置普通文本item
 */
- (void)label {
    self.subtitleLabel.text = self.item.subtitle;
    [self.subtitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.size.equalTo(_item.subtitleFrame.size);
        make.left.equalTo(_item.subtitleFrame.origin.x);
    }];
    self.subtitleLabel.textColor = self.item.subtitleColor;
    self.subtitleLabel.font = self.item.subtitleFont;
    // 控件是否可见
    self.subtitleLabel.hidden = NO;
    self.textField.hidden = YES;
    self.selectField.hidden = YES;
    self.dateField.hidden = YES;
    self.accessoryView = nil;
}

/**
 *  设置输入框item
 */
- (void)field {
    TXBYInputFieldItem *fieldItem = (TXBYInputFieldItem *)self.item;
    self.textField.text = fieldItem.subtitle;
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.size.equalTo(fieldItem.subtitleFrame.size);
        make.left.equalTo(fieldItem.subtitleFrame.origin.x);
    }];
    self.textField.textColor = fieldItem.subtitleColor;
    self.textField.font = fieldItem.subtitleFont;
    self.textField.placeholder = fieldItem.placeholder;
    self.textField.keyboardType = fieldItem.keyboardType;
    // 是否密码框
    self.textField.secureTextEntry = fieldItem.secure;
    self.textField.clearsOnInsertion = fieldItem.secure;
    // 控件是否可见
    self.subtitleLabel.hidden = YES;
    self.textField.hidden = NO;
    self.selectField.hidden = YES;
    self.dateField.hidden = YES;
    self.accessoryView = nil;
    self.textField.enabled = (fieldItem.enabled != 0);
}

/**
 *  设置选择框item
 */
- (void)select {
    TXBYInputPickerItem *pickerItem = (TXBYInputPickerItem *)self.item;
    self.selectField.text = self.item.subtitle;
    [self.selectField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.size.equalTo(self.item.subtitleFrame.size);
        make.left.equalTo(self.item.subtitleFrame.origin.x);
    }];
    self.selectField.textColor = self.item.subtitleColor;
    self.selectField.font = self.item.subtitleFont;
    // 控件是否可见
    self.subtitleLabel.hidden = YES;
    self.textField.hidden = YES;
    self.selectField.hidden = NO;
    self.dateField.hidden = YES;
    self.accessoryView = self.arrowView;
    self.selectField.enabled = (pickerItem.enabled != 0);
    [self setType];
}

/**
 *  设置日期选择item
 */
- (void)date {
    self.dateField.text = self.item.subtitle;
    [self.dateField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.size.equalTo(self.item.subtitleFrame.size);
        make.left.equalTo(self.item.subtitleFrame.origin.x);
    }];
    self.dateField.textColor = self.item.subtitleColor;
    self.dateField.font = self.item.subtitleFont;
    // 控件是否可见
    self.subtitleLabel.hidden = YES;
    self.textField.hidden = YES;
    self.selectField.hidden = YES;
    self.dateField.hidden = NO;
    self.accessoryView = self.arrowView;
    [self setType];
}

/**
 *  设置输入框inputView类型
 */
- (void)setType {
    if ([self.item isKindOfClass:[TXBYInputDateItem class]]) { // 日期选择
        [self.dateToolbar setTitle:self.item.title];
        self.dateField.inputView = self.datePicker;
        self.dateField.inputAccessoryView = self.dateToolbar;
        // 设置时间范围
        TXBYInputDateItem *dateItem = (TXBYInputDateItem *)self.item;
        self.datePicker.minimumDate = dateItem.minimumDate;
        self.datePicker.maximumDate = dateItem.maximumDate;
        if (dateItem.datePickerModeEnable) {
            self.datePicker.datePickerMode = dateItem.datePickerMode;
        }
    } else if ([self.item isKindOfClass:[TXBYInputPickerItem class]]) { // 下拉选择
        [self.pickerToolBar setTitle:self.item.title];
        self.selectField.inputView = self.pickerView;
        self.selectField.inputAccessoryView = self.pickerToolBar;
    }
}

#pragma mark - 文本框代理
/**
 *  点击了return按钮(键盘最右下角的按钮)就会调用
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 结束编辑
    [self endEditing:YES];
    return YES;
}

/**
 *  开始编辑
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.item isKindOfClass:[TXBYInputDateItem class]]) { // 日期选择
        TXBYInputDateItem *dateItem = (TXBYInputDateItem *)self.item;
        if (![NSDate dateFromString:self.item.subtitle format:dateItem.format]) return;
        self.datePicker.date = [NSDate dateFromString:self.item.subtitle format:dateItem.format];
    } else if ([self.item isKindOfClass:[TXBYInputPickerItem class]]) { // 下拉选择
        [self.pickerView reloadAllComponents];
        self.find = NO; // 重置状态
        TXBYInputPickerItem *item = (TXBYInputPickerItem *)self.item;
        NSArray *sources = item.source;
        NSInteger component = 0;
        [self recursionWithArray:sources item:item component:component];
    } else if ([self.item isKindOfClass:[TXBYInputFieldItem class]]) { // 输入框
        TXBYInputFieldItem *fieldItem = (TXBYInputFieldItem *)self.item;
        // 如果有回调
        if (fieldItem.operationStart) {
            fieldItem.operationStart(self.item.subtitle);
        }
    }
}

/**
 *  结束编辑
 */
- (void)textFieldDidEndEditing:(UITextField *)textField {
    // 只有输入框才执行回调
    if (![self.item isKindOfClass:[TXBYInputFieldItem class]]) return;
    // 如果有回调
    if (self.item.operation) {
        self.item.operation(self.item.subtitle);
    }
}

#pragma mark - 私有方法
/**
 *  日期选择工具条按钮点击
 */
- (void)dateClick:(UIButton *)button {
    // 结束编辑
    [self endEditing:YES];
    if([button.titleLabel.text isEqualToString:@"取消"]) return;
    
    TXBYInputDateItem *dateItem = (TXBYInputDateItem *)self.item;
    // 1. 当前日期控件文字
    NSString *text = [NSDate stringFromDate:self.datePicker.date format:dateItem.format];
    
    // 2. 改变模型数据
    self.item.subtitle = text;
    self.dateField.text = self.item.subtitle;
    
    // 3. 执行回调operation
    if (self.item.operation) {
        self.item.operation(self.item.subtitle);
    }
}

/**
 *  选择框工具条点击
 */
- (void)buttonClick:(UIButton *)button {
    // 结束编辑
    [self endEditing:YES];
    if([button.titleLabel.text isEqualToString:@"取消"]) return;
    
    // 1. 取出模型数据
    TXBYInputPickerItem *pickerItem = (TXBYInputPickerItem *)self.item;
    NSArray *sources = pickerItem.source;
    // 2. 根据选中索引计算文字和code
    NSInteger component = [self numberOfComponentsInPickerView:self.pickerView];
    TXBYInputPickerSource *source = nil;
    NSString *last = @""; // 上一次循环的文字
    NSString *subtitle = @""; // 这次确认按钮点击后的子标题文字
    for (int i = 0; i < component; i++) {
        NSInteger index = [self.pickerIndexs[i] integerValue];
        source = sources[index];
        sources = source.subs;
        if (i == (component - 1)) { // 设置模型数据code值
            pickerItem.code = source.code;
        }
        
        if (![last isEqualToString:source.name]) { // 和上一次相同则不追加文字
            subtitle = [NSString stringWithFormat:@"%@ %@", subtitle, source.name];
        }
        last = source.name;
    }
    
    // 3. 设置新的子标题
    pickerItem.subtitle = subtitle.trim;
    self.selectField.text = pickerItem.subtitle;
    
    // 4. 执行回调
    if (pickerItem.operationForPicker) {
        pickerItem.operationForPicker(self.pickerIndexs);
    }
}

/**
 *  根据当前component获取上一个component中选中行的ESPickerSource
 */
- (TXBYInputPickerSource *)sourceWithComponent:(NSInteger)component {
    TXBYInputPickerItem *item = (TXBYInputPickerItem *)self.item;
    NSArray *sources = item.source;
    
    // 当前component的上一个component中选中的ESPickerSource
    TXBYInputPickerSource *source = nil;
    for (int i = 0; i < component; i++) {
        // 选中的索引
        if (!self.pickerIndexs.count) return 0;
        NSInteger index = [self.pickerIndexs[i] integerValue];
        source = sources[index];
        sources = source.subs;
    }
    return source;
}

/**
 *  设置选择框初始选中
 */
- (void)recursionWithArray:(NSArray *)array item:(TXBYInputItem *)item component:(NSInteger)component {
    component++;
    for (int j = 0; j < array.count; j++) {
        TXBYInputPickerSource *source = array[j];
        if (!self.find) {
            [self.pickerView reloadComponent:component-1];
            self.pickerIndexs[component-1] = @(j);
            [self.pickerView selectRow:j inComponent:component-1 animated:NO];
        }
        
        if ((!source.subs) & [source.code isEqualToString:self.item.code]) { // 下一层没有了且已经找到了
            self.find = YES;
        } else { // 递归下一层
            [self recursionWithArray:source.subs item:item component:component];
        }
    }
}

#pragma mark - UIPickerViewDataSource
/**
 *  多少组
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    TXBYInputPickerItem *item = (TXBYInputPickerItem *)self.item;
    TXBYInputPickerSource *first = item.source[0];
    NSInteger num = 0;
    for (; first; num++) {
        first = first.subs[0];
    }
    return num;
}

/**
 *  多少行
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    TXBYInputPickerItem *item = (TXBYInputPickerItem *)self.item;
    NSArray *sources = item.source;
    
    if (!component) return sources.count;
    
    // 当前component的上一个component中选中的ESPickerSource
    TXBYInputPickerSource *source = [self sourceWithComponent:component];
    
    return source.subs.count;
}

/**
 *  每一行内容
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    TXBYInputPickerItem *item = (TXBYInputPickerItem *)self.item;
    NSArray *sources = item.source;
    if (!component) { // 第1个component
        TXBYInputPickerSource *source = sources[row];
        return source.name;
    }
    
    // 当前component的上一个component中选中的TXBYInputPickerSource
    TXBYInputPickerSource *source = [self sourceWithComponent:component];
    NSArray *subs = source.subs;
    if (!subs.count) return @"";
    TXBYInputPickerSource *subRow = subs[row];
    return subRow.name;
}

#pragma mark - UIPickerViewDelegate
/**
 *  点击某一行
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // 一共有多少component
    NSInteger number = [self numberOfComponentsInPickerView:pickerView];
    // 当前component选中的索引
    self.pickerIndexs[component] = @(row);
    // 当前component后面的component
    for (NSInteger i = component; i < (number-1); i++) {
        // 下一个component选中的索引
        self.pickerIndexs[i + 1] = @0;
        // 刷新
        [pickerView reloadComponent:i+1];
        // 选中下一个component第一个
        [pickerView selectRow:0 inComponent:i+1 animated:YES];
    }
}

@end
