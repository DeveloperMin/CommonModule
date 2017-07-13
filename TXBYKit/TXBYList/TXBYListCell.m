//
//  TXBYListCell.m
//  TXBYKit
//
//  Created by mac on 16/4/14.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYListCell.h"
#import "TXBYCategory.h"
#import "TXBYListItem.h"

@interface TXBYListCell ()

/**
 *  标题label
 */
@property (nonatomic, weak) UILabel *titleLabel;

/**
 *  子标题label
 */
@property (nonatomic, weak) UILabel *subtitleLabel;

/**
 *  箭头视图
 */
@property (nonatomic, strong) UIImageView *arrowView;

@end

@implementation TXBYListCell

#pragma mark - getters
/**
 *  获取标题label
 */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [UILabel txby_label];
        [self.contentView addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (void)setListItem:(TXBYListItem *)listItem {
    _listItem = listItem;
    
    if (listItem.hideArrow) {
        self.accessoryView = nil;
    }
    
    if (!listItem.enable) {
        self.userInteractionEnabled = NO;
    }
    
    self.titleLabel.text = listItem.title;
    self.titleLabel.frame = listItem.titleFrame;
    self.titleLabel.font = listItem.titleFont;
    self.titleLabel.textColor = listItem.titleColor;
    
    self.subtitleLabel.text = listItem.subtitle;
    self.subtitleLabel.frame = listItem.subtitleFrame;
    self.subtitleLabel.font = listItem.subtitleFont;
    self.subtitleLabel.textColor = listItem.subtitleColor;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        UILabel *subtitleLabel = [UILabel txby_label];
        [self.contentView addSubview:subtitleLabel];
        _subtitleLabel = subtitleLabel;
    }
    return _subtitleLabel;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TXBYList.bundle/common_icon_arrow"]];
        _arrowView = arrowView;
    }
    return _arrowView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.accessoryView = self.arrowView;
}

@end