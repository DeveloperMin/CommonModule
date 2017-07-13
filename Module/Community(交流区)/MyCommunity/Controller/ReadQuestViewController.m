//
//  ReadQuestViewController.m
//  ydyl
//
//  Created by Limmy on 2016/9/22.
//  Copyright © 2016年 txby. All rights reserved.
//

#import "ReadQuestViewController.h"
#import "CommunityParam.h"
#import "CommunityListItem.h"
#import "CommunityCellFrame.h"
#import "CommunityCommentController.h"
#import "CommunityListCell.h"
#import "CommunityDetailController.h"
#import "ExpertQuestCell.h"

@interface ReadQuestViewController ()

@property (nonatomic, strong) NSArray *quests;

@end

@implementation ReadQuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"ExpertQuestCell" bundle:nil] forCellReuseIdentifier:@"ExpertQuestCell"];
    [self request];
    [self setupRefresh];
}

/**
 *  添加下拉刷新视图
 */
- (void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(request)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

/**
 *  上拉加载更多数据
 */
- (void)loadMoreData {
    if (self.quests.count < 20) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [self accountUnExpired:^{
        CommunityParam *param = [CommunityParam param];
        CommunityListItem *item = self.quests.lastObject;
        param.max_id = item.ID;
        WeakSelf;
        // 发送请求
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYReadQuestAPI parameters:param.mj_keyValues netIdentifier:self.title success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
            // 查询成功
            if ([responseObject[@"errcode"] integerValue] == 0) {
                NSArray *array = [CommunityListItem mj_objectArrayWithKeyValuesArray:responseObject[@"quests"]];
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.quests];
                if (array.count) {
                    [tempArray addObjectsFromArray:array];
                    self.quests = tempArray;
                } else {
                    // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                    [selfWeak.tableView.mj_footer endRefreshingWithNoMoreData];
                    return;
                }
            }
            // 结束刷新
            [selfWeak.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            // 结束刷新
            [selfWeak.tableView.mj_footer endRefreshing];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  网络请求
 */
- (void)request {
    [self deleteEmptyText];
    [self accountUnExpired:^{
        // 请求参数
        CommunityParam *param = [CommunityParam param];
        WeakSelf;
        [MBProgressHUD showMessage:@"加载中..." toView:self.view];
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYReadQuestAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
            // 查询成功
            if ([responseObject[@"errcode"] integerValue] == 0) {
                self.quests = [CommunityListItem mj_objectArrayWithKeyValuesArray:responseObject[@"quests"]];
                if (!self.quests.count) {
                    [selfWeak emptyViewWithText:nil andImg:[UIImage imageNamed:@"community.bundle/no_data@2x"]];
                }
            }
            [self.tableView reloadData];
            // 结束刷新
            [selfWeak.tableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            // 结束刷新
            [selfWeak.tableView.mj_header endRefreshing];
            [MBProgressHUD hideHUDForView:self.view];
            [self requestFailure:error];
        }];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.quests.count;
}

/**
 *  内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpertQuestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpertQuestCell" forIndexPath:indexPath];
    cell.item = self.quests[indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommunityDetailController *detailVc = [[CommunityDetailController alloc] init];
    detailVc.communityFrame = [CommunityCellFrame cellFrameWithCommunityItem:self.quests[indexPath.row]];
    [self.navigationController pushViewController:detailVc animated:YES];
}

@end
