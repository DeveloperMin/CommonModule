//
//  WesternDrugViewController.m
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//

#import "WesternDrugViewController.h"
#import "DrugMenuItem.h"

@interface WesternDrugViewController ()

@end

@implementation WesternDrugViewController

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置西药目录数组
    self.items = [DrugMenuItem mj_objectArrayWithFilename:@"drug.bundle/westernMedical.plist"];
}

@end