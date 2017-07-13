//
//  QuestCacheTool.h
//  smh
//
//  Created by yh on 14/10/10.
//  Copyright (c) 2014年 eeesys. All rights reserved.
//  问题缓存工具类（只缓存最新的20条数据）

typedef enum{
    QuestTypeMe,  // 我的问题
    QuestTypeAll  // 所有问题
}QuestOwnerType;

#import <Foundation/Foundation.h>
@class Quest;
@class QuestParam;

@interface QuestCacheTool : NSObject

/**
 *  缓存一个问题
 */
+ (void)addQuest:(Quest *)quest owner:(QuestOwnerType)ownerType;

/**
 *  缓存多个问题
 */
+ (void)addQuests:(NSArray *)quests owner:(QuestOwnerType)ownerType;

/**
 *  根据QuestParam取出缓存的问题
 */
+ (NSArray *)questsWithParam:(QuestParam *)param owner:(QuestOwnerType)ownerType;

@end