//
//  Quest.h
//  smh
//
//  Created by yh on 15/3/29.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  问题模型

#import <Foundation/Foundation.h>

@interface Quest : NSObject

/**
 *  主键
 */
@property (nonatomic, assign) NSInteger ID;

/**
 *  头像
 */
@property (nonatomic, copy) NSString *avatar;

/**
 *  用户名
 */
@property (nonatomic, copy) NSString *userName;

/**
 *  时间
 */
@property (nonatomic, copy) NSString *createTime;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  详细内容
 */
@property (nonatomic, copy) NSString *content;

/**
 *  头像frame
 */
@property (nonatomic, assign, readonly) CGRect avatarFrame;

/**
 *  用户名frame
 */
@property (nonatomic, assign, readonly) CGRect userNameFrame;

/**
 *  时间frame
 */
@property (nonatomic, assign, readonly) CGRect createTimeFrame;

/**
 *  标题frame
 */
@property (nonatomic, assign, readonly) CGRect titleFrame;

/**
 *  内容frame
 */
@property (nonatomic, assign, readonly) CGRect contentFrame;

/**
 *  cell高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

/**
 *  用户名字体
 */
@property (nonatomic, strong) UIFont *userNameFont;

/**
 *  时间字体
 */
@property (nonatomic, strong) UIFont *createTimeFont;

/**
 *  标题字体
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 *  内容字体
 */
@property (nonatomic, strong) UIFont *contentFont;

/**
 *  创建Quest模型
 *
 *  @param ID          问题ID
 *  @param avatar      头像url地址
 *  @param user_name   用户名
 *  @param create_time 创建时间
 *  @param title       标题
 *  @param content     内容
 *
 */
- (instancetype)initWithID:(NSNumber *)ID avatar:(NSString *)avatar userName:(NSString *)userName createTime:(NSString *)createTime title:(NSString *)title andContent:(NSString *)content;

/**
 *  快速创建Quest模型
 *
 *  @param ID          问题ID
 *  @param avatar      头像url地址
 *  @param user_name   用户名
 *  @param create_time 创建时间
 *  @param title       标题
 *  @param content     内容
 *
 */
+ (instancetype)itemWithID:(NSNumber *)ID avatar:(NSString *)avatar userName:(NSString *)user_name createTime:(NSString *)create_time title:(NSString *)title andContent:(NSString *)content;

/**
 *  创建Quest模型
 *
 *  @param dict Quest字典
 */
- (instancetype)initWithDict:(NSDictionary *)dict;

/**
 *  快速创建Quest模型
 *
 *  @param dict Quest字典
 */
+ (instancetype)itemWithDict:(NSDictionary *)dict;

@end