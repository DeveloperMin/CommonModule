//
//  CommunityCellFrame.h
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/24.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CommunityListItem;

@interface CommunityCellFrame : NSObject
/**
 *  item
 */
@property (nonatomic, strong) CommunityListItem *communityItem;
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
 *  是否是评论
 */
@property (nonatomic, assign) BOOL comment;
/**
 *  标题frame
 */
@property (nonatomic, assign, readonly) CGRect titleFrame;
/**
 *  内容frame
 */
@property (nonatomic, assign, readonly) CGRect contentFrame;
/**
 *  photo高度
 */
@property (nonatomic, assign, readonly) CGRect photoFrame;
/**
 *  工具条frame
 */
@property (nonatomic, assign) CGRect toolBarFrame;
/**
 *  cell高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;
/**
 *  通过模型创建CellFrame
 */
+ (instancetype)cellFrameWithCommunityItem:(CommunityListItem *)communityItem;
@end
