//
//  QuestionReplyButton.m
//  publicCommon
//
//  Created by hj on 17/2/21.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "CircleReplyButton.h"

@implementation CircleReplyButton

+ (instancetype)likeButton {
    CircleReplyButton *likeButton = [[CircleReplyButton alloc] init];
    return likeButton;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    [self setImage:[UIImage imageNamed:@"Circle.bundle/circle_comment"] forState:UIControlStateNormal];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setImage:[UIImage imageNamed:@"Circle.bundle/circle_comment"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setComment:(NSString *)comment {
    _comment = [comment copy];
    if (comment.integerValue) {
        [self setTitle:comment forState:UIControlStateNormal];
    } else {
        [self setTitle:@"" forState:UIControlStateNormal];
    }
}

@end
