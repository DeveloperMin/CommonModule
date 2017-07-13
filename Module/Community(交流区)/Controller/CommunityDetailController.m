//
//  CommunityDetailController.m
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/25.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "CommunityDetailController.h"
#import "CommunityCellFrame.h"
#import "CommunityListCell.h"
#import "CommunityToolBar.h"
#import "AccountTool.h"
#import "CommunityParam.h"
#import "CommunityPerson.h"
#import "CommunityPersonCell.h"
#import "CommunityCommentController.h"

@interface CommunityDetailController ()<UITableViewDelegate, UITableViewDataSource>
/**
 *  tableView
 */
@property (nonatomic, strong) UITableView *tableView;
/**
 *  headerView
 */
@property (nonatomic, weak) UIView *headerView;
/**
 *  toolView
 */
@property (nonatomic, strong) UIView *toolView;
/**
 *  工具滑动条
 */
@property (nonatomic, strong) UIView *tagView;
/**
 *  工具条赞
 */
@property (nonatomic, weak) UIButton *likeBtn;
/**
 *  工具条踩
 */
@property (nonatomic, weak) UIButton *treadBtn;
/**
 *  工具条当前按钮
 */
@property (nonatomic, weak) UIButton *currentBtn;
/**
 *  评论cellFrames
 */
@property (nonatomic, strong) NSArray *commentFrames;
/**
 *  footer赞按钮
 */
@property (nonatomic, weak) UIButton *loveBtn;
/**
 *  footer踩按钮
 */
@property (nonatomic, weak) UIButton *unLoveBtn;
/**
 *  footer评论按钮
 */
@property (nonatomic, weak) UIButton *commonBtn;
/**
 *  赞数组
 */
@property (nonatomic, strong) NSMutableArray *lovePersons;
/**
 *  踩数组
 */
@property (nonatomic, strong) NSMutableArray *treadPersons;

@property (nonatomic, strong) CommunityPerson *myPerson;

@end

@implementation CommunityDetailController

- (NSMutableArray *)lovePersons {
    if (!_lovePersons) {
        _lovePersons = [NSMutableArray array];
    }
    return _lovePersons;
}

- (NSMutableArray *)treadPersons {
    if (!_treadPersons) {
        _treadPersons = [NSMutableArray array];
    }
    return _treadPersons;
}

- (CommunityPerson *)myPerson {
    if (!_myPerson) {
        _myPerson = [[CommunityPerson alloc] init];
        _myPerson.avatar = [AccountTool account].avatar;
        _myPerson.user_name = [AccountTool account].user_name;
        _myPerson.name = [AccountTool account].name;
    }
    return _myPerson;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建tableView
    [self createTableView];
    if (!self.ID.length) {
        [self createHeaderView];
        [self createToolBar];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestCommon];
    [self requestLovePerson];
    [self requestUnLovePerson];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestCommon {
    // 请求参数
    CommunityParam *param = [CommunityParam param];
    CommunityListItem *communityItem = self.communityFrame.communityItem;
    if (self.ID.length) {
        param.quest_id = self.ID;
    } else {
        param.quest_id = communityItem.ID;
    }
    param.uid = [AccountTool account].uid;
    WeakSelf;
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYQuestDetailAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"errcode"] integerValue] == 0) {
            CommunityListItem *communityItem = [CommunityListItem mj_objectWithKeyValues:responseObject[@"quest"]];
            self.communityFrame = [CommunityCellFrame cellFrameWithCommunityItem:communityItem];
            NSArray *array = [CommunityListItem mj_objectArrayWithKeyValuesArray:responseObject[@"replies"]];
            selfWeak.commentFrames = [self communitysToCellFrames:array];
            [selfWeak.commonBtn setTitle:[NSString stringWithFormat:@"评论 %ld", (long)selfWeak.commentFrames.count] forState:UIControlStateNormal];
            [selfWeak.tableView reloadData];
        } else {
            TXBYAlert(responseObject[@"errmsg"]);
        }
        if (self.ID.length) {
            [self createHeaderView];
            [self createToolBar];
        }
    } failure:^(NSError *error) {
        [self requestFailure:error];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)requestUnLovePerson {
    // 存在token, 刷新token
    [self accountExist:^{
        [self accountUnExpired:^{
        }];
    } unExist:^{
    }];
    // 请求参数
    CommunityParam *param = [CommunityParam param];
    CommunityListItem *item = self.communityFrame.communityItem;
    if (self.ID.length) {
        param.ID = self.ID;
    } else {
        param.ID = item.ID;
    }
    param.type = @"4";
    WeakSelf;
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCommunityPersonAPI parameters:param.mj_keyValues netIdentifier:@"unLovePerson" success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 0) {
            selfWeak.treadPersons = [CommunityPerson mj_objectArrayWithKeyValuesArray:responseObject[@"love"]];
            [selfWeak.treadBtn setTitle:[NSString stringWithFormat:@"踩 %ld", (long)self.treadPersons.count] forState:UIControlStateNormal];
        } else {
            TXBYAlert(responseObject[@"errmsg"]);
        }
        if (self.currentBtn.tag == 1) {
            [selfWeak.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self requestFailure:error];
    }];
}

- (void)requestLovePerson {
    // 存在token, 刷新token
    [self accountExist:^{
        [self accountUnExpired:^{
        }];
    } unExist:^{
    }];
    // 请求参数
    CommunityParam *param = [CommunityParam param];
    CommunityListItem *item = self.communityFrame.communityItem;
    if (self.ID.length) {
        param.ID = self.ID;
    } else {
        param.ID = item.ID;
    }
    WeakSelf;
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCommunityPersonAPI parameters:param.mj_keyValues netIdentifier:@"TXBYLovePersonAPI" success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 0) {
            selfWeak.lovePersons = [CommunityPerson mj_objectArrayWithKeyValuesArray:responseObject[@"love"]];
            [selfWeak.likeBtn setTitle:[NSString stringWithFormat:@"赞 %ld", (long)self.lovePersons.count] forState:UIControlStateNormal];
        } else {
            TXBYAlert(responseObject[@"errmsg"]);
        }
        if (self.currentBtn.tag == 2) {
            [selfWeak.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self requestFailure:error];
    }];
}

- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    self.tableView.backgroundColor = TXBYColor(245, 245, 245);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.frame = CGRectMake(0, 0, TXBYApplicationW, TXBYApplicationH - 85);
    [self.view addSubview:tableView];
}

- (void)createHeaderView {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = TXBYColor(239, 239, 239);
    self.headerView = headerView;
    CommunityListCell *headCell = [[CommunityListCell alloc] init];
    headCell.backgroundColor = [UIColor whiteColor];
    headCell.cellFrame = self.communityFrame;
    headCell.frame = CGRectMake(0, 0, TXBYApplicationW, self.communityFrame.cellHeight - 36);
    for (UIView *view in headCell.contentView.subviews) {
        if ([view isKindOfClass:[CommunityToolBar class]]) {
            [view removeFromSuperview];
            break;
        }
    }
    [headerView addSubview:headCell];
    [self createToolView];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.currentBtn.tag == 0) {
        return self.commentFrames.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentBtn.tag == 0) {
        return 1;
    } else if (self.currentBtn.tag == 1){
        return self.treadPersons.count;
    } else {
        return self.lovePersons.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentBtn.tag == 0) {
        // 创建cell
        static NSString *CellIdentifier = @"CommunityListCell";
        CommunityListCell *cell = [CommunityListCell cellWithTableView:tableView classString:CellIdentifier];
        cell.comment = YES;
        cell.isTread = self.isTread;
        // 取出对应的模型
        cell.cellFrame = self.commentFrames[indexPath.section];
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[CommunityToolBar class]]) {
                [view removeFromSuperview];
                break;
            }
        }
        return cell;
    } else {
        static NSString *resueID = @"cell";
        CommunityPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:resueID];
        if (!cell) {
            cell = [[CommunityPersonCell alloc] init];
        }
        if (self.currentBtn.tag == 1) {
            cell.person = self.treadPersons[indexPath.row];
        } else {
            cell.person = self.lovePersons[indexPath.row];
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate
/**
 *  高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentBtn.tag == 0) {
        return [self.commentFrames[indexPath.section] cellHeight] - 36;
    } else {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.currentBtn.tag == 0) {
        return 8;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = ESGlobalBgColor;
    return view;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)createToolView {
    UIView *toolView = [[UIView alloc] init];
    self.toolView = toolView;
    toolView.backgroundColor = [UIColor whiteColor];
    toolView.frame = CGRectMake(0, self.communityFrame.cellHeight - 35, TXBYApplicationW, 45);
    [self.headerView addSubview:toolView];
    
    UIView *tagView = [UIView new];
    self.tagView = tagView;
    tagView.frame = CGRectMake(12, 43, 60, 2);
    tagView.backgroundColor = ESMainColor;
    [toolView addSubview:tagView];
    
    UIButton *commonBtn = [self setUpOneButtonWithTitle:[NSString stringWithFormat:@"评论 %ld", (unsigned long)self.commentFrames.count]];
    
    commonBtn.selected = YES;
    self.commonBtn = commonBtn;
    self.currentBtn = commonBtn;
    commonBtn.tag = 0;
    commonBtn.frame = CGRectMake(10, 0, 60, 43);
    tagView.txby_x = commonBtn.txby_x + 2;
    
    if (self.isTread) {
        UIButton *treadBtn = [self setUpOneButtonWithTitle:[NSString stringWithFormat:@"踩 %ld", (unsigned long)self.treadPersons.count]];
        treadBtn.tag = 1;
        self.treadBtn = treadBtn;
        treadBtn.frame = CGRectMake(TXBYApplicationW - 160, 0, 60, 43);
        self.headerView.frame = CGRectMake(0, 0, TXBYApplicationW, CGRectGetMaxY(toolView.frame));
        self.tableView.tableHeaderView = self.headerView;
    }
    
    UIButton *likeBtn = [self setUpOneButtonWithTitle:[NSString stringWithFormat:@"赞 %ld", (unsigned long)self.lovePersons.count]];
    likeBtn.tag = 2;
    self.likeBtn = likeBtn;
    likeBtn.frame = CGRectMake(TXBYApplicationW - 80, 0, 60, 43);
    self.headerView.frame = CGRectMake(0, 0, TXBYApplicationW, CGRectGetMaxY(toolView.frame));
    self.tableView.tableHeaderView = self.headerView;
}

- (UIButton *)setUpOneButtonWithTitle:(NSString *)title
{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickToolViewBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    [self.toolView addSubview:btn];
    return btn;
}

- (void)clickToolViewBtn:(UIButton *)btn {
    if (self.currentBtn.tag != btn.tag) {
        btn.selected = !btn.selected;
        self.currentBtn.selected = NO;
        self.currentBtn = btn;
    }
    
    if (btn.selected) {
        [UIView animateWithDuration:0.2 animations:^{
            self.tagView.txby_x = btn.txby_x + 2;
        }];
    }
    [self.tableView reloadData];
}

- (void)createToolBar {
    UIView *toolBar = [UIView new];
    toolBar.frame = CGRectMake(0, TXBYApplicationH - 84, self.view.txby_width, 40);
    toolBar.backgroundColor = TXBYColor(239, 239, 239);
    [self.view addSubview:toolBar];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    commentBtn.backgroundColor = [UIColor whiteColor];
    if (!self.isTread) {
        commentBtn.frame = CGRectMake(0, 0, TXBYApplicationW/2 - 1, 40);
    } else {
        commentBtn.frame = CGRectMake(0, 0, TXBYApplicationW/3 - 1, 40);
    }
    [commentBtn setImage:[UIImage imageNamed:@"community.bundle/comment@3x"] forState:UIControlStateNormal];
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(clickCommentBtn) forControlEvents:UIControlEventTouchUpInside];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [commentBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [toolBar addSubview:commentBtn];
    
    UIButton *unLoveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.unLoveBtn = unLoveBtn;
    unLoveBtn.backgroundColor = [UIColor whiteColor];
    unLoveBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    if (self.isTread) {
        unLoveBtn.frame = CGRectMake(TXBYApplicationW/3, 0, TXBYApplicationW/3 - 1, 40);
    }
    if ([self.communityFrame.communityItem.is_treaded isEqualToString:@"1"]) {
        unLoveBtn.selected = YES;
    } else {
        unLoveBtn.selected = NO;
    }
    [unLoveBtn setImage:[UIImage imageNamed:@"community.bundle/undotlike@3x"] forState:UIControlStateNormal];
    [unLoveBtn addTarget:self action:@selector(clickUnLoveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [unLoveBtn setImage:[UIImage imageNamed:@"community.bundle/dotlike@3x"] forState:UIControlStateSelected];
    [unLoveBtn setTitle:@"踩" forState:UIControlStateNormal];
    unLoveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [unLoveBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [toolBar addSubview:unLoveBtn];
    
    UIButton *loveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loveBtn = loveBtn;
    loveBtn.backgroundColor = [UIColor whiteColor];
    loveBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    if (!self.isTread) {
        loveBtn.frame = CGRectMake(TXBYApplicationW/2, 0, TXBYApplicationW/2, 40);
    } else {
        loveBtn.frame = CGRectMake(TXBYApplicationW/3 * 2, 0, TXBYApplicationW/3, 40);
    }
    if ([self.communityFrame.communityItem.is_loved isEqualToString:@"1"]) {
        loveBtn.selected = YES;
    } else {
        loveBtn.selected = NO;
    }
    [loveBtn setImage:[UIImage imageNamed:@"community.bundle/unlike@3x"] forState:UIControlStateNormal];
    [loveBtn addTarget:self action:@selector(clickLoveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [loveBtn setImage:[UIImage imageNamed:@"community.bundle/like@3x"] forState:UIControlStateSelected];
    [loveBtn setTitle:@"赞" forState:UIControlStateNormal];
    loveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [loveBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [toolBar addSubview:loveBtn];
}

- (void)clickCommentBtn {
    CommunityCommentController *commentVc = [[CommunityCommentController alloc] init];
    commentVc.communityCellFrame = self.communityFrame;
    [self.navigationController pushViewController:commentVc animated:YES];
}

- (void)clickUnLoveBtn:(UIButton *)btn {
    if (![AccountTool account]) {
        [MBProgressHUD showInfo:@"请先登录" toView:ESWindow];
        return;
    }
    if (self.loveBtn.selected) {
        return;
    }
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self requsetTread];
        [self.treadPersons addObject:self.myPerson];
    } else {
        [self requsetCancelTread];
        for (CommunityPerson *person in self.treadPersons) {
            if ([person.user_name compare:[AccountTool account].user_name options:NSCaseInsensitiveSearch | NSNumericSearch] == 0) {
                [self.treadPersons removeObject:person];
                break;
            }
        }
    }
    [self.treadBtn setTitle:[NSString stringWithFormat:@"踩 %ld", (long)self.treadPersons.count] forState:UIControlStateNormal];
    [self.tableView reloadData];
    // 点赞的返回
    if (self.unLoveBtnBlock) {
        self.unLoveBtnBlock(btn);
    }
}

- (void)requsetTread {
    CommunityParam *param = [CommunityParam param];
    param.oid = self.communityFrame.communityItem.ID;
    param.category = @"2";
    param.operate = @"4";
    WeakSelf;
    // 发送请求
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCommunityLoveAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 0) {
            selfWeak.communityFrame.communityItem.treaded_id = responseObject[@"ID"];
            selfWeak.communityFrame.communityItem.is_treaded = @"1";
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requsetCancelTread {
    CommunityParam *param = [CommunityParam param];
    param.ID = self.communityFrame.communityItem.treaded_id;
    param.category = @"2";
    param.operate = @"4";
    WeakSelf;
    // 发送请求
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCommunityCancelLoveAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 0) {
            selfWeak.communityFrame.communityItem.is_treaded = @"0";
        }
    } failure:^(NSError *error) {
    }];
}

- (void)clickLoveBtn:(UIButton *)btn {
    if (![AccountTool account]) {
        [MBProgressHUD showInfo:@"请先登录" toView:ESWindow];
        return;
    }
    if (self.unLoveBtn.selected) {
        return;
    }
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self requsetLove];
        [self.lovePersons addObject:self.myPerson];
    } else {
        [self requsetCancelLove];
        for (CommunityPerson *person in self.lovePersons) {
            if ([person.user_name compare:[AccountTool account].user_name options:NSCaseInsensitiveSearch | NSNumericSearch] == 0) {
                [self.lovePersons removeObject:person];
                break;
            }
        }
    }
    [self.likeBtn setTitle:[NSString stringWithFormat:@"赞 %ld", (long)self.lovePersons.count] forState:UIControlStateNormal];
    [self.tableView reloadData];
    // 点赞的返回
    if (self.loveBtnBlock) {
        self.loveBtnBlock(btn);
    }
}

- (void)requsetLove {
    CommunityParam *param = [CommunityParam param];
    param.oid = self.communityFrame.communityItem.ID;
    param.category = @"2";
    param.operate = @"3";
    WeakSelf;
    // 发送请求
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCommunityLoveAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 0) {
            selfWeak.communityFrame.communityItem.is_loved = @"1";
            selfWeak.communityFrame.communityItem.loved_id = responseObject[@"ID"];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requsetCancelLove {
    CommunityParam *param = [CommunityParam param];
    param.ID = self.communityFrame.communityItem.loved_id;
    param.category = @"2";
    param.operate = @"3";
    WeakSelf;
    // 发送请求
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCommunityCancelLoveAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 0) {
            selfWeak.communityFrame.communityItem.is_loved = @"0";
        }
    } failure:^(NSError *error) {
    }];
}

/**
 *  模型数组转cellFrame模型数组
 */
- (NSArray *)communitysToCellFrames:(NSArray *)array {
    NSMutableArray *arrayM = [NSMutableArray array];
    for (CommunityListItem *item in array) {
        CommunityCellFrame *cellFrame = [[CommunityCellFrame alloc] init];
        cellFrame.comment = YES;
        cellFrame.communityItem = item;
        [arrayM addObject:cellFrame];
    }
    return arrayM;
    
}

- (NSString *)title {
    return @"详情";
}

@end
