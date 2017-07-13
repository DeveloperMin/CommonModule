//
//  QuestionListController.m
//  publicCommon
//
//  Created by hj on 17/2/20.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "QuestionListController.h"
#import "QuestionTool.h"
#import "QuestionListCell.h"
#import "Question.h"
#import "QuestionDetailController.h"
#import "QuestionCreateController.h"
#import "AccountTool.h"

@interface QuestionListController ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation QuestionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航栏添加按钮
    [self setupNav];
    
    // 设置tableView属性
    [self setupTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = TXBYColor(245, 245, 245);
}

#pragma mark - private
/**
 *  导航栏添加按钮
 */
- (void)setupNav {
    if (self.questionListControllerType == QuestionListControllerTypePatient) {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Question.bundle/question_createQuestion_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(createQuestion)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
}

- (void)createQuestion {
    QuestionCreateController *vc = [[QuestionCreateController alloc] init];
    vc.questionCreateStyle = QuestionCreateStyleQuestion;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  更新列表数据
 */
- (void)updateList {
    [self accountUnExpired:^{
        if (self.questionListControllerType == QuestionListControllerTypePatient) {
            [self requestMyQuestion];
        } else if (self.questionListControllerType == QuestionListControllerTypeDoctor)
            [self requestAllQuestion];
    }];
}

/**
 *  设置tableView属性
 */
- (void)setupTableView {
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"QuestionListCell" bundle:nil] forCellReuseIdentifier:@"QuestionListCell"];
    
    self.tableView.backgroundColor = TXBYGlobalBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateList)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    [header beginRefreshing];
}

/**
 *  网络请求
 */
- (void)requestMyQuestion {
    // 请求参数
    QuestionParam *param = [QuestionParam param];
    param.group = @"2";
    // 发送请求
//    [MBProgressHUD showMessage:@"请稍候……" toView:self.view];
    WeakSelf;
    [QuestionTool myQuestionWithParam:param netIdentifier:TXBYClassName success:^(QuestionResult *result) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:selfWeak.view];
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
            selfWeak.items = result.items;
            [selfWeak.tableView reloadData];
        } else {
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
    }];
}

/**
 *  网络请求
 */
- (void)requestAllQuestion {
    // 请求参数
    QuestionParam *param = [QuestionParam param];
    param.uid = [AccountTool account].uid;
    param.group = @"2";
    // 发送请求
//    [MBProgressHUD showMessage:@"请稍候……" toView:self.view];
    WeakSelf;
    [QuestionTool allQuestionWithParam:param netIdentifier:TXBYClassName success:^(QuestionResult *result) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:selfWeak.view];
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
            selfWeak.items = result.items;
            [selfWeak.tableView reloadData];
        } else { 
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
    }];
}

/**
 *  问题点赞
 */
- (void)likeQuestion:(Question *)question {
    // 请求参数
    QuestionParam *param = [QuestionParam param];
    param.oid = question.ID;
    param.category = @"2";
    param.operate = @"3";
    NSString *netIdentifier = [NSString stringWithFormat:@"likeQuestionNetIdentifier ID:%@",question.ID];
    // 发送请求
    WeakSelf;
    [QuestionTool likeQuestionWithParam:param netIdentifier:netIdentifier success:^(QuestionResult *result) {
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
            question.is_loved = @"1";
            question.loved_id = result.loved_id;
            question.love = [NSString stringWithFormat:@"%lu",question.love.integerValue + 1];
            
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
- (void)unlikeQuestion:(Question *)question {
    // 请求参数
    QuestionParam *param = [QuestionParam param];
    param.ID = question.loved_id;
    param.category = @"2";
    param.operate = @"5";
    NSString *netIdentifier = [NSString stringWithFormat:@"likeQuestionNetIdentifier ID:%@",question.ID];
    // 发送请求
    WeakSelf;
    [QuestionTool dislikeQuestionWithParam:param netIdentifier:netIdentifier success:^(QuestionResult *result) {
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
            question.is_loved = @"0";
            question.love = [NSString stringWithFormat:@"%lu",question.love.integerValue - 1];
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
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionListCell"];
    Question *question = self.items[indexPath.row];
    cell.question = question;
    WeakSelf;
    cell.likeButtonBlock = ^{
        if (question.is_loved.integerValue) {
            [selfWeak unlikeQuestion:question];
        } else {
            [selfWeak likeQuestion:question];
        }
    };
    cell.replyButtonBlock = ^{
        QuestionCreateController *vc = [[QuestionCreateController alloc] init];
        vc.question = question;
        [selfWeak.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Question *question = self.items[indexPath.row];
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
    CGFloat totalHeight = 78 + photosViewHeight;
    CGFloat maxW = TXBYApplicationW - 20;
    CGSize size = [question.content sizeWithFont:[UIFont systemFontOfSize:15] maxW:maxW];
    totalHeight += size.height;
    return totalHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionDetailController *vc = [[QuestionDetailController alloc] init];
    Question *question = self.items[indexPath.row];
    vc.question = question;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
