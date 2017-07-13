//
//  QuestionCreateController.h
//  publicCommon
//
//  Created by hj on 17/2/20.
//  Copyright © 2017年 txby. All rights reserved.
//

typedef NS_ENUM(NSInteger, QuestionCreateStyle) {
    QuestionCreateStyleReply,
    QuestionCreateStyleQuestion
};

typedef void(^QuestionSuccess)(void);

#import <UIKit/UIKit.h>
@class Question, QuestionReply;

@interface QuestionCreateController : UITableViewController

@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) QuestionReply *questionReply;

@property (nonatomic, assign) QuestionCreateStyle questionCreateStyle;

@property (nonatomic, copy) QuestionSuccess replySuccessBlock;
@property (nonatomic, copy) QuestionSuccess createSuccessBlock;

@end
