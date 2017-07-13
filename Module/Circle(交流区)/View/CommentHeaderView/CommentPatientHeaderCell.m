//
//  CommentPatientHeaderCell.m
//  txzjPatient
//
//  Created by Limmy on 2017/5/18.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "CommentPatientHeaderCell.h"

@implementation CommentPatientHeaderCell

- (void)setup {
    _iconView = [UIImageView new];
    _iconView.layer.cornerRadius = 20;
    _iconView.layer.masksToBounds = YES;
    _iconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewClickAction:)];
    [_iconView addGestureRecognizer:tap];
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:15];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = TXBYColor(125, 125, 125);
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.textColor = TXBYColor(71, 71, 71);
    _contentLabel.numberOfLines = 0;
    
    _picContainerView = [TXBYCirclePhotoView new];
    
    NSArray *views = @[_iconView, _nameLable, _contentLabel, _timeLabel, _picContainerView];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, 10)
    .topSpaceToView(contentView, 10)
    .widthIs(40)
    .heightIs(40);
    
    _nameLable.sd_layout
    .topEqualToView(_iconView)
    .leftSpaceToView(_iconView, 10)
    .heightIs(20);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _timeLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, 3)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _contentLabel.sd_layout
    .topSpaceToView(_iconView, 10)
    .leftSpaceToView(contentView, 10)
    .rightSpaceToView(contentView, 10)
    .autoHeightRatio(0);
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
}

@end
