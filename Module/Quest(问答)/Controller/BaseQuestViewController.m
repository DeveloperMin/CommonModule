//
//  BaseQuestViewController.m
//  smh
//
//  Created by yh on 15/3/29.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//

#import "BaseQuestViewController.h"
#import "QuestDetailViewController.h"
#import "QuestCell.h"

@interface BaseQuestViewController ()

@end

@implementation BaseQuestViewController

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置表格属性
    [self setupTableView];
}

#pragma mark - private
/**
 *  设置表格属性
 */
- (void)setupTableView {
    // 去除分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDataSource
/**
 *  多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.quests.count;
}

/**
 *  内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    static NSString *CellIdentifier = @"QuestCell";
    QuestCell *cell = [QuestCell cellWithTableView:tableView classString:CellIdentifier];
    // 取出对应的模型
    cell.quest = self.quests[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
/**
 *  高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.quests[indexPath.row] cellHeight];
}

/**
 *  选中某一行
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // 跳转到问题详情界面
    QuestDetailViewController *vc = [[QuestDetailViewController alloc] init];
    vc.quest = self.quests[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end