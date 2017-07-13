//
//  UIBarButtonItem+TXBY.m
//  TXBYCategory
//
//  Created by mac on 16/4/19.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "UIBarButtonItem+TXBY.h"
#import "TXBYCategory.h"

@implementation UIBarButtonItem (TXBY)

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon target:(id)target action:(SEL)action {
    NSString *highlighted = [icon stringByAppendingString:@"_highlighted"];
    return [self itemWithIcon:icon highIcon:highlighted target:target action:action];
}

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action {
    // 创建按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // 正常状态下背景图片
    [button setBackgroundImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    // 高亮状态下背景图片
    [button setBackgroundImage:[UIImage imageWithName:highIcon] forState:UIControlStateHighlighted];
    // 设置frame
    button.frame = (CGRect){CGPointZero, button.currentBackgroundImage.size};
    // 点击事件
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end