//
//  TXBYCircleParam.h
//  txzjPatient
//
//  Created by Limmy on 2017/4/22.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "TXBYBaseParam.h"

@interface TXBYCircleParam : TXBYBaseParam
/**
 *  uid
 */
@property (nonatomic, copy) NSString *uid;
/**
 *  range(范围，只看我关注的医生my_doctor，只看医生传doctor,只看患者patient)
 */
@property (nonatomic, copy) NSString *range;
/**
 *  since_id
 */
@property (nonatomic, copy) NSString *since_id;
/**
 *  max_id
 */
@property (nonatomic, copy) NSString *max_id;
/**
 *  oid(如新闻id,步数id,问题id,评论id)
 */
@property (nonatomic, copy) NSString *oid;
/**
 *  category(分类,1新闻,2 问答,3 医生, 4 评论, 5 步数)
 */
@property (nonatomic, copy) NSString *category;
/**
 *  operate(操作,1浏览,2关注,3点赞,4 踩,5 取消点赞,6取消踩)
 */
@property (nonatomic, copy) NSString *operate;
/**
 *  ID(记录id)
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  parent_id(一级评论的id,二级评论必传)
 */
@property (nonatomic, copy) NSString *parent_id;
/**
 *  at_uid(艾特的人的uid,二级评论必传)
 */
@property (nonatomic, copy) NSString *at_uid;
/**
 *  imgs(图片,以竖线分割拼接字符串)
 */
@property (nonatomic, copy) NSString *imgs;
/**
 *  content
 */
@property (nonatomic, copy) NSString *content;
/**
 *  title(标题)
 */
@property (nonatomic, copy) NSString *title;
/**
 *  group
 */
@property (nonatomic, copy) NSString *group;
@end
