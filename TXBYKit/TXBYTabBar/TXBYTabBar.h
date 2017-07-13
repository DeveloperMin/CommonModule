//
//  TXBYTabBar.h
//  TXBYKit-master
//
//  Created by mac on 16/4/20.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
@class TXBYTabBar;
@class TXBYTabBarButton;

// 按钮初始tag
extern NSInteger TXBYTabBarTagStart;

@protocol TXBYTabBarDelegate <NSObject>

@optional
/**
 *  从一个按钮切换到另一个
 */
- (void)tabBar:(TXBYTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface TXBYTabBar : UIView

/**
 *  按钮文字颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 *  选中时按钮文字颜色
 */
@property (nonatomic, strong) UIColor *selectedTitleColor;

/**
 *  当前选中的按钮
 */
@property (nonatomic, weak) TXBYTabBarButton *selectedButton;

/**
 *  代理
 */
@property (nonatomic, weak) id <TXBYTabBarDelegate> delegate;
/**
 *  监听按钮点击
 */
- (void)buttonClick:(TXBYTabBarButton *)button;
/**
 *  用对应控制器的UITabBarItem来添加自定义tabBarbutton
 */
- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@end