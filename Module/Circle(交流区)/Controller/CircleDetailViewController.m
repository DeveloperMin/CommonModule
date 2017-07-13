//
//  CircleDetailViewController.m
//  txzjPatient
//
//  Created by Limmy on 2017/4/25.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "CircleDetailViewController.h"
#import "TXBYCircleParam.h"
#import "AccountTool.h"
#import "CommentHeaderCell.h"
#import "TXBYCommentHeaderToolBar.h"
#import "TXBYCommentToolBar.h"
#import "TXBYCircleReply.h"
#import "CirclePrimaryReplyCell.h"
#import "CircleMinorReplyCell.h"
#import "TXBYCircleModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "CircleDoctorPublishViewController.h"
#import "CirclePatientPublishViewController.h"
#import "TXBYCircleLoveModel.h"
#import "TXBYCircleLoveCell.h"
#import "CircleListViewController.h"
#import "CircleReplyDetailController.h"
#import "TXBYCircleImg.h"
#import "CommentPatientHeaderCell.h"
#import "CircleDetailTipsCell.h"
#import "UIViewController+ServiceCircle.h"

@interface CircleDetailViewController ()<UITableViewDelegate, UITableViewDataSource, TXBYCommentToolBarDelegate, TXBYCommentHeaderToolBarDelegate, CommentHeaderCellDeleagte, CirclePrimaryReplyCellDeleagte>
/**
 *  tableView
 */
@property (nonatomic, strong) UITableView *tableView;
/**
 *  circleModel(问题model)
 */
@property (nonatomic, strong) CommentHeaderModel *circleModel;
/**
 *  replies
 */
@property (nonatomic, strong) NSArray *replies;
/**
 *  最多显示的二级评论条数
 */
@property (nonatomic, assign) NSInteger maxMinorRepliyCount;
/**
 *  commentToolBar
 */
@property (nonatomic, strong) TXBYCommentToolBar *commentToolBar;
/**
 *  lovePersons
 */
@property (nonatomic, strong) NSMutableArray *lovePersons;
/**
 *  currentBtn
 */
@property (nonatomic, weak) UIButton *currentBtn;
/**
 *  headerToolBar
 */
@property (nonatomic, weak) TXBYCommentHeaderToolBar *headerToolBar;
/**
 *  collectBtn
 */
@property (nonatomic, strong) UIButton *collectBtn;
/**
 * currentIndexPath
 */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

@implementation CircleDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialView];
    [self request];
    [self requestLoveDetail];
}

- (void)initialView {
    _maxMinorRepliyCount = 5;
    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectBtn.frame = CGRectMake(0, 0, 25, 25);
    [self.collectBtn setImage:[UIImage imageNamed:self.isDoctorUser?@"Circle.bundle/doctor_uncollect":@"Circle.bundle/patient_uncollect"] forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage imageNamed:self.isDoctorUser?@"Circle.bundle/doctor_collect":@"Circle.bundle/patient_collect"] forState:UIControlStateSelected];
    [self.collectBtn addTarget:self action:@selector(clickCollectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TXBYApplicationW, TXBYApplicationH - 84) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 21;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[CommentHeaderCell class] forCellReuseIdentifier:@"CommentHeaderCell"];
    [self.tableView registerClass:[CommentPatientHeaderCell class] forCellReuseIdentifier:@"CommentPatientHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CirclePrimaryReplyCell"bundle:nil] forCellReuseIdentifier:@"CirclePrimaryReplyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CircleMinorReplyCell"bundle:nil] forCellReuseIdentifier:@"CircleMinorReplyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TXBYCircleLoveCell" bundle:nil] forCellReuseIdentifier:@"TXBYCircleLoveCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CircleDetailTipsCell" bundle:nil] forCellReuseIdentifier:@"CircleDetailTipsCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDetial) name:@"updateCircleDetail" object:nil];
    // 创建评论toolBar
    [self setUpCommentToolBar];
}

- (void)clickCollectBtn:(UIButton *)btn {
    btn.selected = !btn.selected;
    [self requestCollectCircle];
}

- (void)setUpCommentToolBar {
    TXBYCommentToolBar *toolBar = [[TXBYCommentToolBar alloc] initWithFrame:CGRectMake(0, TXBYApplicationH - 84, TXBYApplicationW, 40)];
    toolBar.isDoctorUser = self.isDoctorUser;
    self.commentToolBar = toolBar;
    toolBar.delegate = self;
    [self.view addSubview:toolBar];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.tableView deselectRowAtIndexPath:self.currentIndexPath animated:YES];
}

- (void)request {
    TXBYCircleParam *param = [TXBYCircleParam param];
    param.uid = [AccountTool account].uid;
    param.ID = self.circleID;
    WeakSelf;
    // 发送请求
    [MBProgressHUD showMessage:@"请稍候..." toView:self.view];
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCircleDetailAPI parameters:param.mj_keyValues netIdentifier:selfWeak.title success:^(id json) {
        [MBProgressHUD hideHUDForView:selfWeak.view];
        if ([json[@"errcode"] integerValue] == 0) {
            NSLog(@"%@", json);
            selfWeak.circleModel = [CommentHeaderModel mj_objectWithKeyValues:json[@"data"][@"quest"]];
            selfWeak.replies = [TXBYCircleReply mj_objectArrayWithKeyValuesArray:json[@"data"][@"replies"]];
            [selfWeak setUpHeaderView];
            [selfWeak.tableView reloadData];
        } else {
            [selfWeak emptyViewWithImage:nil WithText:@"没有相关数据"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:selfWeak.view];
        [self requestFailure:error];
    }];
}

- (void)requestLoveDetail {
    TXBYCircleParam *param = [TXBYCircleParam param];
    param.ID = self.circleID;
    WeakSelf;
    // 发送请求
    NSString *className = [NSString stringWithFormat:@"%@_loveDetail", selfWeak.title];
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYLoveDetailAPI parameters:param.mj_keyValues netIdentifier:className success:^(id json) {
        NSLog(@"%@", json);//返回结果对象
        if ([json[@"errcode"] integerValue] == 0) {
            NSArray *array = [TXBYCircleLoveModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            selfWeak.lovePersons = [NSMutableArray arrayWithArray:array];
            [self.tableView reloadData];
        } else {
            [selfWeak emptyViewWithImage:nil WithText:@"没有相关数据"];
        }
    } failure:^(NSError *error) {
        [self requestFailure:error];
    }];
}

- (void)requestCollectCircle {
    [self accountUnExpired:^{
        TXBYCircleParam *param = [TXBYCircleParam param];
        param.oid = self.circleModel.ID;
        NSString *url;
        if (self.collectBtn.selected) {
            url = TXBYCircleCollectAPI;
        } else {
            url = TXBYCancelCircleCollectAPI;
        }
        WeakSelf;
        // 发送请求
        [[TXBYHTTPSessionManager sharedManager] encryptPost:url parameters:param.mj_keyValues netIdentifier:@"collect" success:^(id json) {
            //        NSLog(@"%@", json);//返回结果对象
            if ([json[@"errcode"] integerValue] == 0) {
                
            } else {
                [MBProgressHUD showInfo:json[@"errmsg"] toView:self.view];
            }
        } failure:^(NSError *error) {
            [self requestFailure:error];
        }];
    }];
}

- (void)setUpHeaderView {
    // 设置关注按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.collectBtn];
    if (self.circleModel.is_attentioned.integerValue) {
        self.collectBtn.selected = YES;
    }
    UIView *headerView = [UIView new];
    headerView.backgroundColor = TXBYGlobalBgColor;
    CommentHeaderCell *cell;
    if (self.circleModel.user_type.integerValue == 100) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommentPatientHeaderCell"];
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommentHeaderCell"];
    }
    cell.delegate = self;
    cell.backgroundColor = [UIColor whiteColor];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CGFloat cellH;
    if (self.circleModel.user_type.integerValue == 100) {
        cellH = [self.tableView cellHeightForIndexPath:indexPath model:self.circleModel keyPath:@"model" cellClass:[CommentPatientHeaderCell class] contentViewWidth:TXBYApplicationW];
    } else {
        cellH = [self.tableView cellHeightForIndexPath:indexPath model:self.circleModel keyPath:@"model" cellClass:[CommentHeaderCell class] contentViewWidth:TXBYApplicationW];
    }
    
    cell.frame = CGRectMake(0, 0, TXBYApplicationW, cellH);
    cell.model = self.circleModel;
    [headerView addSubview:cell];
    
    TXBYCommentHeaderToolBar *headerToolBar = [[TXBYCommentHeaderToolBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cell.frame) + 10, TXBYApplicationW, 35)];
    self.headerToolBar = headerToolBar;
    headerToolBar.model = self.circleModel;
    headerToolBar.delegate = self;
    [headerView addSubview:headerToolBar];
    
    headerView.frame = CGRectMake(0, 0, TXBYApplicationW, CGRectGetMaxY(headerToolBar.frame) + 1);
    self.tableView.tableHeaderView = headerView;
    // 设置commentToolBar
    self.commentToolBar.model = self.circleModel;
    // 偏移到评论处
//    if (self.isComment) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
//    }
}
#pragma mark - CommentHeaderCellDeleagte
- (void)iconViewClickAction:(CommentHeaderModel *)model {
    if (model.user_type.integerValue == 200) {
        [self CircleIconViewActionWithModel:model];
    }
}

#pragma mark - TXBYCommentHeaderToolBarDelegate
- (void)commentHeaderToolClickAction:(UIButton *)btn {
    self.currentBtn = btn;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.currentBtn.tag == 1) {
        if (!self.lovePersons.count && self.circleModel) {
            return 1;
        }
        return self.lovePersons.count;
    } else {
        if (!self.replies.count) {
            return 1;
        }
        return self.replies.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentBtn.tag == 1) {
        return 1;
    } else {
        if (!self.replies.count && self.circleModel) {
            return 1;
        }
        TXBYCircleReply *primaryReply = self.replies[section];
        if (primaryReply.sub.count <= _maxMinorRepliyCount) {
            return primaryReply.sub.count;
        } else {
            return _maxMinorRepliyCount + 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentBtn.tag == 1) {
        if (!self.lovePersons.count) {
            CircleDetailTipsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CircleDetailTipsCell"];
            cell.tipLab.text = @"快来点个赞";
            return cell;
        } else {
            TXBYCircleLoveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TXBYCircleLoveCell" forIndexPath:indexPath];
            cell.model = self.lovePersons[indexPath.section];
            return cell;
        }
    } else {
        if (!self.replies.count) {
            CircleDetailTipsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CircleDetailTipsCell"];
            cell.tipLab.text = @"快来发表你的评论吧";
            return cell;
        }
        CircleMinorReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CircleMinorReplyCell"];
        TXBYCircleReply *primaryReply = self.replies[indexPath.section];
        TXBYCircleReply *minorReply = primaryReply.sub[indexPath.row];
        if (indexPath.row < _maxMinorRepliyCount) {
            cell.circleReply = minorReply;
        } else {
            cell.totalReply = [NSString stringWithFormat:@"共%lu条回复 >",(unsigned long)primaryReply.sub.count];
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    if (self.currentBtn.tag == 1) {
//        if (!self.lovePersons.count) {
//            return 150;
//        }
//        return 50;
//    } else {
//        if (!self.replies.count) {
//            return 150;
//        }
//        TXBYCircleReply *primaryReply = self.replies[indexPath.section];
//        TXBYCircleReply *minorReply = primaryReply.sub[indexPath.row];
//        
//        NSString *content = minorReply.content;
//        if (minorReply.at_user_name.length) {
//            content = [NSString stringWithFormat:@"回复%@: %@",minorReply.at_user_name,minorReply.content];
//        }
//        if (minorReply.imgs.count) {
//            // 如果有图片
//            content = [NSString stringWithFormat:@"%@ 查看图片",content];
//        }
//        NSString *contentStr = [NSString stringWithFormat:@"%@: %@",minorReply.user_name,content];
//        CGFloat maxW = TXBYApplicationW - 61 - 15;
//        CGFloat contentHeight = [contentStr sizeHeightSpaceLabelWithFont:[UIFont systemFontOfSize:13] withWidth:maxW lineSpace:6 wordSpace:0];
//        CGFloat totalHeight = MAX(contentHeight, 21);
//        return totalHeight;
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.currentBtn.tag == 1) {
        return 0.1;
    } else {
        if (!self.replies.count) {
            return 0;
        }
        TXBYCircleReply *primaryReply = self.replies[section];
        
        CGFloat totalHeight = 60;
        
        CGFloat photosViewHeight = 0;
        if (primaryReply.imgs.count) {
            if (primaryReply.imgs.count == 1) {
                TXBYCircleImg *questionImage = primaryReply.imgs.lastObject;
                CGFloat imageViewMaxWH = TXBYApplicationW / 2.2;
                CGFloat imageWidth = questionImage.width;
                CGFloat imageHeight = questionImage.height;
                if (imageWidth > imageHeight) {
                    photosViewHeight = MAX(imageViewMaxWH * imageHeight / imageWidth, imageViewMaxWH * 0.4) + 10;
                } else {
                    photosViewHeight = imageViewMaxWH * 0.8 + 10;
                }
            } else {
                photosViewHeight = (TXBYApplicationW - 61 - 15 - 2 * 2) / 3 + 10;
            }
        }
        totalHeight += photosViewHeight;
        if (primaryReply.sub.count) {
            totalHeight += 10;
        }
        
        CGFloat maxW = TXBYApplicationW - 61 - 15;
        CGSize size = [primaryReply.content sizeWithFont:[UIFont systemFontOfSize:15] maxW:maxW];
        totalHeight += size.height;
        return totalHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.currentBtn.tag == 0) {
        if (!self.replies.count) {
            return 0;
        }
        return 10;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.currentBtn.tag == 1) {
        return [UIView new];
    } else {
        if (!self.replies.count) {
            return [UIView new];
        }
        UIView *footer = [UIView new];
        footer.frame = CGRectMake(0, 0, TXBYApplicationW, 10);
        footer.backgroundColor = [UIColor whiteColor];
        UILabel *line = [UILabel new];
        line.frame = CGRectMake(0, 9, TXBYApplicationW, 1);
        line.backgroundColor = TXBYGlobalBgColor;
        [footer addSubview:line];
        return footer;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.currentBtn.tag == 1) {
        return [UIView new];
    } else {
        if (!self.replies.count) {
            return [UIView new];
        }
        CirclePrimaryReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CirclePrimaryReplyCell"];
        cell.isDoctorUser = self.isDoctorUser;
        cell.delegate = self;
        TXBYCircleReply *reply = self.replies[section];
        cell.circleReply = reply;
        WeakSelf;
        
        cell.likeButtonBlock = ^(UIButton *btn){
            [selfWeak accountUnExpired:^{
                [UIView animateWithDuration:0.2 animations:^{
                    btn.transform = CGAffineTransformMakeScale(1.5, 1.5);
                } completion:^(BOOL finished) {
                    btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }];
                btn.selected = !btn.selected;
                NSInteger count = reply.love.integerValue;
                if (btn.selected) {
                    [selfWeak requsetLoveWithModel:reply];
                    count++;
                } else {
                    [selfWeak requsetCancelLoveWithModel:reply];
                    count--;
                }
                reply.love = [NSString stringWithFormat:@"%zd", count];
                if (count > 0) {
                    [btn setTitle:reply.love forState:UIControlStateNormal];
                } else {
                    [btn setTitle:@""forState:UIControlStateNormal];
                }
            }];
        };
        cell.replyButtonBlock = ^(UIButton *btn){
            CircleDoctorPublishViewController *publishVc;
            if (self.isDoctorUser) {
                publishVc = [CircleDoctorPublishViewController new];
            } else {
                publishVc = [CirclePatientPublishViewController new];
            }
            publishVc.circlePublishStyle = CirclePublishStyleReply;
            WeakSelf;
            publishVc.replySuccessBlock = ^() {
                [selfWeak updateDetial];
            };
            publishVc.circleModel = (TXBYCircleModel *)self.circleModel;
            publishVc.circleReply = reply;
            [selfWeak.navigationController pushViewController:publishVc animated:YES];
        };
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickheaderViewCell)];
        [cell addGestureRecognizer:tap];
        return cell;
    }
    
}

// 防止点击header响应didSelectTableViewCell方法
- (void)clickheaderViewCell {}

#pragma mark - CirclePrimaryReplyCellDeleagte
- (void)detialViewCellClickAvatar:(TXBYCircleReply *)circleReply {
    if (circleReply.type.integerValue == 200) {
        [self CircleIconViewActionWithModel:circleReply];
    }
}

/**
 * 点赞请求
 */
- (void)requsetLoveWithModel:(id)model {
    [self accountUnExpired:^{
        TXBYCircleParam *param = [TXBYCircleParam param];
        param.category = @"4";
        param.operate = @"3";
        if ([model isKindOfClass:[CommentHeaderModel class]]) {
            param.category = @"2";
        }
        TXBYCircleReply *itemModel = (TXBYCircleReply *)model;
        param.oid = itemModel.ID;
        NSString *className = [NSString stringWithFormat:@"likeQuestionNetIdentifier ID:%@",itemModel.ID];
        // 发送请求
        WeakSelf;
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCircleLoveAPI parameters:param.mj_keyValues netIdentifier:className success:^(id responseObject) {
            if ([responseObject[@"errcode"] integerValue] == 0) {
                itemModel.loved_id = responseObject[@"data"][@"ID"];
                itemModel.is_loved = @"1";
            }
            [selfWeak updateList];
        } failure:^(NSError *error) {
        }];
    }];
}

/**
 * 取消赞请求
 */
- (void)requsetCancelLoveWithModel:(id)model {
    [self accountUnExpired:^{
        TXBYCircleParam *param = [TXBYCircleParam param];
        param.category = @"4";
        if ([model isKindOfClass:[CommentHeaderModel class]]) {
            param.category = @"2";
        }
        param.operate = @"5";
        TXBYCircleReply *itemModel = (TXBYCircleReply *)model;
        param.ID = itemModel.loved_id;
        // 发送请求
        NSString *className = [NSString stringWithFormat:@"likeQuestionNetIdentifier ID:%@",itemModel.ID];
        WeakSelf;
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCircleCancelLoveAPI parameters:param.mj_keyValues netIdentifier:className success:^(id responseObject) {
            if ([responseObject[@"errcode"] integerValue] == 0) {
                itemModel.is_loved = @"0";
            }
            [selfWeak updateList];
        } failure:^(NSError *error) {
        }];
    }];
}

- (void)updateDetial {
    // 刷新数据
    [self request];
    [self updateList];
}

- (void)updateList {
    // 更新列表数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCircleLove" object:nil];
}

#pragma mark - TXBYCommentToolBarDelegate
- (void)circleToolBarClickBtn:(UIButton *)btn {
    if (btn.tag == 1) {
        [self shareCircleDetail];
    } else if (btn.tag == 2) {
        CircleDoctorPublishViewController *publishVc;
        if (self.isDoctorUser) {
            publishVc = [CircleDoctorPublishViewController new];
        } else {
            publishVc = [CirclePatientPublishViewController new];
        }
        publishVc.circlePublishStyle = CirclePublishStyleReply;
        WeakSelf;
        publishVc.replySuccessBlock = ^() {
            [selfWeak updateDetial];
        };
        publishVc.circleModel = (TXBYCircleModel *)self.circleModel;
        [self.navigationController pushViewController:publishVc animated:YES];
    } else if (btn.tag == 3) {
        btn.selected = !btn.selected;
        TXBYCircleLoveModel *mineModel = [TXBYCircleLoveModel new];
        Account *account = [AccountTool account];
        mineModel.avatar = account.avatar;
        mineModel.user_name = account.name;
        mineModel.ID = account.uid;
        if (btn.selected) {
            [self.lovePersons insertObject:mineModel atIndex:0];
            [self requsetLoveWithModel:self.circleModel];
        } else {
            for (TXBYCircleLoveModel *model in self.lovePersons) {
                if ([model.ID isEqualToString:mineModel.ID]) {
                    [self.lovePersons removeObject:model];
                    break;
                }
            }
            [self requsetCancelLoveWithModel:self.circleModel];
        }
        if (self.lovePersons.count) {
            [self.headerToolBar.likeBtn setTitle:[NSString stringWithFormat:@"赞 %zd", self.lovePersons.count] forState:UIControlStateNormal];
        } else {
            [self.headerToolBar.likeBtn setTitle:@"赞" forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentBtn.tag == 1) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    WeakSelf;
    TXBYCircleReply *primaryReply = self.replies[indexPath.section];
    TXBYCircleReply *minorReply = primaryReply.sub[indexPath.row];
    if (indexPath.row < _maxMinorRepliyCount) {
        CircleDoctorPublishViewController *vc;
        if (self.isDoctorUser) {
            vc = [CircleDoctorPublishViewController new];
        } else {
            vc = [CirclePatientPublishViewController new];
        }
        vc.circleReply = minorReply;
        vc.circleModel = self.circleModel;
        vc.circlePublishStyle = CirclePublishStyleReply;
        WeakSelf;
        vc.replySuccessBlock = ^{
            [selfWeak updateDetial];
        };
        [selfWeak.navigationController pushViewController:vc animated:YES];
    } else {
        CircleReplyDetailController *vc = [[CircleReplyDetailController alloc] init];
        vc.circleReply = primaryReply;
        vc.isDoctorUser = self.isDoctorUser;
        vc.circleModel = (TXBYCircleModel *)self.circleModel;
        vc.indexPath = indexPath;
        vc.updateBlock = ^ {
            [selfWeak updateDetial];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)shareCircleDetail {
    NSString *urlStr = [NSString stringWithFormat:@"http://wechat.eeesys.com/module/share/index.jsp?id=%@", self.circleModel.ID];
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"app_icon"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    NSString *title, *content;
    if (self.circleModel.user_type.integerValue == 100) {
        title = self.circleModel.content;
        content = self.circleModel.content;
    } else {
        title = self.circleModel.title;
        content = self.circleModel.content;
    }
    
    // 限制标题字数
    title = [title substringToIndex:MIN(TXBYShareTitleMaxCount, title.length)];
    // 限制内容字数
    content = [content substringToIndex:MIN(TXBYShareTextMaxCount, content.length)];
    
    
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:content
                                         images:imageArray
                                            url:[NSURL URLWithString:urlStr]
                                          title:title
                                           type:SSDKContentTypeAuto];
        content = [NSString stringWithFormat:@"%@%@",content,urlStr];
        // 限制内容字数
        content = [content substringToIndex:MIN(TXBYShareTextMaxCount, content.length)];
        [shareParams SSDKSetupSinaWeiboShareParamsByText:content
                                                   title:title
                                                   image:imageArray
                                                     url:[NSURL URLWithString:urlStr]
                                                latitude:0
                                               longitude:0
                                                objectID:@"分享"
                                                    type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
        [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            switch (state) {
                case SSDKResponseStateSuccess: {
                    [MBProgressHUD showSuccess:@"分享成功" toView:self.view animated:YES];
                    break;
                }
                case SSDKResponseStateFail: {
                    [MBProgressHUD showInfo:@"分享失败" toView:self.view];
                    break;
                }
                case SSDKResponseStateCancel: {
//                    [MBProgressHUD showInfo:@"分享取消" toView:self.view];
                    break;
                }
                default:
                    break;
            }
        }
         ];
    }
}

/**
 *  销毁
 */
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 取消网络请求
    [[TXBYHTTPSessionManager sharedManager] cancelNetworkingWithNetIdentifier:TXBYClassName];
}

- (NSString *)title {
    return @"圈子详情";
}

@end
