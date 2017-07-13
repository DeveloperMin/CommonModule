//
//  TXBYActionSheetItem.h
//  TXBYKit
//
//  Created by mac on 16/2/23.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//  一个item表示一个按钮数据模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    TXBYActionSheetItemTitleNormalColor = 0,   // 正常黑色文字
    TXBYActionSheetItemTitleRedColor,          // 红色文字
} TXBYActionSheetItemTitleColorType;

// 默认文字大小
#define TXBYACTIONSHEET_BUTTON_TITLE_FONT [UIFont systemFontOfSize:18.0f]

@interface TXBYActionSheetItem : NSObject

/**
 *  按钮文字
 */
@property (nonatomic, copy) NSString *title;

/**
 *  按钮文字字体
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 *  按钮文字颜色
 */
@property (nonatomic, assign) TXBYActionSheetItemTitleColorType titleColor;

/**
 *  点击这个按钮后的操作
 */
@property (nonatomic, copy) void (^operation)();

#pragma mark - init
- (instancetype)initWithTitle:(NSString *)title operation:(void (^)())operation;
- (instancetype)initWithTitle:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title operation:(void (^)())operation;
+ (instancetype)itemWithTitle:(NSString *)title;

@end