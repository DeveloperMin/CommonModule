//
//  CommentHeaderView.m
//  txzjPatient
//
//  Created by Limmy on 2017/4/25.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "CommentHeaderCell.h"
#import "TXBYCircleImg.h"

@implementation CommentHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
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
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.textColor = TXBYColor(71, 71, 71);
    _contentLabel.numberOfLines = 0;
    
    _picContainerView = [TXBYCirclePhotoView new];
    
    NSArray *views = @[_iconView, _signView, _nameLable, _user_title, _contentLabel, _timeLabel, _titleLable, _picContainerView];
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
    
    _user_title.sd_layout.centerYEqualToView(_nameLable).leftSpaceToView(_nameLable, 8).heightIs(16).widthIs(0);
    
    _timeLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, 3)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _titleLable.sd_layout
    .leftSpaceToView(contentView, 10)
    .topSpaceToView(_iconView, 10)
    .rightSpaceToView(contentView, 10)
    .heightIs(21);
    
    _contentLabel.sd_layout
    .topSpaceToView(_iconView, 35)
    .leftSpaceToView(contentView, 10)
    .rightSpaceToView(contentView, 10)
    .autoHeightRatio(0);
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
}

- (void)setModel:(CommentHeaderModel *)model {
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
    }
    _timeLabel.text = [model.create_time minutesAgo];
    _titleLable.text = model.title;
    _contentLabel.text = model.content;
//    _contentLabel.attributedText = [model.content setLineSpace:5];
    _picContainerView.imgModels = model.imgs;
    CGFloat picContainerTopMargin = 0;
    if (model.imgs.count) {
        picContainerTopMargin = 10;
    }
    
    _picContainerView.sd_layout.topSpaceToView(_contentLabel, picContainerTopMargin);
    [self setupAutoHeightWithBottomView:_picContainerView bottomMargin:10];
}

- (void)iconViewClickAction:(UIGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(iconViewClickAction:)]) {
        [self.delegate iconViewClickAction:self.model];
    }
}

@end

@implementation CommentHeaderModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"imgs":[TXBYCircleImg class]};
}
@end
