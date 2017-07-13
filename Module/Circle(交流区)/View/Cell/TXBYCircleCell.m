//
//  TXBYCommunityCell.m
//  TXBYCommunity
//
//  Created by Limmy on 2017/4/13.
//  Copyright © 2017年 Limmy. All rights reserved.
//

#import "TXBYCircleCell.h"
#import "TXBYCircleModel.h"
//#import "TXBYCirclePhotoView.h"
//#import "TXBYCircleToolBar.h"

const CGFloat contentLabelFontSize = 15;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定

@interface TXBYCircleCell ()<TXBYCircleToolBarDelegate>

@end

@implementation TXBYCircleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup {
    _iconView = [UIImageView new];
    _iconView.layer.cornerRadius = 20;
    _iconView.layer.masksToBounds = YES;
    _iconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewClickAction:)];
    [_iconView addGestureRecognizer:tap];
    
    _signView = [UIImageView new];
    _signView.userInteractionEnabled = YES;
    _signView.image = [UIImage imageNamed:self.isDoctorUser? @"Circle.bundle/doctor_sign":@"Circle.bundle/patient_sign"];
    
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
    
    _titleLable = [UILabel new];
    _titleLable.font = [UIFont systemFontOfSize:17];
    _titleLable.textColor = TXBYColor(14, 14, 14);
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
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
    
    NSArray *views = @[_iconView, _signView, _nameLable, _user_title, _contentLabel, _timeLabel, _titleLable, _moreButton, _picContainerView, _toolBarView];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, 10)
    .topSpaceToView(contentView, 10)
    .widthIs(40)
    .heightIs(40);
    
    _signView.sd_layout
    .bottomEqualToView(_iconView)
    .rightEqualToView(_iconView)
    .widthIs(12)
    .heightIs(12);
    
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
    
    _titleLable.sd_layout
    .leftSpaceToView(contentView, 10)
    .topSpaceToView(_iconView, 10)
    .rightSpaceToView(contentView, 10)
    .autoHeightRatio(0);
    
    _contentLabel.sd_layout
    .topSpaceToView(_titleLable, 10)
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

- (void)iconViewClickAction:(UIGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(iconViewClickAction:)]) {
        [self.delegate iconViewClickAction:self.model];
    }
}

- (void)setModel:(TXBYCircleModel *)model {
    _model = model;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"mine_avatar"]];
    if (model.user_type.integerValue == 200) {
        _signView.hidden = NO;
        if (model.user_role.integerValue == 2) {
            _signView.image = [UIImage imageNamed:@"Circle.bundle/secretary_sign"];
        } else {
            _signView.image = [UIImage imageNamed:self.isDoctorUser? @"Circle.bundle/doctor_sign":@"Circle.bundle/patient_sign"];
        }
    } else {
        _signView.hidden = YES;
    }
    _nameLable.text = model.user_name;
    _user_title.text = model.user_title;
    if (model.user_title.length) {
        CGFloat titleW = [model.user_title sizeWithFont:[UIFont systemFontOfSize:12]].width + 8;
        _user_title.sd_layout.widthIs(titleW);
    } else {
        _user_title.sd_layout.widthIs(0);
    }
    _timeLabel.text = [model.create_time minutesAgo];
    _titleLable.text = model.title;
    _contentLabel.text = model.content;
//    _contentLabel.attributedText = [model.content setLineSpace:5];
    if (model.shouldShowMoreButton) { // 如果文字高度超过60
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        if (model.isOpening) { // 如果需要展开
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeight);
            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
        }
    } else {
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
    }
    _picContainerView.imgModels = model.imgs;
    CGFloat picContainerTopMargin = 0;
    if (model.imgs.count) {
        picContainerTopMargin = 10;
        _toolBarView.sd_layout.topSpaceToView(_picContainerView, 10);
    }
    _picContainerView.sd_layout.topSpaceToView(_moreButton, picContainerTopMargin);
    _toolBarView.isDoctorUser = self.isDoctorUser;
    _toolBarView.circleModel = model;
    [self setupAutoHeightWithBottomView:_toolBarView bottomMargin:0];
}

- (void)moreButtonClicked {
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}

#pragma mark - TXBYCircleToolBarDelegate
- (void)circleToolBarClickBtn:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(toolBarClickBtn:WithIndePath:)]) {
        [self.delegate toolBarClickBtn:btn WithIndePath:self.indexPath];
    }
}


@end
