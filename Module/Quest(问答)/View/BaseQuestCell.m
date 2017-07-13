//
//  BaseQuestCell.m
//  smh
//
//  Created by yh on 15/3/29.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//

#import "BaseQuestCell.h"
#import "Quest.h"

@interface BaseQuestCell ()

/**
 *  头像视图
 */
@property (nonatomic, strong) UIImageView *avatarImageView;

/**
 *  用户名标签
 */
@property (nonatomic, strong) UILabel *userNameLabel;

/**
 *  时间标签
 */
@property (nonatomic, strong) UILabel *createTimeLabel;

/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  内容
 */
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation BaseQuestCell

#pragma mark - setters
- (void)setQuest:(Quest *)quest {
    _quest = quest;
    
    // 头像
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:quest.avatar] placeholderImage:[UIImage imageNamed:@"Quest.bundle/avatar_default.png"]];
    self.avatarImageView.frame = quest.avatarFrame;
    
    // 用户名
    self.userNameLabel.text = quest.userName;
    self.userNameLabel.frame = quest.userNameFrame;
    self.userNameLabel.font = quest.userNameFont;
    
    // 时间
    self.createTimeLabel.text = [quest.createTime minutesAgo];
    self.createTimeLabel.frame = quest.createTimeFrame;
    self.createTimeLabel.font = quest.createTimeFont;
    
    // 标题
    self.titleLabel.text = quest.title;
    self.titleLabel.frame = quest.titleFrame;
    self.titleLabel.font = quest.titleFont;
    
    // 内容
    self.contentLabel.text = quest.content;
    self.contentLabel.frame = quest.contentFrame;
    self.contentLabel.font = quest.contentFont;
}


#pragma mark - init
/**
 *  创建
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置背景
        [self setCommonBg];
        
        // 添加控件
        [self setupSubViews];
    }
    return self;
}

#pragma mark - private
/**
 *  添加控件
 */
- (void)setupSubViews {
    // 头像视图
    UIImageView *avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView = avatarImageView;
    [self.contentView addSubview:avatarImageView];
    
    // 用户名标签
    UILabel *userNameLabel = [[UILabel alloc] init];
    userNameLabel.numberOfLines = 0;
    self.userNameLabel = userNameLabel;
    [self.contentView addSubview:userNameLabel];
    
    // 时间标签
    UILabel *createTimeLabel = [[UILabel alloc] init];
    self.createTimeLabel = createTimeLabel;
    createTimeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:createTimeLabel];
    
    // 标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    // 内容标签
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    self.contentLabel = contentLabel;
    contentLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:contentLabel];
}

@end