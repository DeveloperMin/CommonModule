//
//  TXBYListItem.h
//  TXBYKit
//
//  Created by mac on 16/4/14.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TXBYListItem : NSObject

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  标题font
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 *  标题颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 *  子标题
 */
@property (nonatomic, copy) NSString *subtitle;

/**
 *  子标题font
 */
@property (nonatomic, strong) UIFont *subtitleFont;

/**
 *  子标题颜色
 */
@property (nonatomic, strong) UIColor *subtitleColor;

/**
 *  是否隐藏右侧箭头
 */
@property (nonatomic, assign) BOOL hideArrow;

/**
 *  能否被选中
 */
@property (nonatomic, assign) BOOL enable;

/**
 *  cell高度
 */
@property (nonatomic, readonly) CGFloat cellHeight;

/**
 *  标题frame
 */
@property (nonatomic, readonly) CGRect titleFrame;

/**
 *  子标题frame
 */
@property (nonatomic, readonly) CGRect subtitleFrame;

- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
+ (instancetype)itemWithTitle:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle;


@end