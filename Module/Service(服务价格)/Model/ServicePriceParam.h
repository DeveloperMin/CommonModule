//
//  ServicePriceParam.h
//  deptPatientCommon
//
//  Created by hj on 17/3/2.
//  Copyright © 2017年 txby. All rights reserved.
//  服务价格请求对象

#import "TXBYBaseParam.h"

@interface ServicePriceParam : TXBYBaseParam

/**
 *  服务名称
 */
@property (nonatomic, copy) NSString *ServiceName;

/**
 *  code
 */
@property (nonatomic, copy) NSString *Code;

/**
 *  mtid
 */
@property (nonatomic, copy) NSString *mtid;

/**
 *  mtids
 */
@property (nonatomic, copy) NSString *mtids;

@end
