//
//  ServicePriceListViewController.m
//  deptPatientCommon
//
//  Created by hj on 17/3/2.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "ServicePriceListViewController.h"
#import "ServicePriceItem.h"
#import "ServicePriceDetailController.h"

@interface ServicePriceListViewController ()

@end

@implementation ServicePriceListViewController

#pragma mark - setters
/**
 *  设置ServiceItem模型数组
 */
- (void)setServiceItems:(NSArray *)serviceItems {
    _serviceItems = serviceItems;
    
    // 转成ESListItem模型数组
    NSMutableArray *arrayM = [NSMutableArray array];
    for (ServicePriceItem *item in self.serviceItems) {
        TXBYListItem *listItem = [TXBYListItem itemWithTitle:item.name subtitle:item.price];
        listItem.titleColor = [UIColor blackColor];
        listItem.subtitleColor = [UIColor darkGrayColor];
        [arrayM addObject:listItem];
    }
    self.items = arrayM;
}

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - super
/**
 *  导航栏标题
 */
- (NSString *)title {
    return @"查询结果";
}

/**
 *  点击某一行
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    ServicePriceDetailController *vc = [[ServicePriceDetailController alloc] init];
    vc.item = self.serviceItems[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
