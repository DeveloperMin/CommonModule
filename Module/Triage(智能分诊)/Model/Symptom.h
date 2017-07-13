//
//  Symptom.h
//  smh
//
//  Created by yh on 15/3/21.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  症状

#import <Foundation/Foundation.h>

@interface Symptom : NSObject

/**
 *  症状id
 */
@property (nonatomic, assign) NSInteger symptom_id;

/**
 *  症状名称
 */
@property (nonatomic, copy) NSString *symptom_name;

@end