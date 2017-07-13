//
//  BaseDrugMenuViewController.m
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//

// section中header高度
CGFloat const ESDrugMenuH = 50;

#import "BaseDrugMenuViewController.h"
#import "DrugMenu.h"
#import "DrugMenuItem.h"
#import "DrugItemCell.h"

@interface BaseDrugMenuViewController () <DrugItemCellDelegate>

/**
 *  section头部字典
 */
@property (nonatomic, strong) NSMutableDictionary *drugMenu;

@end

@implementation BaseDrugMenuViewController

#pragma mark - getters
/**
 *  section头部字典
 */
- (NSMutableDictionary *)drugMenu
{
    if (!_drugMenu)
    {
        _drugMenu = [NSMutableDictionary dictionary];
    }
    return _drugMenu;
}

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1. 设置表格属性
    [self setupTableView];
}

#pragma mark - private
/**
 *  设置表格属性
 */
- (void)setupTableView
{
    // 1. 设置sectionHeaderHeight
    self.tableView.sectionHeaderHeight = ESDrugMenuH;
    
    // 2. 表格footer
    self.tableView.tableFooterView = [[UIView alloc] init];
}

/**
 *  调用当前tableview滚动代理
 */
- (void)performDelegate
{
    // 调用代理方法
    if ([self.delegate respondsToSelector:@selector(drugMenuViewControllerDidScroll:)])
    {
        [self.delegate drugMenuViewControllerDidScroll:self];
    }
}

/**
 *  section头部控件点击事件
 */
- (void)expandGroup:(DrugMenu *)header event:(UIEvent *)event
{
    // 1. 调用代理方法（这里需要通知让上一级中搜索框隐藏，利用滚动代理执行）
    [self performDelegate];
    
    // 2. 遍历所有头部控件
    [self.drugMenu enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        DrugMenu *btn = obj;
        btn.open = (header == btn) && (!header.open);
    }];
    
    // 3. 刷新表格
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
/**
 *  有多少组
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count;
}

/**
 *  多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 1. 取section对应的view
    DrugMenu *header = self.drugMenu[@(section)];
    // 2. 视图下子目录
    DrugMenuItem *item = self.items[section];
    // 3. 行数
    return header.open ? (item.items.count + ESDrugItemCount - 1) / ESDrugItemCount : 0;
}

/**
 *  cell内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    static NSString *CellIdentifier = @"DrugItemCell";
    DrugItemCell *cell = [DrugItemCell cellWithTableView:tableView classString:CellIdentifier];
    
    // 2. 对应的数据模型
    DrugMenuItem *item = self.items[indexPath.section];
    
    // 3. 根据每行显示个数截取子目录
    // 3.1 截取的开始位置
    NSInteger location = indexPath.row * ESDrugItemCount;
    // 3.2 截取的长度
    NSInteger length = ESDrugItemCount;
    // 3.3 如果截取的范围越界
    if (location + length >= item.items.count)
    {
        length = item.items.count - location;
    }
    
    // 3.4 截取范围
    NSRange range = NSMakeRange(location, length);
    
    // 3.5 根据截取范围，获取这行所需的模型
    NSArray *rowArray = [item.items subarrayWithRange:range];
    
    // 4. 设置这个行Cell所需的数据
    cell.drugMenuItems = rowArray;
    
    // 5. 设置代理
    cell.delegate = self;
    
    return cell;
}

/**
 *  每一行高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ESDrugItemCellH;
}

/**
 *  Section中头部视图
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1 字典中取header
    DrugMenu *header = self.drugMenu[@(section)];
    if (!header)
    {
        // 2 创建
        header = [DrugMenu buttonWithType:UIButtonTypeCustom];
        
        // 3 设置属性
        // 3.1 背景图片
        [header setBgInSection:section count:self.items.count];
        // 3.2 位置
        header.frame = CGRectMake(0, 0, self.view.txby_width, ESDrugMenuH);
        // 3.3 文字
        DrugMenuItem *model = self.items[section];
        [header setTitle:model.name forState:UIControlStateNormal];
        // 3.4 点击事件
        [header addTarget:self action:@selector(expandGroup:event:) forControlEvents:UIControlEventTouchUpInside];
        // 4 加入字典
        [self.drugMenu setObject:header forKey:@(section)];
    }
    return header;
}

#pragma mark - UIScrollViewDelegate
/**
 *  scrollView滚动
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 调用当前tableview滚动代理
    [self performDelegate];
    
    // 去除section头部浮动
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = ESDrugMenuH;
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if (scrollView.contentOffset.y >= sectionHeaderHeight)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

#pragma mark - DrugItemCellDelegate
/**
 *  点击了cell中的目录
 */
- (void)drugItemCell:(DrugItemCell *)cell didClickButtonWithDrugMenuItem:(DrugList *)item
{
    // 调用代理方法
    if ([self.delegate respondsToSelector:@selector(drugMenuViewController:didClickWithItem:)])
    {
        [self.delegate drugMenuViewController:self didClickWithItem:item];
    }
}

@end