//
//  TXBYNavigationController.m
//  TXBYKit
//
//  Created by mac on 16/4/19.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYNavigationController.h"
#import "TXBYKit.h"

// 导航栏系统自带图标默认颜色
#define TXBYNavigationBarTintColor TXBYColor(128, 128, 128)
// 控制器全局默认背景颜色
#define TXBYViewControllerGlobalBackgroundColor TXBYColor(239, 239, 239)
// 导航栏标题默认字体
#define TXBYNavigationBarTitleFont [UIFont boldSystemFontOfSize:19]
// 导航栏标题字体颜色
#define TXBYNavigationBarTitleColor TXBYColor(65, 65, 65)
// 导航栏barButtonItem字体
#define TXBYNavigationBarButtonItemTitleFont [UIFont boldSystemFontOfSize:14]
// 导航栏barButtonItem正常状态下的颜色
#define TXBYNavigationBarButtonItemTitleColor TXBYColor(128, 128, 128)
// 导航栏barButtonItem Disabled状态下的颜色
#define TXBYNavigationBarButtonItemTitleColorDisabled [UIColor grayColor]

@interface TXBYNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation TXBYNavigationController

@synthesize globalBackgroundColor = _globalBackgroundColor;

- (UIColor *)globalBackgroundColor {
    if (!_globalBackgroundColor) {
        _globalBackgroundColor = TXBYViewControllerGlobalBackgroundColor;
    }
    return _globalBackgroundColor;
}

- (void)setGlobalBackgroundColor:(UIColor *)globalBackgroundColor {
    _globalBackgroundColor = globalBackgroundColor;
    self.topViewController.view.backgroundColor = globalBackgroundColor;
}

- (void)setNavigationBarTintColor:(UIColor *)navigationBarTintColor {
    _navigationBarTintColor = navigationBarTintColor;
    if (navigationBarTintColor) {
        UINavigationBar *navBar = [UINavigationBar appearance];
        navBar.tintColor = navigationBarTintColor;
    }
}

- (void)setNavigationBarTitleFont:(UIFont *)navigationBarTitleFont {
    _navigationBarTitleFont = navigationBarTitleFont;
    if (navigationBarTitleFont) {
        [self setTitleTextAttributes:@{NSFontAttributeName:navigationBarTitleFont}];
    }
}

- (void)setNavigationBarTitleColor:(UIColor *)navigationBarTitleColor {
    _navigationBarTitleColor = navigationBarTitleColor;
    if (navigationBarTitleColor) {
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName:navigationBarTitleColor}];
    }
}

- (void)setNavigationBarBarTintColor:(UIColor *)navigationBarBarTintColor {
    _navigationBarBarTintColor = navigationBarBarTintColor;
    if (navigationBarBarTintColor) {
        UINavigationBar *navBar = [UINavigationBar appearance];
        navBar.barTintColor = navigationBarBarTintColor;
        if (navigationBarBarTintColor != [UIColor whiteColor]) {
            // 将导航栏的背景图以及边界的黑线置为透明图
            [navBar setBackgroundImage:[UIImage imageWithColor:_navigationBarBarTintColor] forBarMetrics:UIBarMetricsDefault];
            [navBar setShadowImage:[UIImage new]];
        }
    }
}

- (void)setBarButtonItemFont:(UIFont *)barButtonItemFont {
    _barButtonItemFont = barButtonItemFont;
    if (barButtonItemFont) {
        [self setBarButtonItemTitleTextAttributes:@{NSFontAttributeName:barButtonItemFont}];
    }
}

- (void)setBarButtonItemColor:(UIColor *)barButtonItemColor {
    _barButtonItemColor = barButtonItemColor;
    if (barButtonItemColor) {
        [self setBarButtonItemTitleTextAttributes:@{NSForegroundColorAttributeName:barButtonItemColor}];
    }
}

- (void)setBarButtonItemDisabledColor:(UIColor *)barButtonItemDisabledColor {
    _barButtonItemDisabledColor = barButtonItemDisabledColor;
    if (barButtonItemDisabledColor) {
        [self setBarButtonItemDisabledTitleTextAttributes:@{NSForegroundColorAttributeName:barButtonItemDisabledColor}];
    }
}

- (NSDictionary *)setTitleTextAttributes:(NSDictionary *)dictionary {
    UINavigationBar *navBar = [UINavigationBar appearance];
    NSMutableDictionary *textAttrs = [navBar.titleTextAttributes mutableCopy];
    [textAttrs addEntriesFromDictionary:dictionary];
    [navBar setTitleTextAttributes:textAttrs];
    return textAttrs;
}

- (NSDictionary *)setBarButtonItemTitleTextAttributes:(NSDictionary *)dictionary {
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *textAttrs = [[item titleTextAttributesForState:UIControlStateNormal] mutableCopy];
    [textAttrs addEntriesFromDictionary:dictionary];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
    return textAttrs;
}

- (NSDictionary *)setBarButtonItemDisabledTitleTextAttributes:(NSDictionary *)dictionary {
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *textAttrs = [[item titleTextAttributesForState:UIControlStateDisabled] mutableCopy];
    [textAttrs addEntriesFromDictionary:dictionary];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateDisabled];
    return textAttrs;
}

#pragma mark - lifecycle
/**
 *  第一次使用这个类的时候会调用(1个类只会调用1次)
 */
+ (void)initialize {
    // 1. 设置导航栏主题
    [self setupNavBarTheme];
    
    // 2. 设置导航栏按钮主题
    [self setupBarButtonItemTheme];
}

#pragma mark - private
/**
 *  设置导航栏主题
 */
+ (void)setupNavBarTheme {
    // 1. 取出appearance对象
    UINavigationBar *navBar = [UINavigationBar appearance];

    // 2. 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = TXBYNavigationBarTitleColor;
    textAttrs[NSFontAttributeName] = TXBYNavigationBarTitleFont;
    [navBar setTitleTextAttributes:textAttrs];
    
    // 3. 导航栏系统自带图标颜色
    navBar.tintColor = TXBYNavigationBarTintColor;
}

/**
 *  设置导航栏按钮主题
 */
+ (void)setupBarButtonItemTheme {
    // 1. 获取整个项目中的导航栏按钮
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 2. 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = TXBYNavigationBarButtonItemTitleColor;
    textAttrs[NSFontAttributeName] = TXBYNavigationBarButtonItemTitleFont;
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
    // Disabled下的文字属性
    NSMutableDictionary *textAttrsDisabled = [NSMutableDictionary dictionary];
    textAttrsDisabled[NSForegroundColorAttributeName] = TXBYNavigationBarButtonItemTitleColorDisabled;
    textAttrsDisabled[NSFontAttributeName] = TXBYNavigationBarButtonItemTitleFont;
    [item setTitleTextAttributes:textAttrsDisabled forState:UIControlStateDisabled];
}

/**
 *  导航栏返回按钮点击
 */
- (void)back {
    // 1. pop回上一个控制器
    [self popViewControllerAnimated:YES];
}

#pragma mark - super
/**
 *  拦截控制器push
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 1. 如果不是nav的根控制器
    if (self.viewControllers.count > 0) {
        // 1.1 push时隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        
        NSString *navBackIcon;
        if (self.navBackIcon.length) {
            navBackIcon = self.navBackIcon;
        } else {
            navBackIcon = @"TXBYNavigation.bundle/toolbar_back";
            if ((self.navigationBarBarTintColor == [UIColor whiteColor]) || (!self.navigationBarBarTintColor)) {
                navBackIcon = @"TXBYNavigation.bundle/toolbar_back_gray";
            }
        }
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:navBackIcon target:self action:@selector(back)];
        
//        if (self.backBarButtonItem) {
//            self.backBarButtonItem.target = viewController;
//            self.backBarButtonItem.action = @selector(back);
//            viewController.navigationItem.leftBarButtonItem = self.backBarButtonItem;
//        }
        // 1.2 添加自定义返回按钮
        self.interactivePopGestureRecognizer.enabled = YES;
        self.interactivePopGestureRecognizer.delegate = self;
    }
    
    // 2 设置控制器背景颜色
    viewController.view.backgroundColor = self.globalBackgroundColor;
    
    if ([viewController isKindOfClass:[UITableViewController class]]) {
        // 导航栏有穿透效果
        viewController.edgesForExtendedLayout = UIRectEdgeTop | UIRectEdgeBottom;
    } else {
        // 导航栏没有穿透效果
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // 3. push
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.interactivePopGestureRecognizer == gestureRecognizer) {
        // 根控制器禁用右滑返回手势，防止应用出现假死
        return (self.viewControllers.count - 1);
    }
    return YES;
}

@end
