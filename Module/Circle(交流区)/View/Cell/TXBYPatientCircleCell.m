//
//  TXBYPatientCircleCell.m
//  txzjPatient
//
//  Created by Limmy on 2017/5/3.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "TXBYPatientCircleCell.h"


@interface TXBYPatientCircleCell ()

@end

@implementation TXBYPatientCircleCell

- (void)setup {
    CGFloat maxContentLabelHeight = 0;
    
    _iconView = [UIImageView new];
    _iconView.layer.cornerRadius = 20;
    _iconView.layer.masksToBounds = YES;
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:15];
    //    _nameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _user_title = [UILabel new];
    _user_title.font = [UIFont systemFontOfSize:12];
    _user_title.backgroundColor = TXBYColor(170, 220, 119);
    _user_title.textAlignment = NSTextAlignmentCenter;
    _user_title.textColor = [UIColor whiteColor];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = TXBYColor(125, 125, 125);
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.textColor = TXBYColor(71, 71, 71);
    _contentLabel.numberOfLines = 0;
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:TXBYMainColor forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _picContainerView = [TXBYCirclePhotoView new];
    _toolBarView = [TXBYCircleToolBar new];
    _toolBarView.delegate = self;
    
    NSArray *views = @[_iconView, _nameLable, _user_title, _contentLabel, _timeLabel, _moreButton, _picContainerView, _toolBarView];
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
    
    _user_title.sd_layout.centerYEqualToView(_nameLable).leftSpaceToView(_nameLable, 8).heightIs(16);
    
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
    
    _moreButton.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 4)
    .widthIs(30)
    .heightIs(15);
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    _toolBarView.sd_layout
    .leftEqualToView(contentView)
    .topSpaceToView(_picContainerView, 10)
    .rightEqualToView(contentView)
    .heightIs(40);
}

@end
