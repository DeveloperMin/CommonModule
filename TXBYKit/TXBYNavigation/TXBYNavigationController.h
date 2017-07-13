//
//  TXBYNavigationController.h
//  TXBYKit
//
//  Created by mac on 16/4/19.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXBYNavigationController : UINavigationController

/**
 *  控制器全局背景颜色
 */
@property (nonatomic, strong) UIColor *globalBackgroundColor;

/**
 *  导航栏背景颜色
 */
@property (nonatomic, strong) UIColor *navigationBarBarTintColor;

/**
 *  导航栏系统自带图标颜色
 */
@property (nonatomic, strong) UIColor *navigationBarTintColor;

/**
 *  导航栏标题字体
 */
@property (nonatomic, strong) UIFont *navigationBarTitleFont;

/**
 *  导航栏标题文字颜色
 */
@property (nonatomic, strong) UIColor *navigationBarTitleColor;

/**
 *  正常状态下导航栏按钮字体
 */
@property (nonatomic, strong) UIFont *barButtonItemFont;

/**
 *  正常状态下导航栏按钮文字颜色
 */
@property (nonatomic, strong) UIColor *barButtonItemColor;

/**
 *  disabled状态下导航栏按钮文字颜色
 */
@property (nonatomic, strong) UIColor *barButtonItemDisabledColor;
/**
 *  navBackIcon
 */
@property (nonatomic, copy) NSString *navBackIcon;
/**
 *  自定义返回按钮
 */
@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;

@end
