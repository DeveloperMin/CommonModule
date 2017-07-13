//
//  CommunityMainController.m
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/24.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "CommunityMainController.h"
#import "CommunityParam.h"
#import "CommunityGroup.h"
#import "TXBYSlideHeadView.h"
#import "CommunityListController.h"
#import "CommunitySearchController.h"
#import "CommunityPublishController.h"

@interface CommunityMainController ()

@property (nonatomic, strong) NSArray *groups;

@end

@implementation CommunityMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isRequestGroup) {
        // 网络请求
        [self requestGroup];
    } else {
        CommunityGroup *group = [[CommunityGroup alloc] init];
        group.name = self.title;
        self.groups = @[group];
        [self setUpScrollView];
    }
    // Nav
    [self setupNavItem];
}

/**
 *  导航栏添加提问按钮
 */
- (void)setupNavItem {
    NSMutableArray *temp = [NSMutableArray array];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"community.bundle/add@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    [temp addObject:addItem];
    if (self.isSearch) {
        UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"community.bundle/search@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
        [temp addObject:searchItem];
    }
    
    self.navigationItem.rightBarButtonItems = temp;
}

- (void)search  {
    CommunitySearchController *searchVc = [[CommunitySearchController alloc] init];
    searchVc.groups = self.groups;
    [self.navigationController pushViewController:searchVc animated:YES];
}

/**
 *  提问按钮点击
 */
- (void)add {
    // 账号是否存在
    [self accountExist:^{
        CommunityPublishController *publishVc = [[CommunityPublishController alloc] init];
        publishVc.groups = self.groups;
        [self.navigationController pushViewController:publishVc animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestGroup {
    // 请求参数
    CommunityParam *param = [CommunityParam param];
    param.type = @"1";
    [MBProgressHUD showMessage:@"请稍候..." toView:self.view];
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCommunityGroupAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"errcode"] integerValue] == 0) {
            self.groups = [CommunityGroup mj_objectArrayWithKeyValuesArray:responseObject[@"categorys"]];
            if (self.groups.count) {
                [self setUpScrollView];
            }
        } else {
            TXBYAlert(responseObject[@"errmsg"]);
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [self requestFailure:error];
    }];
}

- (void)setUpScrollView{
    //初始化SlideHeadView，并加进view
    TXBYSlideHeadView *slideVC = [[TXBYSlideHeadView alloc] init];
    slideVC.titleColor = ESMainColor;
    slideVC.titleDefaultColor = [UIColor grayColor];
    slideVC.backViewColor = ESMainColor;
    [self.view addSubview:slideVC];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSInteger i = 0; i < self.groups.count; i++) {
        CommunityListController *listVc = [[CommunityListController alloc] init];
        CommunityGroup *group = self.groups[i];
        listVc.title = group.name;
        listVc.isTread = self.isTread;
        listVc.group = group;
        [temp addObject:listVc];
    }
    [slideVC setSlideHeadViewWithArr:temp andLoadMode:loadAfterClick];
}

@end
