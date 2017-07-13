//
//  TXBYSettingViewController.m
//  TXBYKit
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYSettingViewController.h"
#import "TXBYSettingCell.h"
#import "TXBYCategory.h"

#define TXBYSETTING_IOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

@interface TXBYSettingViewController ()

@end

@implementation TXBYSettingViewController
#pragma mark -- getter and setter
- (NSMutableArray *)groups {
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (void)setSectionMargin:(TXBYSettingSectionMargin)sectionMargin {
    if (!TXBYSETTING_IOS7) return;
    CGFloat margin = sectionMargin ? 20 : 10;
    
    // 设置tableView属性
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = margin;
    self.tableView.contentInset = UIEdgeInsetsMake(margin - 35, 0, 0, 0);
}

#pragma mark - init
/**
 *  屏蔽tableView的样式
 */
- (id)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - lifecycle
/**
 *  视图加载完成
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置section之间的距离
    [self setSectionMargin:TXBYSettingSectionMarginSmall];
}

#pragma mark - Table view data source
/**
 *  有多少组
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

/**
 *  有多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TXBYSettingGroup *group = self.groups[section];
    return group.items.count;
}

/**
 *  每一行内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1. 创建cell
    static NSString *CellIdentifier = @"TXBYSettingCell";
    TXBYSettingCell *cell = (TXBYSettingCell *)[UITableViewCell cellWithTableView:tableView classString:CellIdentifier];
    
    // 2. 传递模型
    TXBYSettingGroup *group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    
    // 3. 设置背景
    [cell setBgAtIndexPath:indexPath countInSection:group.items.count];
    
    return cell;
}

/**
 *  尾部文字
 */
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    TXBYSettingGroup *group = self.groups[section];
    return group.footer;
}

/**
 *  头部文字
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    TXBYSettingGroup *group = self.groups[section];
    return group.header;
}

/**
 *  每一行高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TXBYSettingViewCellH;
}

#pragma mark - Table view delegate
/**
 *  选中某一行
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // 1. 取出模型
    TXBYSettingGroup *group = self.groups[indexPath.section];
    TXBYSettingItem *item = group.items[indexPath.row];
    
    // 1. 如果是打勾
    if ([item isKindOfClass:[TXBYSettingCheckItem class]]) { // 打勾
        TXBYSettingCheckItem *checkItem = (TXBYSettingCheckItem *)item;
        if (checkItem.on) return; // 如果点击的这个cell没有打勾才去改变状态。否则不改变
        
        // 循环所有item
        [group.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             if (![obj isKindOfClass:[TXBYSettingCheckItem class]]) return;
             [obj setOn:[obj isEqual:item]];
         }];
        // 刷新表格
        [self.tableView reloadData];
    }
    
    // 2. 判断有没有要跳转的控制器
    if (item.destClass) {
        // 创建目标控制器
        UIViewController *vc = [[item.destClass alloc] init];
        // 设置标题
        vc.title = item.title;
        // 跳转到目标控制器
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    // 3. 判断有没有操作
    if (item.operation) {
        item.operation();
    }
}

@end