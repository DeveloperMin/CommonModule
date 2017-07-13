//
//  QuestParam.h
//  smh
//
//  Created by yh on 15/3/29.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  问答请求参数

#import "TXBYBaseParam.h"

@interface QuestParam : TXBYBaseParam

#pragma mark - 问题详情

/**
 *  问题id主键
 */
@property (nonatomic, assign) NSInteger quest_id;

/**
 *  返回比maxId小的数据（上拉加载更多）
 */
@property (nonatomic, assign) NSInteger max_id;

/**
 *  返回比sinceId大的数据（下拉刷新）
 */
@property (nonatomic, assign) NSInteger since_id;

#pragma mark - 提问
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  内容
 */
@property (nonatomic, copy) NSString *content;

@end