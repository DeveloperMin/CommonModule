//
//  TriageTool.m
//  smh
//
//  Created by yh on 15/3/20.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//

#import "TriageTool.h"
#import "TriageParam.h"
#import "TriageResult.h"
#import "Symptom.h"
#import "Ill.h"

@implementation TriageTool

/**
 *  症状列表
 */
+ (void)symptomsWithParam:(TriageParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(TriageResult *result))success failure:(void (^)(NSError *error))failure {
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYTriageSymptomListAPI parameters:param.mj_keyValues netIdentifier:netIdentifier success:^(id responseObject) {
        // 返回结果对象
        TriageResult *result = [TriageResult resultWithDict:responseObject];
        result.symptoms = [Symptom mj_objectArrayWithKeyValuesArray:responseObject[@"symptom"]];
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
 *  疾病列表
 */
+ (void)illsWithParam:(TriageParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(TriageResult *result))success failure:(void (^)(NSError *error))failure {
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYTriageIllListAPI parameters:param.mj_keyValues netIdentifier:netIdentifier success:^(id responseObject) {
        // 返回结果对象
        TriageResult *result = [TriageResult resultWithDict:responseObject];

        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"disease"]) {
            Ill *ill = [Ill itemWithDict:dict];
            [array addObject:ill];
        }
        result.ills = array;
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