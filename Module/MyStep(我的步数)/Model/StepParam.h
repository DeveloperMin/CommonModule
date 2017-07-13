//
//  StepParam.h
//  publicCommon
//
//  Created by Limmy on 2017/2/15.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "TXBYBaseParam.h"

@interface StepParam : TXBYBaseParam
/**
 *  ID
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  date
 */
@property (nonatomic, copy) NSString *date;
/**
 *  page
 */
@property (nonatomic, copy) NSString *page;
/**
 *  steps
 */
@property (nonatomic, copy) NSString *steps;
/**
 *  avatar
 */
@property (nonatomic, copy) NSString *background;
/**
 *  uid
 */
@property (nonatomic, copy) NSString *uid;
/**
 *  oid
 */
@property (nonatomic, copy) NSString *oid;
/**
 *  category
 */
@property (nonatomic, copy) NSString *category;
/**
 *  operate
 */
@property (nonatomic, copy) NSString *operate;
/**
 *  item_count
 */
@property (nonatomic, copy) NSString *item_count;

@end
