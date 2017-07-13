//
//  ServicePriceDetailController.h
//  deptPatientCommon
//
//  Created by hj on 17/3/2.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "TXBYListViewController.h"
@class ServicePriceItem;

@interface ServicePriceDetailController : TXBYListViewController

/**
 *  ServiceItem模型
 */
@property (nonatomic, strong) ServicePriceItem *item;

@end
