//
//  QuestTool.h
//  smh
//
//  Created by yh on 15/3/29.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  问答工具类

#import <Foundation/Foundation.h>
@class QuestParam, QuestResult;

@interface QuestTool : NSObject

/**
 *  问题列表
 */
+ (void)questsWithParam:(QuestParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  问题详情
 */
+ (void)questDetailWithParam:(QuestParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  提问
 */
+ (void)questAddWithParam:(QuestParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  回复
 */
+ (void)questReplyWithParam:(QuestParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  我的问题列表
 */
+ (void)myQuestsWithParam:(QuestParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestResult *result))success failure:(void (^)(NSError *error))failure;

@end