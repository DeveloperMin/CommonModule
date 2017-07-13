//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+MJ.h"
#import "TXBYHudView.h"

#define HUDColor [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.8]

@implementation MBProgressHUD (MJ)

#pragma mark 显示信息

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view hudType:(TXBYHudType)animateType completion:(void (^)(BOOL finished))completion andAnimated:(BOOL)animated
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    hud.margin = 18;
    if (!animated) {
        // 设置图片
        hud.customView =[UIView new];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
        imgView.frame = CGRectMake(0, -3, 32, 32);
        [hud.customView addSubview:imgView];
    }
    else {
        hud.customView = [UIView new];
        TXBYHudView *hudView = [[TXBYHudView alloc] initWithSize:32];
        hudView.frame = CGRectMake(0, -3, 32, 32);
        hudView.duration = 0.5;
        hudView.hudType = animateType;
        hudView.lineWidth = 1.0;
        hudView.animate = YES;
        hudView.hudColor = [UIColor whiteColor];
        [hud.customView addSubview:hudView];
        [hudView createView];
    }
    hud.customView.txby_width = 32;
    hud.customView.txby_height = 32;
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.color = HUDColor;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    NSTimeInterval delay = 1.5f;
    [hud hide:YES afterDelay:delay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion(YES);
        }
    });
}

#pragma mark 显示提示
+ (void)showError:(NSString *)error toView:(UIView *)view {
    [self show:error icon:@"error@2x.png" view:view hudType:TXBYHudTypeError completion:nil andAnimated:NO];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view {
    [self show:success icon:@"success@2x.png" view:view hudType:TXBYHudTypeSuccess completion:nil andAnimated:NO];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view completion:(void (^)(BOOL finished))completion {
    [self show:success icon:@"success@2x.png" view:view hudType:TXBYHudTypeSuccess completion:completion andAnimated:NO];
}

+ (void)showInfo:(NSString *)info toView:(UIView *)view {
    [self show:info icon:@"alert@2x.png" view:view hudType:TXBYHudTypeInfo completion:nil andAnimated:NO];
}


// 添加动画选项
+ (void)showError:(NSString *)error toView:(UIView *)view animated:(BOOL)animated {
    [self show:error icon:@"error@2x.png" view:view hudType:TXBYHudTypeError completion:nil andAnimated:animated];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view animated:(BOOL)animated {
    [self show:success icon:@"success@2x.png" view:view hudType:TXBYHudTypeSuccess completion:nil andAnimated:animated];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view completion:(void (^)(BOOL finished))completion animated:(BOOL)animated {
    [self show:success icon:@"success@2x.png" view:view hudType:TXBYHudTypeSuccess completion:completion andAnimated:animated];
}

+ (void)showInfo:(NSString *)info toView:(UIView *)view animated:(BOOL)animated {
    [self show:info icon:@"alert@2x.png" view:view hudType:TXBYHudTypeInfo completion:nil andAnimated:animated];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.color = HUDColor;
    hud.margin = 18;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
@end
