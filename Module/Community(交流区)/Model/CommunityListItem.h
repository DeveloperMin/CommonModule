//
//  CommunityListItem.h
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/24.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityListItem : NSObject
/**
 *  头像
 */
@property (nonatomic, copy) NSString *avatar;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  内容
 */
@property (nonatomic, copy) NSString *content;
/**
 *  时间
 */
@property (nonatomic, copy) NSString *create_time;
/**
 *  用户名
 */
@property (nonatomic, copy) NSString *user_name;
/**
 *  name
 */
@property (nonatomic, copy) NSString *name;
/**
 *  ID
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  图片地址
 */
@property (nonatomic, strong) NSArray *imgs;
/**
 *  赞id
 */
@property (nonatomic, copy) NSString *loved_id;
/**
 *  自己是否赞过
 */
@property (nonatomic, copy) NSString *is_loved;
/**
 *  点赞数
 */
@property (nonatomic, copy) NSString *love;
/**
 *  浏览数
 */
@property (nonatomic, copy) NSString *browse;
/**
 *  所属类型
 */
@property (nonatomic, copy) NSString *group_name;
/**
 *  评论数
 */
@property (nonatomic, copy) NSString *comment;
/**
 *  当前页
 */
@property (nonatomic, copy) NSString *page;
/**
 *  总共页数
 */
@property (nonatomic, copy) NSString *page_count;
/**
 *  aid
 */
@property (nonatomic, copy) NSString *aid;
/**
 *  踩数
 */
@property (nonatomic, copy) NSString *tread;
/**
 *  自己是否踩过
 */
@property (nonatomic, copy) NSString *is_treaded;
/**
 *  踩id
 */
@property (nonatomic, copy) NSString *treaded_id;

@end
