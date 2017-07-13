//
//  TXBYBaseParam.h
//  TXBYBaseParam
//
//  Created by hj on 16/5/9.
//  Copyright © 2016年 eeesys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXBYBaseParam : NSObject

/**
 *  身份验证令牌
 */
@property (nonatomic, copy) NSString *token;

/**
 *  访问类型
 */
@property (nonatomic, copy) NSString *act;

/**
 *  医院ID
 */
@property (nonatomic, copy) NSString *hospital;

/**
 *  app类型
 */
@property (nonatomic, copy) NSString *app_type;

/**
 *  院区
 */
@property (nonatomic, copy) NSString *branch;

  
/**
 *  快速创建一个请求参数对象
 */
+ (instancetype)param;

@end
