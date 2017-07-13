//
//  TXBYListCell.h
//  TXBYKit
//
//  Created by mac on 16/4/14.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TXBYListItem;

@interface TXBYListCell : UITableViewCell

/**
 *  数据模型
 */
@property (nonatomic, strong) TXBYListItem *listItem;

@end