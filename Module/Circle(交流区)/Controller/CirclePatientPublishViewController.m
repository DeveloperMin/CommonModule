//
//  CirclePublishViewController.m
//  txzjPatient
//
//  Created by Limmy on 2017/4/26.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "CirclePatientPublishViewController.h"
#import "TXBYCircleModel.h"
#import "TXBYCircleReply.h"
#import "TXBYCircleParam.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "CircleTipsView.h"
#import "ChangeInfoParam.h"
#import "AccountTool.h"

@interface CirclePatientPublishViewController ()<UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, CirclePublishPhotoViewDelegate, TZImagePickerControllerDelegate, CircleTipsViewDelegate>

@end

@implementation CirclePatientPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![AccountTool account].nick_name.length) {
        [self setUpTipsView];
    }
}

- (void)setUpTipsView {
    CircleTipsView *tipsView = [CircleTipsView new];
    tipsView.delegate = self;
    self.tipsView = tipsView;
    tipsView.frame = CGRectMake(0, 0, TXBYApplicationW, TXBYApplicationH);
    [TXBYWindow.rootViewController.view addSubview:tipsView];
}

#pragma mark - CircleTipsViewDelegate
- (void)clickCircleTipsViewWithBtn:(UIButton *)btn nickName:(NSString *)nickName {
    nickName = [nickName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (btn.tag == 0) {
        [self.tipsView removeFromSuperview];
        [self popVc];
    } else {
        if (!nickName.length) {
            [MBProgressHUD showInfo:@"请您输入有效昵称" toView:self.tipsView];
            return;
        } else if(nickName.length < 1 || nickName.length > 10) {
            [MBProgressHUD showInfo:@"昵称长度为1-10位" toView:self.tipsView];
            return;
        } else {
            [self.tipsView removeFromSuperview];
            [self accountUnExpired:^{
                [self modifyNickName:nickName];
            }];
        }
    }
}

- (void)modifyNickName:(NSString *)nickName {
    ChangeInfoParam *param = [ChangeInfoParam param];
    param.nick_name = nickName;
    WeakSelf;
    [MBProgressHUD showMessage:@"正在修改..." toView:selfWeak.view];
    [[TXBYHTTPSessionManager sharedManager]encryptPost:TXBYUserNicknameModAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:selfWeak.view animated:YES];
        if ([responseObject[@"errcode"] intValue] ==[TXBYSuccessCode intValue]) {
            [MBProgressHUD hideHUDForView:selfWeak.view animated:YES];
            [MBProgressHUD showSuccess:@"修改成功" toView:selfWeak.view completion:^(BOOL finished) {
                
                Account *tempaccount = [AccountTool account];
                if (param.nick_name) {
                    tempaccount.nick_name = param.nick_name;
                }
                [AccountTool saveAccountExceptTime:tempaccount];
            }];
        } else {
            [MBProgressHUD showInfo:responseObject[@"errmsg"] toView:selfWeak.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:selfWeak.view animated:YES];
        [selfWeak requestFailure:error];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * setUpHeaderView
 */
- (void)setUpHeaderView {
    UIView *headerView = [UIView new];
    self.headerView = headerView;
    headerView.backgroundColor = [UIColor whiteColor];
    
    UITextView *content = [UITextView new];
    self.content = content;
    content.delegate = self;
    content.returnKeyType = UIReturnKeyDone;
    content.font = [UIFont systemFontOfSize:16];
    content.textColor = [UIColor darkGrayColor];
    [headerView addSubview:content];
    content.frame = CGRectMake(8, 0, TXBYApplicationW - 16, 150);
    
    UILabel *placehold = [UILabel new];
    self.placehold = placehold;
    [headerView addSubview:placehold];
    placehold.textColor = TXBYColor(199, 199, 199);
    placehold.font = [UIFont systemFontOfSize:16];
    if (self.circlePublishStyle == CirclePublishStyleCircle) {
        placehold.text = @"请输入提问的具体内容";
    } else {
        placehold.text = [NSString stringWithFormat:@"回复%@:", self.circleReply?self.circleReply.user_name:self.circleModel.user_name];
    }
    placehold.frame = CGRectMake(12, 7, 200, 21);
    
    [headerView addSubview:self.photoBtn];
    self.photoBtn.frame = CGRectMake(TXBYApplicationW - 38, CGRectGetMaxY(content.frame), 30, 30);
    
    // line
    UILabel *line = [UILabel new];
    line.backgroundColor = TXBYGlobalBgColor;
    [headerView addSubview:line];
    line.frame = CGRectMake(0, CGRectGetMaxY(self.photoBtn.frame) + 5, TXBYApplicationW, 1);
    
    self.photosView = [CirclePublishPhotoView new];
    [headerView addSubview:self.photosView];
    self.photosView.delegate = self;
    self.photosView.frame = CGRectMake(0, CGRectGetMaxY(line.frame), TXBYApplicationW, 0);
    headerView.frame = CGRectMake(0, 0, TXBYApplicationW, CGRectGetMaxY(line.frame));
    self.photosView.circlePublishStyle = self.circlePublishStyle;
    self.photosView.hidden = YES;
    self.tableView.tableHeaderView = headerView;
}

- (void)popVc {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
