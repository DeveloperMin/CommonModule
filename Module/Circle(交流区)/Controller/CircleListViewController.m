//
//  CircleListViewController.m
//  txzjPatient
//
//  Created by Limmy on 2017/4/22.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "CircleListViewController.h"
#import "TXBYCircleParam.h"
#import "TXBYCircleModel.h"
#import "TXBYCircleCell.h"
#import "AccountTool.h"
#import "CircleDetailViewController.h"
#import "CircleDoctorPublishViewController.h"
#import "CirclePatientPublishViewController.h"
#import "TXBYPatientCircleCell.h"
#import "UIViewController+ServiceCircle.h"


@interface CircleListViewController ()<TXBYCircleCellDeleagte>
/**
 *  circles
 */
@property (nonatomic, strong) NSArray *circleItems;
/**
 *  selectPath
 */
@property (nonatomic, strong) NSIndexPath *selectPath;

@end

@implementation CircleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化view
    [self initialView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initialView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = TXBYGlobalBgColor;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[TXBYCircleCell class] forCellReuseIdentifier:@"TXBYCircleCell"];
    [self.tableView registerClass:[TXBYPatientCircleCell class] forCellReuseIdentifier:@"TXBYPatientCircleCell"];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(request)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(request) name:@"updateCircleList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLoveList) name:@"updateCircleLove" object:nil];
}

/**
 *  更新列表数据
 */
- (void)updateLoveList {
    if (self.selectPath.row) {
        [self requestLove];
    }
}

- (void)requestLove {
    TXBYCircleParam *param = [TXBYCircleParam param];
    param.uid = [AccountTool account].uid;
    TXBYCircleModel *circleModel = self.circleItems[self.selectPath.row];
    param.ID = circleModel.ID;
    WeakSelf;
    // 发送请求
    [MBProgressHUD showMessage:@"请稍候..." toView:self.view];
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCircleDetailAPI parameters:param.mj_keyValues netIdentifier:[NSString stringWithFormat:@"%@_Love", selfWeak.title] success:^(id json) {
        [MBProgressHUD hideHUDForView:selfWeak.view];
        if ([json[@"errcode"] integerValue] == 0) {
            TXBYCircleModel *model = [TXBYCircleModel mj_objectWithKeyValues:json[@"data"][@"quest"]];
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.circleItems];
            [array replaceObjectAtIndex:self.selectPath.row withObject:model];
            self.circleItems = array;
            [selfWeak.tableView reloadRowsAtIndexPaths:@[selfWeak.selectPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:selfWeak.view];
        [self requestFailure:error];
    }];
}

- (void)request {
    // 去除提示字符
    [self deleteEmptyText];
    TXBYCircleParam *param = [TXBYCircleParam param];
    param.uid = [AccountTool account].uid;
    param.range = self.range;
    param.group = @"1";
    WeakSelf;
    // 发送请求
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCircleQueryAPI parameters:param.mj_keyValues netIdentifier:selfWeak.title success:^(id json) {
        [self.tableView.mj_header endRefreshing];
//        NSLog(@"%@", json);//返回结果对象
        if ([json[@"errcode"] integerValue] == 0) {
            selfWeak.circleItems = [TXBYCircleModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [selfWeak.tableView reloadData];
            if (selfWeak.circleItems.count > 19) {
                [self setUpFooterFresh];
            }
        } else {
            selfWeak.circleItems = nil;
            [selfWeak addEmptyView];
            [selfWeak.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self requestFailure:error];
    }];
}

- (void)addEmptyView {
    NSString *message;
    if ([self.title isEqualToString:@"我的关注"]) {
        message = @"没有关注的圈子信息";
    } else if ([self.title isEqualToString:@"医生圈"]) {
        message = @"没有医生圈子信息";
    } else if ([self.title isEqualToString:@"病友圈"]) {
        message = @"没有圈子信息，点击加号去发布一条吧";
    }
    [self emptyViewWithImage:nil WithText:message];
}

- (void)requestMoreData {
    TXBYCircleParam *param = [TXBYCircleParam param];
    param.uid = [AccountTool account].uid;
    param.range = self.range;
    TXBYCircleModel *lastModel = self.circleItems.lastObject;
    param.max_id = lastModel.ID;
    param.group = @"1";
    WeakSelf;
    // 发送请求
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCircleQueryAPI parameters:param.mj_keyValues netIdentifier:selfWeak.title success:^(id json) {
        [self.tableView.mj_footer endRefreshing];
        if ([json[@"errcode"] integerValue] == 0) {
            NSArray *array = [TXBYCircleModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            NSMutableArray *temp = [NSMutableArray arrayWithArray:selfWeak.circleItems];
            if (array.count) {
                [temp addObjectsFromArray:array];
                selfWeak.circleItems = temp;
                [selfWeak.tableView reloadData];
            }
        } else {
            [selfWeak.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self requestFailure:error];
    }];
}

- (void)setUpFooterFresh {
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.circleItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXBYCircleCell *cell;
    TXBYCircleModel *model = self.circleItems[indexPath.section];
    if (model.user_type.integerValue == 100) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TXBYPatientCircleCell"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TXBYCircleCell"];
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.isDoctorUser = self.isDoctorUser;
    __weak typeof(self) weakSelf = self;
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            TXBYCircleModel *model = weakSelf.circleItems[indexPath.section];
            model.isOpening = !model.isOpening;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    //此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅
//    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    cell.model = self.circleItems[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXBYCircleModel *model = self.circleItems[indexPath.section];
    if (model.user_type.integerValue == 100) {
//        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"patientModel" cellClass:[TXBYPatientCircleCell class] contentViewWidth:[self cellContentViewWith]];
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[TXBYCircleCell class] contentViewWidth:[self cellContentViewWith]] - 30;
    } else {
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[TXBYCircleCell class] contentViewWidth:[self cellContentViewWith]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
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

#pragma mark - TXBYCircleCellDeleagte
- (void)toolBarClickBtn:(UIButton *)btn WithIndePath:(NSIndexPath *)indexPath{
    TXBYCircleModel *model = self.circleItems[indexPath.section];
    if (btn.tag == 1) {
        TXBYCircleModel *model = self.circleItems[indexPath.section];
        CircleDoctorPublishViewController *publishVc;
        if (self.isDoctorUser) {
            publishVc = [CircleDoctorPublishViewController new];
        } else {
            publishVc = [CirclePatientPublishViewController new];
        }
        publishVc.circlePublishStyle = CirclePublishStyleReply;
        publishVc.circleModel = model;
        [self.navigationController pushViewController:publishVc animated:YES];
    } else if(btn.tag == 2) {
        [UIView animateWithDuration:0.2 animations:^{
            btn.transform = CGAffineTransformMakeScale(1.5, 1.5);
        } completion:^(BOOL finished) {
            btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
        [self clickToolBarLoveBtn:btn WithModel:model];
    }
}

- (void)iconViewClickAction:(TXBYCircleModel *)model {
    if (model.user_type.integerValue == 200) {
        [self CircleIconViewActionWithModel:model];
    }
}

- (void)clickToolBarLoveBtn:(UIButton *)btn WithModel:(TXBYCircleModel *)model {
    [self accountUnExpired:^{
        btn.selected = !btn.selected;
        NSInteger count = model.love.integerValue;
        if (btn.selected) {
            [self requsetLoveWithModel:model];
            count++;
        } else {
            [self requsetCancelLoveWithModel:model];
            count--;
        }
        model.love = [NSString stringWithFormat:@"%ld", (long)count];
        if (count > 0) {
            [btn setTitle:model.love forState:UIControlStateNormal];
        } else {
            [btn setTitle:@"赞"forState:UIControlStateNormal];
        }
    }];
}

/**
 * 点赞请求
 */
- (void)requsetLoveWithModel:(TXBYCircleModel *)model {
    [self accountUnExpired:^{
        TXBYCircleParam *param = [TXBYCircleParam param];
        param.oid = model.ID;
        param.category = @"2";
        param.operate = @"3";
        // 发送请求
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCircleLoveAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
            if ([responseObject[@"errcode"] integerValue] == 0) {
                model.loved_id = responseObject[@"data"][@"ID"];
                model.is_loved = @"1";
            }
        } failure:^(NSError *error) {
        }];
    }];
}

/**
 * 取消赞请求
 */
- (void)requsetCancelLoveWithModel:(TXBYCircleModel *)model {
    [self accountUnExpired:^{
        TXBYCircleParam *param = [TXBYCircleParam param];
        param.ID = model.loved_id;
        param.category = @"2";
        param.operate = @"5";
        // 发送请求
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCircleCancelLoveAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
            if ([responseObject[@"errcode"] integerValue] == 0) {
                model.is_loved = @"0";
            }
        } failure:^(NSError *error) {
        }];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectPath = indexPath;
    TXBYCircleModel *model = self.circleItems[indexPath.section];
    CircleDetailViewController *detailVc = [CircleDetailViewController new];
    detailVc.circleID = model.ID;
    detailVc.isDoctorUser = self.isDoctorUser;
    [self.navigationController pushViewController:detailVc animated:YES];
}

/**
 *  销毁
 */
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
