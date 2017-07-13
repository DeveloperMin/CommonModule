//
//  DrugDetailViewController.h
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//  药价公示详情

#import "TXBYInputViewController.h"
@class Drug;

@interface DrugDetailViewController : TXBYInputViewController

/**
 *  模型
 */
@property (nonatomic, strong) Drug *drug;

@end