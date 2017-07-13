//
//  TXBYInputItem.m
//  TXBYKit
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYInputItem.h"
#import "TXBYInputDateItem.h"
#import "TXBYInputFieldItem.h"
#import "TXBYInputLabelItem.h"
#import "TXBYInputPickerItem.h"
#import "TXBYCategory.h"

const CGFloat TXBYINPUTCELLMARGIN = 10;

@implementation TXBYInputItem

- (CGFloat)titleScale {
    if (!_titleScale) {
        _titleScale = 0.4;
    }
    return _titleScale;
}

- (UIFont *)titleFont {
    if (!_titleFont) {
        _titleFont = [UIFont systemFontOfSize:16];
    }
    return _titleFont;
}

- (UIFont *)subtitleFont {
    if (!_subtitleFont) {
        _subtitleFont = [UIFont systemFontOfSize:16];
    }
    return _subtitleFont;
}

- (UIColor *)titleColor {
    if (!_titleColor) {
        _titleColor = [UIColor grayColor];
    }
    return _titleColor;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    CGFloat titleX = TXBYINPUTCELLMARGIN * 1.5;
    CGFloat titleY = TXBYINPUTCELLMARGIN * 1.5;
    CGFloat titleW = [UIScreen mainScreen].applicationFrame.size.width * self.titleScale - 2 * titleX;
    CGFloat titleH = [title sizeWithFont:self.titleFont maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
    _titleFrame = CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    
    // 子标题
    if ([self isKindOfClass:[TXBYInputLabelItem class]]) { // 普通文本
        [self label];
    }
    else if ([self isKindOfClass:[TXBYInputFieldItem class]]) { // 输入框
        [self field];
    }
    else if ([self isKindOfClass:[TXBYInputDateItem class]]) { // 日期选择
        [self select];
    }
    else if ([self isKindOfClass:[TXBYInputPickerItem class]]) { // 选择框
        [self select];
    }
    
    // cell高度
    _cellHeight = CGRectGetMaxY(_titleFrame) > CGRectGetMaxY(_subtitleFrame) ? CGRectGetMaxY(_titleFrame) : CGRectGetMaxY(_subtitleFrame);
    _cellHeight += TXBYINPUTCELLMARGIN * 1.5;
}

/**
 *  计算普通文本frame
 */
- (void)label {
    CGFloat subtitleX = CGRectGetMaxX(_titleFrame) + self.titleFrame.origin.x;
    CGFloat subtitleY = TXBYINPUTCELLMARGIN * 1.5;
    CGFloat subtitleW = [UIScreen mainScreen].applicationFrame.size.width * (1 - self.titleScale) - 2 * TXBYINPUTCELLMARGIN * 1.5;
    CGFloat subtitleH = [self.subtitle sizeWithFont:self.subtitleFont maxSize:CGSizeMake(subtitleW, MAXFLOAT)].height;
    _subtitleFrame = CGRectMake(subtitleX, subtitleY, subtitleW, subtitleH);
}

/**
 *  计算输入框frame
 */
- (void)field {
    CGFloat subtitleX = CGRectGetMaxX(_titleFrame) + self.titleFrame.origin.x;
    CGFloat subtitleY = TXBYINPUTCELLMARGIN * 1.5;
    CGFloat subtitleW = [UIScreen mainScreen].applicationFrame.size.width * (1 - self.titleScale) - TXBYINPUTCELLMARGIN * 1.5;
    CGFloat subtitleH = self.titleFrame.size.height;
    _subtitleFrame = CGRectMake(subtitleX, subtitleY, subtitleW, subtitleH);
}

/**
 *  计算日期选择和下拉框
 */
- (void)select {
    CGFloat subtitleX = CGRectGetMaxX(_titleFrame) + self.titleFrame.origin.x;
    CGFloat subtitleY = TXBYINPUTCELLMARGIN * 1.5;
    CGFloat subtitleW = [UIScreen mainScreen].applicationFrame.size.width * (1 - self.titleScale) - 2 * TXBYINPUTCELLMARGIN * 1.5;
    CGFloat subtitleH = [self.subtitle sizeWithFont:self.subtitleFont maxSize:CGSizeMake(subtitleW, MAXFLOAT)].height;
    _subtitleFrame = CGRectMake(subtitleX, subtitleY, subtitleW, subtitleH);
}

+ (instancetype)item {
    return [[self alloc] init];
}

+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    TXBYInputItem *item = [self item];
    item.title = title;
    item.subtitle = subtitle;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title titleScale:(CGFloat)titleScale subtitle:(NSString *)subtitle {
    TXBYInputItem *item = [self item];
    if (titleScale > 0 && titleScale < 1) {
        item.titleScale = titleScale;
    }
    item.title = title;
    item.subtitle = subtitle;
    return item;
}

- (instancetype)init {
    if (self = [super init]) {
        if ([self isKindOfClass:[TXBYInputFieldItem class]]) {
            TXBYInputFieldItem *item = (TXBYInputFieldItem *)self;
            item.enabled = YES;
        }
        if ([self isKindOfClass:[TXBYInputPickerItem class]]) {
            TXBYInputPickerItem *item = (TXBYInputPickerItem *)self;
            item.enabled = YES;
        }
    }
    return self;
}

@end