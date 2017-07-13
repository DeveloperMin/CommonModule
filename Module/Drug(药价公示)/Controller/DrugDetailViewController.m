//
//  DrugDetailViewController.m
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//

#import "DrugDetailViewController.h"
#import "Drug.h"

@interface DrugDetailViewController ()

@end

@implementation DrugDetailViewController

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 组织数据
    [self setupGroups];
}

#pragma mark - private
/**
 *  组织数据
 */
- (void)setupGroups
{
    // 加载plist文件
    NSArray *array = [NSArray arrayWithContentsOfFile:[NSString pathForResource:@"drug.bundle/drugDetail"]];
    // 数据
    NSMutableArray *arrayM = [NSMutableArray array];
    NSDictionary *drugDict = self.drug.mj_keyValues;
    for (NSDictionary *dict in array)
    {
        NSString *title = dict[@"title"];
        NSString *subtitle = drugDict[dict[@"subtitle"]];
        subtitle = [subtitle isEqualToString:@"null"] ? @"" : subtitle;

        TXBYInputItem *item = [TXBYInputLabelItem itemWithTitle:title subtitle:subtitle];
        item.titleFont = [UIFont systemFontOfSize:15.0];
        item.subtitleFont = [UIFont systemFontOfSize:15.0];
        [arrayM addObject:item];
    }
    
    // 创建组
    TXBYInputGroup *group = [TXBYInputGroup group];
    group.items = arrayM;
    [self.groups addObject:group];
}

#pragma mark - super
/**
 *  导航栏标题
 */
- (NSString *)title
{
    return self.drug.cpm;
}

@end
