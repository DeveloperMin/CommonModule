//
//  TXBYInputViewController.h
//  TXBYKit-master
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//  文本、输入框、日期选择UITableView父类

#import <UIKit/UIKit.h>
#import "TXBYInputItem.h"
#import "TXBYInputLabelItem.h"
#import "TXBYInputFieldItem.h"
#import "TXBYInputPickerItem.h"
#import "TXBYInputPickerSource.h"
#import "TXBYInputDateItem.h"
#import "TXBYInputGroup.h"

typedef enum {
    TXBYInputViewSectionMarginSmall,
    TXBYInputViewSectionMarginBig
} TXBYInputViewSectionMargin;

@interface TXBYInputViewController : UITableViewController

/**
 *  拖动时是否隐藏键盘
 */
@property (nonatomic, assign) BOOL keyboardDismissOnDrag;

/**
 *  所有组数据模型
 */
@property (nonatomic, strong) NSMutableArray *groups;

/**
 *  sction之间的距离
 */
@property (nonatomic, assign) TXBYInputViewSectionMargin sctionMargin;

@end