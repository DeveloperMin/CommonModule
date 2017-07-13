//
//  MyCirclePublishController.m
//  txzjPatient
//
//  Created by Limmy on 2017/4/28.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "MyCirclePublishController.h"
#import "MyCirclePublishCell.h"
#import "TXBYCircleParam.h"
#import "TXBYCircleModel.h"
#import "CircleDetailViewController.h"

@interface MyCirclePublishController ()<UITableViewDelegate, UITableViewDataSource>
/**
 *  publishItems
 */
@property (nonatomic, strong) NSArray *publishItems;
/**
 *  tipLabel
 */
@property (nonatomic, strong) UILabel *tipLabel;
/**
 *  tableView
 */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MyCirclePublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化view
    [self initialView];
}

- (void)initialView {
    self.tableView = [UITableView new];
    self.tableView.frame = CGRectMake(0, 0, TXBYApplicationW, TXBYApplicationH - 88);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = TXBYGlobalBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCirclePublishCell" bundle:nil]forCellReuseIdentifier:@"MyCirclePublishCell"];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(request)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    self.tipLabel = [UILabel new];
    self.tipLabel.backgroundColor = TXBYMainColor;
    self.tipLabel.hidden = YES;
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.font = [UIFont systemFontOfSize:15];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.layer.masksToBounds = YES;
    self.tipLabel.layer.cornerRadius = 30;
    [self.view addSubview:self.tipLabel];
    self.tipLabel.frame = CGRectMake(TXBYApplicationW - 80, TXBYApplicationH - 180, 60, 60);
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.tipLabel removeFromSuperview];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)request {
    [self accountUnExpired:^{
        TXBYCircleParam *param = [TXBYCircleParam param];
        param.group = @"1";
        WeakSelf;
        // 发送请求
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYMyPublishCircleAPI parameters:param.mj_keyValues netIdentifier:selfWeak.title success:^(id json) {
            [self.tableView.mj_header endRefreshing];
            NSLog(@"%@", json);//返回结果对象
            if ([json[@"errcode"] integerValue] == 0) {
                selfWeak.publishItems = [TXBYCircleModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                [selfWeak.tableView reloadData];
                if (selfWeak.publishItems.count) {
                    [selfWeak setUpHeaderView];
                    self.tipLabel.hidden = NO;
                }
                if (selfWeak.publishItems.count > 19) {
                    [selfWeak setUpFooterFresh];
                }
            } else {
                [selfWeak emptyViewWithImage:nil WithText:@"还没有发布过圈子，点击首页加号去发布一条吧"];
            }
        } failure:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [self requestFailure:error];
        }];
    }];
}

- (void)setUpFooterFresh {
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
}

- (void)requestMoreData {
    [self accountUnExpired:^{
        TXBYCircleParam *param = [TXBYCircleParam param];
        TXBYCircleModel *lastModel = self.publishItems.lastObject;
        param.max_id = lastModel.ID;
        param.group = @"1";
        WeakSelf;
        // 发送请求
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYMyPublishCircleAPI parameters:param.mj_keyValues netIdentifier:selfWeak.title success:^(id json) {
            [self.tableView.mj_footer endRefreshing];
            if ([json[@"errcode"] integerValue] == 0) {
                NSArray *array = [TXBYCircleModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                NSMutableArray *temp = [NSMutableArray arrayWithArray:selfWeak.publishItems];
                if (array.count) {
                    [temp addObjectsFromArray:array];
                    selfWeak.publishItems = temp;
                    [selfWeak.tableView reloadData];
                }
            } else {
                [selfWeak.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } failure:^(NSError *error) {
            [self.tableView.mj_footer endRefreshing];
            [self requestFailure:error];
        }];
    }];
}

- (void)setUpHeaderView {
    UIView *headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, TXBYApplicationW, 30);
    headerView.backgroundColor = [UIColor whiteColor];
    UIView *topView = [UIView new];
    topView.frame = CGRectMake(0, 0, TXBYApplicationW, 10);
    topView.backgroundColor = TXBYGlobalBgColor;
    [headerView addSubview:topView];
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.publishItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCirclePublishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCirclePublishCell"];
    cell.indexPath = indexPath;
    //此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    TXBYCircleModel *model = self.publishItems[indexPath.row];
    // 设置提示年
    self.tipLabel.text = [model.create_time substringToIndex:4];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.publishItems[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[MyCirclePublishCell class] contentViewWidth:[self cellContentViewWith]];
}

/**
 * 计算contentView的宽度
 */
- (CGFloat)cellContentViewWith {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TXBYCircleModel *model = self.publishItems[indexPath.row];
    CircleDetailViewController *detailVc = [CircleDetailViewController new];
    detailVc.circleID = model.ID;
    [self.navigationController pushViewController:detailVc animated:YES];
}

/**
 *  销毁
 */
- (void)dealloc {
    // 取消网络请求
    [[TXBYHTTPSessionManager sharedManager] cancelNetworkingWithNetIdentifier:TXBYClassName];
}
@end
