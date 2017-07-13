//
//  CommunityCellFrame.m
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/24.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "CommunityCellFrame.h"
#import "CommunityListItem.h"

@implementation CommunityCellFrame
/**
 *  创建MessagesCellFrame
 */
+ (instancetype)cellFrameWithCommunityItem:(CommunityListItem *)communityItem
{
    CommunityCellFrame *communityFrame = [[self alloc] init];
    communityFrame.communityItem = communityItem;
    return communityFrame;
}

- (void)setCommunityItem:(CommunityListItem *)communityItem {
    _communityItem = communityItem;
    // 头像
    CGFloat avatarX = TXBYCellMargin;
    CGFloat avatarY = TXBYCellMargin;
    CGFloat avatarWH = 36;
    _avatarFrame = CGRectMake(avatarX, avatarY, avatarWH, avatarWH);
    
    // user_name
    CGFloat userNameX = CGRectGetMaxX(_avatarFrame) + TXBYCellMargin;
    CGFloat userNameY = CGRectGetMinY(_avatarFrame);
    CGFloat userNameW = TXBYApplicationW/2;
    CGSize userNameSize = [communityItem.name sizeWithFont:[UIFont systemFontOfSize:16] maxW:userNameW];
    _userNameFrame = CGRectMake(userNameX, userNameY, userNameW, userNameSize.height);
    
    // 时间
    CGFloat createTimeX = CGRectGetMinX(_userNameFrame);
    CGFloat createTimeY = CGRectGetMaxY(_userNameFrame) + 5;
    CGFloat createTimeWidth = _userNameFrame.size.width;
    
    
    CGSize createTimeSize = [[communityItem.create_time minutesAgo] sizeWithFont:[UIFont systemFontOfSize:12] maxW:createTimeWidth];
    _createTimeFrame = CGRectMake(createTimeX, createTimeY, createTimeWidth, createTimeSize.height + 5);
    // 标题
    CGFloat titleX = CGRectGetMinX(_avatarFrame);
    CGFloat titleY = 0;
    if (CGRectGetMaxY(_avatarFrame) > CGRectGetMaxY(_createTimeFrame)) {
        titleY = CGRectGetMaxY(_avatarFrame) + TXBYCellMargin;
    } else {
        titleY = CGRectGetMaxY(_createTimeFrame) + TXBYCellMargin;
    }
    
    if (self.comment) {
        CGFloat titleWidth = TXBYApplicationW - userNameX - TXBYCellMargin;
        CGSize titleSize = [communityItem.title sizeWithFont:[UIFont systemFontOfSize:16] maxW:titleWidth];
        _titleFrame = CGRectMake(userNameX, titleY, titleWidth, titleSize.height);
    } else {
        CGFloat titleWidth = TXBYApplicationW - 2 * titleX;
        CGSize titleSize = [communityItem.title sizeWithFont:[UIFont systemFontOfSize:16] maxW:titleWidth];
        _titleFrame = CGRectMake(titleX, titleY, titleWidth, titleSize.height);
    }
    
    // 内容
    CGFloat contentX = CGRectGetMinX(_titleFrame);
    CGFloat margin = 0;
    if (_titleFrame.size.height) {
        margin = TXBYCellMargin;
    }
    CGFloat contentY = CGRectGetMaxY(_titleFrame) + margin;
    CGFloat contentWidth = _titleFrame.size.width;
    CGSize contentSize = [communityItem.content sizeWithFont:[UIFont systemFontOfSize:15] maxW:contentWidth];
    _contentFrame = CGRectMake(contentX, contentY, contentWidth, contentSize.height);
    
    CGFloat photoY = CGRectGetMaxY(_contentFrame);
    CGFloat photoH = (TXBYApplicationW - 8 * 4)/3 + 12;
    if (self.comment) {
        photoH = (TXBYApplicationW - 8 * 3 - _titleFrame.origin.x)/3 + 12;
        _photoFrame = CGRectMake(0, photoY, TXBYApplicationW - 2 * titleX, photoH);
    } else {
        photoH = (TXBYApplicationW - 8 * 4)/3 + 12;
        _photoFrame = CGRectMake(0, photoY, TXBYApplicationW, photoH);
    }
    
    if (communityItem.imgs.count == 1) { // 只有一张图片时toolBarFrame
        // 工具条的高度
        _toolBarFrame = CGRectMake(0, CGRectGetMaxY(_photoFrame) + 45, TXBYApplicationW, 40);
        // cell高度
        _cellHeight = CGRectGetMaxY(_toolBarFrame);
    } else if (communityItem.imgs.count > 1) { // 大于一张图片时toolBarFrame
        // 工具条的高度
        _toolBarFrame = CGRectMake(0, CGRectGetMaxY(_photoFrame) + 5, TXBYApplicationW, 40);
        // cell高度
        _cellHeight = CGRectGetMaxY(_toolBarFrame);
    } else { // 没有图片时toolBarFrame
        // 工具条的高度
        _toolBarFrame = CGRectMake(0, CGRectGetMaxY(_contentFrame) + 5, TXBYApplicationW, 40);
        // cell高度
        _cellHeight = CGRectGetMaxY(_toolBarFrame);
    }
}
@end
