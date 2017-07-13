//
//  CommunitySelectView.m
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/26.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "CommunitySelectView.h"
#import "TXBYAccessoryView.h"
#import "CommunityGroup.h"

@interface CommunitySelectView ()<UIPickerViewDelegate, UIPickerViewDataSource>
/**
 *  pickerToolBar
 */
@property (nonatomic, strong) TXBYAccessoryView *pickerToolBar;
/**
 *  pickerView
 */
@property (nonatomic, strong) UIPickerView *pickerView;
/**
 *  选中的组
 */
@property (nonatomic, strong) CommunityGroup *selGroup;

@end

@implementation CommunitySelectView

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self addSubview:_pickerView];
        [_pickerView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pickerToolBar.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(-44);
        }];
    }
    return _pickerView;
}

- (void)setGroups:(NSArray *)groups {
    _groups = groups;
    [self.pickerView reloadAllComponents];
    NSInteger i = 0;
    for (CommunityGroup *group in self.groups) {
        if ([group.name isEqualToString:self.defaultGroup.name]) {
            [self.pickerView selectRow:i inComponent:0 animated:YES];
            break;
        }
        i++;
    }
}

- (TXBYAccessoryView *)pickerToolBar {
    if (!_pickerToolBar) {
        _pickerToolBar = [TXBYAccessoryView accessoryViewWithTarget:self action:@selector(buttonClick:)];
        _pickerToolBar.title = @"分类";
        [self addSubview:_pickerToolBar];
        [_pickerToolBar makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(40);
        }];
    }
    return _pickerToolBar;
}

/**
 *  选择框工具条点击
 */
- (void)buttonClick:(UIButton *)btn {
    // 结束编辑
    if ([btn.titleLabel.text isEqualToString:@"确定"]) {
        if (self.commitBlock) {
            self.commitBlock(self.selGroup);
        }
    } else {
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.groups.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    CommunityGroup *group = self.groups[row];
    return group.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selGroup = self.groups[row];
}


@end
