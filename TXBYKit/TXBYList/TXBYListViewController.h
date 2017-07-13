//
//  TXBYListViewController.h
//  TXBYKit
//
//  Created by mac on 16/4/14.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXBYListItem.h"

@interface TXBYListViewController : UITableViewController

/**
 *  模型数组
 */
@property (nonatomic, strong) NSArray *items;

/**
 *  group形式的数组
 */
@property (nonatomic, strong) NSArray *groups;

@end