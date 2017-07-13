//
//  TriageResult.m
//  smh
//
//  Created by yh on 15/3/22.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//

#import "TriageResult.h"
#import "Symptom.h"
#import "Ill.h"

@implementation TriageResult

/**
 *  实现这个方法的目的：告诉MJExtension框架symptom和desiese数组里面装的是什么模型
 */
+ (NSDictionary *)objectClassInArray {
    return @{@"symptoms" : [Symptom class], @"ills": [Ill class]};
}

@end