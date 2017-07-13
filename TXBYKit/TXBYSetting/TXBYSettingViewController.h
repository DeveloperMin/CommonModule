//
//  TXBYSettingViewController.h
//  TXBYKit
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//  设置界面父类，其他类似界面只需要给出数据

#import <UIKit/UIKit.h>
#import "TXBYSettingGroup.h"
#import "TXBYSettingItem.h"
#import "TXBYSettingArrowItem.h"
#import "TXBYSettingSwitchItem.h"
#import "TXBYSettingLabelItem.h"
#import "TXBYSettingCheckItem.h"

typedef enum {
    TXBYSettingSectionMarginSmall = 0,  // section间距小
    TXBYSettingSectionMarginBig         // section间距大
} TXBYSettingSectionMargin;

@interface TXBYSettingViewController : UITableViewController

/**
 *  所有组数据模型
 */
@property (nonatomic, strong) NSMutableArray *groups;

/**
 *  sction之间的距离
 */
@property (nonatomic, assign) TXBYSettingSectionMargin sectionMargin;

@end