//
//  MyQuestViewController.m
//  smh
//
//  Created by yh on 15/4/6.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//

#import "MyQuestViewController.h"
#import "QuestTool.h"
#import "QuestParam.h"
#import "QuestResult.h"

@interface MyQuestViewController ()

@end

@implementation MyQuestViewController

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 检查账号是否过期
    [self checkAccount];
}

/**
 *  销毁
 */
- (void)dealloc {
    // 取消网络请求
    [[TXBYHTTPSessionManager sharedManager] cancelNetworkingWithNetIdentifier:TXBYClassName];
}

#pragma mark - private
/**
 *  检查账号是否过期
 */
- (void)checkAccount {
    // 加载提示
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
    // 是否过期
    [self accountUnExpired:^{
        [self request];
    }];
}

/**
 *  网络请求
 */
- (void)request {
    // 请求参数
    QuestParam *param = [QuestParam param];
    WeakSelf;
    // 发送请求
    [QuestTool myQuestsWithParam:param netIdentifier:TXBYClassName success:^(QuestResult *result) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:selfWeak.view];
        
        if ([result.errcode intValue] == 20002) {
            [selfWeak refreshToken:^{
                [selfWeak request];
            }];
        }
        else {
            selfWeak.quests = [NSMutableArray arrayWithArray:result.quests];
            
            if (result.quests.count) {
                // 刷新表格
                [selfWeak.tableView reloadData];
            } else {
                [selfWeak emptyViewWithText:@"你还没有提问过"];
            }
        }        
    } failure:^(NSError *error) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:selfWeak.view];
        // 网络加载失败
        [selfWeak requestFailure:error];
    }];
}

@end