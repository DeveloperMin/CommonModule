//
//  CircleViewController.m
//  txzjPatient
//
//  Created by hj on 2017/4/14.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "CircleViewController.h"
#import "TXBYCircleSlideHeadView.h"
#import "CircleListViewController.h"
#import "TXBYCircleModel.h"

@interface CircleViewController ()

/**
 *  titleItems
 */
@property (nonatomic, strong) NSArray *titleItems;

@property (nonatomic, assign) BOOL show;
@end

@implementation CircleViewController

- (NSArray *)titleItems {
    if (!_titleItems) {
        _titleItems = [TXBYTitleItem mj_objectArrayWithFilename:@"Circle.bundle/circleTitleItem.plist"];
    }
    return _titleItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建子控制器
    [self setUpSubVc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    for (TXBYTitleItem *item in self.titleItems) {
        CircleListViewController *listVC = [[CircleListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        listVC.isDoctorUser = self.isDoctorUser;
        listVC.title = item.title;
        listVC.range = item.range;
        [vcs addObject:listVC];
    }
    slideVC.titleColor = TXBYMainColor;
    slideVC.titleDefaultColor = [UIColor colorWithHexString:@"#333333"];
    slideVC.backViewColor = TXBYMainColor;
    slideVC.headBackViewColor = [UIColor whiteColor];
    
    // 调用setSlideHeadView
    [slideVC setSlideHeadViewWithArr:vcs andLoadMode:loadBeforeClick];
}


@end
