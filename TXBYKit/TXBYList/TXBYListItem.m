//
//  TXBYListItem.m
//  TXBYKit
//
//  Created by mac on 16/4/14.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYListItem.h"
#import "TXBYCategory.h"

CGFloat const TXBYLIST_CELL_MARGIN = 10;

@implementation TXBYListItem
@synthesize titleFont = _titleFont;
@synthesize subtitleFont = _subtitleFont;

- (UIFont *)titleFont {
    if (!_titleFont) {
        _titleFont = [UIFont systemFontOfSize:16];
    }
    return _titleFont;
}

- (UIColor *)titleColor {
    if (!_titleColor) {
        _titleColor = [UIColor blackColor];
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
        _subtitleColor = [UIColor blackColor];
    }
    return _subtitleColor;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.title = self.title;
}

- (void)setSubtitleFont:(UIFont *)subtitleFont {
    _subtitleFont = subtitleFont;
    self.subtitle = self.subtitle;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    CGFloat titleX = TXBYLIST_CELL_MARGIN * 2;
    CGFloat titleY = TXBYLIST_CELL_MARGIN * 2;
    CGFloat titleW = [UIScreen mainScreen].applicationFrame.size.width - 6 * TXBYLIST_CELL_MARGIN;
    CGFloat titleH = [title sizeWithFont:self.titleFont maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
    _titleFrame = CGRectMake(titleX, titleY, titleW, titleH);
    
    _cellHeight = CGRectGetMaxY(_titleFrame) + TXBYLIST_CELL_MARGIN * 2;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    
    CGFloat subtitleX = _titleFrame.origin.x;
    CGFloat subtitleY = CGRectGetMaxY(_titleFrame) + TXBYLIST_CELL_MARGIN / 2;
    CGFloat subtitleW = _titleFrame.size.width;
    CGFloat subtitleH = [subtitle sizeWithFont:self.subtitleFont maxSize:CGSizeMake(subtitleW, MAXFLOAT)].height;
    _subtitleFrame = CGRectMake(subtitleX, subtitleY, subtitleW, subtitleH);
    
    _cellHeight = CGRectGetMaxY(_subtitleFrame) + TXBYLIST_CELL_MARGIN * 2;
}

- (instancetype)initWithTitle:(NSString *)title {
    return [self initWithTitle:title subtitle:nil];
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    if (self = [super init]) {
        self.title = title;
        self.subtitle = subtitle;
        self.enable = YES;
        self.hideArrow = NO;
    }
    return self;
}

+ (instancetype)itemWithTitle:(NSString *)title {
    return [self itemWithTitle:title subtitle:nil];
}

+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    return [[self alloc] initWithTitle:title subtitle:subtitle];
}

@end