//
//  ServiceSearchTableViewController.m
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//
//tableview头部高度
#define ServiceTableViewH 80
// tabbar高度
#define TabbarH 49
#import "ServiceSearchTableViewController.h"

@interface ServiceSearchTableViewController ()

/**
 *  服务名称输入框
 */
@property (nonatomic)UITextField *textFeild;
/**
 *  服务类型标签
 */
@property (nonatomic)UILabel *labelServiceType;

@end

@implementation ServiceSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.title = @"服务价格";
    //表格背景色
    self.tableView.backgroundColor =TXBYColor(230, 230, 230);
    //设置表格内容布局
    [self setTableViewContent];
}
/**
 *  设置表格内容布局
 */
- (void)setTableViewContent {
    // 清除父类UIEdgeInsets
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 禁止滚动
    self.tableView.scrollEnabled = NO;
    // 头部空白
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, TXBYApplicationW, ServiceTableViewH)];
    //头部背景色
    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    // 尾部按钮
    CGFloat distance = 25;
    //尾部视图
    UIView *footer = [[UIView alloc] init];
    //尾部结构
    footer.frame = CGRectMake(0, 0, TXBYApplicationW, distance + TabbarH);
    //footer背景色
    footer.backgroundColor = [UIColor clearColor];
    //按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, distance, TXBYApplicationW, TabbarH-10)];
    //按钮标题
    [button setTitle:@"查询" forState:UIControlStateNormal];
    //标题颜色
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //按钮背景色
    [button setBackgroundColor:[UIColor whiteColor]];
    //按钮事件
    [button addTarget:self action:@selector(queryService) forControlEvents:UIControlEventTouchUpInside];
    //添加按钮到视图
    [footer addSubview:button];
    self.tableView.tableFooterView = footer;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}
/**
 *  cell
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *serviceID = @"srviceID";
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:serviceID];
        cell.textLabel.text = @"服务名称";
        //追加输入框
        _textFeild = [[UITextField alloc] initWithFrame:CGRectMake(TXBYApplicationW/3, 0, TXBYApplicationW/2, TabbarH)];
        [_textFeild setPlaceholder:@"医疗服务名称"];
        [cell.contentView addSubview:_textFeild];
    }
    else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:serviceID];
        cell.textLabel.text = @"服务类型";
        //追加标签
        _labelServiceType = [[UILabel alloc] initWithFrame:CGRectMake(TXBYApplicationW/3, 0, TXBYApplicationW/2, TabbarH)];
        [_labelServiceType setText:@"一般检查治疗"];
        [cell.contentView addSubview:_labelServiceType];
        //右侧指示图标
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    //禁止点击变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
/**
 *  cell高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TabbarH;
}
/**
 *  cell点击
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        NSLog(@"选择服务类型");
    }
}
/**
 *  查询服务价格
 */
- (void)queryService {
    NSString *name = _textFeild.text;
    NSString *type = _labelServiceType.text;
    NSLog(@"服务名称：%@",name);
    NSLog(@"服务类型：%@",type);
}
@end
