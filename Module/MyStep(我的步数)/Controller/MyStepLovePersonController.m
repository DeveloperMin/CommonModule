//
//  MyStepLovePersonController.m
//  publicCommon
//
//  Created by Limmy on 2017/2/15.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "MyStepLovePersonController.h"
#import "StepParam.h"
#import "StepLoveCell.h"
#import "MyLovePersonModel.h"

@interface MyStepLovePersonController ()

/**
 *  items
 */
@property (nonatomic, strong) NSArray *items;

@end

@implementation MyStepLovePersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 请求数据
    [self requestList];
    // 初始化view
    [self initalView];
}

- (void)initalView {
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"StepLoveCell" bundle:nil] forCellReuseIdentifier:@"StepLoveCell"];
}

/**
 *  网络请求
 */
- (void)requestList {
    // 请求参数
    StepParam *param = [StepParam param];
    param.ID = self.ID;
    WeakSelf;
    // 发送请求
    [MBProgressHUD showMessage:@"加载中..." toView:selfWeak.view];
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYStepLovePersonAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:selfWeak.view];
        if ([responseObject[@"errcode"] integerValue] == 0) {
            self.items = [MyLovePersonModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (!self.items.count) {
                [self setUpNodataView];
            } else {
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:selfWeak.view];
        // 网络加载失败
        [selfWeak requestFailure:error];
    }];
}

- (void)setUpNodataView {
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"myStep.bundle/stepNoData"];
    [self.tableView addSubview:imageView];
    imageView.frame = CGRectMake(0, 50, 100, 100);
    imageView.txby_centerX = self.tableView.txby_centerX;
    
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 15, 100, 22);
    label.text = @"还没有朋友点赞";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor lightGrayColor];
    label.txby_centerX = self.tableView.txby_centerX;
    [self.tableView addSubview:label];
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
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StepLoveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StepLoveCell" forIndexPath:indexPath];
    cell.model = self.items[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)title {
    return @"赞我的朋友";
}

@end
