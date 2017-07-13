//
//  QuestionTool.m
//  publicCommon
//
//  Created by hj on 17/2/20.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "QuestionTool.h"
#import "Question.h"
#import "QuestionReply.h"

@implementation QuestionTool

/**
 *  查询所有问题
 */
+ (void)allQuestionWithParam:(QuestionParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestionResult *result))success failure:(void (^)(NSError *error))failure {
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYQuestionListAPI parameters:param.mj_keyValues netIdentifier:netIdentifier success:^(id responseObject) {
        // 返回结果对象
        QuestionResult *result = [QuestionResult resultWithDict:responseObject];
        // 访问成功
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
            result.items = [Question mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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
 *  查询我的问题
 */
+ (void)myQuestionWithParam:(QuestionParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestionResult *result))success failure:(void (^)(NSError *error))failure {
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYMyQuestionAPI parameters:param.mj_keyValues netIdentifier:netIdentifier success:^(id responseObject) {
        // 返回结果对象
        QuestionResult *result = [QuestionResult resultWithDict:responseObject];
        // 访问成功
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
            result.items = [Question mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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
 *  问题详情
 */
+ (void)questionDetailWithParam:(QuestionParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestionResult *result))success failure:(void (^)(NSError *error))failure {
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYQuestionDetailAPI parameters:param.mj_keyValues netIdentifier:netIdentifier success:^(id responseObject) {
        // 返回结果对象
        QuestionResult *result = [QuestionResult resultWithDict:responseObject];
        // 访问成功
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
            result.question = [Question mj_objectWithKeyValues:responseObject[@"data"][@"quest"]];
            result.replies = [QuestionReply mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"replies"]];
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
 *  添加新问题
 */
+ (void)createQuestionWithParam:(QuestionParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestionResult *result))success failure:(void (^)(NSError *error))failure {
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYQuestionCreateAPI parameters:param.mj_keyValues netIdentifier:netIdentifier success:^(id responseObject) {
        // 返回结果对象
        QuestionResult *result = [QuestionResult resultWithDict:responseObject];
        // 访问成功
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
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
 *  回答问题
 */
+ (void)replyQuestionWithParam:(QuestionParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestionResult *result))success failure:(void (^)(NSError *error))failure {
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYQuestionReplyAPI parameters:param.mj_keyValues netIdentifier:netIdentifier success:^(id responseObject) {
        // 返回结果对象
        QuestionResult *result = [QuestionResult resultWithDict:responseObject];
        // 访问成功
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
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
 *  点赞
 */
+ (void)likeQuestionWithParam:(QuestionParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestionResult *result))success failure:(void (^)(NSError *error))failure {
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYQuestionLikeAPI parameters:param.mj_keyValues netIdentifier:netIdentifier success:^(id responseObject) {
        // 返回结果对象
        QuestionResult *result = [QuestionResult resultWithDict:responseObject];
        // 访问成功
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
            result.loved_id = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"ID"]];
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
 *  取消点赞
 */
+ (void)dislikeQuestionWithParam:(QuestionParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(QuestionResult *result))success failure:(void (^)(NSError *error))failure {
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYQuestioDislikeAPI parameters:param.mj_keyValues netIdentifier:netIdentifier success:^(id responseObject) {
        // 返回结果对象
        QuestionResult *result = [QuestionResult resultWithDict:responseObject];
        // 访问成功
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
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
