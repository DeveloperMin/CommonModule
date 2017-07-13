//
//  QuestCacheTool.m
//  smh
//
//  Created by yh on 14/10/10.
//  Copyright (c) 2014年 eeesys. All rights reserved.
//

#import "QuestCacheTool.h"
#import "Quest.h"
#import "FMDB.h"
#import "QuestParam.h"

@implementation QuestCacheTool

static FMDatabaseQueue *_queue;

+ (void)initialize {
    // 1. 创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:TXBYSQLitePath];
    
    // 2. 创表
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_quest (id integer primary key autoincrement, questId integer, owner integer, quest blob);"];
    }];
}

/**
 *  缓存一个问题
 */
+ (void)addQuest:(Quest *)quest owner:(QuestOwnerType)ownerType {
    [_queue inDatabase:^(FMDatabase *db) {
        
        // 1. 先删除一条最旧的问题(如果缓存的数据大于等于20条才删除)
        FMResultSet *rs = [db executeQuery:@"select count(questId) as number,min(questId) as questId from t_quest where owner = ?;", @(ownerType)];
        if (rs.next) {
            // 已经缓存了多少条
            int number = [rs intForColumn:@"number"];
            if (number >= 20) {
                NSInteger questId = [rs intForColumn:@"questId"];
                [db executeUpdate:@"delete from t_quest where owner = ? and questId = ?;", @(ownerType), @(questId)];
            }
        }
        [rs close];
        
        // 2. 获得需要存储的数据
        NSInteger questId = quest.ID;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:quest];
        
        // 3. 存储数据
        [db executeUpdate:@"insert into t_quest (questId, owner, quest) values(? , ?, ?);", @(questId), @(ownerType) , data];
    }];
}

/**
 *  缓存多个问题
 */
+ (void)addQuests:(NSArray *)quests owner:(QuestOwnerType)ownerType {
    for (Quest *quest in quests) {
        [self addQuest:quest owner:ownerType];
    }
}

/**
 *  根据QuestParam取出缓存的问题
 */
+ (NSArray *)questsWithParam:(QuestParam *)param owner:(QuestOwnerType)ownerType {
    // 1.定义数组
    __block NSMutableArray *quests = nil;
    
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        // 创建数组
        quests = [NSMutableArray array];
        
        FMResultSet *rs = nil;
        if (param.since_id) { // 下拉刷新
            rs = [db executeQuery:@"select * from t_quest where owner = ? and questId > ? order by questId desc limit 0,20;", @(ownerType), @(param.since_id)];
        } else if (param.max_id) { // 上拉加载更多
            rs = [db executeQuery:@"select * from t_quest where owner = ? and questId < ? order by questId desc limit 0,20;", @(ownerType), @(param.max_id)];
        } else { // 加载最新的数据
            rs = [db executeQuery:@"select * from t_quest where owner = ? order by questId desc limit 0,20;", @(ownerType)];
        }
        
        while (rs.next) {
            NSData *data = [rs dataForColumn:@"quest"];
            Quest *quest = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [quests addObject:quest];
        }
        
        [rs close];
    }];
    
    // 3.返回数据
    return quests;
}

@end