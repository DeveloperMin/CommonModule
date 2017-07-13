//
//  DrugViewController.m
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//

#import "DrugViewController.h"
#import "WesternDrugViewController.h"
#import "ChineseDrugViewController.h"
#import "DrugListViewController.h"
#import "DrugMenuItem.h"
#import "DrugList.h"

@interface DrugViewController () < BaseDrugMenuViewControllerDelegate, UISearchBarDelegate>
/**
 *  内容占位视图
 */
@property (nonatomic, weak) UIView *contentView;

/**
 *  西药
 */
@property (nonatomic, strong) WesternDrugViewController *westren;

/**
 *  中成药
 */
@property (nonatomic, strong) ChineseDrugViewController *chinese;

/**
 *  搜索框
 */
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak)  UIView *toolView;
/**
 *  指示条
 */
@property (nonatomic, weak) UIView *indicationView;

@end

@implementation DrugViewController

#pragma mark - getters
/**
 *  占位视图
 */
- (UIView *)contentView
{
    if (!_contentView)
    {
        // 1. 创建占位视图
        UIView *contentView = [[UIView alloc] init];
        _contentView = contentView;
        // 2. 设置frame
        CGFloat contentViewY = 80;
        contentView.frame = CGRectMake(0, contentViewY, self.view.txby_width, TXBYApplicationH - 44 - contentViewY);
        // 3. 背景颜色
        contentView.backgroundColor = [UIColor whiteColor];
        // 4. 添加到view中
        [self.view addSubview:contentView];
    }
    return _contentView;
}

/**
 *  西药控制器
 */
- (WesternDrugViewController *)westren
{
    if (!_westren)
    {
        _westren = [[WesternDrugViewController alloc] init];
        _westren.view.frame = self.contentView.bounds;
        _westren.delegate = self;
    }
    return _westren;
}

/**
 *  中药控制器
 */
- (ChineseDrugViewController *)chinese
{
    if (!_chinese)
    {
        _chinese = [[ChineseDrugViewController alloc] init];
        _chinese.view.frame = self.contentView.bounds;
        _chinese.delegate = self;
    }
    return _chinese;
}

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1. 添加搜索框
    [self setupSearchBar];
    
    // 2. 添加工具条
    [self setupToolView];
    
    // 3. 默认选中西药
    [self clickToolViewBtn:nil];
}

#pragma mark - private
/**
 *  添加搜索框
 */
- (void)setupSearchBar
{
    // 1. 创建搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    self.searchBar = searchBar;
    searchBar.backgroundImage = [UIImage imageWithColor:TXBYColor(242, 242, 242)];
    searchBar.returnKeyType = UIReturnKeySearch;
    CGFloat searchBarX = 0;
    CGFloat searchBarY = 0;
    CGFloat searchBarW = self.view.txby_width - 2 * searchBarX;
    CGFloat searchBarH = 40;
    // 2. 设置frame
    searchBar.frame = CGRectMake(searchBarX, searchBarY, searchBarW, searchBarH);
    // 3. 设置提示文字
    searchBar.placeholder = @"请输入药品名称";
    // 3. 添加到view中
    [self.view addSubview:searchBar];
    // 4. 设置代理
    searchBar.delegate = self;
}

/**
 *  添加工具条
 */
- (void)setupToolView
{
    // 1. 创建工具条
    UIView *toolView = [[UIView alloc] init];
    toolView.backgroundColor = [UIColor whiteColor];
    // 2. 添加到view中
    [self.view addSubview:toolView];
    // 3. 设置frame
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@40);
    }];
    // 4. 根据按钮标题创建按钮
    
    // 西药
    UIButton *westerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    westerBtn.tag = 0;
    [toolView addSubview:westerBtn];
    [westerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    westerBtn.backgroundColor = [UIColor whiteColor];
    [westerBtn setTitle:@"西药" forState:UIControlStateNormal];
    [westerBtn addTarget:self action:@selector(clickToolViewBtn:) forControlEvents:UIControlEventTouchUpInside];
    //中药
    UIButton *chineseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chineseBtn.tag = 1;
    [chineseBtn setTitle:@"中成药" forState:UIControlStateNormal];
    [chineseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    chineseBtn.backgroundColor = [UIColor whiteColor];
    [toolView addSubview:chineseBtn];
    [chineseBtn addTarget:self action:@selector(clickToolViewBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [westerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toolView.mas_top);
        make.left.equalTo(toolView.mas_left);
        make.right.equalTo(chineseBtn.mas_left).offset(-1);
        make.bottom.equalTo(toolView.mas_bottom).offset(-3);
    }];
    
    [chineseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toolView.mas_top);
        make.left.equalTo(westerBtn.mas_right).offset(1);
        make.right.equalTo(toolView.mas_right);
        make.width.equalTo(westerBtn.width);
        make.height.equalTo(westerBtn.height);
    }];
    
    UIView *separatorLineView = [[UIView alloc] init];
    separatorLineView.backgroundColor = TXBYColor(242, 242, 242);
    [toolView addSubview:separatorLineView];
    [separatorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(toolView.mas_bottom).offset(0);
        make.top.equalTo(toolView.mas_top).offset(0);
        make.left.equalTo(westerBtn.mas_right);
        make.width.equalTo(@1);
    }];
    // 指示条
    UIView *indicationView = [[UIView alloc] init];
    self.indicationView = indicationView;
    indicationView.backgroundColor = TXBYColor(58, 178, 255);
    [toolView addSubview:indicationView];
    [indicationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(toolView.mas_bottom).offset(-1);
        make.centerX.equalTo(westerBtn.mas_centerX);
        make.width.equalTo(toolView.width).multipliedBy(0.2);
        make.height.equalTo(@2);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TXBYColor(221, 221, 221);
    [toolView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(toolView.mas_bottom).offset(0);
        make.left.equalTo(toolView.mas_left);
        make.width.equalTo(toolView.width);
        make.height.equalTo(@1);
    }];
    
}

- (void)clickToolViewBtn:(UIButton *)btn {
    [UIView animateWithDuration:0.3 animations:^{
        self.indicationView.txby_centerX = btn.txby_centerX;
    }];
    
    // 1. 退出键盘
    [self.view endEditing:YES];
    
    // 2. 移除所有子视图
    for (UIView *views in self.contentView.subviews)
    {
        [views removeFromSuperview];
    }
    
    // 3. 根据工具条索引添加对应的view
    if (btn.tag == 0) // 西药
    {
        [self.contentView addSubview:self.westren.view];
    } else if (btn.tag == 1) // 中成药
    {
        [self.contentView addSubview:self.chinese.view];
    }
   
}

#pragma mark - BaseDrugMenuViewControllerDelegate
/**
 *  UITableView滚动
 */
- (void)drugMenuViewControllerDidScroll:(BaseDrugMenuViewController *)vc
{
    [self.view endEditing:YES];
}

/**
 *  点击了某个条目
 */
- (void)drugMenuViewController:(BaseDrugMenuViewController *)vc didClickWithItem:(DrugList *)item
{
    // 跳转到药价公示列表控制器
    DrugListViewController *drugVc = [[DrugListViewController alloc] init];
    drugVc.item = item;
    [self.navigationController pushViewController:drugVc animated:YES];
}

#pragma mark - UISearchBarDelegate
/**
 *  点击键盘上的搜索时调用
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchText = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (searchText.length) {
        // 创建DrugMenuItem模型
        DrugList *item = [[DrugList alloc] init];
        item.name = searchBar.text;
        item.mtid = @"-1";
        item.mtids = @"";
        
        // 跳转到列表控制器
        [self drugMenuViewController:nil didClickWithItem:item];
    }
}

@end
