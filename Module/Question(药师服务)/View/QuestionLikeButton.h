//
//  QuestionLikeButton.h
//  publicCommon
//
//  Created by hj on 17/2/21.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionLikeButton : UIButton

+ (instancetype)likeButton;

@property (nonatomic, copy) NSString *likeNumberStr;

@property (nonatomic, assign) BOOL liking;

@end
