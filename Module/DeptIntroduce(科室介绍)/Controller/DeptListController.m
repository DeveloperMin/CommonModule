//
//  DeptViewController.m
//  taicang
//
//  Created by txby on 16/1/6.
//  Copyright © 2016年 eeesys. All rights reserved.
//

#import "DeptListController.h"
#import "DeptParam.h"
#import "DeptList.h"
#import "GeneralDept.h"
#import "DeptDetailController.h"

@interface DeptListController ()

@property (nonatomic, strong) NSArray *depts;

@end

@implementation DeptListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionMargin = TXBYSettingSectionMarginBig;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //请求数据
    [self requestForDeptsList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  请求科室列表数据
 */
- (void)requestForDeptsList {
    //参数
    DeptParam *param = [DeptParam param];
    param.hospital = self.branch;
    if ([self.level intValue] == 0) {
        param.level = self.level;
    }
    else {
        param.level = @"1";
    }
    [MBProgressHUD showMessage:@"加载中..." toView:[UIApplication sharedApplication].keyWindow];
    WeakSelf;
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYDeptIntroduceListAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id json) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (![json[@"errcode"] isEqual:@0]) {
            // 提示信息
            [selfWeak emptyViewWithText:@"暂无相关科室"];
        }
        else {
            // 创建模型数组
            if ([selfWeak.level intValue] == 0) {
                selfWeak.depts = [DeptList mj_objectArrayWithKeyValuesArray:json[@"depts"]];
            }
            else {
                selfWeak.depts = [GeneralDept mj_objectArrayWithKeyValuesArray:json[@"depts"]];
            }
            // 刷新页面
            [selfWeak setupGroups];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        // 网络加载失败
        [selfWeak requestFailure:error];
    }];
}

- (void)setupGroups {
    // 没有按大科室分类
    if ([self.level intValue] == 0) {
        TXBYSettingGroup *group = [TXBYSettingGroup group];
        // 取出科室
        for (DeptList *dept in self.depts) {
            TXBYSettingLabelItem *item = [TXBYSettingLabelItem itemWithTitle:dept.dept_name];
            [group addItem:item];
        }
        [self.groups addObject:group];
    }
    // 按大科室分类
    else {
         // 取出大科室
        for (GeneralDept *generalDept in self.depts) {
            TXBYSettingGroup *group = [TXBYSettingGroup group];
            group.header = generalDept.dept_name;
            // 取出大科室中的详细科室
            for (DeptList *dept in generalDept.depts) {
                TXBYSettingLabelItem *item = [TXBYSettingLabelItem itemWithTitle:dept.dept_name];
                [group addItem:item];
            }
            [self.groups addObject:group];
        }
    }
    [self.tableView reloadData];
}

#pragma mark -- tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *deptId;
    if ([self.level intValue] == 0) {
        DeptList *dept = self.depts[indexPath.row];
        deptId = dept.ID;
    }
    else {
        GeneralDept *generalDept = self.depts[indexPath.section];
        DeptList *dept = generalDept.depts[indexPath.row];
        deptId = dept.ID;
    }
    DeptDetailController *detailVC = [[DeptDetailController alloc] init];
    detailVC.ID = deptId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
