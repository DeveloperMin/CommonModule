//
//  TXBYTabBarController.h
//  TXBYKit-master
//
//  Created by mac on 16/4/20.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXBYNavigationController.h"
#import "TXBYTabBar.h"

@interface TXBYTabBarController : UITabBarController
/**
 *  自定义tabbar
 */
@property (nonatomic, weak) TXBYTabBar *customTabBar;
/**
 *  导航控制器
 */
@property (nonatomic, strong) TXBYNavigationController *navigationController;
/**
 *  tabBar背景颜色
 */
@property (nonatomic, strong) UIColor *backgroundColor;
/**
 *  按钮文字颜色
 */
@property (nonatomic, strong) UIColor *titleColor;
/**
 *  选中时按钮文字颜色
 */
@property (nonatomic, strong) UIColor *selectedTitleColor;
/**
 *  navBackIcon
 */
@property (nonatomic, copy) NSString *navBackIcon;
/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 */
- (void)addChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName;

@end
