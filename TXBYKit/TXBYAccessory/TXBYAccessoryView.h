//
//  TXBYAccessoryView.h
//  TXBYKit
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//  键盘辅助视图

#import <UIKit/UIKit.h>

@interface TXBYAccessoryView : UIView

/**
 *  文字标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  创建辅助视图
 */
+ (instancetype)accessoryViewWithTarget:(id)target action:(SEL)action;

@end