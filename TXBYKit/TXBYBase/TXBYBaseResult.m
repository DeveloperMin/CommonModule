//
//  TXBYBaseResult.m
//  TXBYBaseResult
//
//  Created by hj on 16/5/9.
//  Copyright © 2016年 eeesys. All rights reserved.
//

#import "TXBYBaseResult.h"

@implementation TXBYBaseResult

/**
 *  创建返回结果对象
 */
+ (instancetype)resultWithDict:(NSDictionary *)dict {
    TXBYBaseResult *result = [[self alloc] init];
    if (![dict.class isSubclassOfClass:[NSDictionary class]]) {
        return result;
    }
    result.errcode = [NSString stringWithFormat:@"%@",dict[@"errcode"]];
    result.errmsg = dict[@"errmsg"];
    return result;
}

+ (instancetype)result {
    return [self resultWithDict:nil];
}
@end
