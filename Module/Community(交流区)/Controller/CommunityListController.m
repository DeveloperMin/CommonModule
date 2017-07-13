//
//  CommunityListController.m
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/24.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "CommunityListController.h"
#import "CommunityGroup.h"
#import "CommunityParam.h"
#import "AccountTool.h"
#import "CommunityListItem.h"
#import "CommunityCellFrame.h"
#import "CommunityListCell.h"
#import "CommunityDetailController.h"
#import "CommunityCommentController.h"

@interface CommunityListController ()

@property (nonatomic, strong) NSArray *communityFrames;

@end

@implementation CommunityListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //// 请求数据
    //[self request];
    // 下拉刷新
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
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  网络请求
 */
- (void)request {
    // 如果存在token, 刷新token
    [self accountExist:^{
        [self accountUnExpired:^{
        }];
    } unExist:^{
    }];
    [self deleteEmptyText];
    // 请求参数
    CommunityParam *param = [CommunityParam param];
    param.group = self.group.ID;
    if (self.isSearch) {
        param.content = self.content;
    }
    param.uid = [AccountTool account].uid;
    WeakSelf;
    //[MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCommunityListAPI parameters:param.mj_keyValues netIdentifier:self.title success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        // 查询成功
        if ([responseObject[@"errcode"] integerValue] == 0) {
            NSArray *quests = [CommunityListItem mj_objectArrayWithKeyValuesArray:responseObject[@"quests"]];
            NSArray *communityFrames = [self communitysToCellFrames:quests];
            self.communityFrames = communityFrames;
            if (!self.communityFrames.count) {
                [selfWeak emptyViewWithImage:[UIImage imageNamed:@"community.bundle/no_data@2x"] WithText:nil];
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
}

/**
 *  上拉加载更多数据
 */
- (void)loadMoreData {
    if (![AccountTool account]) {
        [MBProgressHUD showInfo:@"登陆后查看更多" toView:self.view];
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        return ;
    }
    [self accountExist:^{
        [self accountUnExpired:^{
        }];
    } unExist:^{
    }];
    // 请求参数
    CommunityParam *param = [CommunityParam param];
    param.uid = [AccountTool account].uid;
    param.group = self.group.ID;
    if (self.communityFrames.count) {
        CommunityCellFrame *cellFrame = self.communityFrames.lastObject;
        CommunityListItem *lastQuest = cellFrame.communityItem;
        param.max_id = lastQuest.ID;
        if (!self.group.ID.length && (lastQuest.page.integerValue < lastQuest.page_count.integerValue)) {
            param.page = [NSString stringWithFormat:@"%ld", (long)lastQuest.page.integerValue + 1];
        } else {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
    }
    param.group = self.group.ID;
    
    if (self.isSearch) {
        param.content = self.content;
    }
    WeakSelf;
    // 发送请求
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCommunityListAPI parameters:param.mj_keyValues netIdentifier:self.title success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        // 查询成功
        if ([responseObject[@"errcode"] integerValue] == 0) {
            NSArray *array = [CommunityListItem mj_objectArrayWithKeyValuesArray:responseObject[@"quests"]];
            NSArray *cellFrames = [self communitysToCellFrames:array];
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.communityFrames];
            if (cellFrames.count) {
                [tempArray addObjectsFromArray:cellFrames];
                self.communityFrames = tempArray;
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
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.communityFrames.count;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

/**
 *  内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    static NSString *CellIdentifier = @"CommunityListCell";
    CommunityListCell *cell = [CommunityListCell cellWithTableView:tableView classString:CellIdentifier];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CommunityCellFrame *cellFrame = self.communityFrames[indexPath.section];
    CommunityListItem *communityItem = cellFrame.communityItem;
    cell.toolBarBlock = ^(NSInteger index){
        if (communityItem.aid.integerValue == -1 || [communityItem.aid isEqualToString:[AccountTool account].uid]) {
            CommunityCommentController *commentVc = [[CommunityCommentController alloc] init];
            commentVc.communityCellFrame = cellFrame;
            [self.navigationController pushViewController:commentVc animated:YES];
        } else {
            [MBProgressHUD showInfo:@"对不起, 您没有权限回答该问题!" toView:self.view];
        }
    };
    // 取出对应的模型
    cell.isTread = self.isTread;
    cell.cellFrame = cellFrame;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommunityCellFrame *cellFrame = self.communityFrames[indexPath.section];
    return cellFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommunityDetailController *detailVc = [[CommunityDetailController alloc] init];
    CommunityCellFrame *cellFrame = self.communityFrames[indexPath.section];
    detailVc.communityFrame = cellFrame;
    detailVc.isTread = self.isTread;
    detailVc.loveBtnBlock = ^(UIButton *btn) {
        if (btn.selected) {
            cellFrame.communityItem.is_loved = @"1";
            cellFrame.communityItem.love = [NSString stringWithFormat:@"%d", cellFrame.communityItem.love.integerValue + 1];
        } else {
            cellFrame.communityItem.is_loved = @"0";
            cellFrame.communityItem.love = [NSString stringWithFormat:@"%d", cellFrame.communityItem.love.integerValue - 1];
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
- (NSArray *)communitysToCellFrames:(NSArray *)array {
    NSMutableArray *arrayM = [NSMutableArray array];
    for (CommunityListItem *item in array) {
        CommunityCellFrame *cellFrame = [CommunityCellFrame cellFrameWithCommunityItem:item];
        [arrayM addObject:cellFrame];
    }
    return arrayM;
}

@end
