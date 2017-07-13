//
//  TXBYInputDateItem.m
//  TXBYKit
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYInputDateItem.h"
#import "TXBYCategory.h"

@implementation TXBYInputDateItem

/**
 *  最小日期
 */
- (NSDate *)minimumDate {
    if (!_minimumDate) {
        _minimumDate = [NSDate dateFromString:@"1900-01-01" format:self.format];
    }
    return _minimumDate;
}

/**
 *  最大日期
 */
- (NSDate *)maximumDate {
    if (!_maximumDate) {
        _maximumDate = [NSDate date];
    }
    return _maximumDate;
}

/**
 *  日期格式
 */
- (NSString *)format {
    if (!_format) {
        _format = @"yyyy-MM-dd";
    }
    return _format;
}

/**
 *  时间选择模式
 */
- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
    _datePickerMode = datePickerMode;
    _datePickerModeEnable = YES;
}

@end