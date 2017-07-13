//
//  UITableViewCell+TXBY.h
//  TXBYCategory
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (TXBY)

/**
 *  创建一个可重用的cell
 *
 *  @param tableView  UITableView
 *  @param className  要创建的cell类名
 *  @param identifier 可重用标识符
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView classString:(NSString *)className identifier:(NSString *)identifier;

/**
 *  创建一个可重用的cell(默认用类名当可重用标识符)
 *
 *  @param tableView  UITableView
 *  @param className  要创建的cell类名
 *  @param identifier 可重用标识符
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView classString:(NSString *)className;

/**
 *  设置cell背景
 *
 *  @param indexPath  cell在表格中的位置
 *  @param count      cell所在section中的cell个数
 */
- (void)setBgAtIndexPath:(NSIndexPath *)indexPath countInSection:(NSUInteger)count;

/**
 *  设置cell背景图片（cell背景图片相同时）
 */
- (void)setCommonBg;

@end