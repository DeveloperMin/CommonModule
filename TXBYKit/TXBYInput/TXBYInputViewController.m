//
//  TXBYInputViewController.m
//  TXBYKit-master
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYInputViewController.h"
#import "TXBYInputCell.h"
#import "TXBYCategory.h"

@interface TXBYInputViewController () <TXBYInputCellDelegate>

@end

@implementation TXBYInputViewController

#pragma mark - getters
/**
 *  获取所有组数据模型
 */
- (NSMutableArray *)groups
{
    if (!_groups)
    {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

#pragma mark - setters
/**
 *  设置section之间的距离
 */
- (void)setSctionMargin:(TXBYInputViewSectionMargin)sctionMargin
{
    //if (!IOS7) return;
    CGFloat margin = sctionMargin ? 20 : 10;
    
    // 设置tableView属性
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = margin;
    self.tableView.contentInset = UIEdgeInsetsMake(margin - 35, 0, 0, 0);
}

#pragma mark - lifecycle
/**
 *  屏蔽tableView的样式
 */
- (id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

/**
 *  视图加载完成
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置section之间的距离
    [self setSctionMargin:TXBYInputViewSectionMarginSmall];
}

#pragma mark - Table view data source
/**
 *  有多少组
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

/**
 *  有多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TXBYInputGroup *group = self.groups[section];
    return group.items.count;
}

/**
 *  每一行内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1. 创建cell
    static NSString *CellIdentifier = @"TXBYInputCell";
    TXBYInputCell *cell = (TXBYInputCell *)[UITableViewCell cellWithTableView:tableView classString:CellIdentifier];
    
    // 2. 传递模型
    TXBYInputGroup *group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    
    // 3. 设置背景
    [cell setBgAtIndexPath:indexPath countInSection:group.items.count];
    
    // 4. 设置代理（如果是日期选择控件或下拉选择控件）
    TXBYInputItem *item = cell.item;
    if ([item isKindOfClass:[TXBYInputDateItem class]] || [item isKindOfClass:[TXBYInputPickerItem class]])
    {
        cell.delegate = self;
    }
    
    return cell;
}

/**
 *  尾部文字
 */
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    TXBYInputGroup *group = self.groups[section];
    return group.footer;
}

/**
 *  头部文字
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    TXBYInputGroup *group = self.groups[section];
    return group.header;
}

/**
 *  每一行高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 对应的组
    TXBYInputGroup *group = self.groups[indexPath.section];
    // 对应的行
    TXBYInputItem *item = group.items[indexPath.row];
    
    return item.cellHeight;
}

#pragma mark - Table view delegate
/**
 *  选中某一行
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // 取出模型
    TXBYInputGroup *group = self.groups[indexPath.section];
    TXBYInputItem *item = group.items[indexPath.row];
    
    // 成为第一响应者（如果是输入框或日期选择控件或下拉选择控件）
    if ([item isKindOfClass:[TXBYInputFieldItem class]] ||[item isKindOfClass:[TXBYInputDateItem class]] || [item isKindOfClass:[TXBYInputPickerItem class]])
    {
        // 设置输入框为第一响应者
        TXBYInputCell *cell = (TXBYInputCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirst];
    }
}

#pragma mark - TXBYInputCellDelegate
/**
 *  刷新表格
 */
- (void)cellWillReload:(TXBYInputCell *)cell
{
    [self.tableView reloadData];
}

#pragma mark - scrollView代理
/**
 *  开始滚动
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.keyboardDismissOnDrag) {
        [self.view endEditing:YES];
    }
}

@end