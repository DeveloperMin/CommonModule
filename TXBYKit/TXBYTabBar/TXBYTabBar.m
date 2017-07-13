//
//  TXBYTabBar.m
//  TXBYKit-master
//
//  Created by mac on 16/4/20.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYTabBar.h"
#import "TXBYTabBarButton.h"
#import "TXBYKit.h"

// 按钮初始tag
NSInteger TXBYTabBarTagStart = 200;

@implementation TXBYTabBar

- (UIColor *)titleColor {
    if (!_titleColor) {
        _titleColor = TXBYColor(151, 151, 151);
    }
    return _titleColor;
}

- (UIColor *)selectedTitleColor {
    if (!_selectedTitleColor) {
        _selectedTitleColor = TXBYColor(100, 156, 33);
    }
    return _selectedTitleColor;
}

#pragma mark - private
/**
 *  监听按钮点击
 */
- (void)buttonClick:(TXBYTabBarButton *)button {
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:button.tag];
    }
}

#pragma mark - public
/**
 *  添加自定义tabBarbutton
 */
- (void)addTabBarButtonWithItem:(UITabBarItem *)item {
    // 1. 创建按钮
    TXBYTabBarButton *button = [[TXBYTabBarButton alloc] init];
    [self addSubview:button];
    
    [button setTitleColor:self.titleColor forState:UIControlStateNormal];
    [button setTitleColor:self.selectedTitleColor forState:UIControlStateSelected];
    
    // 2. 设置数据
    button.item = item;
    
    // 3. 监听按钮点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    // 4. 默认选中第0个按钮
    if (self.subviews.count == 1) {
        button.selected = YES;
        self.selectedButton = button;
    }
}

#pragma mark - super
/**
 *  调整子视图
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 1. 按钮的frame数据
    CGFloat buttonH = self.frame.size.height;
    CGFloat buttonW = self.frame.size.width / self.subviews.count;
    CGFloat buttonY = 0;
    
    for (int index = 0; index < self.subviews.count; index++) {
        // 2.取出按钮
        TXBYTabBarButton *button = self.subviews[index];
        
        // 3.设置按钮的frame
        CGFloat buttonX = index * buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 4.绑定tag
        button.tag = TXBYTabBarTagStart + index;
    }
}

@end