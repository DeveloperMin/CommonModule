//
//  UITextField+TXBY.m
//  TXBYCategory
//
//  Created by mac on 16/5/9.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "UITextField+TXBY.h"

@implementation UITextField (TXBY)

/**
 *  创建普通文本框
 *
 *  @param leftIcon    左边图标
 *  @param placeholder 提示文字
 */
+ (instancetype)fieldWithLeft:(NSString *)leftIcon placeholder:(NSString *)placeholder {
    return [self fieldWithLeft:leftIcon placeholder:placeholder type:NO];
}

/**
 *  创建密码框
 *
 *  @param leftIcon    左边图标
 *  @param placeholder 提示文字
 */
+ (instancetype)passwordWithLeft:(NSString *)leftIcon placeholder:(NSString *)placeholder {
    return [self fieldWithLeft:leftIcon placeholder:placeholder type:YES];
}

/**
 *  创建通用文本框
 */
+ (instancetype)fieldWithLeft:(NSString *)leftIcon placeholder:(NSString *)placeholder type:(BOOL)pass {
    // 创建文本框
    UITextField *field = [[UITextField alloc] init];
    
    // 文本框左边视图
    UIImageView *fieldLeft = [[UIImageView alloc] init];
    fieldLeft.frame = CGRectMake(20, 0, 45, 20);
    fieldLeft.contentMode = UIViewContentModeScaleAspectFit;
    field.leftViewMode = UITextFieldViewModeAlways;
    fieldLeft.image = [UIImage imageNamed:leftIcon];
    field.leftView = fieldLeft;
    
    // 背景图片
    field.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TXBYCategory.bundle/textfield_bkg"]];
    // 提示文字
    field.placeholder = placeholder;
    // 清除按钮
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.returnKeyType = UIReturnKeyDone;
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    if (pass) { // 密码框
    
        field.secureTextEntry = YES;
        field.clearsOnInsertion = YES;
    }
    
    return field;
}

@end