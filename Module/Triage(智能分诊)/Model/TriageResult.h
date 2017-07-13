//
//  TriageResult.h
//  smh
//
//  Created by yh on 15/3/22.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  智能分诊返回结果

#import "TXBYBaseResult.h"

@interface TriageResult : TXBYBaseResult

/**
 *  症状列表
 */
@property (nonatomic, strong) NSArray *symptoms;

/**
 *  疾病列表
 */
@property (nonatomic, strong) NSArray *ills;

@end