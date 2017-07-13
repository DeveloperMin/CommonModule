//
//  ExpertQuestController.m
//  ydyl
//
//  Created by Limmy on 2016/9/22.
//  Copyright © 2016年 txby. All rights reserved.
//

#import "ExpertQuestController.h"
#import "TXBYSlideHeadView.h"
#import "ReadQuestViewController.h"
#import "UnReadQuestController.h"

@interface ExpertQuestController ()

@end

@implementation ExpertQuestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpScrollView{
    // 移除之前的数据
    [self.view removeAllSubviews];
    //初始化SlideHeadView，并加进view
    TXBYSlideHeadView *slideVC = [[TXBYSlideHeadView alloc] init];
    slideVC.titleColor = ESMainColor;
    slideVC.titleDefaultColor = [UIColor grayColor];
    slideVC.backViewColor = ESMainColor;
    [self.view addSubview:slideVC];
    NSMutableArray *temp = [NSMutableArray array];
    
    UnReadQuestController *unreadVc = [[UnReadQuestController alloc] init];
    unreadVc.title = @"待解答";
    [temp addObject:unreadVc];
    
    ReadQuestViewController *readVc = [[ReadQuestViewController alloc] init];
    readVc.title = @"已解答";
    [temp addObject:readVc];
    [slideVC setSlideHeadViewWithArr:temp andLoadMode:loadAfterClick];
}

- (NSString *)title {
    return @"我的解答";
}

@end
