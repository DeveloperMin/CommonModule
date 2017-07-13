//
//  DrugMenu.h
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//  药价公示目录中的sectionHeader

#import <UIKit/UIKit.h>

@interface DrugMenu : UIButton

/**
 *  是否展开
 */
@property (nonatomic, assign) BOOL open;

/**
 *  设置背景
 *
 *  @param indexPath  按钮在在第几个section
 *  @param count      一共有几个section
 */
- (void)setBgInSection:(NSInteger)section count:(NSInteger)count;

@end