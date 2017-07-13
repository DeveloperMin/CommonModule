//
//  TXBYSettingCell.m
//  TXBYKit
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYSettingCell.h"
#import "TXBYSettingItem.h"
#import "TXBYSettingArrowItem.h"
#import "TXBYSettingSwitchItem.h"
#import "TXBYSettingLabelItem.h"
#import "TXBYSettingCheckItem.h"
#import "TXBYSettingBadgeView.h"
#import "TXBYCategory.h"

// cell高度
CGFloat TXBYSettingViewCellH = 50;

@interface TXBYSettingCell ()

/**
 *  箭头
 */
@property (nonatomic, strong) UIImageView *arrow;

/**
 *  开关
 */
@property (nonatomic, strong) UISwitch *rightSwitch;

/**
 *  文字
 */
@property (nonatomic, strong) UILabel *rightLabel;

/**
 *  打勾
 */
@property (nonatomic, strong) UIImageView *checkmark;

/**
 *  数字提醒
 */
@property (nonatomic, strong) TXBYSettingBadgeView *badgeView;

@end

@implementation TXBYSettingCell
#pragma mark - setter and getter
/**
 *  箭头
 */
- (UIImageView *)arrow {
    if (!_arrow) {
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TXBYSetting.bundle/common_icon_arrow"]];
    }
    return _arrow;
}

/**
 *  开关
 */
- (UISwitch *)rightSwitch {
    if (!_rightSwitch) {
        _rightSwitch = [[UISwitch alloc] init];
        // 监听事件
        [_rightSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _rightSwitch;
}

/**
 *  文字
 */
- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = [UIColor lightGrayColor];
        _rightLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_rightLabel];
    }
    return _rightLabel;
}

/**
 *  打勾
 */
- (UIImageView *)checkmark {
    if (!_checkmark) {
        _checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TXBYSetting.bundle/common_icon_checkmark"]];
    }
    return _checkmark;
}

/**
 *  获取数字提醒
 */
- (TXBYSettingBadgeView *)badgeView {
    if (!_badgeView) {
        _badgeView = [[TXBYSettingBadgeView alloc] init];
    }
    return _badgeView;
}

/**
 *  设置item模型
 */
- (void)setItem:(TXBYSettingItem *)item {
    _item = item;
    
    // 1. 设置基本数据
    self.imageView.image = [UIImage imageWithName:item.icon];
    self.textLabel.text = item.title;
    self.textLabel.textColor = item.titleColor;
    self.detailTextLabel.text = item.subtitle;
    self.detailTextLabel.font = item.subtitleFont;
    self.detailTextLabel.textColor= item.subtitleColor;
    
    // 2. 设置右边的内容
    if (item.badgeValue) { // 有提醒数字（优先显示数字）
        // 设置数字
        self.badgeView.badgeValue = item.badgeValue;
        self.accessoryView = self.badgeView;
    } else if ([item isKindOfClass:[TXBYSettingArrowItem class]]) { // 箭头
        self.accessoryView = self.arrow;
    } else if ([item isKindOfClass:[TXBYSettingSwitchItem class]]) { // 开关
        self.accessoryView = self.rightSwitch;
        // 设置打开状态
        TXBYSettingSwitchItem *switchItem = (TXBYSettingSwitchItem *)item;
        self.rightSwitch.on = switchItem.on;
        if (switchItem.color) {
            self.rightSwitch.onTintColor = switchItem.color;
        }
    } else if([item isKindOfClass:[TXBYSettingLabelItem class]]) { // 文字
        self.accessoryView = self.arrow;
        TXBYSettingLabelItem *labelItem = (TXBYSettingLabelItem *)item;
        // 设置文字
        self.rightLabel.text = labelItem.text;
        self.rightLabel.textColor = labelItem.textColor;
        if (labelItem.textFont) {
            self.rightLabel.font = labelItem.textFont;
        }
    } else if ([item isKindOfClass:[TXBYSettingCheckItem class]]) { // 打勾
        TXBYSettingCheckItem *checkItem = (TXBYSettingCheckItem *)item;
        self.accessoryView = checkItem.on ? self.checkmark : nil;
    } else { // 取消右边的内容
        self.accessoryView = nil;
    }
    
    // 3. 右侧文字控件是否显示
    self.rightLabel.hidden = ![item isKindOfClass:[TXBYSettingLabelItem class]];
    
    // 4. 右侧箭头是否显示
    if([self.item isKindOfClass:[TXBYSettingLabelItem class]]) {
        TXBYSettingLabelItem *labelItem = (TXBYSettingLabelItem *)self.item;
        self.accessoryView.hidden = !labelItem.enabled;
        self.userInteractionEnabled = labelItem.enabled;
    } else {
        self.accessoryView.hidden = NO;
        self.userInteractionEnabled = YES;
    }
}

#pragma mark - init
/**
 *  根据样式初始化cell
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        // 设置标题的字体
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
    }
    return self;
}

#pragma mark - private
/**
 *  UISwitch监听事件
 */
- (void)switchChange:(UISwitch *)sender {
    TXBYSettingSwitchItem *switchItem = (TXBYSettingSwitchItem *)self.item;
    switchItem.on = sender.on;
}

#pragma mark - super
/**
 *  调整子控件的位置
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 距离标题的间距
    CGFloat distance = 10;
    
    // 调整子标题的x
    self.detailTextLabel.txby_x = CGRectGetMaxX(self.textLabel.frame) + distance;
    
    // 计算右侧文字x坐标
    
    if([self.item isKindOfClass:[TXBYSettingLabelItem class]]) {
        TXBYSettingLabelItem *labelItem = (TXBYSettingLabelItem *)self.item;
        // 根据文字计算尺寸
        self.rightLabel.txby_size = [labelItem.text sizeWithFont:self.rightLabel.font maxSize:CGSizeMake(TXBYApplicationW * 0.6, MAXFLOAT)];
        CGFloat labelX = self.accessoryView.frame.origin.x - self.rightLabel.frame.size.width - 5;
        if (!labelItem.enabled || self.accessoryView.hidden) {
            labelX = self.accessoryView.frame.origin.x - self.rightLabel.frame.size.width + self.accessoryView.frame.size.width;
        }
        // 右侧文字frame
        self.rightLabel.frame = CGRectMake(labelX, (TXBYSettingViewCellH - self.rightLabel.frame.size.height) / 2, self.rightLabel.frame.size.width, self.rightLabel.frame.size.height);
    }
}

@end
