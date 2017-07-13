//
//  TXBYActionSheetItem.m
//  TXBYKit
//
//  Created by mac on 16/2/23.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYActionSheetItem.h"

@implementation TXBYActionSheetItem

- (UIFont *)titleFont {
    if (_titleFont) {
        _titleFont = TXBYACTIONSHEET_BUTTON_TITLE_FONT;
    }
    return _titleFont;
}

- (TXBYActionSheetItemTitleColorType)titleColor {
    if (!_titleColor) {
        _titleColor = TXBYActionSheetItemTitleNormalColor;
    }
    return _titleColor;
}

- (instancetype)initWithTitle:(NSString *)title operation:(void (^)())operation {
    if (self = [super init]) {
        self.title = title;
        self.operation = operation;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    return [self initWithTitle:title operation:nil];
}

+ (instancetype)itemWithTitle:(NSString *)title operation:(void (^)())operation {
    return [[self alloc] initWithTitle:title operation:operation];
}

+ (instancetype)itemWithTitle:(NSString *)title {
    return [self itemWithTitle:title operation:nil];
}

@end