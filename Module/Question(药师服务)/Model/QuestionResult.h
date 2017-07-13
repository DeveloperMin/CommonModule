//
//  QuestionResult.h
//  publicCommon
//
//  Created by hj on 17/2/20.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "TXBYBaseResult.h"
@class Question, QuestionReply;

@interface QuestionResult : TXBYBaseResult

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) NSArray *replies;
@property (nonatomic, copy) NSString *loved_id;

@end
