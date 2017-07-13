//
//  GeneralDept.m
//  syxrmyy_patient
//
//  Created by YandL on 16/5/4.
//  Copyright © 2016年 txby. All rights reserved.
//

#import "GeneralDept.h"

@implementation GeneralDept

//+ (NSDictionary *)replacedKeyFromPropertyName {
//    return @{@"ID":@"id"};
//}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"depts":[DeptList class]};
}
@end
