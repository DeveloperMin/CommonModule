//
//  TXBYCircleModel.h
//  txzjPatient
//
//  Created by Limmy on 2017/4/22.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXBYCircleModel : NSObject
/**
 *  ID
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  uid(患者或者医生的id)
 */
@property (nonatomic, copy) NSString *uid;
/**
 *  avatar
 */
@property (nonatomic, copy) NSString *avatar;
/**
 *  user_title
 */
@property (nonatomic, copy) NSString *user_title;
/**
 *  user_role
 */
@property (nonatomic, copy) NSString *user_role;
/**
 *  content
 */
@property (nonatomic, copy) NSString *content;
/**
 *  imgs
 */
@property (nonatomic, strong) NSArray *imgs;
/**
 *  title
 */
@property (nonatomic, copy) NSString *title;
/**
 *  name
 */
@property (nonatomic, copy) NSString *name;
/**
 *  user_name
 */
@property (nonatomic, copy) NSString *user_name;
/**
 *  user_type
 */
@property (nonatomic, copy) NSString *user_type;
/**
 *  create_time
 */
@property (nonatomic, copy) NSString *create_time;
/**
 *  comment
 */
@property (nonatomic, copy) NSString *comment;
/**
 *  is_loved
 */
@property (nonatomic, copy) NSString *is_loved;
/**
 *  love
 */
@property (nonatomic, copy) NSString *love;
/**
 *  loved_id
 */
@property (nonatomic, copy) NSString *loved_id;
/**
 *  oid
 */
@property (nonatomic, copy) NSString *oid;

#pragma mark - private
/**
 * shouldShowMoreButton
 */
@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;
/**
 * isOpening
 */
@property (nonatomic, assign) BOOL isOpening;

@end




@interface TXBYTitleItem : NSObject
/**
 *  title
 */
@property (nonatomic, copy) NSString *title;
/**
 *  range
 */
@property (nonatomic, copy) NSString *range;

@end
