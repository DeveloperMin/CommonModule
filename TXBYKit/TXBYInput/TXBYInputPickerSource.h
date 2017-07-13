//
//  TXBYInputPickerSource.h
//  TXBYKit
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//  下拉框数据源

#import <Foundation/Foundation.h>

@interface TXBYInputPickerSource : NSObject

/**
 *  主键代号等
 */
@property (nonatomic, copy) NSString *code;

/**
 *  名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  值
 */
@property (nonatomic, copy) NSString *value;

/**
 *  下一级数据
 */
@property (nonatomic, strong) NSArray *subs;

@end