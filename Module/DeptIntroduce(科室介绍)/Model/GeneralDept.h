//
//  GeneralDept.h
//  syxrmyy_patient
//
//  Created by YandL on 16/5/4.
//  Copyright © 2016年 txby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeptList.h"

@interface GeneralDept : NSObject
/**
 *  大科室对应的科室
 */
@property (nonatomic, strong) NSArray *depts;
/**
 *  id
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  大科室的名称
 */
@property (nonatomic, copy) NSString *dept_name;
@end
