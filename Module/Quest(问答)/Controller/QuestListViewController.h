//
//  QuestListViewController.h
//  smh
//
//  Created by yh on 15/3/29.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  问题列表

#import "BaseQuestViewController.h"

@interface QuestListViewController : BaseQuestViewController

/**
 *  刷新
 *
 *  @param fromOther YES表示从其他控制器过来 NO表示不是从其他控制器过来
 */
- (void)refreshFromOther:(BOOL)fromOther;

@end