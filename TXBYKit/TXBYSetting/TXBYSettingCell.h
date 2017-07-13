//
//  TXBYSettingCell.h
//  TXBYKit
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TXBYSettingItem;

// cell高度
extern CGFloat TXBYSettingViewCellH;

@interface TXBYSettingCell : UITableViewCell

/**
 *  cell对应的item数据
 */
@property (nonatomic, strong) TXBYSettingItem *item;

@end