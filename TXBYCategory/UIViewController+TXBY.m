//
//  UIViewController+TXBY.m
//  TXBYCategory
//
//  Created by mac on 16/5/9.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "UIViewController+TXBY.h"
#import "TXBYKit.h"
#import "Account.h"
#import "AccountTool.h"
#import "LoginTool.h"
#import "LoginParam.h"
#import "LoginResult.h"
#import "LoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CLLocationManager.h>

@implementation UIViewController (TXBY)

#pragma mark - 网络失败
/**
 *  加载网络失败
 *
 *  @param error 错误信息
 */
- (void)requestFailure:(NSError *)error {
    NSInteger code = error.code;
    // “取消网络请求”和“网络请求正在进行”不显示错误
    if (code == -999 || code == -12001) {
        TXBYLog(@"%@",error);
        return;
    }
    NSString *msg = @"网络有问题，请稍后再试";
    if(code == -1009) {
        msg = @"似乎已断开与互联网的连接";
    }
    
    TXBYAlert(msg);
}

#pragma mark - 添加提示view
/**
 *  没有数据的提示view
 */
- (void)emptyViewWithText:(NSString *)text {
    UILabel *label = [UILabel label];
    label.tag = 9999;
    label.frame = self.view.bounds;
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.text = text;
    label.numberOfLines = 0;
    [self.view addSubview:label];
}

/**
 *  没有数据的提示view, image大小根据image自身大小
 */
- (void)emptyViewWithImage:(UIImage *)image WithText:(NSString *)text {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    if (image) {
        imgView.tag = 9999;
        [self.view addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view.centerY).offset(-50);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }

    UILabel *label = [UILabel label];
    label.tag = 9999;
    label.numberOfLines = 0;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        if (image) {
            make.top.equalTo(imgView.mas_bottom).offset(10);
        } else {
            make.centerY.equalTo(self.view.mas_centerY);
        }
        make.width.equalTo(self.view.mas_width).offset(-20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.text = text;
}

/**
 *  没有数据的提示view
 */
- (void)emptyViewWithText:(NSString *)text andImg:(UIImage *)image {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.tag = 9999;
    imgView.frame = CGRectMake(TXBYApplicationW / 2 - TXBYApplicationW * 0.2 / 2, TXBYApplicationH / 2 - TXBYApplicationW * 0.2 / 2 - 70, TXBYApplicationW * 0.2, TXBYApplicationW * 0.2);
    //imgView.center = self.view.center;
    //imgView.txby_centerY -= 50;
    [self.view addSubview:imgView];
    
    UILabel *label = [UILabel label];
    label.tag = 9999;
    label.frame = self.view.bounds;
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.txby_y = CGRectGetMaxY(imgView.frame);
    label.txby_height = 30;
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.text = text;
    [self.view addSubview:label];
}
/**
 *  删除没有数据的提示
 */
- (void)deleteEmptyText {
    for (UIView *view in self.view.subviews) {
        if (view.tag == 9999) {
            [view removeFromSuperview];
        }
    }
}

/**
 *  添加提示声明等
 */
- (void)addTipsText:(NSString *)text {
    
    UIView *tipsView = [[UIView alloc] init];
    tipsView.frame = CGRectMake(0, 0, TXBYApplicationW, 50);
    tipsView.backgroundColor = [UIColor colorWithRed:253.0 / 255 green:210.0 / 255 blue:95.0 / 255 alpha:1];
    [self.view addSubview:tipsView];
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.frame = CGRectMake(20, 5, TXBYApplicationW - 60, 40);
    tipsLabel.font = [UIFont systemFontOfSize:14.0];
    tipsLabel.textColor = [UIColor colorWithRed:245.0 / 255 green:116.0 / 255 blue:15.0/255 alpha:1];
    tipsLabel.text = text;
    tipsLabel.numberOfLines = 0;
    [tipsView addSubview:tipsLabel];
    
    UIButton *closeButon = [[UIButton alloc] init];
    closeButon.backgroundColor = [UIColor clearColor];
    closeButon.frame = CGRectMake(TXBYApplicationW - 30, 13, 25, 25);
    [closeButon setTitle:@"×" forState:UIControlStateNormal];
    [closeButon setTintColor:[UIColor whiteColor]];
    closeButon.titleLabel.font = [UIFont boldSystemFontOfSize:23];
    [closeButon addTarget:self action:@selector(closeTips) forControlEvents:UIControlEventTouchUpInside];
    [tipsView addSubview:closeButon];
    tipsView.tag = 9998;
}

- (void)closeTips {
    for (UIView *view in self.view.subviews) {
        if (view.tag == 9998) {
            [view removeFromSuperview];
            break;
        }
    }
}

/**
 *  在相机权限被禁时进行提示
 */
- (BOOL)alertForNoCameraAuthorization {
    BOOL authorization = YES;
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
        authorization = NO;
        NSString *tips = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”选项中，允许%@访问你的相机。",[NSString TXBYAppName]];
        TXBYAlert(tips);
    }
    return authorization;
}

/**
 *  在麦克风权限被禁时进行提示
 */
- (BOOL)alertForNoAudioAuthorization {
    BOOL authorization = YES;
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
        authorization = NO;
        NSString *tips = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-麦克风”选项中，允许%@访问你的麦克风。",[NSString TXBYAppName]];
        TXBYAlert(tips);
    }
    return authorization;
}

/**
 *  在定位权限被禁时进行提示
 */
- (BOOL)alertForNoLocationAuthorization {
    BOOL authorization = YES;
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusRestricted || authorizationStatus == kCLAuthorizationStatusDenied) {
        authorization = NO;
        NSString *tips = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-定位服务”选项中，允许%@访问你的定位信息。",[NSString TXBYAppName]];
        TXBYAlert(tips);
    }
    return authorization;
}

#pragma mark - 是否登录
/**
 *  检查有没有账号
 *
 *  @param exist 有账号的回调（已经登录）
 *  @param unExist 没有账号的回调（未登录）
 */
- (void)accountExist:(void (^)())exist unExist:(void (^)())unExist {
    //1. 取出登录的账号
    Account *account = [AccountTool account];
    
    //2. 判断账号状态
    //有缓存账号
    if (account) {
        if (exist) {
            exist();
        }
    } else { // 没有账号
        if (unExist) {
            unExist();
        }
    }
}

/**
 *  检查有没有账号（没有默认跳转到登录界面）
 *
 *  @param exist 有账号的回调（已经登录）
 */
- (void)accountExist:(void (^)())exist {
    [self accountExist:exist unExist:^{
        TXBYLog(@"没有账号,跳转到登录控制器");
        LoginViewController *vc = [[LoginViewController alloc] init];
        TXBYNavigationController *nav = [[TXBYNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }];
}

#pragma mark - token是否过期
/**
 *  检查登录Token是否过期
 *
 *  @param expired   账号过期的回调
 *  @param unExpired 账号未过期的回调
 */
- (void)accountExpired:(void (^)())expired unExpired:(void (^)())unExpired {
     //1. 取出缓存的账号(
    Account *account = [AccountTool account];
     //2. 判断状态
     //过期了
    if ([AccountTool isExpires:account]) {
        if (expired) {
            expired();
        }
    } else { // 没过期
        if (unExpired) {
            unExpired();
        }
    }
}

/**
 *  检查登录Token是否过期（如果过期默认更新令牌）
 *
 *  @param expired   账号过期的回调
 *  @param unExpired 账号未过期的回调
 */
- (void)accountUnExpired:(void (^)())unExpired {
    [self accountExpired:^{
        TXBYLog(@"令牌过期,用旧令牌换新令牌");
        // 请求参数
        LoginParam *param = [LoginParam param];
        Account *account = [AccountTool account];
        param.token = account.token;
        
        MBProgressHUD *hud = [MBProgressHUD showMessage:@"加载中..." toView:self.view];
        // 发送更新请求
        [LoginTool refreshTokenWithParam:param netIdentifier:TXBYRefreshTokenNetIdentifier success:^(LoginResult *result) {
            // 隐藏加载提示
            [hud hide:YES];
            // 更新成功
            if ([result.errcode isEqualToString:TXBYSuccessCode]) {
                // 传递block
                if (unExpired) {
                    unExpired();
                }
            }
        } failure:^(NSError *error) {
            // 隐藏加载提示
            [hud hide:YES];
            // 加载网络错误提示
            [self requestFailure:error];
            // 如果导航栏右侧按钮不能点击
            if (!self.navigationItem.rightBarButtonItem.enabled) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
        }];
    } unExpired:unExpired];
}

- (void)refreshToken:(void (^)())success {
    TXBYLog(@"令牌过期,用旧令牌换新令牌");
    //请求参数
    LoginParam *param = [LoginParam param];
    Account *account = [AccountTool account];
    param.token = account.token;
    
    // 发送更新请求
    [LoginTool refreshTokenWithParam:param netIdentifier:TXBYRefreshTokenNetIdentifier success:^(LoginResult *result) {
        // 更新成功
        if ([result.errcode isEqualToString:@"0"]) {
            // 传递block
            if (success) {
                success();
            }
        } else { // 账号过期
            // 隐藏加载提示
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD hideHUDForView:self.view.window];
            [MBProgressHUD showInfo:@"账号已过期" toView:self.view];
        }
    } failure:^(NSError *error) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD hideHUDForView:self.view.window];
        // 加载网络错误提示
        [self requestFailure:error];
        // 如果导航栏右侧按钮不能点击
        if (!self.navigationItem.rightBarButtonItem.enabled) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }];
}

@end
