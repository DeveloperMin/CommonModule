//
//  QuestionReplyDetailController.h
//  publicCommon
//
//  Created by hj on 17/2/24.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Question, QuestionReply;

@interface QuestionReplyDetailController : UITableViewController

@property (nonatomic, strong) Question *question;

@property (nonatomic, strong) QuestionReply *questionReply;

@end
