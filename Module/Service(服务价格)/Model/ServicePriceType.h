//
//  ServicePriceType.h
//  deptPatientCommon
//
//  Created by hj on 17/3/2.
//  Copyright © 2017年 txby. All rights reserved.
//  服务类型

#import <Foundation/Foundation.h>

@interface ServicePriceType : NSObject

/**
 *  类型名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  mtid
 */
@property (nonatomic, copy) NSString *mtid;

/**
 *  mtids
 */
@property (nonatomic, copy) NSString *mtids;

@end
