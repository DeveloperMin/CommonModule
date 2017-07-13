//
//  DeptListController.h
//  taicang
//
//  Created by txby on 16/1/6.
//  Copyright © 2016年 eeesys. All rights reserved.
//  科室列表

#import "TXBYKit.h"

@interface DeptListController : TXBYSettingViewController
/**
 *  院区
 */
@property (nonatomic, copy) NSString *branch;
/**
 *  是否按大科室分类(默认按,传0为不按大科室分类)
 */
@property (nonatomic, copy) NSString *level;
@end
