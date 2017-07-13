//
//  QuestionReplyDetailController.m
//  publicCommon
//
//  Created by hj on 17/2/24.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "CircleReplyDetailController.h"
#import "TXBYCircleReply.h"
#import "CirclePrimaryReplyCell.h"
#import "CircleDoctorPublishViewController.h"
#import "CirclePatientPublishViewController.h"
#import "TXBYCircleImg.h"
#import "TXBYCircleParam.h"
#import "AccountTool.h"
#import "UIViewController+ServiceCircle.h"

@interface CircleReplyDetailController ()

@property (nonatomic, strong) CirclePrimaryReplyCell *headerCell;

@property (nonatomic, strong) UIView *tableHeaderView;

@end

@implementation CircleReplyDetailController

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] init];
        _tableHeaderView.frame = CGRectMake(0, 0, TXBYApplicationW, 0);
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        
        CirclePrimaryReplyCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CirclePrimaryReplyCell" owner:nil options:nil] lastObject];
        cell.frame = CGRectMake(0, 0, TXBYApplicationW, 0);
//        cell.contentLabelLeftConstraint.constant = -46;
        cell.isDoctorUser = self.isDoctorUser;
        cell.circleReply = self.circleReply;
        cell.delegate = self;
        WeakSelf;
        cell.likeButtonBlock = ^(UIButton *btn){
            if (selfWeak.circleReply.is_loved.integerValue) {
                [selfWeak unlikeQuestion:selfWeak.circleReply];
            } else {
                [selfWeak likeQuestion:selfWeak.circleReply];
            }
        };
        cell.replyButtonBlock = ^(UIButton *btn){
            CircleDoctorPublishViewController *vc;
            if (self.isDoctorUser) {
                vc = [CircleDoctorPublishViewController new];
            } else {
                vc = [CirclePatientPublishViewController new];
            }
            vc.circleReply = selfWeak.circleReply;
            vc.circleModel = selfWeak.circleModel;
            [selfWeak.navigationController pushViewController:vc animated:YES];
        };
        self.headerCell = cell;
        [_tableHeaderView addSubview:cell];
    }
    return _tableHeaderView;
}

- (void)setCircleReply:(TXBYCircleReply *)circleReply {
    _circleReply = circleReply;
    
    [self tableHeaderView];
    self.headerCell.circleReply = circleReply;
    CGFloat headerCellHeight = 60;
    CGFloat maxW = TXBYApplicationW - 15 * 2;
    CGSize size = [circleReply.content sizeWithFont:[UIFont systemFontOfSize:15] maxW:maxW];
    headerCellHeight += size.height + 10;
    
    // 加上图片高度
    CGFloat photosViewHeight = 0;
    if (circleReply.imgs.count) {
        photosViewHeight = (TXBYApplicationW - 61 - 15 - 2 * 2) / 3 + 10;
    }
    headerCellHeight += photosViewHeight;
    
    self.headerCell.txby_height = headerCellHeight;
    self.tableHeaderView.txby_height = headerCellHeight;
    self.tableView.tableHeaderView = self.tableHeaderView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

/**
 *  设置tableView属性
 */
- (void)setupTableView {
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"CirclePrimaryReplyCell" bundle:nil] forCellReuseIdentifier:@"CirclePrimaryReplyCell"];
    self.tableView.backgroundColor = TXBYGlobalBgColor;
}

- (void)request {
    TXBYCircleParam *param = [TXBYCircleParam param];
    param.uid = [AccountTool account].uid;
    param.ID = self.circleModel.ID;
    WeakSelf;
    // 发送请求
//    [MBProgressHUD showMessage:@"请稍候..." toView:self.view];
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCircleDetailAPI parameters:param.mj_keyValues netIdentifier:selfWeak.title success:^(id json) {
        [MBProgressHUD hideHUDForView:selfWeak.view];
        if ([json[@"errcode"] integerValue] == 0) {
            NSArray *array = [TXBYCircleReply mj_objectArrayWithKeyValuesArray:json[@"data"][@"replies"]];
            selfWeak.circleReply = array[self.indexPath.section];
            [selfWeak.tableView reloadData];
        } else {
            [selfWeak emptyViewWithImage:nil WithText:@"没有相关数据"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:selfWeak.view];
        [self requestFailure:error];
    }];
}

/**
 *  问题点赞
 */
- (void)likeQuestion:(TXBYCircleModel *)item {
    [self accountUnExpired:^{
        // 请求参数
        TXBYCircleParam *param = [TXBYCircleParam param];
        param.oid = item.ID;
        // 分类,1新闻,2 问答,3 医生, 4 评论, 5 步数
        param.category = @"4";
        param.operate = @"3";
        NSString *netIdentifier = [NSString stringWithFormat:@"likeQuestionNetIdentifier ID:%@",item.ID];
        // 发送请求
        WeakSelf;
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCircleLoveAPI parameters:param.mj_keyValues netIdentifier:netIdentifier success:^(id responseObject) {
            if ([responseObject[@"errcode"] integerValue] == 0) {
                item.is_loved = @"1";
                item.loved_id = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"ID"]];
                // 更新列表数据
                if (self.updateBlock) {
                    self.updateBlock();
                }
            } else {
                TXBYAlert(responseObject[@"errmsg"]);
            }
            
        } failure:^(NSError *error) {
            // 网络加载失败
            [selfWeak requestFailure:error];
        }];
    }];
}

/**
 *  问题取消点赞
 */
- (void)unlikeQuestion:(TXBYCircleModel *)item {
    [self accountUnExpired:^{
        // 请求参数
        TXBYCircleParam *param = [TXBYCircleParam param];
        param.ID = item.loved_id;
        
        // 分类,1新闻,2 问答,3 医生, 4 评论, 5 步数
        param.category = @"4";
        param.operate = @"5";
        NSString *netIdentifier = [NSString stringWithFormat:@"likeQuestionNetIdentifier ID:%@",item.ID];
        // 发送请求
        WeakSelf;
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCircleCancelLoveAPI parameters:param.mj_keyValues netIdentifier:netIdentifier success:^(id responseObject)  {
            if ([responseObject[@"errcode"] integerValue] == 0) {
                item.is_loved = @"0";
                // 更新列表数据
                if (self.updateBlock) {
                    self.updateBlock();
                }
            } else {
                TXBYAlert(responseObject[@"errmsg"]);
            }
        } failure:^(NSError *error) {
            // 网络加载失败
            [selfWeak requestFailure:error];
        }];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.circleReply.sub.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TXBYCircleReply *minorReply = self.circleReply.sub[indexPath.row];
    
    CGFloat totalHeight = 60;
    
    CGFloat photosViewHeight = 0;
    if (minorReply.imgs.count) {
        CGFloat imageViewHeight = (TXBYApplicationW - 61 - 15 - 4) / 3;
        // 如果只有一张图片
        if (minorReply.imgs.count == 1) {
            TXBYCircleImg *questionImage = minorReply.imgs[0];
            CGFloat imageViewMaxWH = TXBYApplicationW / 2.2;
            CGFloat imageWidth = questionImage.width;
            CGFloat imageHeight = questionImage.height;
            if (imageWidth > imageHeight) {
                imageViewHeight = MAX(imageViewMaxWH * imageHeight / imageWidth, imageViewMaxWH * 0.4);
            } else {
                imageViewHeight = imageViewMaxWH;
            }
        }
        photosViewHeight = imageViewHeight + 10;
    }
    
    
    totalHeight += photosViewHeight;
    
    CGFloat maxW = TXBYApplicationW - 61 - 15;

    NSString *content = minorReply.content;
    if (minorReply.at_user_name.length) {
        content = [NSString stringWithFormat:@"回复%@：%@",minorReply.at_user_name,minorReply.content];
    }
    
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:15] maxW:maxW];
    totalHeight += size.height + 10;
    return totalHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CirclePrimaryReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CirclePrimaryReplyCell"];
    TXBYCircleReply *minorReply = self.circleReply.sub[indexPath.row];
    cell.isDoctorUser = self.isDoctorUser;
    cell.isMinorReply = YES;
    cell.circleReply = minorReply;
    cell.delegate = self;
    WeakSelf;
    cell.likeButtonBlock = ^(UIButton *btn){
        [selfWeak accountUnExpired:^{
            [UIView animateWithDuration:0.2 animations:^{
                btn.transform = CGAffineTransformMakeScale(1.5, 1.5);
            } completion:^(BOOL finished) {
                btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
            btn.selected = !btn.selected;
            NSInteger count = minorReply.love.integerValue;
            if (btn.selected) {
                [selfWeak likeQuestion:minorReply];
                count++;
            } else {
                [selfWeak unlikeQuestion:minorReply];
                count--;
            }
            minorReply.love = [NSString stringWithFormat:@"%zd", count];
            if (count > 0) {
                [btn setTitle:minorReply.love forState:UIControlStateNormal];
            } else {
                [btn setTitle:@""forState:UIControlStateNormal];
            }
        }];
    };
    cell.replyButtonBlock = ^(UIButton *btn){
        CircleDoctorPublishViewController *vc;
        if (self.isDoctorUser) {
            vc = [CircleDoctorPublishViewController new];
        } else {
            vc = [CirclePatientPublishViewController new];
        }
        vc.circleReply = minorReply;
        vc.circleModel = selfWeak.circleModel;
        vc.replySuccessBlock = ^{
            [selfWeak request];
            [selfWeak updateList];
        };
        [selfWeak.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

// 刷新数据
- (void)updateList {
    if (self.updateBlock) {
        self.updateBlock();
    }
}

// 设置UITableViewCell分割线从最左端开始
- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

#pragma mark - CirclePrimaryReplyCellDeleagte
- (void)detialViewCellClickAvatar:(TXBYCircleReply *)circleReply {
    if (circleReply.type.integerValue == 200) {
        [self CircleIconViewActionWithModel:circleReply];
    }
}

- (NSString *)title {
    return @"回复详情";
}

@end
