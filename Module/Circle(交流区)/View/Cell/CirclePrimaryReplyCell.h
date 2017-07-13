//
//  QuestionPrimaryReplyCell.h
//  publicCommon
//
//  Created by hj on 17/2/21.
//  Copyright © 2017年 txby. All rights reserved.
//

typedef void(^ButtonBlock)(UIButton *btn);

#import <UIKit/UIKit.h>
@class TXBYCircleReply, TXBYCircleModel;

@protocol CirclePrimaryReplyCellDeleagte <NSObject>

- (void)detialViewCellClickAvatar:(TXBYCircleReply *)circleReply;

@end

@interface CirclePrimaryReplyCell : UITableViewCell

@property (nonatomic, strong) TXBYCircleReply *circleReply;
@property (nonatomic, strong) TXBYCircleModel *circleModel;

/**
 *  是否二级评论
 */
@property (nonatomic, assign) BOOL isMinorReply;

@property (nonatomic, copy) ButtonBlock likeButtonBlock;
@property (nonatomic, copy) ButtonBlock replyButtonBlock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelLeftConstraint;
/**
 *  是否是医生端
 */
@property (nonatomic, assign) BOOL isDoctorUser;
/**
 * delegate
 */
@property (nonatomic, weak) id<CirclePrimaryReplyCellDeleagte> delegate;

@end
