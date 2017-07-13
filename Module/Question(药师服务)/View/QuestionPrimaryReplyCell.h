//
//  QuestionPrimaryReplyCell.h
//  publicCommon
//
//  Created by hj on 17/2/21.
//  Copyright © 2017年 txby. All rights reserved.
//

typedef void(^ButtonBlock)(void);

#import <UIKit/UIKit.h>
@class QuestionReply, Question;

@interface QuestionPrimaryReplyCell : UITableViewCell

@property (nonatomic, strong) QuestionReply *questionReply;
@property (nonatomic, strong) Question *question;

/**
 *  是否二级评论
 */
@property (nonatomic, assign) BOOL isMinorReply;

@property (nonatomic, copy) ButtonBlock likeButtonBlock;
@property (nonatomic, copy) ButtonBlock replyButtonBlock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelLeftConstraint;

@end
