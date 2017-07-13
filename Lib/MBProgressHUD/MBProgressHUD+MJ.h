//
//  MBProgressHUD+MJ.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (MJ)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showInfo:(NSString *)info toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view completion:(void (^)(BOOL finished))completion;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view animated:(BOOL)animated;
+ (void)showError:(NSString *)error toView:(UIView *)view animated:(BOOL)animated;
+ (void)showInfo:(NSString *)info toView:(UIView *)view animated:(BOOL)animated;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view completion:(void (^)(BOOL finished))completion animated:(BOOL)animated;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
