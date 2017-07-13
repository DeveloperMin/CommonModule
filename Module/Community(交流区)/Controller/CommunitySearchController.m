//
//  CommunitySearchController.m
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/26.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "CommunitySearchController.h"
#import "TXBYSlideHeadView.h"
#import "CommunityGroup.h"
#import "CommunityListController.h"
#import "HistoryQuestCell.h"
#import "CommunityGroup.h"

@interface CommunitySearchController ()<UISearchBarDelegate, UITableViewDelegate , UITableViewDataSource>

@property (nonatomic, weak) UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *historyArr;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSString *path;

@property (nonatomic, weak) UIButton *btn;
/**
 *  slideVC
 */
@property (nonatomic, strong) TXBYSlideHeadView *slideVC;

@end

@implementation CommunitySearchController

- (NSMutableArray *)historyArr {
    if (!_historyArr) {
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:self.path];
        _historyArr = [NSMutableArray arrayWithArray:arr];
    }
    return _historyArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.path = [ESCachePath stringByAppendingPathComponent:@"HistoryQuest.text"];
    if (self.groups.count > 1) {
        CommunityGroup *group = [[CommunityGroup alloc] init];
        group.ID = @"";
        group.name = @"综合";
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.groups];
        [tempArr insertObject:group atIndex:0];
        self.groups = tempArr;
    }
    
    [self setUpTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpTableView {
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.frame = CGRectMake(0, 0, TXBYApplicationW, TXBYApplicationH - 44);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    // 添加清除所有按钮
    UIView *footerView = [UIView new];
    footerView.frame = CGRectMake(0, 0, TXBYApplicationW, 50);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn = btn;
    btn.frame = CGRectMake(0, 0, 100, 30);
    btn.center = footerView.center;
    [btn setTitle:@"清除所有" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:ESMainColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(deleteAllData) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    self.tableView.tableFooterView = footerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.historyArr.count) {
        self.btn.hidden = NO;
    } else {
        self.btn.hidden = YES;
    }
    [self setSearch];
}

- (void)deleteAllData {
    [self.historyArr removeAllObjects];
    [NSKeyedArchiver archiveRootObject:self.historyArr toFile:self.path];
    [self.tableView reloadData];
    self.tableView.tableFooterView = [UIView new];
}

- (void)setSearch{
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    self.searchBar = searchBar;
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入关键字";
    searchBar.tintColor = ESMainColor;
    searchBar.frame = CGRectMake(0, 0, TXBYApplicationW * 0.8, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    if (searchBar.text.length) {
        BOOL isExist = NO;
        for (NSString *str in self.historyArr) {
            if ([str isEqualToString:searchBar.text]) {
                isExist = YES;
                break;
            }
        }
        if (!isExist) {
            [self.historyArr addObject:searchBar.text];
        }
        [self.tableView reloadData];
        
        [NSKeyedArchiver archiveRootObject:self.historyArr toFile:self.path];
        [self showSearchWithContent:searchBar.text];
    }
}

- (void)showSearchWithContent:(NSString *)content {
    [self.view removeAllSubviews];
    [self setUpScrollViewWithContent:content];
}

- (void)setUpScrollViewWithContent:(NSString *)content{
    //初始化SlideHeadView，并加进view
    TXBYSlideHeadView *slideVC = [[TXBYSlideHeadView alloc] init];
//    self.slideVC = slideVC;
    slideVC.titleColor = ESMainColor;
    slideVC.titleDefaultColor = [UIColor grayColor];
    slideVC.backViewColor = ESMainColor;
    [self.view addSubview:slideVC];
    NSMutableArray *temp = [NSMutableArray array];
    for (CommunityGroup *group in self.groups) {
        CommunityListController *listVc = [[CommunityListController alloc] init];
        listVc.title = group.name;
        listVc.group = group;
        listVc.content = content;
        listVc.isSearch = YES;
        [temp addObject:listVc];
    }
    [slideVC setSlideHeadViewWithArr:temp andLoadMode:loadAfterClick];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *resueID = @"cell";
    HistoryQuestCell *cell = [tableView dequeueReusableCellWithIdentifier:resueID];
    if (!cell) {
        cell = [[HistoryQuestCell alloc] init];
    }
    cell.deleteBtn.tag = indexPath.row;
    cell.title.text = self.historyArr[indexPath.row];
    [cell.deleteBtn addTarget:self action:@selector(deleteSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)deleteSelectBtn:(UIButton *)btn {
    [self.historyArr removeObjectAtIndex:btn.tag];
    [self.tableView reloadData];
    [NSKeyedArchiver archiveRootObject:self.historyArr toFile:self.path];
    if (!self.historyArr.count) {
        self.tableView.tableFooterView = [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showSearchWithContent:self.historyArr[indexPath.row]];
}


@end
