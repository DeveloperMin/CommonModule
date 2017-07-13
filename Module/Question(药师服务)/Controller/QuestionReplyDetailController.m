//
//  QuestionReplyDetailController.m
//  publicCommon
//
//  Created by hj on 17/2/24.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "QuestionReplyDetailController.h"
#import "QuestionReply.h"
#import "QuestionTool.h"
#import "QuestionPrimaryReplyCell.h"
#import "QuestionCreateController.h"
#import "QuestionDetailController.h"

@interface QuestionReplyDetailController ()

@property (nonatomic, strong) QuestionPrimaryReplyCell *headerCell;

@property (nonatomic, strong) UIView *tableHeaderView;

@end

@implementation QuestionReplyDetailController

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] init];
        _tableHeaderView.frame = CGRectMake(0, 0, TXBYApplicationW, 0);
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        
        QuestionPrimaryReplyCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"QuestionPrimaryReplyCell" owner:nil options:nil] lastObject];
        cell.frame = CGRectMake(0, 0, TXBYApplicationW, 0);
        cell.contentLabelLeftConstraint.constant = -46;
        cell.questionReply = self.questionReply;
        WeakSelf;
        cell.likeButtonBlock = ^{
            if (selfWeak.questionReply.is_loved.integerValue) {
                [selfWeak unlikeQuestion:selfWeak.questionReply];
            } else {
                [selfWeak likeQuestion:selfWeak.questionReply];
            }
        };
        cell.replyButtonBlock = ^{
            QuestionCreateController *vc = [[QuestionCreateController alloc] init];
            vc.questionReply = selfWeak.questionReply;
            vc.question = selfWeak.question;
            [selfWeak.navigationController pushViewController:vc animated:YES];
        };
        self.headerCell = cell;
        [_tableHeaderView addSubview:cell];
    }
    return _tableHeaderView;
}

- (void)setQuestionReply:(QuestionReply *)questionReply {
    _questionReply = questionReply;
    
    [self tableHeaderView];
    self.headerCell.questionReply = questionReply;
    CGFloat headerCellHeight = 60;
    CGFloat maxW = TXBYApplicationW - 15 * 2;
    CGSize size = [questionReply.content sizeWithFont:[UIFont systemFontOfSize:15] maxW:maxW];
    headerCellHeight += size.height;
    
    // 加上图片高度
    CGFloat photosViewHeight = 0;
    if (questionReply.imgs.count) {
        photosViewHeight = (TXBYApplicationW - 10 * 4) / 3 + 20;
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
 *  更新列表数据
 */
- (void)updateList {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[QuestionDetailController class]]) {
            QuestionDetailController *questionDetailController = (QuestionDetailController *)vc;
            [questionDetailController updateList];
            break;
        }
    }
}

/**
 *  设置tableView属性
 */
- (void)setupTableView {
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"QuestionPrimaryReplyCell" bundle:nil] forCellReuseIdentifier:@"QuestionPrimaryReplyCell"];    
    self.tableView.backgroundColor = TXBYGlobalBgColor;
    // 设置下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateList)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
}

/**
 *  问题点赞
 */
- (void)likeQuestion:(BaseQuestionItem *)item {
    // 请求参数
    QuestionParam *param = [QuestionParam param];
    param.oid = item.ID;
    // 分类,1新闻,2 问答,3 医生, 4 评论, 5 步数
    param.category = @"4";
    param.operate = @"3";
    NSString *netIdentifier = [NSString stringWithFormat:@"likeQuestionNetIdentifier ID:%@",item.ID];
    // 发送请求
    WeakSelf;
    [QuestionTool likeQuestionWithParam:param netIdentifier:netIdentifier success:^(QuestionResult *result) {
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
            item.is_loved = @"1";
            item.loved_id = result.loved_id;
            item.love = [NSString stringWithFormat:@"%lu",item.love.integerValue + 1];
            if (item == selfWeak.questionReply) {
                selfWeak.questionReply = (QuestionReply *)item;
            }
            [selfWeak.tableView reloadData];
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
    // 请求参数
    QuestionParam *param = [QuestionParam param];
    param.ID = item.loved_id;
    
    // 分类,1新闻,2 问答,3 医生, 4 评论, 5 步数
    param.category = @"4";
    param.operate = @"5";
    NSString *netIdentifier = [NSString stringWithFormat:@"likeQuestionNetIdentifier ID:%@",item.ID];
    // 发送请求
    WeakSelf;
    [QuestionTool dislikeQuestionWithParam:param netIdentifier:netIdentifier success:^(QuestionResult *result) {
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
            item.is_loved = @"0";
            item.love = [NSString stringWithFormat:@"%lu",item.love.integerValue - 1];
            if (item == selfWeak.questionReply) {
                selfWeak.questionReply = (QuestionReply *)item;
            }
            [selfWeak.tableView reloadData];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questionReply.sub.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    QuestionReply *minorReply = self.questionReply.sub[indexPath.row];
    
    CGFloat totalHeight = 60;
    
    CGFloat photosViewHeight = 0;
    if (minorReply.imgs.count) {
        CGFloat imageViewHeight = (TXBYApplicationW - 10 * 4) / 3;
        // 如果只有一张图片
        if (minorReply.imgs.count == 1) {
            QuestionImage *questionImage = minorReply.imgs[0];
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
    
    
    totalHeight += photosViewHeight;
    
    CGFloat maxW = TXBYApplicationW - 61 - 15;

    NSString *content = minorReply.content;
    if (minorReply.at_user_name.length) {
        content = [NSString stringWithFormat:@"回复%@：%@",minorReply.at_user_name,minorReply.content];
    }
    
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:15] maxW:maxW];
    totalHeight += size.height;
    return totalHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionPrimaryReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionPrimaryReplyCell"];
    QuestionReply *minorReply = self.questionReply.sub[indexPath.row];
    cell.isMinorReply = YES;
    cell.questionReply = minorReply;
    WeakSelf;
    cell.likeButtonBlock = ^{
        if (minorReply.is_loved.integerValue) {
            [selfWeak unlikeQuestion:minorReply];
        } else {
            [selfWeak likeQuestion:minorReply];
        }
    };
    cell.replyButtonBlock = ^{
        QuestionCreateController *vc = [[QuestionCreateController alloc] init];
        vc.questionReply = minorReply;
        vc.question = selfWeak.question;
        [selfWeak.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

// 设置UITableViewCell分割线从最左端开始
-(void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (NSString *)title {
    return @"回复详情";
}

@end
