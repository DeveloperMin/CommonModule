//
//  QuestionReplyButton.m
//  publicCommon
//
//  Created by hj on 17/2/21.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "QuestionReplyButton.h"

@implementation QuestionReplyButton

+ (instancetype)likeButton {
    QuestionReplyButton *likeButton = [[QuestionReplyButton alloc] init];
    return likeButton;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setImage:[UIImage imageNamed:@"Question.bundle/question_reply_icon"] forState:UIControlStateNormal];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setImage:[UIImage imageNamed:@"Question.bundle/question_reply_icon"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setComment:(NSString *)comment {
    _comment = [comment copy];
    if (comment.integerValue) {
        [self setTitle:comment forState:UIControlStateNormal];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    } else {
        [self setTitle:@"" forState:UIControlStateNormal];
    }
}

@end
