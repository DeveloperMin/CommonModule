//
//  QuestionDetailController.m
//  publicCommon
//
//  Created by hj on 17/2/20.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "QuestionDetailController.h"
#import "QuestionTool.h"
#import "Question.h"
#import "QuestionPrimaryReplyCell.h"
#import "QuestionCreateController.h"
#import "QuestionMinorReplyCell.h"
#import "QuestionReply.h"
#import "AccountTool.h"
#import "QuestionListController.h"
#import "QuestionReplyDetailController.h"

@interface QuestionDetailController ()

@property (nonatomic, strong) NSArray *replies;

@property (nonatomic, strong) QuestionPrimaryReplyCell *headerCell;

@property (nonatomic, strong) UIView *tableHeaderView;

@property (nonatomic, strong) UIView *separateView;

@property (nonatomic, strong) UILabel *emptyLabel;


@property (nonatomic, strong) NSIndexPath *currentIndexPath;

/**
 *  最多显示的二级评论条数
 */
@property (nonatomic, assign) NSInteger maxMinorRepliyCount;

@end

@implementation QuestionDetailController

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] init];
        _tableHeaderView.frame = CGRectMake(0, 0, TXBYApplicationW, 0);
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        
        QuestionPrimaryReplyCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"QuestionPrimaryReplyCell" owner:nil options:nil] lastObject];
        cell.frame = CGRectMake(0, 0, TXBYApplicationW, 0);
        cell.contentLabelLeftConstraint.constant = -42;
        WeakSelf;
        cell.likeButtonBlock = ^{
            if (self.question.is_loved.integerValue) {
                [selfWeak unlikeQuestion:selfWeak.question];
            } else {
                [selfWeak likeQuestion:selfWeak.question];
            }
        };
        cell.replyButtonBlock = ^{
            QuestionCreateController *vc = [[QuestionCreateController alloc] init];
            vc.question = self.question;
            vc.replySuccessBlock = ^{
                [selfWeak updateList];
            };
            [selfWeak.navigationController pushViewController:vc animated:YES];
        };
        self.headerCell = cell;
        [_tableHeaderView addSubview:cell];
        
        
        CGFloat blankViewH = 15;
        CGFloat titleLabelH = 35;
        CGFloat separateViewH = blankViewH + titleLabelH;
        
        UIView *separateView = [[UIView alloc] init];
        separateView.frame = CGRectMake(0, 80, TXBYApplicationW, separateViewH);
        separateView.backgroundColor = [UIColor whiteColor];
        [_tableHeaderView addSubview:separateView];
        self.separateView = separateView;
        
        UIView *blankView = [[UIView alloc] init];
        blankView.frame = CGRectMake(0, 0, TXBYApplicationW, blankViewH);
        blankView.backgroundColor = TXBYColor(245, 245, 245);
        [separateView addSubview:blankView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"回复";
        titleLabel.textColor = TXBYColor(43, 43, 43);
        titleLabel.frame = CGRectMake(20, blankViewH, TXBYApplicationW, 35);
        [separateView addSubview:titleLabel];
    }
    return _tableHeaderView;
}

- (UILabel *)emptyLabel {
    if (!_emptyLabel) {
        _emptyLabel = [UILabel label];
        _emptyLabel.frame = self.view.bounds;
        _emptyLabel.textColor = [UIColor grayColor];
        _emptyLabel.backgroundColor = [UIColor whiteColor];
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _emptyLabel.text = @"目前还没有回复";
        _emptyLabel.numberOfLines = 0;
        [self.view addSubview:_emptyLabel];
    }
    return _emptyLabel;
}


- (void)setQuestion:(Question *)question {
    _question = question;
    
    [self tableHeaderView];
    self.headerCell.question = question;
    CGFloat headerCellHeight = 60;
    CGFloat maxW = TXBYApplicationW - 15 * 2;
    CGSize size = [question.content sizeWithFont:[UIFont systemFontOfSize:15] maxW:maxW];
    headerCellHeight += size.height;
    
    // 加上图片高度
    CGFloat photosViewHeight = 0;
    if (question.imgs.count) {
        CGFloat imageViewHeight = (TXBYApplicationW - 10 * 4) / 3;
        // 如果只有一张图片
        if (question.imgs.count == 1) {
            QuestionImage *questionImage = question.imgs[0];
            CGFloat imageViewMaxWH = TXBYApplicationW / 2.2;
            CGFloat imageWidth = questionImage.width.doubleValue;
            CGFloat imageHeight = questionImage.height.doubleValue;
            if (imageWidth > imageHeight) {
                imageViewHeight = MAX(imageViewMaxWH * imageHeight / imageWidth, imageViewMaxWH * 0.4);
            } else {
                imageViewHeight = imageViewMaxWH;
            }
        }
        photosViewHeight = imageViewHeight + 20;
    }
    headerCellHeight += photosViewHeight;
    
    self.headerCell.txby_height = headerCellHeight;
    self.separateView.txby_y = headerCellHeight;
    self.tableHeaderView.txby_height = headerCellHeight + self.separateView.txby_height;
    self.tableView.tableHeaderView = self.tableHeaderView;
}

-  (instancetype)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        _maxMinorRepliyCount = 5;
    }
    return self;
}

-  (instancetype)initWithQuestionID:(NSString *)ID {
    if (self = [super init]) {
        Question *question = [Question new];
        question.ID = ID;
        self.question = question;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tableView属性
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.tableView deselectRowAtIndexPath:self.currentIndexPath animated:YES];
}

/**
 *  设置tableView属性
 */
- (void)setupTableView {
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"QuestionPrimaryReplyCell" bundle:nil] forCellReuseIdentifier:@"QuestionPrimaryReplyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QuestionMinorReplyCell" bundle:nil] forCellReuseIdentifier:@"QuestionMinorReplyCell"];
    
    self.tableView.backgroundColor = TXBYGlobalBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    // 设置下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateList)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    [header beginRefreshing];
    
}

/**
 *  更新列表数据
 */
- (void)updateList {
    [self accountUnExpired:^{
        [self request];
    }];
}

/**
 *  网络请求
 */
- (void)request {
    // 请求参数
    QuestionParam *param = [QuestionParam param];
    param.ID = self.question.ID;
    param.uid = [AccountTool account].uid;
    // 发送请求
//    [MBProgressHUD showMessage:@"请稍候" toView:self.view];
    WeakSelf;
    [QuestionTool questionDetailWithParam:param netIdentifier:TXBYClassName success:^(QuestionResult *result) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:selfWeak.view];
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
            selfWeak.replies = result.replies;
            selfWeak.question = result.question;
            [selfWeak.tableView reloadData];
            // 更新二级评论列表数据
            for (UIViewController *vc in selfWeak.navigationController.viewControllers) {
                if ([vc isKindOfClass:[QuestionReplyDetailController class]]) {
                    QuestionReplyDetailController *questionReplyDetailController = (QuestionReplyDetailController *)vc;
                    // 结束刷新
                    [questionReplyDetailController.tableView.mj_header endRefreshing];
                    for (QuestionReply *reply in result.replies) {
                        if ([reply.ID isEqualToString:questionReplyDetailController.questionReply.ID]) {
                            questionReplyDetailController.questionReply = reply;
                            [questionReplyDetailController.tableView reloadData];
                            break;
                        }
                    }
                    break;
                }
            }
        } else { // 注册失败
            TXBYAlert(result.errmsg);
        }
        // 结束刷新
        [selfWeak.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
//        // 隐藏加载提示
//        [MBProgressHUD hideHUDForView:selfWeak.view];
        // 网络加载失败
        [selfWeak requestFailure:error];
        // 结束刷新
        [selfWeak.tableView.mj_header endRefreshing];
        // 结束二级评论列表刷新
        for (UIViewController *vc in selfWeak.navigationController.viewControllers) {
            if ([vc isKindOfClass:[QuestionReplyDetailController class]]) {
                QuestionReplyDetailController *questionReplyDetailController = (QuestionReplyDetailController *)vc;
                // 结束刷新
                [questionReplyDetailController.tableView.mj_header endRefreshing];
                break;
            }
        }
        
    }];
}

/**
 *  问题点赞
 */
- (void)likeQuestion:(BaseQuestionItem *)item {
    Question *question;
    // 请求参数
    QuestionParam *param = [QuestionParam param];
    param.oid = item.ID;

    // 分类,1新闻,2 问答,3 医生, 4 评论, 5 步数
    param.category = @"4";
    if ([item isKindOfClass:[Question class]]) {
        question = (Question *)item;
        param.category = @"2";
    }
    param.operate = @"3";
    NSString *netIdentifier = [NSString stringWithFormat:@"likeQuestionNetIdentifier ID:%@",item.ID];
    // 发送请求
    WeakSelf;
    [QuestionTool likeQuestionWithParam:param netIdentifier:netIdentifier success:^(QuestionResult *result) {
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
            item.is_loved = @"1";
            item.loved_id = result.loved_id;
            item.love = [NSString stringWithFormat:@"%lu",item.love.integerValue + 1];
            if (question) {
                selfWeak.question = question;
            }
            [selfWeak.tableView reloadData];
            // 更新列表数据
            for (UIViewController *vc in selfWeak.navigationController.viewControllers) {
                if ([vc isKindOfClass:[QuestionListController class]]) {
                    QuestionListController *questionListController = (QuestionListController *)vc;
                    [questionListController updateList];
                    break;
                }
            }
        } else {
            TXBYAlert(result.errmsg);
        }
        
    } failure:^(NSError *error) {
        // 网络加载失败
        [selfWeak requestFailure:error];
    }];
}

/**
 *  问题取消点赞
 */
- (void)unlikeQuestion:(BaseQuestionItem *)item {
    Question *question;
    // 请求参数
    QuestionParam *param = [QuestionParam param];
    param.ID = item.loved_id;
    
    // 分类,1新闻,2 问答,3 医生, 4 评论, 5 步数
    param.category = @"4";
    if ([item isKindOfClass:[Question class]]) {
        question = (Question *)item;
        param.category = @"2";
    }
    
    param.operate = @"5";
    NSString *netIdentifier = [NSString stringWithFormat:@"likeQuestionNetIdentifier ID:%@",item.ID];
    // 发送请求
    WeakSelf;
    [QuestionTool dislikeQuestionWithParam:param netIdentifier:netIdentifier success:^(QuestionResult *result) {
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
            item.is_loved = @"0";
            item.love = [NSString stringWithFormat:@"%lu",item.love.integerValue - 1];
            if (question) {
                selfWeak.question = question;
            }
            [selfWeak.tableView reloadData];
            // 更新列表数据
            for (UIViewController *vc in selfWeak.navigationController.viewControllers) {
                if ([vc isKindOfClass:[QuestionListController class]]) {
                    QuestionListController *questionListController = (QuestionListController *)vc;
                    [questionListController updateList];
                    break;
                }
            }
        } else {
            TXBYAlert(result.errmsg);
        }
        
    } failure:^(NSError *error) {
        // 网络加载失败
        [selfWeak requestFailure:error];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.replies.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    QuestionReply *primaryReply = self.replies[section];
    if (primaryReply.sub.count <= _maxMinorRepliyCount) {
        return primaryReply.sub.count;
    } else {
        return _maxMinorRepliyCount + 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QuestionPrimaryReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionPrimaryReplyCell"];
    QuestionReply *reply = self.replies[section];
    cell.questionReply = reply;
    WeakSelf;
    cell.likeButtonBlock = ^{
        if (reply.is_loved.integerValue) {
            [selfWeak unlikeQuestion:reply];
        } else {
            [selfWeak likeQuestion:reply];
        }
    };
    cell.replyButtonBlock = ^{
        QuestionCreateController *vc = [[QuestionCreateController alloc] init];
        vc.questionReply = reply;
        vc.question = selfWeak.question;
        vc.replySuccessBlock = ^{
            [selfWeak updateList];
        };
        [selfWeak.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    QuestionReply *primaryReply = self.replies[section];
    
    CGFloat totalHeight = 60;
    
    CGFloat photosViewHeight = 0;
    if (primaryReply.imgs.count) {
        photosViewHeight = (TXBYApplicationW - 61 - 15 - 10 * 2) / 3 + 20;
    }
    totalHeight += photosViewHeight;
    
    CGFloat maxW = TXBYApplicationW - 61 - 15;
    CGSize size = [primaryReply.content sizeWithFont:[UIFont systemFontOfSize:15] maxW:maxW];
    totalHeight += size.height;
    return totalHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    QuestionReply *primaryReply = self.replies[indexPath.section];
    QuestionReply *minorReply = primaryReply.sub[indexPath.row];
    
    
    NSString *content = minorReply.content;
    if (minorReply.at_user_name.length) {
        content = [NSString stringWithFormat:@"回复%@：%@",minorReply.at_user_name,minorReply.content];
    }
    if (minorReply.imgs.count) {
        // 如果有图片
        content = [NSString stringWithFormat:@"%@ 查看图片",content];
    }
    NSString *contentStr = [NSString stringWithFormat:@"%@：%@",minorReply.user_name,content];
    
    
    CGFloat contentHeight = 0;
    CGFloat maxW = TXBYApplicationW - 61 - 15;
    CGSize size = [contentStr sizeWithFont:[UIFont systemFontOfSize:15] maxW:maxW];
    contentHeight += size.height;
    contentHeight += 3;
    
    CGFloat totalHeight = MAX(contentHeight, 25);
//    if (indexPath.row == primaryReply.sub.count - 1) {
//        return totalHeight + 10;
//    }
    return totalHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QuestionMinorReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionMinorReplyCell"];
    QuestionReply *primaryReply = self.replies[indexPath.section];
    QuestionReply *minorReply = primaryReply.sub[indexPath.row];
    
    if (indexPath.row < _maxMinorRepliyCount) {
        cell.questionReply = minorReply;
    } else {
        cell.totalReply = [NSString stringWithFormat:@"共%lu条回复 >",(unsigned long)primaryReply.sub.count];
    }
    
    return cell;
}

- (void)moreReply {
//    QuestionReply *primaryReply = self.replies[indexPath.section];
    QuestionReply *primaryReply;
    QuestionReplyDetailController *vc = [[QuestionReplyDetailController alloc] init];
    vc.question = self.question;
    vc.questionReply = primaryReply;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    
    QuestionReply *primaryReply = self.replies[indexPath.section];
    QuestionReply *minorReply = primaryReply.sub[indexPath.row];
    if (indexPath.row < _maxMinorRepliyCount) {
        QuestionCreateController *vc = [[QuestionCreateController alloc] init];
        vc.questionReply = minorReply;
        vc.question = self.question;
        WeakSelf;
        vc.replySuccessBlock = ^{
            [selfWeak updateList];
        };
        [selfWeak.navigationController pushViewController:vc animated:YES];
    } else {
        QuestionReplyDetailController *vc = [[QuestionReplyDetailController alloc] init];
        vc.questionReply = primaryReply;
        vc.question = self.question;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSString *)title {
    return @"问题详情";
}

@end
