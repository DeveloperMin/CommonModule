//
//  MyQuestController.m
//  ydyl
//
//  Created by Limmy on 2016/9/22.
//  Copyright © 2016年 txby. All rights reserved.
//

#import "MyCommunityController.h"
#import "CommunityParam.h"
#import "CommunityListItem.h"
#import "CommunityCellFrame.h"
#import "CommunityCommentController.h"
#import "CommunityListCell.h"
#import "CommunityDetailController.h"

@interface MyCommunityController ()


@end

@implementation MyCommunityController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  添加下拉刷新视图
 */
- (void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(request)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  上拉加载更多数据
 */
- (void)loadMoreData {
    if (self.questFrames.count < 20) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [self accountUnExpired:^{
        CommunityParam *param = [CommunityParam param];
        CommunityCellFrame *cellFrame = self.questFrames.lastObject;
        CommunityListItem *item = cellFrame.communityItem;
        param.max_id = item.ID;
        WeakSelf;
        // 发送请求
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYReadQuestAPI parameters:param.mj_keyValues netIdentifier:self.title success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
            // 查询成功
            if ([responseObject[@"errcode"] integerValue] == 0) {
                NSArray *array = [CommunityListItem mj_objectArrayWithKeyValuesArray:responseObject[@"quests"]];
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.questFrames];
                if (array.count) {
                    NSArray *cellFrames = [self questsToCellFrames:array];
                    [tempArray addObjectsFromArray:cellFrames];
                    self.questFrames = tempArray;
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

/**
 *  网络请求
 */
- (void)request {
    [self deleteEmptyText];
    [self accountUnExpired:^{
        // 请求参数
        CommunityParam *param = [CommunityParam param];
        WeakSelf;
        //[MBProgressHUD showMessage:@"加载中..." toView:self.view];
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYMyQuestAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
            // 查询成功
            if ([responseObject[@"errcode"] integerValue] == 0) {
                NSArray *quests = [CommunityListItem mj_objectArrayWithKeyValuesArray:responseObject[@"quests"]];
                NSArray *cellFrames = [self questsToCellFrames:quests];
                
                self.questFrames = cellFrames;
                if (!cellFrames.count) {
                    [selfWeak emptyImage];
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

- (void)emptyImage {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"community.bundle/no_data"]];
    imgView.tag = 9999;
    imgView.frame = CGRectMake(TXBYApplicationW / 2 - TXBYApplicationW * 0.3 / 2, TXBYApplicationH / 2 - TXBYApplicationW * 0.3 / 2 - 70, TXBYApplicationW * 0.3, TXBYApplicationW * 0.3);
    [self.view addSubview:imgView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.questFrames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

/**
 *  内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    static NSString *CellIdentifier = @"QuestListCell";
    CommunityListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CommunityListCell alloc] init];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CommunityCellFrame *cellFrame = self.questFrames[indexPath.section];
    cell.toolBarBlock = ^(NSInteger index){
        CommunityCommentController *commentVc = [[CommunityCommentController alloc] init];
        commentVc.communityCellFrame = cellFrame;
        [self.navigationController pushViewController:commentVc animated:YES];
    };
    cell.isTread = self.isTread;
    cell.cellFrame = cellFrame;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 2) {
        return 40;
    }
    return [self.questFrames[indexPath.section] cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView.tag == 2) {
        return 1;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommunityDetailController *detailVc = [[CommunityDetailController alloc] init];
    CommunityCellFrame *cellFrame = self.questFrames[indexPath.section];
    detailVc.communityFrame = cellFrame;
    detailVc.isTread = self.isTread;
    detailVc.loveBtnBlock = ^(UIButton *btn) {
        if (btn.selected) {
            cellFrame.communityItem.is_loved = @"1";
            cellFrame.communityItem.love = [NSString stringWithFormat:@"%ld", cellFrame.communityItem.love.integerValue + 1];
        } else {
            cellFrame.communityItem.is_loved = @"0";
            cellFrame.communityItem.love = [NSString stringWithFormat:@"%ld", cellFrame.communityItem.love.integerValue - 1];
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    detailVc.unLoveBtnBlock = ^(UIButton *btn) {
        if (btn.selected) {
            cellFrame.communityItem.is_treaded = @"1";
        } else {
            cellFrame.communityItem.is_treaded = @"0";
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:detailVc animated:YES];
}

/**
 *  模型数组转cellFrame模型数组
 */
- (NSArray *)questsToCellFrames:(NSArray *)array {
    NSMutableArray *arrayM = [NSMutableArray array];
    for (CommunityListItem *communtiy in array) {
        CommunityCellFrame *cellFrame = [CommunityCellFrame cellFrameWithCommunityItem:communtiy];
        [arrayM addObject:cellFrame];
    }
    return arrayM;
}

- (NSString *)title {
    return @"我的问答";
}

@end
