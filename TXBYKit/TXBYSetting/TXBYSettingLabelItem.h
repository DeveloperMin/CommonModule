//
//  TXBYSettingLabelItem.h
//  TXBYKit
//
//  Created by mac on 16/2/24.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//  右侧文字

#import "TXBYSettingItem.h"

@interface TXBYSettingLabelItem : TXBYSettingItem

/**
 *  右侧要显示的文字
 */
@property (nonatomic, copy) NSString *text;

/**
 *  右侧要显示的文字颜色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 *  右侧要显示的文字字体
 */
@property (nonatomic, strong) UIFont *textFont;

/**
 *  是否可以点击（如果不可以点击则不现实箭头）
 */
@property (nonatomic, assign) BOOL enabled;

@end
