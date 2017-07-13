//
//  QuestionMinorReplyCell.h
//  publicCommon
//
//  Created by hj on 17/2/21.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionReply;

@interface QuestionMinorReplyCell : UITableViewCell

@property (nonatomic, strong) QuestionReply *questionReply;

@property (nonatomic, copy) NSString *totalReply;

@end
