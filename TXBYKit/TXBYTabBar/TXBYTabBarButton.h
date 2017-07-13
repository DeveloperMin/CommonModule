//
//  TXBYTabBarButton.h
//  TXBYKit-master
//
//  Created by mac on 16/4/20.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXBYTabBarButton : UIButton

/**
 *  接收对应控制器传来的UITabBarItem模型
 */
@property (nonatomic, strong) UITabBarItem *item;

@end