//
//  QuestResult.h
//  smh
//
//  Created by yh on 15/3/29.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  问答返回结果

#import "TXBYBaseResult.h"

@interface QuestResult : TXBYBaseResult

#pragma mark - 问题列表
/**
 *  问题列表
 */
@property (nonatomic, strong) NSArray *quests;

@end