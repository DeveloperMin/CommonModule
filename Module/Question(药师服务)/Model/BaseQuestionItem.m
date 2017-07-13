//
//  BaseQuestionItem.m
//  publicCommon
//
//  Created by hj on 17/2/22.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "BaseQuestionItem.h"

@implementation BaseQuestionItem

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"imgs" : [QuestionImage class]};
}

@end
