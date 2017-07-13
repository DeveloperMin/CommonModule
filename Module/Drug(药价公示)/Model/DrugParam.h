//
//  DrugParam.h
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//  药价公示请求参数对象

#import "TXBYBaseParam.h"

@interface DrugParam : TXBYBaseParam

/**
 *  ID
 */
@property (nonatomic, copy) NSString *ID;

/**
 *  mtid
 */
@property (nonatomic, copy) NSString *mtid;

/**
 *  mtids
 */
@property (nonatomic, copy) NSString *mtids;

/**
 *  产品名
 */
@property (nonatomic, copy) NSString *cpm;

@end