//
//  TXBYInputDateItem.h
//  TXBYKit
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//  右边显示日期控件

#import "TXBYInputItem.h"

@interface TXBYInputDateItem : TXBYInputItem

/**
 *  最小日期
 */
@property (nonatomic, strong) NSDate *minimumDate;

/**
 *  最大日期
 */
@property (nonatomic, strong) NSDate *maximumDate;

/**
 *  日期格式
 */
@property (nonatomic, copy) NSString *format;

/**
 *  时间选择模式(默认为UIDatePickerModeDate)
 */
@property (nonatomic, assign) UIDatePickerMode datePickerMode;

/**
 *  是否开启时间选择模式
 */
@property (nonatomic, assign, readonly) BOOL datePickerModeEnable;


@end