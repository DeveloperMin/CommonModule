//
//  TXBYSettingItem.m
//  TXBYKit
//
//  Created by mac on 16/2/24.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYSettingItem.h"
#import "TXBYSettingLabelItem.h"
#import "TXBYKit.h"

@implementation TXBYSettingItem

/**
 *  根据标题和图标创建TXBYSettingItem
 *
 *  @param title 标题
 *  @param icon  图标
 */
+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon {
    return [[self alloc] initWithTitle:title icon:icon];
}

/**
 *  根据标题创建TXBYSettingItem
 *
 *  @param title 标题
 */
+ (instancetype)itemWithTitle:(NSString *)title {
    return [self itemWithTitle:title icon:nil];
}

/**
 *  根据标题和图标创建TXBYSettingItem
 *
 *  @param title 标题
 *  @param icon  图标
 */
- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon {
    if (self = [super init]) {
        self.title = title;
        self.icon = icon;
        if ([self isKindOfClass:[TXBYSettingLabelItem class]]) {
            TXBYSettingLabelItem *item = (TXBYSettingLabelItem *)self;
            item.enabled = YES;
            return item;
        }
    }
    return self;
}

/**
 *  根据标题创建TXBYSettingItem
 *
 *  @param title 标题
 */
- (instancetype)initWithTitle:(NSString *)title {
    return [self initWithTitle:title icon:nil];
}

- (UIColor *)titleColor {
    if (!_titleColor) {
        _titleColor = TXBYColor(20, 20, 20);;
    }
    return _titleColor;
}

- (UIFont *)subtitleFont {
    if (!_subtitleFont) {
        _subtitleFont = [UIFont systemFontOfSize:14];
    }
    return _subtitleFont;
}

- (UIColor *)subtitleColor {
    if (!_subtitleColor) {
        _subtitleColor = [UIColor lightGrayColor];
    }
    return _subtitleColor;
}

@end