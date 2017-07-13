//
//  QuestionTool.h
//  publicCommon
//
//  Created by hj on 17/2/20.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionParam.h"
#import "QuestionResult.h"

@interface QuestionTool : NSObject

/**
 *  查询所有问题
 */
+ (void)allQuestionWithParam:(QuestionParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestionResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  查询我的问题
 */
+ (void)myQuestionWithParam:(QuestionParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestionResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  问题详情
 */
+ (void)questionDetailWithParam:(QuestionParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestionResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  添加新问题
 */
+ (void)createQuestionWithParam:(QuestionParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestionResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  回答问题
 */
+ (void)replyQuestionWithParam:(QuestionParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestionResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  点赞
 */
+ (void)likeQuestionWithParam:(QuestionParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestionResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  取消点赞
 */
+ (void)dislikeQuestionWithParam:(QuestionParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestionResult *result))success failure:(void (^)(NSError *error))failure;

@end
