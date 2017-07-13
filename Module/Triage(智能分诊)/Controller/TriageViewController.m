//
//  TriageViewController.m
//  smh
//
//  Created by yh on 15/3/20.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//

#import "TriageViewController.h"
#import "SymptomViewController.h"
#import "TriageView.h"
#import "TriageParam.h"

@interface TriageViewController () <TriageViewDelegate>

@end

@implementation TriageViewController

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加TriageView
    [self setupTriageView];
    
    [self addTipsLabel];
    
}

#pragma mark - private
/**
 *  添加TriageView
 */
- (void)setupTriageView {
    TriageView *triageView = [[[NSBundle mainBundle] loadNibNamed:@"TriageViewXib" owner:nil options:nil] lastObject];
    triageView.frame = self.view.bounds;
    triageView.delegate = self;
    [self.view addSubview:triageView];
}
/**
 *  添加提示
 */
- (void)addTipsLabel {
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.frame = CGRectMake(0, 0, TXBYApplicationW, 25);
    tipLabel.text = @"注: 导诊结果仅供参考";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.backgroundColor = TXBYColor(253, 251, 156);
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.font = [UIFont systemFontOfSize:16.0];
    [self.view addSubview:tipLabel];
}

#pragma mark - TriageViewDelegate
/**
 *  点击了某个部位
 */
- (void)triageView:(TriageView *)view didClickWithBodyPart:(NSString *)partName param:(TriageParam *)param {
    NSDictionary *partDict = @{@"头" : @"头部", @"胸" : @"胸部", @"腹" : @"腹部", @"颈" : @"颈部", @"腰" : @"腰部", @"臀" : @"臀部", @"脑" : @"颅脑"};
    if (partDict[partName]) {
        partName = partDict[partName];
    }
    // 跳转到症状控制器
    SymptomViewController *vc = [[SymptomViewController alloc] init];
    vc.title = [NSString stringWithFormat:@"%@症状",partName];
    param.part = partName;
    vc.param = param;
    [self.navigationController pushViewController:vc animated:YES];
}
@end