//
//  StepListModel.h
//  publicCommon
//
//  Created by Limmy on 2017/2/15.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StepListModel : NSObject
/**
 *  ID
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  name
 */
@property (nonatomic, copy) NSString *name;
/**
 *  step
 */
@property (nonatomic, copy) NSString *step;
/**
 *  love
 */
@property (nonatomic, copy) NSString *love;
/**
 *  avatar
 */
@property (nonatomic, copy) NSString *avatar;
/**
 *  uid
 */
@property (nonatomic, copy) NSString *uid;
/**
 *  is_loved
 */
@property (nonatomic, copy) NSString *is_loved;
/**
 *  order
 */
@property (nonatomic, copy) NSString *order;
/**
 *  background
 */
@property (nonatomic, copy) NSString *background;
/**
 *  loved_id
 */
@property (nonatomic, copy) NSString *loved_id;

@end
