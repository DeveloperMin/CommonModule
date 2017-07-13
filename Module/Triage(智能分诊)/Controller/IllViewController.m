//
//  IllViewController.m
//  smh
//
//  Created by yh on 15/3/21.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//

#import "IllViewController.h"
#import "TriageTool.h"
#import "TriageResult.h"
#import "Ill.h"
#import "IllCell.h"

@interface IllViewController ()

/**
 *  ill模型数组
 */
@property (nonatomic, strong) NSArray *ills;

@end

@implementation IllViewController

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置表格属性
    [self setupTableView];
    
    // 网络请求
    [self request];

}

/**
 *  销毁
 */
- (void)dealloc {
    // 取消网络请求
    [[TXBYHTTPSessionManager sharedManager] cancelNetworkingWithNetIdentifier:TXBYClassName];
}

#pragma mark - private
/**
 *  网络请求
 */
- (void)request {
    // 发送请求
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    __weak typeof(self)weakSelf = self;
    [TriageTool illsWithParam:self.param netIdentifier:TXBYClassName success:^(TriageResult *result) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:weakSelf.view];
        
        weakSelf.ills= result.ills;
        // 刷新表格
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:weakSelf.view];
        // 网络加载失败
        [weakSelf requestFailure:error];
    }];
}

/**
 *  设置表格属性
 */
- (void)setupTableView {
    // 去除分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置头部
    UIView *header = [[UIView alloc] init];
    CGFloat cellMargin = 10;
    header.frame = CGRectMake(0, 0, self.view.frame.size.width, cellMargin);
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
}

#pragma mark - UITableViewDataSource
/**
 *  多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ills.count;
}

/**
 *  内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    static NSString *CellIdentifier = @"IllCell";
    IllCell *cell = [IllCell cellWithTableView:tableView classString:CellIdentifier];
    
    // 取出对应的模型
    cell.ill = self.ills[indexPath.row];
    
    // 设置背景和内容
    [cell setBgAtIndexPath:indexPath countInSection:self.ills.count];
    
    return cell;
}

#pragma mark - UITableViewDelegate
/**
 *  高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.ills[indexPath.row] cellHeight];
}

#pragma mark - super
/**
 *  导航栏标题
 */
- (NSString *)title {
    return @"疾病";
}

@end