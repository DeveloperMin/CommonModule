//
//  SymptomViewController.m
//  smh
//
//  Created by yh on 15/3/21.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//

#import "SymptomViewController.h"
#import "IllViewController.h"
#import "Symptom.h"
#import "TriageTool.h"
#import "TriageParam.h"
#import "TriageResult.h"

@interface SymptomViewController ()

/**
 *  Symptom模型数组
 */
@property (nonatomic, strong) NSArray *symptoms;

@end

@implementation SymptomViewController

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 网络请求
    [self request];
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
 *  网络请求
 */
- (void)request {
    // 发送请求
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    __weak typeof(self)weakSelf = self;
    [TriageTool symptomsWithParam:self.param netIdentifier:TXBYClassName success:^(TriageResult *result) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (!result.symptoms.count) {
            return;
        }
        // 设置item数据
        weakSelf.symptoms = result.symptoms;
        NSMutableArray *arrayM = [NSMutableArray array];
        for (Symptom *symptom in weakSelf.symptoms) {
            TXBYListItem *item = [TXBYListItem itemWithTitle:symptom.symptom_name];
            item.titleFont = [UIFont systemFontOfSize:17];
            item.subtitleFont = [UIFont systemFontOfSize:15];
            [arrayM addObject:item];
        }
        weakSelf.items = arrayM;
    } failure:^(NSError *error) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:weakSelf.view];
        // 网络加载失败
        [weakSelf requestFailure:error];
    }];
}

/**
 *  点击了某一行
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    // 跳转到疾病控制器
    IllViewController *vc = [[IllViewController alloc] init];
    TriageParam *param = [TriageParam param];
    Symptom *symptom = self.symptoms[indexPath.row];
    param.symptom_id = [NSString stringWithFormat:@"%ld",(long)symptom.symptom_id];
    vc.param = param;
    [self.navigationController pushViewController:vc animated:YES];
}

@end