//
//  QuestionDetailController.h
//  publicCommon
//
//  Created by hj on 17/2/20.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Question;

@interface QuestionDetailController : UITableViewController

@property (nonatomic, strong) Question *question;
/**
 *  更新列表数据
 */
- (void)updateList;

-  (instancetype)initWithQuestionID:(NSString *)ID;

@end
