//
//  QuestionReplyDetailController.h
//  publicCommon
//
//  Created by hj on 17/2/24.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TXBYCircleModel, TXBYCircleReply;

typedef void(^UpdateListBlock)(void);

@interface CircleReplyDetailController : UITableViewController
/**
 *  是否是医生端
 */
@property (nonatomic, assign) BOOL isDoctorUser;

@property (nonatomic, strong) TXBYCircleModel *circleModel;

@property (nonatomic, strong) TXBYCircleReply *circleReply;
/**
 *  updateBlock
 */
@property (nonatomic, copy) UpdateListBlock updateBlock;
/**
 *  indexPath
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
