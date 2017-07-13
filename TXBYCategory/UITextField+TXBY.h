//
//  UITextField+TXBY.h
//  TXBYCategory
//
//  Created by mac on 16/5/9.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (TXBY)

/**
 *  创建普通文本框
 *
 *  @param leftIcon    左边图标
 *  @param placeholder 提示文字
 */
+ (instancetype)fieldWithLeft:(NSString *)leftIcon placeholder:(NSString *)placeholder;

/**
 *  创建密码框
 *
 *  @param leftIcon    左边图标
 *  @param placeholder 提示文字
 */
+ (instancetype)passwordWithLeft:(NSString *)leftIcon placeholder:(NSString *)placeholder;

@end