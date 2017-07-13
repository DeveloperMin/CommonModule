//
//  QuestionLikeButton.m
//  publicCommon
//
//  Created by hj on 17/2/21.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "CircleLikeButton.h"

@implementation CircleLikeButton

+ (instancetype)likeButton {
    CircleLikeButton *likeButton = [[self alloc] init];
    return likeButton;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.titleLabel.font = [UIFont systemFontOfSize:13];
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

//- (void)setLiking:(BOOL)liking {
//    _liking = liking;
//    
//    NSString *imageName = liking ? @"Circle.bundle/circle_unliked": @"Circle.bundle/circle_unlike";
//    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//}

- (void)setLikeNumberStr:(NSString *)likeNumberStr {
    _likeNumberStr = [likeNumberStr copy];
    if (likeNumberStr.integerValue) {
        [self setTitle:likeNumberStr forState:UIControlStateNormal];
    } else {
        [self setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
