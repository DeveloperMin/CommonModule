//
//  QuestListViewController.m
//  smh
//
//  Created by yh on 15/3/29.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//

#import "QuestListViewController.h"
#import "QuestAddViewController.h"
#import "QuestTool.h"
#import "QuestParam.h"
#import "QuestResult.h"
#import "Quest.h"

@interface QuestListViewController () <QuestAddViewDelegage>

/**
 *  是否提问成功后刷新列表
 */
@property (nonatomic, assign) BOOL refresh;

@end

@implementation QuestListViewController

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航栏添加提问按钮
    [self setupNav];
    
    // 添加下拉刷新视图
    [self setupRefreshHeader];
    
    // 网络请求
    [self request];
}

/**
 *  view出现
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // self.refresh为真,刷新
    if (self.refresh) {
        [self.tableView.mj_header beginRefreshing];
        self.refresh = NO;
    }
}

#pragma mark - private
/**
 *  导航栏添加提问按钮
 */
- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(add)];
}

/**
 *  提问按钮点击
 */
- (void)add {
    // 检查账号是否存在
    [self checkAccount];
}

/**
 *  检查账号是否存在
 */
- (void)checkAccount {
    // 账号是否存在
    [self accountExist:^{
        QuestAddViewController *vc = [[QuestAddViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

/**
 *  添加下拉刷新视图
 */
- (void)setupRefreshHeader {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}

/**
 *  网络请求
 */
- (void)request {
    // 请求参数
    QuestParam *param = [QuestParam param];
    
    // 发送请求
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [QuestTool questsWithParam:param netIdentifier:TXBYClassName success:^(QuestResult *result) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:self.view];
        
        self.quests = [NSMutableArray arrayWithArray:result.quests];

        // 添加上拉加载更多视图
        if (result.quests.count) {
            [self setupRefreshFooter];
        }
        
        // 刷新表格
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:self.view];
        // 网络加载失败
        [self requestFailure:error];
    }];
}

/**
 *  添加上拉加载更多视图
 */
- (void)setupRefreshFooter {
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

/**
 *  加载新数据
 */
- (void)loadNewData {
    // 请求参数
    QuestParam *param = [QuestParam param];
    // 当前最新一条问题id
    if (self.quests.count) {
        Quest *firstQuest = self.quests[0];
        param.since_id = firstQuest.ID;
    }
    WeakSelf;
    // 发送请求
    [QuestTool questsWithParam:param netIdentifier:TXBYClassName success:^(QuestResult *result) {
        // 添加数据
        // 将最新的数据追加到旧数据的最前面
        NSMutableArray *tempArray = [NSMutableArray array];
        // 添加cellFrames的所有元素 添加到 tempArray中
        [tempArray addObjectsFromArray:result.quests];
        if (result.quests.count < 20) {
            // 添加self.cellFrames的所有元素 添加到 tempArray中
            [tempArray addObjectsFromArray:selfWeak.quests];
        }
        selfWeak.quests = tempArray;
        // 结束刷新
        [selfWeak.tableView.mj_header endRefreshing];
        // 刷新表格
        [selfWeak.tableView reloadData];
    } failure:^(NSError *error) {
        // 结束刷新
        [selfWeak.tableView.mj_header endRefreshing];
    }];
}

/**
 *  上拉加载更多数据
 */
- (void)loadMoreData {
    // 请求参数
    QuestParam *param = [QuestParam param];
    if (self.quests.count) {
        Quest *lastQuest = self.quests.lastObject;
        param.max_id = lastQuest.ID;
    }
    WeakSelf;
    // 请求网络
    [QuestTool questsWithParam:param netIdentifier:TXBYClassName success:^(QuestResult *result) {
        // 没有数据
        if (!result.quests.count) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [selfWeak.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }

        [self.quests addObjectsFromArray:result.quests];
        // 刷新表格
        [self.tableView reloadData];

        // 结束刷新
        [selfWeak.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        // 结束刷新
        [selfWeak.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - public
/**
 *  刷新
 *
 *  @param fromOther YES表示从其他控制器过来 NO表示不是从其他控制器过来
 */
- (void)refreshFromOther:(BOOL)fromOther {
    // 不是从别的控制器来并且不在刷新时
    if ((!fromOther) && (!self.tableView.mj_header.isRefreshing)) {
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - QuestAddViewDelegage
/**
 *  提问完成
 */
- (void)questAddViewControllerDidFinish:(QuestAddViewController *)vc {
    self.refresh = YES;
}

@end