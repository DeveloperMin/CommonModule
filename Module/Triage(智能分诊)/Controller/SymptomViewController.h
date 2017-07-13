//
//  SymptomViewController.h
//  smh
//
//  Created by yh on 15/3/21.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  症状

#import "TXBYListViewController.h"
@class TriageParam;

@interface SymptomViewController : TXBYListViewController

/**
 *  请求参数模型
 */
@property (nonatomic, strong) TriageParam *param;

@end