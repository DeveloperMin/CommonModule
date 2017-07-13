//
//  TXBYActionSheetButton.h
//  TXBYKit
//
//  Created by mac on 16/2/23.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//  一个item表示一个按钮

#import <UIKit/UIKit.h>
@class TXBYActionSheetItem;

@interface TXBYActionSheetButton : UIButton

/**
 *  数据模型
 */
@property (nonatomic, strong) TXBYActionSheetItem *item;

#pragma mark - init
+ (instancetype)buttonWithItem:(TXBYActionSheetItem *)item;
- (instancetype)initWithItem:(TXBYActionSheetItem *)item;

@end