//
//  DrugListViewController.h
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//  药价公示列表

#import "TXBYListViewController.h"
@class DrugList;

@interface DrugListViewController : UITableViewController

/**
 *  目录模型
 */
@property (nonatomic, strong) DrugList *item;

@end
