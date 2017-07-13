//
//  TriageTool.h
//  smh
//
//  Created by yh on 15/3/20.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  智能分诊工具类

#import <Foundation/Foundation.h>
@class TriageParam, TriageResult;

@interface TriageTool : NSObject

/**
 *  症状列表
 */
+ (void)symptomsWithParam:(TriageParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(TriageResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  疾病列表
 */
+ (void)illsWithParam:(TriageParam *)param netIdentifier:(NSString *)netIdentifier success:(void (^)(TriageResult *result))success failure:(void (^)(NSError *error))failure;

@end