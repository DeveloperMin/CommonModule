//
//  MyCirclePublishCell.m
//  txzjPatient
//
//  Created by Limmy on 2017/4/28.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "MyCirclePublishCell.h"
#import "MyCirclePhotoView.h"

@interface MyCirclePublishCell () {
    UILabel *_tipLabel;
    UILabel *_lineLabel;
    UILabel *_timeLabel;
    UILabel *_titleLable;
    UILabel *_contentLabel;
    MyCirclePhotoView *_picContainerView;
}

@end

@implementation MyCirclePublishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup {
    _tipLabel = [UILabel new];
    _tipLabel.backgroundColor = TXBYColor(216, 216, 216);
    _tipLabel.layer.cornerRadius = 8;
    _tipLabel.layer.masksToBounds = YES;
    
    _lineLabel = [UILabel new];
    _lineLabel.backgroundColor = TXBYColor(216, 216, 216);
    
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
    
    _picContainerView = [MyCirclePhotoView new];
    
    NSArray *views = @[_tipLabel, _lineLabel, _contentLabel, _timeLabel, _titleLable, _picContainerView];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    
    _tipLabel.sd_layout
    .leftSpaceToView(contentView, 30)
    .topSpaceToView(contentView, 0)
    .widthIs(16)
    .heightIs(16);
    
    _lineLabel.sd_layout
    .topSpaceToView(_tipLabel, -2)
    .centerXEqualToView(_tipLabel)
    .bottomEqualToView(contentView)
    .widthIs(1);
    
    _timeLabel.sd_layout
    .leftSpaceToView(_tipLabel, 8)
    .centerYEqualToView(_tipLabel)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _titleLable.sd_layout
    .leftEqualToView(_timeLabel)
    .topSpaceToView(_timeLabel, 10)
    .rightSpaceToView(contentView, 20)
    .autoHeightRatio(0);
//    .heightIs(21);
    
    _contentLabel.sd_layout
    .topSpaceToView(_titleLable, 10)
    .leftEqualToView(_titleLable)
    .rightSpaceToView(contentView, 20)
    .heightIs(25);
    
    _picContainerView.sd_layout
    .leftEqualToView(_timeLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
}

- (void)setModel:(TXBYCircleModel *)model {
    _model = model;

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
    UIView *bottomView;
    if (!model.imgs.count) {
        bottomView = _contentLabel;
    } else {
        bottomView = _picContainerView;
    }
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:20];
}

@end
