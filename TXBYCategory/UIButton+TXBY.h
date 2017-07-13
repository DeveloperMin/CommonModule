//
//  UIButton+TXBY.h
//  TXBYCategory
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (TXBY)

/**
 *  快速创建一个button
 */
+ (instancetype)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

/**
 *  快速创建一个button
 */
+ (instancetype)buttonWithTitle:(NSString *)title bg:(NSString *)bg target:(id)target action:(SEL)action;

/**
 *  快速创建一个button
 */
+ (instancetype)buttonWithTitle:(NSString *)title normalBg:(NSString *)normalBg highlightedBg:(NSString *)highlightedBg target:(id)target action:(SEL)action;

@end