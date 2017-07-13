//
//  QuestTool.m
//  smh
//
//  Created by yh on 15/3/29.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//

#import "QuestTool.h"
#import "Quest.h"
#import "QuestCacheTool.h"
#import "QuestParam.h"
#import "QuestResult.h"
#import "QuestCacheTool.h"

@implementation QuestTool

/**
 *  问题列表
 */
+ (void)questsWithParam:(QuestParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestResult *result))success failure:(void (^)(NSError *error))failure {
    // 从本地缓存里加载
    NSArray *quests = [QuestCacheTool questsWithParam:param owner:QuestTypeAll];
    if (quests.count) { // 本地有缓存
        // 返回结果
        QuestResult *result = [[QuestResult alloc] init];
        result.quests = quests;
        
        // 传递block
        if (success) {
            success(result);
        }
    } else { // 本地没有缓存
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYQuestListAPI parameters:param.mj_keyValues netIdentifier:netIdentifier success:^(id responseObject) {
            // 返回结果对象
            QuestResult *result = [QuestResult resultWithDict:responseObject];
            // 查询成功
            if ([result.errcode isEqualToString:TXBYSuccessCode]) {
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in responseObject[@"quests"]) {
                    Quest *quest = [Quest itemWithDict:dict];
                    [array addObject:quest];
                }
                result.quests = array;
            }
            // 缓存数据(不是上拉加载更多时才缓存)
            if (!param.max_id) {
                [QuestCacheTool addQuests:result.quests owner:QuestTypeAll];
            }
            
            // 传递block
            if (success) {
                success(result);
            }
        } failure:^(NSError *error) {
            // 传递block
            if (failure) {
                failure(error);
            }
        }];
    }
}

/**
 *  问题详情
 */
+ (void)questDetailWithParam:(QuestParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestResult *result))success failure:(void (^)(NSError *error))failure {
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYQuestDetailAPI parameters:param.mj_keyValues netIdentifier:netIdentifier success:^(id responseObject) {
        // 返回结果对象
        QuestResult *result = [QuestResult resultWithDict:responseObject];
        // 查询成功
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"replies"]) {
                Quest *quest = [Quest itemWithDict:dict];
                [array addObject:quest];
            }
            result.quests = array;
        }
        
        // 传递block
        if (success) {
            success(result);
        }
    } failure:^(NSError *error) {
        // 传递block
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  提问
 */
+ (void)questAddWithParam:(QuestParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestResult *result))success failure:(void (^)(NSError *error))failure {
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYQuestAddAPI parameters:param.mj_keyValues netIdentifier:netIdentifier success:^(id responseObject) {
        // 返回结果对象
        QuestResult *result = [QuestResult mj_objectWithKeyValues:responseObject];

        // 传递block
        if (success) {
            success(result);
        }
    } failure:^(NSError *error) {
        // 传递block
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  回复
 */
+ (void)questReplyWithParam:(QuestParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestResult *result))success failure:(void (^)(NSError *error))failure {
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYQuestReplyAPI parameters:param.mj_keyValues netIdentifier:netIdentifier success:^(id responseObject) {
        // 返回结果对象
        QuestResult *result = [QuestResult resultWithDict:responseObject];
        // 回复成功
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"replies"]) {
                Quest *quest = [Quest itemWithDict:dict];
                [array addObject:quest];
            }
            result.quests = array;
        }
        
        // 传递block
        if (success) {
            success(result);
        }
    } failure:^(NSError *error) {
        // 传递block
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  我的问题列表
 */
+ (void)myQuestsWithParam:(QuestParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestResult *result))success failure:(void (^)(NSError *error))failure {
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYMyQuestAPI parameters:param.mj_keyValues netIdentifier:netIdentifier success:^(id responseObject) {
        // 返回结果对象
        QuestResult *result = [QuestResult resultWithDict:responseObject];
        // 查询成功
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"quests"]) {
                Quest *quest = [Quest itemWithDict:dict];
                [array addObject:quest];
            }
            result.quests = array;
        }
        // 传递block
        if (success) {
            success(result);
        }
    } failure:^(NSError *error) {
        // 传递block
        if (failure) {
            failure(error);
        }
    }];
}

@end