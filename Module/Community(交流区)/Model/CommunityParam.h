//
//  CommunityParam.h
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/24.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYBaseParam.h"

@interface CommunityParam : TXBYBaseParam
#pragma mark - 问题详情

/**
 *  问题id主键
 */
@property (nonatomic, copy) NSString *quest_id;
/**
 *  返回比maxId小的数据（上拉加载更多）
 */
@property (nonatomic, copy) NSString *max_id;
/**
 *  返回比sinceId大的数据（下拉刷新）
 */
@property (nonatomic, copy) NSString *since_id;

#pragma mark - 提问
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  内容
 */
@property (nonatomic, copy) NSString *content;
/**
 *  group的id
 */
@property (nonatomic, copy) NSString *group;
/**
 *  uid
 */
@property (nonatomic, copy) NSString *uid;
/**
 *  aid
 */
@property (nonatomic, copy) NSString *aid;
/**
 *  上传的图片地址
 */
@property (nonatomic, copy) NSString *imgs;
/**
 *  oid
 */
@property (nonatomic, copy) NSString *oid;
/**
 *  category
 */
@property (nonatomic, copy) NSString *category;
/**
 *  operate
 */
@property (nonatomic, copy) NSString *operate;
/**
 *  ID
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  page
 */
@property (nonatomic, copy) NSString *page;
/**
 *  type
 */
@property (nonatomic, copy) NSString *type;

@end
