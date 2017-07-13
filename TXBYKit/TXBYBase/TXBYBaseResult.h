//
//  TXBYBaseResult.h
//  TXBYBaseResult
//
//  Created by hj on 16/5/9.
//  Copyright © 2016年 eeesys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXBYBaseResult : NSObject

/**
 *  状态码
 */
@property (nonatomic, copy) NSString *errcode;

/**
 *  状态描述
 */
@property (nonatomic, copy) NSString *errmsg;

/**
 *  创建返回结果对象
 */
+ (instancetype)resultWithDict:(NSDictionary *)dict;
+ (instancetype)result;

@end
