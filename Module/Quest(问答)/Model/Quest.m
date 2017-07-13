//
//  Quest.m
//  smh
//
//  Created by yh on 15/3/29.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  

#import "Quest.h"

// cell内容宽度
#define cellWidth [UIScreen mainScreen].bounds.size.width - 4 * cellMargin

@implementation Quest

#pragma mark - setter
/**
 *  头像
 */
- (void)setAvatar:(NSString *)avatar {
    _avatar = [avatar copy];
    
    CGFloat avatarX = TXBYCellMargin * 1.5;
    CGFloat avatarY = TXBYCellMargin * 1.5;
    CGFloat avatarWH = 35;
    _avatarFrame = CGRectMake(avatarX, avatarY, avatarWH, avatarWH);
}

/**
 *  用户名
 */
- (void)setUserName:(NSString *)userName {
    _userName = [userName copy];
    
    CGFloat userNameX = CGRectGetMaxX(_avatarFrame) + TXBYCellMargin * 1.5;
    CGFloat userNameY = CGRectGetMinY(_avatarFrame);
    CGFloat userNameW = TXBYApplicationW - TXBYCellMargin - userNameX;
    CGSize userNameSize = [userName sizeWithFont:self.userNameFont maxW:userNameW];
    _userNameFrame = CGRectMake(userNameX, userNameY, userNameW, userNameSize.height);
}

/**
 *  时间
 */
- (void)setCreateTime:(NSString *)createTime {
    _createTime = [createTime copy];
    
    // 时间
    CGFloat createTimeX = CGRectGetMinX(_userNameFrame);
    CGFloat extrenY = 3;
    CGFloat createTimeY = CGRectGetMaxY(_userNameFrame) + extrenY;
    CGFloat createTimeWidth = _userNameFrame.size.width;
    CGSize createTimeSize = [[createTime minutesAgo] sizeWithFont:self.createTimeFont maxW:createTimeWidth];
    _createTimeFrame = CGRectMake(createTimeX, createTimeY, createTimeWidth, createTimeSize.height);
}

/**
 *  标题
 */
- (void)setTitle:(NSString *)title {
    _title = [title copy];
    
    // 标题
    CGFloat titleX = CGRectGetMinX(_avatarFrame);
    CGFloat titleY = CGRectGetMaxY(_avatarFrame) + TXBYCellMargin * 1.5;
    CGFloat titleWidth = TXBYApplicationW - 2 * titleX;
    CGSize titleSize = [title sizeWithFont:self.titleFont maxW:titleWidth];
    _titleFrame = CGRectMake(titleX, titleY, titleWidth, titleSize.height);
}

/**
 *  内容
 */
- (void)setContent:(NSString *)content {
    _content = [content copy];
    
    // 内容
    CGFloat contentX = CGRectGetMinX(_titleFrame);
    CGFloat margin = 0;
    if (_titleFrame.size.height) {
        margin = TXBYCellMargin * 1.5;
    }
    CGFloat contentY = CGRectGetMaxY(_titleFrame) + margin;
    CGFloat contentWidth = _titleFrame.size.width;
    CGSize contentSize = [content sizeWithFont:self.contentFont maxW:contentWidth];
    _contentFrame = CGRectMake(contentX, contentY, contentWidth, contentSize.height);
    
    // cell高度
    _cellHeight = CGRectGetMaxY(_contentFrame) + TXBYCellMargin + CGRectGetMinY(_avatarFrame);
}

/**
 *  用户名字体
 */
- (UIFont *)userNameFont {
    if (!_userNameFont) {
        _userNameFont = [UIFont systemFontOfSize:16];
    }
    return _userNameFont;
}

/**
 *  时间字体
 */
- (UIFont *)createTimeFont {
    if (!_createTimeFont) {
        _createTimeFont = [UIFont systemFontOfSize:12];
    }
    return _createTimeFont;
}

/**
 *  标题字体
 */
- (UIFont *)titleFont {
    if (!_titleFont) {
        _titleFont = [UIFont systemFontOfSize:16];
    }
    return _titleFont;
}

/**
 *  内容字体
 */
- (UIFont *)contentFont {
    if (!_contentFont) {
        _contentFont = [UIFont systemFontOfSize:15];
    }
    return _contentFont;
}

#pragma mark - public
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
- (instancetype)initWithID:(NSNumber *)ID avatar:(NSString *)avatar userName:(NSString *)userName createTime:(NSString *)createTime title:(NSString *)title andContent:(NSString *)content {
    if (self = [super init]) {
        self.ID = ID.integerValue;
        self.avatar = avatar;
        self.userName = userName;
        self.createTime = createTime;
        self.title = title;
        self.content = content;
    }
    return self;
}

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
+ (instancetype)itemWithID:(NSNumber *)ID avatar:(NSString *)avatar userName:(NSString *)user_name createTime:(NSString *)create_time title:(NSString *)title andContent:(NSString *)content {
    return [[self alloc] initWithID:ID avatar:avatar userName:user_name createTime:create_time title:title andContent:content];
}

/**
 *  创建Quest模型
 *
 *  @param dict Quest字典
 */
- (instancetype)initWithDict:(NSDictionary *)dict {
    return [self initWithID:dict[@"ID"] avatar:dict[@"avatar"] userName:dict[@"user_name"] createTime:dict[@"create_time"] title:dict[@"title"] andContent:dict[@"content"]];
}

/**
 *  快速创建Quest模型
 *
 *  @param dict Quest字典
 */
+ (instancetype)itemWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

MJCodingImplementation

@end