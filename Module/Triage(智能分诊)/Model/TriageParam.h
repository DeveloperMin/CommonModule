//
//  TriageParam.h
//  smh
//
//  Created by yh on 15/3/20.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  智能分诊请求参数

#import "TXBYBaseParam.h"

@interface TriageParam : TXBYBaseParam

/**
 *  部位名称
 */
@property (nonatomic, copy) NSString *part;

/**
 *  性别
 */
@property (nonatomic, copy) NSString *sex;

/**
 *  症状id
 */
@property (nonatomic, copy) NSString *symptom_id;

@end