//
//  TXBYInputItem.h
//  TXBYKit
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//  一个TXBYInputItem模型来描述每一行的信息:标题、子标题（可能是UILabel、UITextField、UIPickerView、UIDatePicker）、箭头

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TXBYInputItem : NSObject

/**
 *  主键代号等(可能出现的枚举值)
 */
@property (nonatomic, copy) NSString *code;

/**
 *  主键名称
 */
@property (nonatomic, copy) NSString *ID;

/**
 *  标题文字
 */
@property (nonatomic, copy) NSString *title;

/**
 *  标题颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 *  标题font
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 *  标题文字占屏幕宽度比例(默认0.4)
 */
@property (nonatomic, assign) CGFloat titleScale;

/**
 *  子标题文字
 */
@property (nonatomic, copy) NSString *subtitle;

/**
 *  子标题颜色
 */
@property (nonatomic, strong) UIColor *subtitleColor;

/**
 *  子标题font
 */
@property (nonatomic, strong) UIFont *subtitleFont;

/**
 *  输入完成或选择完成后要进行的操作（如改变其他行数据）
 */
@property (nonatomic, copy) void (^operation)(NSString *subtitle);

/**
 *  cell高度
 */
@property (nonatomic, readonly) CGFloat cellHeight;

/**
 *  标题frame
 */
@property (nonatomic, readonly) CGRect titleFrame;

/**
 *  子标题frame
 */
@property (nonatomic, readonly) CGRect subtitleFrame;

+ (instancetype)item;
+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
+ (instancetype)itemWithTitle:(NSString *)title titleScale:(CGFloat)titleScale subtitle:(NSString *)subtitle;

@end