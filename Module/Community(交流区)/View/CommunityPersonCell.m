//
//  CommunityPersonCell.m
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/25.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "CommunityPersonCell.h"

@interface CommunityPersonCell ()
/**
 *  头像
 */
@property (nonatomic, strong) UIImageView *iconView;
/**
 *  title
 */
@property (nonatomic, strong) UILabel *title;

@end

@implementation CommunityPersonCell

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.frame = CGRectMake(8, 0, 40, 40);
        _iconView.txby_centerY = 30;
        _iconView.layer.cornerRadius = 20;
        _iconView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.frame = CGRectMake(56, 0, 200, 30);
        _title.txby_centerY = 30;
        [self.contentView addSubview:_title];
    }
    return _title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setPerson:(CommunityPerson *)person {
    _person = person;
    self.title.text = person.name;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:person.avatar] placeholderImage:[UIImage imageNamed:@"community.bundle/mine_avatar"]];
}

@end
