//
//  UIViewController+TXBY.h
//  TXBYCategory
//
//  Created by mac on 16/5/9.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TXBY)

#pragma mark - 网络失败
/**
 *  加载网络失败
 *
 *  @param error 错误信息
 */
- (void)requestFailure:(NSError *)error;

#pragma mark - 添加提示view
/**
 *  没有数据的提示view
 */
- (void)emptyViewWithText:(NSString *)text;
/**
 *  没有数据的提示view
 */
- (void)emptyViewWithText:(NSString *)text andImg:(UIImage *)image;
/**
 *  没有数据的提示view, image大小根据image自身大小
 */
- (void)emptyViewWithImage:(UIImage *)image WithText:(NSString *)text;
/**
 *  删除没有数据的提示
 */
- (void)deleteEmptyText;
/**
 *  添加提示声明等
 */
- (void)addTipsText:(NSString *)text;

/**
 *  在相机权限被禁时进行提示
 */
- (BOOL)alertForNoCameraAuthorization;

/**
 *  在麦克风权限被禁时进行提示
 */
- (BOOL)alertForNoAudioAuthorization;

/**
 *  在定位权限被禁时进行提示
 */
- (BOOL)alertForNoLocationAuthorization;

#pragma mark - 是否登录
/**
 *  检查有没有账号
 *
 *  @param exist 有账号的回调（已经登录）
 *  @param unExist 没有账号的回调（未登录）
 */
- (void)accountExist:(void (^)())exist unExist:(void (^)())unExist;

/**
 *  检查有没有账号（没有默认跳转到登录界面）
 *
 *  @param exist 有账号的回调（已经登录）
 */
- (void)accountExist:(void (^)())exist;

#pragma mark - token是否过期
/**
 *  检查登录token是否过期
 *
 *  @param expired   账号过期的回调
 *  @param unExpired 账号未过期的回调
 */
- (void)accountExpired:(void (^)())expired unExpired:(void (^)())unExpired;

/**
 *  检查登录token是否过期（如果过期默认自动更新）
 *
 *  @param expired   账号过期的回调
 *  @param unExpired 账号未过期的回调
 */
- (void)accountUnExpired:(void (^)())unExpired;

/**
 *  服务端返回token过期的情况下再次刷新token
 *
 *  @param success 刷新成功的回调
 */
- (void)refreshToken:(void (^)())success;

@end
