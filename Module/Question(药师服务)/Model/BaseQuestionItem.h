//
//  BaseQuestionItem.h
//  publicCommon
//
//  Created by hj on 17/2/22.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionImage.h"

@interface BaseQuestionItem : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *attention;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *browse;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *group;
@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, copy) NSString *is_loved;
@property (nonatomic, copy) NSString *is_treaded;
@property (nonatomic, copy) NSString *love;
@property (nonatomic, copy) NSString *loved_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tread;
@property (nonatomic, copy) NSString *top;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, strong) NSArray *imgs;

@end
