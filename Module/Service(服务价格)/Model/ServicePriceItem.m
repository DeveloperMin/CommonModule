//
//  ServicePriceItem.m
//  deptPatientCommon
//
//  Created by hj on 17/3/2.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "ServicePriceItem.h"

@implementation ServicePriceItem

/**
 *  模型中增加详情数据
 */
- (instancetype)detailWithDict:(NSDictionary *)dict {
    if (self) {
        self.Code = dict[@"Code"];
        self.ServiceName = dict[@"ServiceName"];
        self.Until = dict[@"Until"];
        self.Prices = dict[@"Price"];
        self.ServiceBody = dict[@"ServiceBody"];
        self.ServiceContent = dict[@"ServiceContent"];
        self.Note = dict[@"Note"];
    }
    return self;
}

@end
