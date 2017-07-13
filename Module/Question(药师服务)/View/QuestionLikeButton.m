//
//  QuestionLikeButton.m
//  publicCommon
//
//  Created by hj on 17/2/21.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "QuestionLikeButton.h"

@implementation QuestionLikeButton

+ (instancetype)likeButton {
    QuestionLikeButton *likeButton = [[QuestionLikeButton alloc] init];
    return likeButton;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setImage:[UIImage imageNamed:@"Question.bundle/question_dislike_icon"] forState:UIControlStateNormal];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setImage:[UIImage imageNamed:@"Question.bundle/question_dislike_icon"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setLiking:(BOOL)liking {
    _liking = liking;
    
    NSString *imageName = liking ? @"Question.bundle/question_liked_icon" : @"Question.bundle/question_dislike_icon";
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)setLikeNumberStr:(NSString *)likeNumberStr {
    _likeNumberStr = [likeNumberStr copy];
    if (likeNumberStr.integerValue) {
        [self setTitle:likeNumberStr forState:UIControlStateNormal];
        [self setTitleColor:TXBYColor(250, 126, 33) forState:UIControlStateNormal];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    } else {
        [self setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

@end
