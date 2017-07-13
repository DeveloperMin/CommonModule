//
//  QuestionReply.m
//  publicCommon
//
//  Created by hj on 17/2/20.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "QuestionReply.h"

@implementation QuestionReply

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"sub" : [QuestionReply class],@"imgs" : [QuestionImage class]};
}
@end
