//
//  TXBYActionSheet.h
//  TXBYKit
//
//  Created by mac on 16/2/22.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//  自定义ActionSheet

#import <UIKit/UIKit.h>
#import "TXBYActionSheetItem.h"
@class TXBYActionSheet;

@protocol TXBYActionSheetDelegate <NSObject>

@optional
/**
 *  点击了第index个按钮
 */
- (void)actionSheet:(TXBYActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)index;

@end


@interface TXBYActionSheet : UIView

/**
 *  标题文字
 */
@property (nonatomic, copy) NSString *title;

/**
 *  取消按钮文字，默认为"取消"
 */
@property (nonatomic, copy) NSString *cancelTitle;

/**
 * 其它按钮模型（存放TXBYActionSheetItem）
 */
@property (nonatomic, strong) NSArray *otherButtonItems;

/**
 *  动画时间，默认0.25秒
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 *  背景透明度,默认0.3
 */
@property (nonatomic, assign) CGFloat backgroundOpacity;

/**
 *  点击按钮block
 */
@property (nonatomic, copy) void (^operation)(NSInteger index);

#pragma mark - methods
/**
 *  显示actionSheet
 */
- (void)show;

#pragma mark - init
#pragma mark 使用item模型中的块代码
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonItems:(NSArray *)otherButtonItems;
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle;
- (instancetype)initWithTitle:(NSString *)title otherButtonItems:(NSArray *)otherButtonItems;
- (instancetype)initWithTitle:(NSString *)title;
+ (instancetype)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonItems:(NSArray *)otherButtonItems;
+ (instancetype)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle;
+ (instancetype)actionSheetWithTitle:(NSString *)title otherButtonItems:(NSArray *)otherButtonItems;
+ (instancetype)actionSheetWithTitle:(NSString *)title;

#pragma mark 使用代理方法
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonItems:(NSArray *)otherButtonItems delegate:(id<TXBYActionSheetDelegate>)delegate;
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *) cancelButtonTitle delegate:(id<TXBYActionSheetDelegate>)delegate;
- (instancetype)initWithTitle:(NSString *)title otherButtonItems:(NSArray *)otherButtonItems delegate:(id<TXBYActionSheetDelegate>)delegate;
- (instancetype)initWithTitle:(NSString *)title delegate:(id<TXBYActionSheetDelegate>)delegate;
+ (instancetype)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonItems:(NSArray *)otherButtonItems delegate:(id<TXBYActionSheetDelegate>)delegate;
+ (instancetype)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *) cancelButtonTitle delegate:(id<TXBYActionSheetDelegate>)delegate;
+ (instancetype)actionSheetWithTitle:(NSString *)title otherButtonItems:(NSArray *)otherButtonItems delegate:(id<TXBYActionSheetDelegate>)delegate;
+ (instancetype)actionSheetWithTitle:(NSString *)title delegate:(id<TXBYActionSheetDelegate>)delegate;

#pragma mark 使用块代码
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonItems:(NSArray *)otherButtonItems clicked:(void (^)(NSInteger index))clicked;
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *) cancelButtonTitle clicked:(void (^)(NSInteger index))clicked;
- (instancetype)initWithTitle:(NSString *)title otherButtonItems:(NSArray *)otherButtonItems clicked:(void (^)(NSInteger index))clicked;
- (instancetype)initWithTitle:(NSString *)title clicked:(void (^)(NSInteger index))clicked;
+ (instancetype)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonItems:(NSArray *)otherButtonItems clicked:(void (^)(NSInteger index))clicked;
+ (instancetype)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *) cancelButtonTitle clicked:(void (^)(NSInteger index))clicked;
+ (instancetype)actionSheetWithTitle:(NSString *)title otherButtonItems:(NSArray *)otherButtonItems clicked:(void (^)(NSInteger index))clicked;
+ (instancetype)actionSheetWithTitle:(NSString *)title clicked:(void (^)(NSInteger index))clicked;

@end