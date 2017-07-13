//
//  TXBYKit.h
//  TXBYKit
//
//  Created by mac on 16/4/26.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#ifndef __TXBYKitConst__M__
#define __TXBYKitConst__M__

#pragma mark - 宏定义

// 日志输出
#ifdef DEBUG
#define TXBYLog(...) NSLog(__VA_ARGS__)
#else
#define TXBYLog(...)
#endif

// 设备类型
// iPhone4
#define iPhone4 ([UIScreen mainScreen].bounds.size.height == 480.0)
// iPhone5
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568.0)
// iPhone6
#define iPhone6 ([UIScreen mainScreen].bounds.size.height == 667.0)
// iPhone6p
#define iPhone6p ([UIScreen mainScreen].bounds.size.height == 736.0)

//屏幕的宽度
#define TXBYApplicationW ([UIScreen mainScreen].applicationFrame.size.width)
//屏幕的高度
#define TXBYApplicationH ([UIScreen mainScreen].applicationFrame.size.height)
// 16进制转对应的颜色
#define TXBYColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 通过RGB创建颜色
#define TXBYColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 用于定义weak类型
#define WeakObj(o) __weak typeof(o) o##Weak = o
// 定义__weakSelf
#define WeakSelf WeakObj(self)
// 当前控制器名称
#define TXBYClassName NSStringFromClass(self.class)

// 创建UIAlertView并且显示
#define TXBYAlert(msg) [[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil] show];
// 判断是否为iOS7以上版本
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 判断是否为iOS10以上版本
#define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0f)

// SQLite路径
#define TXBYSQLitePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"db.sqlite"]
// 默认偏好设置
#define TXBYUserDefaults [NSUserDefaults standardUserDefaults]

// 登录状态变更通知
#define TXBY_NOTIFICATION_LOGINCHANGE @"TXBYLoginStateChange"

// 医院ID
extern NSString *TXBYHospital;
// App_type
extern NSString *TXBYApp_type;
// 医院分支
extern NSString *TXBYBranch;

// 导航栏高度
extern CGFloat const TXBYNavH;
// tabbar高度
extern CGFloat const TXBYTabbarH;
// cell之间的间距
extern CGFloat const TXBYCellMargin;
// 接口调用成功
extern NSString *const TXBYSuccessCode;

#pragma mark - 网络标识
// 刷新token网络标识
extern NSString *const TXBYRefreshTokenNetIdentifier;
// 注销token网络标识
extern NSString *const TXBYRevokeTokenNetIdentifier;
// 变更DeviceToken网络标识
extern NSString *const TXBYDeviceTokenNetIdentifier;

#pragma mark - 服务端接口
// 智能分诊症状列表
extern NSString *const TXBYTriageSymptomListAPI;
// 智能分诊疾病列表
extern NSString *const TXBYTriageIllListAPI;

// 问题列表
extern NSString *const TXBYQuestListAPI;
// 问题详情
extern NSString *const TXBYQuestDetailAPI;
// 提问
extern NSString *const TXBYQuestAddAPI;
// 回复问题
extern NSString *const TXBYQuestReplyAPI;
// 我的问题
extern NSString *const TXBYMyQuestAPI;

#pragma mark - 药师服务
// 问题列表查询
extern NSString *const TXBYQuestionListAPI;
// 问题详情
extern NSString *const TXBYQuestionDetailAPI;
// 发布问题
extern NSString *const TXBYQuestionCreateAPI;
// 回复问题
extern NSString *const TXBYQuestionReplyAPI;
// 查询置顶问题
extern NSString *const TXBYTopQuestionAPI;
// 搜索问题
extern NSString *const TXBYQuestionSearchAPI;
// 我的问题
extern NSString *const TXBYMyQuestionAPI;
// 点赞
extern NSString *const TXBYQuestionLikeAPI;
// 取消点赞
extern NSString *const TXBYQuestioDislikeAPI;

#pragma mark - 步数接口
// 步数列表
extern NSString *const TXBYStepListAPI;
// 上传步数
extern NSString *const TXBYSaveStepAPI;
// 设置步数个人主页背景
extern NSString *const TXBYUploadStepBackImgeAPI;
// 获取一周的数据
extern NSString *const TXBYWeekStepListStepAPI;
// 赞步数
extern NSString *const TXBYStepLoveAPI;
// 取消赞步数
extern NSString *const TXBYStepCancelLoveAPI;
// 赞我的人
extern NSString *const TXBYStepLovePersonAPI;

// 科室介绍列表
extern NSString *const TXBYDeptIntroduceListAPI;
// 科室介绍详情
extern NSString *const TXBYDeptIntroduceDetailAPI;
// 服务价格
extern NSString *const TXBYServiceAPI;
// 服务条款
extern NSString *const TXBYAgreementAPI;
// 药价公示列表
extern NSString *const TXBYDrugListAPI;
#pragma mark - 交流区接口
// 交流区分类
extern NSString *const TXBYCommunityGroupAPI;
// 交流区列表
extern NSString *const TXBYCommunityListAPI;
// 交流区thumb图片
extern NSString *const TXBYCommunityThumbAPI;
// 交流区点赞和踩
extern NSString *const TXBYCommunityLoveAPI;
// 交流区取消点赞和踩
extern NSString *const TXBYCommunityCancelLoveAPI;
// 交流区点赞和点踩人数
extern NSString *const TXBYCommunityPersonAPI;
// 交流区上传请求
extern NSString *const TXBYCommunityUploadImageAPI;
// 已回答API
extern NSString *const TXBYReadQuestAPI;
// 未回答API
extern NSString *const TXBYUnReadQuestAPI;

#pragma mark - 交流区接口(模块二)
// 圈子列表
extern NSString *const TXBYCircleQueryAPI;
// 圈子详情
extern NSString *const TXBYCircleDetailAPI;
// 点赞详情
extern NSString *const TXBYLoveDetailAPI;
// 点赞
extern NSString *const TXBYCircleLoveAPI;
// 取消赞
extern NSString *const TXBYCircleCancelLoveAPI;
// 我收藏的圈子
extern NSString *const TXBYMyCollectCircleAPI;
// 我评论的圈子
extern NSString *const TXBYMyCommentCircleAPI;
// 我发布的圈子
extern NSString *const TXBYMyPublishCircleAPI;
// 圈子收藏
extern NSString *const TXBYCircleCollectAPI;
// 取消圈子收藏
extern NSString *const TXBYCancelCircleCollectAPI;
// 修改昵称
extern NSString *const TXBYUserNicknameModAPI;

#endif
