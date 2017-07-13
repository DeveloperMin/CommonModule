//
//  BaseQuestViewController.h
//  smh
//
//  Created by yh on 15/3/29.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  问题列表，我的问题父类

#import <UIKit/UIKit.h>

@interface BaseQuestViewController : UITableViewController

/**
 *  问题模型数组
 */
@property (nonatomic, strong) NSMutableArray *quests;

@end