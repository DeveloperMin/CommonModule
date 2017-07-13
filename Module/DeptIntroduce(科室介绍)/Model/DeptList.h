//
//  DeptList.h
//  taicang
//
//  Created by txby on 16/1/6.
//  Copyright © 2016年 eeesys. All rights reserved.
//  科室模型

#import <Foundation/Foundation.h>

@interface DeptList : NSObject
/**
 *  id
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  科室id
 */
@property (nonatomic, copy) NSString *dept_id;
/**
 *  科室名字
 */
@property (nonatomic, copy) NSString *dept_name;
/**
 *  父母
 */
@property (nonatomic, copy) NSString *parent;
@end
