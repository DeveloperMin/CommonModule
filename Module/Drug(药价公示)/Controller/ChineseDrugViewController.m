//
//  ChineseDrugViewController.m
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//

#import "ChineseDrugViewController.h"
#import "DrugMenuItem.h"

@interface ChineseDrugViewController ()

@end

@implementation ChineseDrugViewController

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置中成药目录数组
    self.items = [DrugMenuItem mj_objectArrayWithFilename:@"drug.bundle/chineseMedical.plist"];
}

@end