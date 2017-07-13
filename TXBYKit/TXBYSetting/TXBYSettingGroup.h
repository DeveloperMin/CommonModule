//
//  TXBYSettingGroup.h
//  TXBYKit
//
//  Created by mac on 16/2/24.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//  一个ESSettingGroup模型来描述每组的信息：组头、组尾、这组的所有行

#import <Foundation/Foundation.h>
#import "TXBYSettingItem.h"

@interface TXBYSettingGroup : NSObject

/**
 *  组头
 */
@property (nonatomic, copy) NSString *header;

/**
 *  组尾
 */
@property (nonatomic, copy) NSString *footer;

/**
 *  这组的所有模型（数组中存放的是TXBYSettingGroup模型）
 */
@property (nonatomic, strong) NSArray *items;

#pragma mark - init
+ (instancetype)group;
+ (instancetype)groupWithItems:(NSArray *)items;

#pragma mark - methods
/**
 *  添加一个item
 */
- (void)addItem:(TXBYSettingItem *)anItem;

@end