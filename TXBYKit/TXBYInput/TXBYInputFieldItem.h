//
//  TXBYInputFieldItem.h
//  TXBYKit
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//  右边显示输入框

#import "TXBYInputItem.h"

@interface TXBYInputFieldItem : TXBYInputItem

/**
 *  是否可以编辑
 */
@property(nonatomic, assign) BOOL enabled;

/**
 *  提示文字
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 *  是否密码框
 */
@property (nonatomic, assign) BOOL secure;

/**
 *  键盘类型
 */
@property(nonatomic, assign) UIKeyboardType keyboardType;

/**
 *  输入框开始编辑的回调
 */
@property (nonatomic, copy) void (^operationStart)(NSString *subtitle);

/**
 *  输入框文字变化的回调
 */
@property (nonatomic, copy) void (^operationValueChange)(NSString *subtitle);

@end