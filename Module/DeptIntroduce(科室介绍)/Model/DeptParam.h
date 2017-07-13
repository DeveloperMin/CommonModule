//
//  DeptParam.h
//  taicang
//
//  Created by txby on 16/1/6.
//  Copyright © 2016年 eeesys. All rights reserved.
//  科室参数

#import "TXBYBaseParam.h"

@interface DeptParam : TXBYBaseParam
/**
 *  科室id
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  科室类型
 */
@property (nonatomic, copy) NSString *register_type;
/**
 *  是否按大科室分类
 */
@property (nonatomic, copy) NSString *level;


@end
