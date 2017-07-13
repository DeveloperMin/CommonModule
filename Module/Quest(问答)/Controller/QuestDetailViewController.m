//
//  QuestDetailViewController.m
//  smh
//
//  Created by eeesysdev3 on 15/3/31.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//

// 回复栏高
CGFloat const TXBYReplyBarH = 42;

#import "QuestDetailViewController.h"
#import "QuestTool.h"
#import "ReplyBar.h"
#import "BaseQuestCell.h"
#import "AccountTool.h"
#import "Quest.h"
#import "QuestParam.h"
#import "QuestResult.h"

@interface QuestDetailViewController () <UITableViewDataSource, UITableViewDelegate, ReplyBarDelegate>

/**
 *  表视图
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 *  回复栏
 */
@property (nonatomic, strong) ReplyBar *replyBar;

/**
 *  quest模型数组
 */
@property (nonatomic, strong) NSMutableArray *quests;

/**
 *  回复内容
 */
@property (nonatomic, copy) NSString *content;

@end

@implementation QuestDetailViewController

#pragma mark - getter
- (NSMutableArray *)quests {
    if (!_quests) {
        _quests = [NSMutableArray arrayWithObject:self.quest];
    }
    return _quests;
}

#pragma mark - lifecyle
/**
 *  view加载完成
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isPush) {
        // 导航栏添加ButtonItem
        [self setupNav];
    }
    
    // 添加表视图
    [self setupTableView];
    
    // 添加回复栏
    [self setupReplyBar];
    
    // 网络请求
    [self request];
    
    // 监听通知中心
    [self setupNotification];
    
    // 添加触摸手势
    [self setupTapGesture];
}

/**
 *  销毁
 */
- (void)dealloc {
    // 取消网络请求
    [[TXBYHTTPSessionManager sharedManager] cancelNetworkingWithNetIdentifier:TXBYClassName];
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - getter


#pragma mark - private
/**
 *  导航栏添加ButtonItem
 */
- (void)setupNav {
    // 返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

/**
 *  返回按钮点击
 */
- (void)back {
    // 关闭当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  观察键盘frame的变化
 */
- (void)keyboardDidChangeFrame:(NSNotification *)notification {
    //改变window的背景颜色
    self.view.window.backgroundColor = self.tableView.backgroundColor;
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 调整工具条位置
        CGFloat viewH = TXBYApplicationH - TXBYNavH;
        if (keyboardF.origin.y > viewH) {
            self.replyBar.txby_y = viewH - self.replyBar.txby_height;
        } else {
            CGFloat statusBarH = 20;
            self.replyBar.txby_y = keyboardF.origin.y - self.replyBar.txby_height - TXBYNavH - statusBarH;
        }
    }];
}

/**
 *  添加表视图
 */
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TXBYApplicationW, TXBYApplicationH - TXBYNavH - TXBYReplyBarH) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableView.dataSource = self;
    tableView.delegate = self;
}

/**
 *  添加回复栏
 */
- (void)setupReplyBar {
    ReplyBar *replyBar = [ReplyBar replyBar];
    self.replyBar = replyBar;
    [self.view addSubview:replyBar];
    replyBar.frame = CGRectMake(0, self.tableView.txby_height, TXBYApplicationW, TXBYReplyBarH);
    replyBar.delegate = self;
}

/**
 *  网络请求
 */
- (void)request {
    // 请求参数
    QuestParam *param = [QuestParam param];
    param.quest_id = self.quest.ID;
    WeakSelf;
    // 发送请求
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [QuestTool questDetailWithParam:param netIdentifier:TXBYClassName success:^(QuestResult *result){
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:selfWeak.view];
        // 设置数据
        [selfWeak.quests addObjectsFromArray:result.quests];
        // 刷新页面
        [selfWeak.tableView reloadData];
        
    } failure:^(NSError *error) {
         // 隐藏加载提示
         [MBProgressHUD hideHUDForView:selfWeak.view];
         // 网络加载失败
         [selfWeak requestFailure:error];
     }];
}

/**
 *  监听通知中心
 */
- (void)setupNotification {
    // 观察键盘frame变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

/**
 *  添加触摸手势
 */
- (void)setupTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.tableView addGestureRecognizer:tap];
}

#pragma mark - UITableViewDataSource
/**
 *  多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.quests.count;
}

/**
 *  内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    static NSString *CellIdentifier = @"BaseQuestCell";
    BaseQuestCell *cell = [BaseQuestCell cellWithTableView:tableView classString:CellIdentifier];
    [cell setBgAtIndexPath:indexPath countInSection:self.quests.count];
    
    // 取出对应模型
    cell.quest = self.quests[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
/**
 *  行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.quests[indexPath.row] cellHeight];
}

/**
 *  开始滚动
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - ReplyDelegate
/**
 *  点击按钮
 */
- (void)replyBar:(ReplyBar *)replyBar textField:(UITextField *)field {
    if (![AccountTool account]) { // 没有账号
        [self accountExist:nil];
    } else { // 有账号
        // 记住输入内容
        self.content = field.text.trim;
        
        // 输入校验
        if (self.content.length < 3 ) {
            [MBProgressHUD showInfo:@"内容太短了" toView:self.view];
            return;
        }
        
        // 清除文字
        field.text = nil;
        
        [MBProgressHUD showMessage:@"回复中" toView:self.view];
        // 检查令牌是否过期
        [self accountUnExpired:^{
            // 回复请求
            [self reply];
        }];
    }
}

/**
 *  回复请求
 */
- (void)reply {
    // 请求参数
    QuestParam *param = [QuestParam param];
    param.quest_id = self.quest.ID;
    param.content = self.content;
    WeakSelf;
    [QuestTool questReplyWithParam:param netIdentifier:TXBYClassName success:^(QuestResult *result) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:selfWeak.view];
        
        
        if ([result.errcode intValue] == 20002) {
            [selfWeak refreshToken:^{
                [selfWeak reply];
            }];
        }
        else if ([result.errcode isEqualToString:TXBYSuccessCode]) { // 提问成功
            // 清空quests数组
            selfWeak.quests = nil;
            // 设置数据
            [selfWeak.quests addObjectsFromArray:result.quests];
            // 刷新
            [selfWeak.tableView reloadData];
            // 表格滑动到最后一栏
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:result.quests.count inSection:0];
            [selfWeak.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        } else { // 提问失败
            [MBProgressHUD showInfo:result.errmsg toView:selfWeak.view];
        }
    } failure:^(NSError *error) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:selfWeak.view];
        [selfWeak requestFailure:error];
    }];
}

#pragma mark - super
/**
 *  标题文字
 */
- (NSString *)title {
    return @"问题正文";
}

@end