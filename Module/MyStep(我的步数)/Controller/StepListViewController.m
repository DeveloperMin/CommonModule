//
//  StepListViewController.m
//  publicCommon
//
//  Created by Limmy on 2017/2/14.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "StepListViewController.h"
#import "StepParam.h"
#import <HealthKit/HealthKit.h>
#import "AccountTool.h"
#import "StepListModel.h"
#import "StepListViewCell.h"
#import "MyStepListCell.h"
#import "MyStepViewController.h"
#import "MyStepLovePersonController.h"


#define HeadViewHeight TXBYApplicationH * 0.42

@interface StepListViewController ()<UITableViewDelegate, UITableViewDataSource, StepViewUpdateDelegate>

/**
 *  健康
 */
@property (nonatomic, strong) HKHealthStore * healthStore;
/**
 *  时间区间
 */
@property (nonatomic, strong) NSPredicate *timePredicate;
/**
 *  scrollView
 */
@property (nonatomic, weak) UIScrollView *scrollView;
/**
 *  imageView
 */
@property (nonatomic, weak) UIImageView *imageView;
/**
 *  封面label
 */
@property (nonatomic, weak) UILabel *champLabel;
/**
 *  封面label
 */
@property (nonatomic, weak) UIImageView *champImage;
/**
 *  lastOffSetY
 */
@property (nonatomic, assign) CGFloat lastOffSetY;
/**
 *  头部背景图
 */
@property (nonatomic, strong) UIImageView *headBackImgView;
/**
 *  当前view
 */
@property (nonatomic, strong) UIView *headerView;
// myStep
@property (nonatomic, strong) StepListModel *myStepModel;
// 封面model
@property (nonatomic, strong) StepListModel *champStepModel;
/**
 *  所有数据
 */
@property (nonatomic, strong) NSMutableArray *allStepArray;
/**
 *  listItems
 */
@property (nonatomic, strong) NSArray *listItems;
/**
 *  current_page
 */
@property (nonatomic, copy) NSString *current_page;
/**
 *  page_count
 */
@property (nonatomic, copy) NSString *page_count;

/**
 *  tableView
 */
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation StepListViewController

- (NSMutableArray *)allStepArray {
    if (!_allStepArray) {
        _allStepArray = [NSMutableArray array];
    }
    return _allStepArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 初始化view
    [self initalView];
    [self readStep];
}

- (void)initalView {
    UIView *view = [UIView new];
    [self.view addSubview:view];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TXBYApplicationW, TXBYApplicationH - 44) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"StepListViewCell" bundle:nil] forCellReuseIdentifier:@"StepListViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyStepListCell" bundle:nil] forCellReuseIdentifier:@"MyStepListCell"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(HeadViewHeight, 0, 0, 0);
    // 创建头部视图
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor clearColor];
    [self.tableView addSubview:self.headerView];
    self.headerView.frame = CGRectMake(0, -HeadViewHeight, TXBYApplicationW, HeadViewHeight);
    
    // 创建头部视图的背景图
    self.headBackImgView = [[UIImageView alloc] init];
    self.headBackImgView.image = [UIImage imageNamed:@"myStep.bundle/stepbg"];
    self.headBackImgView.contentMode = UIViewContentModeScaleToFill;
    self.headBackImgView.clipsToBounds = YES;
    [self.headerView addSubview:self.headBackImgView];
    [self.headBackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left);
        make.right.equalTo(self.headerView.mas_right);
        make.top.equalTo(self.headerView.mas_top);
        make.bottom.equalTo(self.headerView.mas_bottom);
    }];
    
    UILabel *champLabel = [UILabel new];
    self.champLabel = champLabel;
    [self.headerView addSubview:champLabel];
    champLabel.textColor = [UIColor whiteColor];
    [champLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headBackImgView.mas_top).offset(10);
//        make.width.equalTo(TXBYApplicationW * 0.45);
        make.centerX.equalTo(self.headerView.mas_centerX).offset(18);
        make.height.equalTo(25);
    }];
    champLabel.text = @"今日封面";
    champLabel.hidden = YES;
    champLabel.font = [UIFont systemFontOfSize:16];
    champLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *champImage = [UIImageView new];
    self.champImage = champImage;
    [self.headerView addSubview:champImage];
    champImage.layer.masksToBounds = YES;
    champImage.layer.cornerRadius = 18;
    [champImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(champLabel.mas_centerY);
        make.right.equalTo(champLabel.mas_left).offset(-8);
        make.width.equalTo(@36);
        make.height.equalTo(@36);
    }];
}

- (void)readStep {
    [MBProgressHUD showMessage:@"请稍候..." toView:self.view];
    //查看healthKit在设备上是否可用，ipad不支持HealthKit
    if(![HKHealthStore isHealthDataAvailable])
    {
        NSLog(@"设备不支持healthKit");
    }
    
    //创建healthStore实例对象
    self.healthStore = [[HKHealthStore alloc] init];
    
    //设置需要获取的权限这里仅设置了步数
    HKObjectType *stepCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    NSSet *healthSet = [NSSet setWithObjects:stepCount, nil];
    
    //从健康应用中获取权限
    [self.healthStore requestAuthorizationToShareTypes:nil readTypes:healthSet completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"获取步数权限成功");
            //获取步数后我们调用获取步数的方法
//            [self readStepCount];
            [self readAllStepCount];
        } else {
            [MBProgressHUD hideHUDForView:self.view];
            NSLog(@"获取步数权限失败");
        }
    }];
}

////查询数据
//- (void)readStepCount
//{
//    //查询采样信息
//    HKSampleType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
//    
//    //NSSortDescriptors用来告诉healthStore怎么样将结果排序。
//    NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
//    NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
//    
//    /*查询的基类是HKQuery，这是一个抽象类，能够实现每一种查询目标，这里我们需要查询的步数是一个
//     HKSample类所以对应的查询类就是HKSampleQuery。
//     下面的limit参数传1表示查询最近一条数据,查询多条数据只要设置limit的参数值就可以了
//     */
//    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:self.timePredicate limit:HKObjectQueryNoLimit sortDescriptors:@[start,end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
//        NSInteger currentStep = 0;
////        results = [self getRealHealthData:results];
//        for (HKQuantitySample *result in results) {
//            NSString *stepStr = [NSString stringWithFormat:@"%@", result.quantity];
//            NSRange range = [stepStr rangeOfString:@"count"];
//            NSInteger nowCount = [stepStr substringToIndex:range.location].integerValue;
//            currentStep += nowCount;
//        }
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            //查询是在多线程中进行的，如果要对UI进行刷新，要回到主线程中
//            self.myStep = currentStep;
////            self.todayStep.text = [NSString stringWithFormat:@"%ld步", (long)currentStep];
//        }];
//    }];
//    //执行查询
//    [self.healthStore executeQuery:sampleQuery];
//}

// 获取所有数据
- (void)readAllStepCount {
    
    //查询采样信息
    HKSampleType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSDate *now = [NSDate date];
    NSDate *startDate = [[NSDate date] dateByAddingTimeInterval:-31*24*3600];
    NSPredicate *allPredicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:now options:HKQueryOptionNone];
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:allPredicate limit:HKObjectQueryNoLimit sortDescriptors:nil resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        results = [self getRealHealthData:results];
        for (HKQuantitySample *result in results) {
            NSString *time = [NSDate stringFromDate:result.startDate format:@"yyyy-MM-dd"];
            NSString *stepStr = [NSString stringWithFormat:@"%@", result.quantity];
            NSRange range = [stepStr rangeOfString:@"count"];
            NSString *count = [stepStr substringToIndex:range.location - 1];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:time forKey:@"date"];
            [dict setObject:count forKey:@"step"];
            if ([self checkStepTimeWithTime:time]) {
                for (NSMutableDictionary *dic in self.allStepArray) {
                    if ([dic[@"date"] isEqualToString:time]) {
                        NSInteger sum = [dic[@"step"] integerValue] + count.integerValue;
                        [dic setObject:[NSString stringWithFormat:@"%ld", (long)sum] forKey:@"step"];
                        [dic setObject:time forKey:@"date"];
                    }
                }
            } else {
                [self.allStepArray addObject:dict];
            }
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            if (self.allStepArray.count) {
                [self saveAllMyStep];
//            }
        }];
    }];
    //执行查询
    [self.healthStore executeQuery:sampleQuery];
}

// 检查是否已经存入该日期数据
- (BOOL)checkStepTimeWithTime:(NSString *)time {
    for (NSDictionary *dict in self.allStepArray) {
        if ([dict[@"date"] isEqualToString:time]) {
            return YES;
            break;
        }
    }
    return NO;
}

// 剔除人为添加的数据
- (NSArray *)getRealHealthData:(NSArray *)resultArr
{
    NSMutableArray *returnArr = [[NSMutableArray alloc]init];
    for (HKQuantitySample *model in resultArr) {
        NSDictionary *dict = (NSDictionary *)model.metadata;
        NSInteger wasUserEntered = [dict[@"HKWasUserEntered"]integerValue];
        if(wasUserEntered != 1) {
            [returnArr addObject:model];
        }
    }
    return returnArr;
}

/**
 *  网络请求
 */
- (void)saveAllMyStep {
    [self accountUnExpired:^{
        // 请求参数
        StepParam *param = [StepParam param];
        if (self.allStepArray.count) {
            param.steps = self.allStepArray.mj_JSONString.encrypt;
        } else {
            NSString *date = [NSDate stringFromDate:[NSDate date] format:@"yyyy-MM-dd"];
            param.steps = @[@{@"date":date,@"step":@"0"}].mj_JSONString.encrypt;
        }
     
        param.token = [AccountTool account].token;
        // 发送请求
        //    [MBProgressHUD showMessage:@"加载中..." toView:selfWeak.view];
        WeakSelf;
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYSaveStepAPI parameters:param.mj_keyValues netIdentifier:@"SaveStep" success:^(id responseObject) {
            // 请求排名列表
            [selfWeak requestList];
        } failure:^(NSError *error) {
            // 请求排名列表
            [selfWeak requestList];
        }];
    }];
}

/**
 *  网络请求
 */
- (void)requestList {
    [self accountUnExpired:^{
        // 请求参数
        StepParam *param = [StepParam param];
        param.date = [NSDate stringFromDate:[NSDate date] format:@"yyyy-MM-dd"];
        WeakSelf;
        // 发送请求
//        [MBProgressHUD showMessage:@"请稍候..." toView:selfWeak.view];
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYStepListAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
            NSLog(@"%@", responseObject);
            // 隐藏加载提示
            [MBProgressHUD hideHUDForView:selfWeak.view];
            if ([responseObject[@"errcode"] integerValue] == 0) {
                selfWeak.listItems = [StepListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"rank"]];
                selfWeak.myStepModel = [StepListModel mj_objectWithKeyValues:responseObject[@"data"][@"self"]];
                selfWeak.champStepModel = [StepListModel mj_objectWithKeyValues:responseObject[@"data"][@"champion"]];
                selfWeak.current_page = responseObject[@"data"][@"current_page"];
                selfWeak.page_count = responseObject[@"data"][@"page_count"];
                if (selfWeak.current_page.integerValue < selfWeak.page_count.integerValue) {
                    selfWeak.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:selfWeak refreshingAction:@selector(requestMoreList)];
                }
                if (!selfWeak.myStepModel.name.length) {
                    selfWeak.myStepModel.uid = [AccountTool account].uid;
                    selfWeak.myStepModel.avatar = [AccountTool account].avatar;
                    selfWeak.myStepModel.order = [NSString stringWithFormat:@"%ld", (long)self.listItems.count + 1];
                }
                // 设置封面
                [selfWeak updateChampion];
                [selfWeak.tableView reloadData];
            }
            
        } failure:^(NSError *error) {
            // 隐藏加载提示
            [MBProgressHUD hideHUDForView:selfWeak.view];
            // 网络加载失败
            [selfWeak requestFailure:error];
        }];
    }];
}

/**
 *  网络请求
 */
- (void)requestMoreList {
    [self accountUnExpired:^{
        // 请求参数
        StepParam *param = [StepParam param];
        param.date = [NSDate stringFromDate:[NSDate date] format:@"yyyy-MM-dd"];
        if (self.current_page.integerValue < self.page_count.integerValue) {
            param.page = [NSString stringWithFormat:@"%ld", (long)self.current_page.integerValue + 1];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        WeakSelf;
        // 发送请求
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYStepListAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
            [self.tableView.mj_footer endRefreshing];
            if ([responseObject[@"errcode"] integerValue] == 0) {
                selfWeak.current_page = responseObject[@"data"][@"current_page"];
                selfWeak.page_count = responseObject[@"data"][@"page_count"];
                NSArray *array = [StepListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"rank"]];
                NSMutableArray *temp = [NSMutableArray arrayWithArray:self.listItems];
                [temp addObjectsFromArray:array];
                selfWeak.listItems = temp;
                [selfWeak.tableView reloadData];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } failure:^(NSError *error) {
            // 隐藏加载提示
            [self.tableView.mj_footer endRefreshing];
            // 网络加载失败
            [selfWeak requestFailure:error];
        }];
    }];
}

- (void)updateChampion {
    [self.champImage sd_setImageWithURL:[NSURL URLWithString:self.champStepModel.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.champLabel.hidden = NO;
    self.champLabel.text = [NSString stringWithFormat:@"今日封面: %@", self.champStepModel.name.length?self.champStepModel.name:[AccountTool account].user_name];
    [self.headBackImgView sd_setImageWithURL:[NSURL URLWithString:self.champStepModel.background] placeholderImage:[UIImage imageNamed:@"myStep.bundle/stepbg"]];
}

- (void)setUpHeaderView {
    UIView *bgView = [UIView new];
    bgView.frame = CGRectMake(0, 10, TXBYApplicationW, TXBYApplicationH * 0.26);
    bgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bgView];
    
    UIView *headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, TXBYApplicationW, TXBYApplicationH * 0.26);
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.listItems.count) {
        return 0;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.listItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        MyStepListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyStepListCell" forIndexPath:indexPath];
        cell.myRank.text = self.myStepModel.order;
        [cell.button addTarget:self action:@selector(clickMyStepCell) forControlEvents:UIControlEventTouchUpInside];
        cell.love.text = self.myStepModel.love.length?self.myStepModel.love:@"0";
        cell.model = self.myStepModel;
        return cell;
    } else {
        StepListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StepListViewCell" forIndexPath:indexPath];
        cell.button.tag = indexPath.row;
        StepListModel *model = self.listItems[indexPath.row];
        cell.love.text = model.love;
        cell.button.selected = model.is_loved.integerValue == 1?YES:NO;
        cell.loveImage.image = model.is_loved.integerValue == 1?[UIImage imageNamed:@"myStep.bundle/start_selected"]:[UIImage imageNamed:@"myStep.bundle/start"];
        [cell.button addTarget:self action:@selector(clickLoveBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.model = model;
        return cell;
    }
}

- (void)clickMyStepCell {
    MyStepLovePersonController *vc = [MyStepLovePersonController new];
    vc.ID = self.myStepModel.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickLoveBtn:(UIButton *)btn {
    StepListModel *model = self.listItems[btn.tag];
    if (model.uid.integerValue == [AccountTool account].uid.integerValue) {
        [self clickMyStepCell];
    } else {
        btn.selected = !btn.selected;
        NSIndexPath *path = [NSIndexPath indexPathForRow:btn.tag inSection:1];
        StepListViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        if (btn.selected) {
            cell.loveImage.image = [UIImage imageNamed:@"myStep.bundle/start_selected"];
            model.love = [NSString stringWithFormat:@"%ld",(long)model.love.integerValue + 1];
            [self requetLove:model];
        } else {
            cell.loveImage.image = [UIImage imageNamed:@"myStep.bundle/start"];
            model.love = [NSString stringWithFormat:@"%ld",(long)model.love.integerValue - 1];
            [self cancelRequetLove:model];
        }
        [UIView animateWithDuration:0.3 animations:^{
            cell.loveImage.transform = CGAffineTransformScale(cell.loveImage.transform, 1.2, 1.2);
        } completion:^(BOOL finished) {
            cell.loveImage.transform = CGAffineTransformIdentity;
        }];
        cell.love.text = model.love;
    }
}

- (void)requetLove:(StepListModel *)model {
    // 请求参数
    StepParam *param = [StepParam param];
    param.oid = model.ID;
    param.category = @"5";
    param.operate = @"3";
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYStepLoveAPI parameters:param.mj_keyValues netIdentifier:@"loveStep" success:^(id responseObject) {
        model.loved_id =  [NSString stringWithFormat:@"%@",responseObject[@"data"][@"ID"]];
    } failure:^(NSError *error) {
    }];
}

- (void)cancelRequetLove:(StepListModel *)model {
    // 请求参数
    StepParam *param = [StepParam param];
    param.ID = model.loved_id;
    param.category = @"5";
    param.operate = @"5";
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYStepCancelLoveAPI parameters:param.mj_keyValues netIdentifier:@"cancelLoveStep" success:^(id responseObject) {
    } failure:^(NSError *error) {
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyStepViewController *myVc = [MyStepViewController new];
    myVc.delegate = self;
    if (indexPath.section == 0) {
        myVc.myModel = self.myStepModel;
    } else {
        myVc.myModel = self.listItems[indexPath.row];
    }
    [self.navigationController pushViewController:myVc animated:YES];
}
#pragma mark - StepViewDelegate
- (void)updateStepViewData {
    if (self.champStepModel.uid.integerValue == [AccountTool account].uid.integerValue) {
        [self requestList];
    }
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float offsetY = scrollView.contentOffset.y + HeadViewHeight;
//    float alpha = [self currentAlpha];
    
    // 1.根据偏移量设置当前元素的颜色
//    UIColor *currentColor = [UIColor colorWithRed:TXBYMainColor.red green:TXBYMainColor.green blue:TXBYMainColor.blue alpha:0.8];
//    self.navigationView.backgroundColor = currentColor;
    // 设置标题的位移
//    [self setCurrentTitle];
    [self.champLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headBackImgView.top).offset(offsetY + 10);
    }];
    self.champLabel.alpha = (HeadViewHeight - offsetY - 10)/(HeadViewHeight);
    self.champImage.alpha = self.champLabel.alpha;
    
    // 2.设置图片的拉伸效果
    // 向上的阻力系数（值越大，阻力越大，向上的力越大）
    CGFloat upFactor = 0.6;
    
    if (offsetY > 0) {
        // 将图片恢复原状
        self.headBackImgView.transform = CGAffineTransformIdentity;
        return;
    }
    
    // 到什么位置开始放大
    CGFloat upMin = 0;
    
    // 还没到顶部位置，就向上挪动
    if (offsetY >= upMin) {
        self.headBackImgView.transform = CGAffineTransformMakeTranslation(0, offsetY * upFactor);
    }
    else {
        // 中点位置
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, offsetY - upMin * (upFactor));
        // 图片在x轴的放大比例
        CGFloat scaleX = 1 + (upMin - offsetY) * 0.005;
        // 图片在y轴的放大比例
        CGFloat scaleY = -(offsetY * 2 - HeadViewHeight) / (HeadViewHeight);
        self.headBackImgView.transform = CGAffineTransformScale(transform, scaleX, scaleY);
    }
    
}

@end
