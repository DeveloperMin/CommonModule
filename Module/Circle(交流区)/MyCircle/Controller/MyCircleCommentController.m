//
//  MyCircleCommentController.m
//  txzjPatient
//
//  Created by Limmy on 2017/4/28.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "MyCircleCommentController.h"
#import "MyCircleCommentCell.h"
#import "TXBYCircleParam.h"
#import "AccountTool.h"
#import "MyCircleCommentModel.h"
#import "CircleDetailViewController.h"

@interface MyCircleCommentController ()
/**
 *  commentItems
 */
@property (nonatomic, strong) NSArray *commentItems;

@end

@implementation MyCircleCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化view
    [self initialView];
}

- (void)initialView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = TXBYGlobalBgColor;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCircleCommentCell" bundle:nil]forCellReuseIdentifier:@"MyCircleCommentCell"];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(request)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
}

- (void)request {
    [self deleteEmptyText];
    TXBYCircleParam *param = [TXBYCircleParam param];
    param.uid = [AccountTool account].uid;
    param.group = @"1";
    WeakSelf;
    // 发送请求
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYMyCommentCircleAPI parameters:param.mj_keyValues netIdentifier:selfWeak.title success:^(id json) {
        [self.tableView.mj_header endRefreshing];
        if ([json[@"errcode"] integerValue] == 0) {
            selfWeak.commentItems = [MyCircleCommentModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [selfWeak.tableView reloadData];
            if (selfWeak.commentItems.count > 19) {
                [selfWeak setUpFooterFresh];
            }
        } else {
            [selfWeak emptyViewWithImage:nil WithText:@"还没有评论过圈子"];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self requestFailure:error];
    }];
}

- (void)setUpFooterFresh {
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
}

- (void)requestMoreData {
    TXBYCircleParam *param = [TXBYCircleParam param];
    param.uid = [AccountTool account].uid;
    MyCircleCommentModel *commentModel = self.commentItems.lastObject;
    param.max_id = commentModel.comment.ID;
    param.group = @"1";
    WeakSelf;
    // 发送请求
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYMyCommentCircleAPI parameters:param.mj_keyValues netIdentifier:selfWeak.title success:^(id json) {
        [self.tableView.mj_footer endRefreshing];
        if ([json[@"errcode"] integerValue] == 0) {
            NSArray *array = [MyCircleCommentModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            NSMutableArray *temp = [NSMutableArray arrayWithArray:selfWeak.commentItems];
            if (array.count) {
                [temp addObjectsFromArray:array];
                selfWeak.commentItems = temp;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCircleCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCircleCommentCell" forIndexPath:indexPath];
    cell.model = self.commentItems[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat commentH = 68;
    CGFloat circelH = (TXBYApplicationW - 16) * 0.28 + 16;
    
    MyCircleCommentModel *model = self.commentItems[indexPath.row];
    NSString *content = model.comment.content;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为10
    [paragraphStyle setLineSpacing:5];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    
    CGFloat maxW = TXBYApplicationW - 16;
    CGSize size = [attrStr.string sizeWithFont:[UIFont systemFontOfSize:15] maxW:maxW];
    
    return circelH + commentH + size.height + 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCircleCommentModel *model = self.commentItems[indexPath.row];
    CircleDetailViewController *detailVc = [CircleDetailViewController new];
    detailVc.circleID = model.quest.ID;
    [self.navigationController pushViewController:detailVc animated:YES];
}

@end
