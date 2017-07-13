//
//  TXBYActionSheetButton.m
//  TXBYKit
//
//  Created by mac on 16/2/23.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYActionSheetButton.h"
#import "TXBYActionSheetItem.h"
#import "TXBYKit.h"

@interface TXBYActionSheetButton ()

/**
 *  按钮高亮时的背景图片
 */
@property (nonatomic, strong) UIImage *bgImage;

@end

// 默认文字颜色
#define TXBYACTIONSHEET_BUTTON_TITLE_NORMAL_COLOR TXBYColor(59, 59, 59)
// 红色文字
#define TXBYACTIONSHEET_BUTTON_TITLE_RED_COLOR TXBYColor(255, 10, 10)

@implementation TXBYActionSheetButton

- (UIImage *)bgImage {
    if (!_bgImage) {
        _bgImage = [UIImage imageWithName:@"TXBYActionSheet.bundle/bgImage_HL"];
    }
    return _bgImage;
}

- (void)setItem:(TXBYActionSheetItem *)item {
    [self setTitle:item.title forState:UIControlStateNormal];
    UIColor *titleColor = TXBYACTIONSHEET_BUTTON_TITLE_NORMAL_COLOR;
    if (item.titleColor == TXBYActionSheetItemTitleRedColor) {
        titleColor = TXBYACTIONSHEET_BUTTON_TITLE_RED_COLOR;
    }
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [[self titleLabel] setFont:item.titleFont];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setTitleColor:TXBYACTIONSHEET_BUTTON_TITLE_NORMAL_COLOR forState:UIControlStateNormal];
        [[self titleLabel] setFont:TXBYACTIONSHEET_BUTTON_TITLE_FONT];
        [self setBackgroundImage:self.bgImage forState:UIControlStateHighlighted];
    }
    return self;
}

- (instancetype)initWithItem:(TXBYActionSheetItem *)item {
    if (self = [super init]) {
        self.item = item;
    }
    return self;
}

+ (instancetype)buttonWithItem:(TXBYActionSheetItem *)item {
    return [[TXBYActionSheetButton alloc] initWithItem:item];
}

@end