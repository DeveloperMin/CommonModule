//
//  QuestionParam.h
//  publicCommon
//
//  Created by hj on 17/2/20.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "TXBYBaseParam.h"

@interface QuestionParam : TXBYBaseParam

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, copy) NSString *at_uid;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;

/**
 *  图片,以竖线分割拼接字符串
 */
@property (nonatomic, copy) NSString *imgs;

/**
 *  分类id,药师服务为2
 */
@property (nonatomic, copy) NSString *group;

/**
 *  指定回答者的id
 */
@property (nonatomic, copy) NSString *aid;

#pragma mark - 点赞
/**
 *  用户id
 */
@property (nonatomic, copy) NSString *uid;
/**
 *  问题id
 */
@property (nonatomic, copy) NSString *oid;
/**
 *  分类,1新闻,2 问答,3 医生, 4 评论, 5 步数
 */
@property (nonatomic, copy) NSString *category;
/**
 *  操作,1浏览,2关注,3点赞,4 踩,5 取消点赞,6取消踩
 */
@property (nonatomic, copy) NSString *operate;


@end
