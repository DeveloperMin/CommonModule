//
//  ReplyBar.h
//  smh
//
//  Created by eeesysdev3 on 15/3/31.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  回复工具栏

#import <UIKit/UIKit.h>
@class ReplyBar;

@protocol ReplyBarDelegate <NSObject>

@optional

/**
 *  点击按钮
 */
- (void)replyBar:(ReplyBar *)replyBar textField:(UITextField *)field;

@end

@interface ReplyBar : UIView

/**
 *  代理
 */
@property (nonatomic, assign) id <ReplyBarDelegate> delegate;

/**
 *  创建ReplyBar
 */
+ (instancetype)replyBar;

@end