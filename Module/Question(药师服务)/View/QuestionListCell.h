//
//  QuestionListCell.h
//  publicCommon
//
//  Created by hj on 17/2/20.
//  Copyright © 2017年 txby. All rights reserved.
//

typedef void(^ButtonBlock)(void);

#import <UIKit/UIKit.h>
@class Question;

@interface QuestionListCell : UITableViewCell

@property (nonatomic, strong) Question *question;

@property (nonatomic, copy) ButtonBlock likeButtonBlock;
@property (nonatomic, copy) ButtonBlock replyButtonBlock;

@end
