//
//  MyCircleCollectController.m
//  txzjPatient
//
//  Created by Limmy on 2017/4/28.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "MyCircleCollectController.h"
#import "TXBYCircleCell.h"
#import "TXBYCircleParam.h"
#import "AccountTool.h"
#import "TXBYCircleModel.h"

@interface MyCircleCollectController ()
/**
 *  circleItems
 */
@property (nonatomic, strong) NSArray *circleItems;

@end

@implementation MyCircleCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)request {
    [self deleteEmptyText];
    [self accountUnExpired:^{
        TXBYCircleParam *param = [TXBYCircleParam param];
        param.uid = [AccountTool account].uid;
        param.group = @"1";
        WeakSelf;
        // 发送请求
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYMyCollectCircleAPI parameters:param.mj_keyValues netIdentifier:selfWeak.title success:^(id json) {
            [self.tableView.mj_header endRefreshing];
            NSLog(@"%@", json);//返回结果对象
            if ([json[@"errcode"] integerValue] == 0) {
                selfWeak.circleItems = [TXBYCircleModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                [selfWeak.tableView reloadData];
                if (selfWeak.circleItems.count > 19) {
                    [self setUpFooterFresh];
                }
            } else {
                selfWeak.circleItems = nil;
                [selfWeak emptyViewWithImage:nil WithText:@"还没有收藏过圈子"];
                [self.tableView reloadData];
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
        param.uid = [AccountTool account].uid;
        param.range = self.range;
        TXBYCircleModel *lastModel = self.circleItems.lastObject;
        param.max_id = lastModel.oid;
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
    }];
}

@end
