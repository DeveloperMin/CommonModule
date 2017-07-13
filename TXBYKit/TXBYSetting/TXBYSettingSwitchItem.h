//
//  TXBYSettingSwitchItem.h
//  TXBYKit
//
//  Created by mac on 16/2/24.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//  右侧开关

#import "TXBYSettingItem.h"

@interface TXBYSettingSwitchItem : TXBYSettingItem

/**
 *  开关是否打开
 */
@property (nonatomic, assign) BOOL on;
/**
 *  开关颜色
 */
@property (nonatomic, strong) UIColor *color;

@end
