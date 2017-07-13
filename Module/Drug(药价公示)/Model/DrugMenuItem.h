//
//  DrugMenuItem.h
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//  药价列表目录

#import <Foundation/Foundation.h>

@interface DrugMenuItem : NSObject

/**
 *  文字
 */
@property (nonatomic, copy) NSString *name;

/**
 *  子分类
 */
@property (nonatomic, strong) NSArray *items;

@end