//
//  TXBYInputCell.h
//  TXBYKit
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TXBYInputCell;
@class TXBYInputItem;

@protocol TXBYInputCellDelegate <NSObject>

@optional
/**
 *  cell将要刷新
 */
- (void)cellWillReload:(TXBYInputCell *)cell;

@end

@interface TXBYInputCell : UITableViewCell

/**
 *  数据模型
 */
@property (nonatomic, strong) TXBYInputItem *item;

/**
 *  代理
 */
@property (nonatomic, assign) id<TXBYInputCellDelegate> delegate;

/**
 *  cell中的输入框成为第一响应者
 */
- (void)becomeFirst;

@end