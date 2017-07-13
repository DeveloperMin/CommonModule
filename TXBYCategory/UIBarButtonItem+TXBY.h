//
//  UIBarButtonItem+TXBY.h
//  TXBYCategory
//
//  Created by mac on 16/4/19.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (TXBY)

/**
 *  快速创建一个显示图片的UIBarButtonItem
 *  @param icon   普通图片名称
 */
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon target:(id)target action:(SEL)action;

/**
 *  快速创建一个显示图片的UIBarButtonItem
 *
 *  @param icon     普通图片名称
 *  @param highIcon 高亮图片名称
 */
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;

@end