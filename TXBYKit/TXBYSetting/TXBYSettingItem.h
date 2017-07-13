//
//  TXBYSettingItem.h
//  TXBYKit
//
//  Created by mac on 16/2/24.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//  一个TXBYSettingItem模型来描述每一行的信息:图标、标题、子标题、右边的样式（箭头、数字、开关等）

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TXBYSettingItem : NSObject

/**
 *  图标
 */
@property (nonatomic, copy) NSString *icon;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  标题颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 *  子标题
 */
@property (nonatomic, copy) NSString *subtitle;

/**
 *  子标题字体
 */
@property (nonatomic, strong) UIFont *subtitleFont;

/**
 *  子标题颜色
 */
@property (nonatomic, strong) UIColor *subtitleColor;

/**
 *  右边显示的数字标记
 */
@property (nonatomic, copy) NSString *badgeValue;

/**
 *  点击cell，需要跳转到哪个控制器
 */
@property (nonatomic, assign) Class destClass;

/**
 *  ID
 */
@property (nonatomic, copy) NSString *ID;

/**
 *  点击这行cell后的操作
 */
@property (nonatomic, copy) void (^operation)();

#pragma mark - init
/**
 *  根据标题和图标创建TXBYSettingItem
 *
 *  @param title 标题
 *  @param icon  图标
 */
+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon;

/**
 *  根据标题创建TXBYSettingItem
 *
 *  @param title 标题
 */
+ (instancetype)itemWithTitle:(NSString *)title;

/**
 *  根据标题和图标创建TXBYSettingItem
 *
 *  @param title 标题
 *  @param icon  图标
 */
- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon;

/**
 *  根据标题创建TXBYSettingItem
 *
 *  @param title 标题
 */
- (instancetype)initWithTitle:(NSString *)title;

@end