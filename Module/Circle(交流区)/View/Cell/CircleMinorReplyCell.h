//
//  QuestionMinorReplyCell.h
//  publicCommon
//
//  Created by hj on 17/2/21.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TXBYCircleReply;

@interface CircleMinorReplyCell : UITableViewCell

@property (nonatomic, strong) TXBYCircleReply *circleReply;

@property (nonatomic, copy) NSString *totalReply;

@end
