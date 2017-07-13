//
//  QuestionListController.h
//  publicCommon
//
//  Created by hj on 17/2/20.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QuestionListControllerType) {
    QuestionListControllerTypePatient,
    QuestionListControllerTypeDoctor
};

@interface QuestionListController : UITableViewController

@property (nonatomic, assign) QuestionListControllerType questionListControllerType;

/**
 *  更新列表数据
 */
- (void)updateList;

@end
