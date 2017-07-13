//
//  BaseQuestCell.h
//  smh
//
//  Created by yh on 15/3/29.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  问题列表和详情中共有属性的cell

#import <UIKit/UIKit.h>
@class Quest;

@interface BaseQuestCell : UITableViewCell

/**
 *  quest模型
 */
@property (nonatomic, strong) Quest *quest;

@end