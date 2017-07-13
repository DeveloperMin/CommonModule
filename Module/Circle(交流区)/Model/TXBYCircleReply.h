//
//  QuestionReply.h
//  publicCommon
//
//  Created by hj on 17/2/20.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "TXBYCircleModel.h"

@interface TXBYCircleReply : TXBYCircleModel

@property (nonatomic, copy) NSString *type;
/**
 *  user_role
 */
@property (nonatomic, copy) NSString *user_role;
@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, copy) NSString *at_uid;
@property (nonatomic, copy) NSString *at_name;
@property (nonatomic, copy) NSString *at_user_name;
@property (nonatomic, strong) NSArray *sub;

@end
