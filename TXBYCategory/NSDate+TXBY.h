//
//  NSDate+TXBY.h
//  TXBYCategory
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TXBY)

/**
 *  字符串转NSDate
 */
+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format;

/**
 *  NSDate转字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;

/**
 *  根据日期计算星期几
 */
- (NSString *)txby_week;

/**
 *  是否为今天
 */
- (BOOL)isToday;

/**
 *  是否为昨天
 */
- (BOOL)isYesterday;

/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;

@end
