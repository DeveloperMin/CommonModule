//
//  TXBYInputPickerItem.h
//  TXBYKit
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//  右边显示UIPickerView

#import "TXBYInputItem.h"
#import "TXBYInputPickerSource.h"

@interface TXBYInputPickerItem : TXBYInputItem

/**
 *  是否可以编辑
 */
@property(nonatomic, assign) BOOL enabled;

/**
 *  数据源
 */
@property (nonatomic, strong) NSArray *source;

/**
 *  输入完成或选择完成后要进行的操作（如改变其他行数据）
 */
@property (nonatomic, copy) void (^operationForPicker)(NSArray *indexs);

@end