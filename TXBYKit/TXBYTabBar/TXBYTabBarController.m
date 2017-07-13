//
//  TXBYTabBarController.m
//  TXBYKit-master
//
//  Created by mac on 16/4/20.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYTabBarController.h"
#import "TXBYNavigationController.h"
#import "TXBYCategory.h"
#import "TXBYTabBarButton.h"

@interface TXBYTabBarController () <TXBYTabBarDelegate>



@end

@implementation TXBYTabBarController

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.customTabBar.titleColor = titleColor;
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    _selectedTitleColor = selectedTitleColor;
    self.customTabBar.selectedTitleColor = selectedTitleColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    self.customTabBar.backgroundColor = backgroundColor;
}

- (TXBYNavigationController *)navigationController {
    if (!_navigationController) {
        _navigationController = [[TXBYNavigationController alloc] init];
    }
    return _navigationController;
}

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 初始化tabbar
    [self setupTabbar];
}

/**
 *  view将要出现
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 移除系统UITabBarButton
    [self removeTabBarButton];
}

/**
 *  view's layoutSubviews method is invoked
 */
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // 移除系统UITabBarButton
    [self removeTabBarButton];
    
    // 调整自定义tabbarframe
    [self layoutTabbar];
}

#pragma mark - private
/**
 *  移除系统UITabBarButton
 */
- (void)removeTabBarButton {
    if (self.tabBar.subviews.count < self.customTabBar.subviews.count) return;
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

/**
 *  调整自定义tabbarframe
 */
- (void)layoutTabbar {
    self.customTabBar.frame = self.tabBar.bounds;
}

/**
 *  初始化tabbar
 */
- (void)setupTabbar {
    // 自定义tabbar
    TXBYTabBar *customTabBar = [[TXBYTabBar alloc] init];
    self.customTabBar = customTabBar;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
}


/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 */
- (void)addChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName {
    NSString *selectedImageName = [imageName stringByAppendingString:@"_selected"];
    [self setupChildViewController:childVc title:title imageName:imageName selectedImageName:selectedImageName];
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    // 1.1 设置控制器的属性
    childVc.title = title;
    // 1.2 设置图标
    childVc.tabBarItem.image = [UIImage imageWithName:imageName];
    // 1.3 设置选中的图标
    UIImage *selectedImage = [UIImage imageWithName:selectedImageName];
    childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
 
    // 2. 包装一个导航控制器
    TXBYNavigationController *nav = [[TXBYNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    nav.navigationBarBarTintColor = self.navigationController.navigationBarBarTintColor;
    nav.globalBackgroundColor = self.navigationController.globalBackgroundColor;
    nav.navigationBarTintColor = self.navigationController.navigationBarTintColor;
    nav.navigationBarTitleFont = self.navigationController.navigationBarTitleFont;
    nav.navBackIcon = self.navBackIcon;
    nav.navigationBarTitleColor = self.navigationController.navigationBarTitleColor;
    nav.barButtonItemFont = self.navigationController.barButtonItemFont;
    nav.barButtonItemColor = self.navigationController.barButtonItemColor;
    nav.barButtonItemDisabledColor = self.navigationController.barButtonItemDisabledColor;
    nav.backBarButtonItem = self.navigationController.backBarButtonItem;
    
    // 3. 添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}

# pragma mark - TXBYTabBarDelegate
/**
 *  监听tabbar按钮的改变
 *  @param from   原来选中的位置
 *  @param to     最新选中的位置
 */
- (void)tabBar:(TXBYTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to {
    tabBar.selectedButton.selected = NO;
    TXBYTabBarButton *toBtn = tabBar.subviews[to - TXBYTabBarTagStart];
    toBtn.selected = YES;
    tabBar.selectedButton = toBtn;
    // 把tabbar控制器切换到当前选中按钮对应的页面
    self.selectedIndex = to - TXBYTabBarTagStart;
}

@end
