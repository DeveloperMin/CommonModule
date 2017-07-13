//
//  CommunityListCell.h
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/24.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityCellFrame.h"


typedef void(^CommunityToolBlock)(NSInteger index);

@interface CommunityListCell : UITableViewCell

@property (nonatomic, strong) CommunityCellFrame *cellFrame;
/**
 *  是否是评论界面
 */
@property (nonatomic, assign) BOOL comment;
/**
 *  工具条的回调
 */
@property (nonatomic, copy) CommunityToolBlock toolBarBlock;
/**
 *  是否开启踩功能
 */
@property (nonatomic, assign) BOOL isTread;

@end
