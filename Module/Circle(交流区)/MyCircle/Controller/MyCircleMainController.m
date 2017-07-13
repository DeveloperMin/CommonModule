//
//  MyCircleMainController.m
//  txzjPatient
//
//  Created by Limmy on 2017/4/28.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "MyCircleMainController.h"
#import "MyCircleCollectController.h"
#import "MyCirclePublishController.h"
#import "MyCircleCommentController.h"
#import "TXBYCircleSlideHeadView.h"

@interface MyCircleMainController ()

@end

@implementation MyCircleMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self accountUnExpired:^{
        [self setUpSubVc];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpSubVc {
    //初始化TXBYSlideHeadView，并加进view
    TXBYCircleSlideHeadView *slideVC = [[TXBYCircleSlideHeadView alloc] init];
    [self.view addSubview:slideVC];
    // 调用setSlideHeadView
    NSMutableArray *vcs = [NSMutableArray array];
    
    MyCirclePublishController *publishVc = [[MyCirclePublishController alloc] init];
    publishVc.title = @"我的发布";
    [vcs addObject:publishVc];
    
    MyCircleCommentController *commentVc = [[MyCircleCommentController alloc] init];
    commentVc.title = @"我的评论";
    [vcs addObject:commentVc];
    
    MyCircleCollectController *collectVc = [[MyCircleCollectController alloc] init];
    collectVc.title = @"我的收藏";
    [vcs addObject:collectVc];
    
    slideVC.titleColor = TXBYMainColor;
    slideVC.titleDefaultColor = [UIColor lightGrayColor];
    slideVC.backViewColor = TXBYMainColor;
    slideVC.headBackViewColor = [UIColor whiteColor];
    
    // 调用setSlideHeadView
    [slideVC setSlideHeadViewWithArr:vcs andLoadMode:loadBeforeClick];
}

@end
