//
//  QuestAddViewController.h
//  smh
//
//  Created by yh on 15/3/31.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  提问控制器

#import <UIKit/UIKit.h>
@class QuestAddViewController;

@protocol QuestAddViewDelegage <NSObject>

@optional
/**
 *  提问完成
 */
- (void)questAddViewControllerDidFinish:(QuestAddViewController *)vc;

@end

@interface QuestAddViewController : UIViewController

/**
 *  代理
 */
@property (nonatomic, assign) id <QuestAddViewDelegage> delegate;

@end