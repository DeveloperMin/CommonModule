//
//  DrugListViewController.m
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//

#import "DrugListViewController.h"
#import "DrugList.h"
#import "Drug.h"
#import "DrugParam.h"
#import "TXBYListItem.h"
#import "DrugDetailViewController.h"
#import "DrugListCell.h"

// cell栏目高度
#define kHeightForRow 85

@interface DrugListViewController ()

/**
 *  Drug模型数组
 */
@property (nonatomic, strong) NSArray *drugs;

@end

@implementation DrugListViewController

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置tableView属性
    [self setupTableView];
    
    // 发送网络请求
    [self request];
}

/**
 *  销毁
 */
- (void)dealloc
{
    // 取消网络请求
    [[TXBYHTTPSessionManager sharedManager] cancelAllNetworking];
}

#pragma mark - private
/**
 *  设置tableView属性
 */
- (void)setupTableView {
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"DrugListCell" bundle:nil] forCellReuseIdentifier:@"DrugListCell"];
}

/**
 *  发送网络请求
 */
- (void)request
{
    // 1. 加载提示
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
    // 2. 请求参数
    DrugParam *param = [[DrugParam alloc] init];
    param.mtid = self.item.mtid;
    param.mtids = self.item.mtids;
    if ([param.mtid isEqualToString:@"-1"])
    {
        param.cpm = self.item.name;
    }
    
    // 3. 发送请求
    [[TXBYHTTPSessionManager sharedManager] get:TXBYDrugListAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:self.view];
        
        // 转成Drug模型数组
        self.drugs = [Drug mj_objectArrayWithKeyValuesArray:responseObject];
        if (!self.drugs.count)
        {
            [self emptyViewWithText:@"暂无相关数据" andImg:[UIImage imageNamed:@"no_data"]];
            return;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:self.view];
        // 网络加载失败
        [self requestFailure:error];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.drugs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DrugListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DrugListCell"];
    Drug *drug = self.drugs[indexPath.row];
    cell.drug = drug;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightForRow;
}

// 设置UITableViewCell分割线从最左端开始
-(void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

#pragma mark - super
/**
 *  导航栏标题
 */
- (NSString *)title
{
    return [self.item.mtid isEqualToString:@"-1"] ? @"搜索结果" : self.item.name;
}

/**
 *  点击某一行
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DrugDetailViewController *vc = [[DrugDetailViewController alloc] init];
    vc.drug = self.drugs[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
