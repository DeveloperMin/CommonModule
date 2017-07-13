//
//  TXBYListViewController.m
//  TXBYKit
//
//  Created by mac on 16/4/14.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYListViewController.h"
#import "TXBYListItem.h"
#import "TXBYListCell.h"
#import "TXBYKit.h"

@interface TXBYListViewController ()

@end

@implementation TXBYListViewController

#pragma mark - setters
- (void)setItems:(NSArray *)items {
    _items = items;
    
    // 刷新表格
    [self.tableView reloadData];
}

- (void)setGroups:(NSArray *)groups {
    _groups = groups;
    
    // 刷新表格
    [self.tableView reloadData];
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

#pragma mark - private
- (void)setup {
    // 1. 设置sectionHeaderHeight
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 2. 设置头部
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, self.view.frame.size.width, 10);
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
    self.view.backgroundColor = TXBYColor(230, 232, 237);
}

#pragma mark - UITableViewDataSource
/**
 *  多少组
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_groups) {
        return _groups.count;
    } else {
        return 1;
    }
}


/**
 *  多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_groups) {
        NSArray *itemArr = _groups[section];
        return itemArr.count;
    } else {
        return self.items.count;
    }
}

/**
 *  cell显示内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_groups) {
        NSArray *itemArr = _groups[indexPath.section];
        // 1. 创建cell
        static NSString *CellIdentifier = @"TXBYListCell";
        TXBYListCell *cell = [TXBYListCell cellWithTableView:tableView classString:CellIdentifier];
        
        // 2. 传递模型
        cell.listItem = itemArr[indexPath.row];
        
        // 3. 设置背景图片
        [cell setBgAtIndexPath:indexPath countInSection:itemArr.count];
        
        return cell;
    } else {
        // 1. 创建cell
        static NSString *CellIdentifier = @"TXBYListCell";
        TXBYListCell *cell = [TXBYListCell cellWithTableView:tableView classString:CellIdentifier];
        
        // 2. 传递模型
        cell.listItem = self.items[indexPath.row];
        
        // 3. 设置背景图片
        [cell setBgAtIndexPath:indexPath countInSection:self.items.count];
        
        return cell;
    }
}

/**
 *  每一行高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_groups) {
        NSArray *itemArr = _groups[indexPath.section];
        return [itemArr[indexPath.row] cellHeight];
    } else {
        return [self.items[indexPath.row] cellHeight];
    }
}

#pragma mark - UITabelViewDelegate
/**
 *  选中某一行
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end