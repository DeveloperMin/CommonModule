//
//  QuestDetailViewController.h
//  smh
//
//  Created by eeesysdev3 on 15/3/31.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  问题详情

#import <UIKit/UIKit.h>
@class Quest;

@interface QuestDetailViewController : UIViewController

/**
 *  问题对象
 */
@property (nonatomic, strong) Quest *quest;

/**
 *  推送到这个界面
 */
@property (nonatomic, assign) BOOL isPush;

@end