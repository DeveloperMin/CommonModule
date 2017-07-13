//
//  QuestionPrimaryReplyCell.m
//  publicCommon
//
//  Created by hj on 17/2/21.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "CirclePrimaryReplyCell.h"
#import "CircleLikeButton.h"
#import "CircleReplyButton.h"
#import "TXBYCircleReply.h"
#import "TXBYCircleModel.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "TXBYCircleImg.h"

@interface CirclePrimaryReplyCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet CircleLikeButton *likeButton;
@property (strong, nonatomic) IBOutlet UIImageView *signView;
@property (weak, nonatomic) IBOutlet CircleReplyButton *replyButton;
/**
 *  photosView
 */
@property (strong, nonatomic) UIView *photosView;
@property (strong, nonatomic) NSMutableArray *photosViewArray;

@property (assign, nonatomic) CGFloat photosViewHeight;
@property (assign, nonatomic) CGFloat photosViewWidth;
@property (assign, nonatomic) CGFloat photoHeight;

@property (nonatomic, strong) UIColor *nameColor;
@property (nonatomic, strong) UIColor *bgColor;

@property (nonatomic, strong) UIColor *atColor;
@property (nonatomic, strong) UIColor *normalColor;

@end

@implementation CirclePrimaryReplyCell

- (UIColor *)atColor {
    return TXBYColor(58,178,255);
}

- (UIColor *)normalColor {
    return TXBYColor(100,100,100);
}

- (CGFloat)photosViewWidth {
    if (!_photosViewWidth) {
        _photosViewWidth = TXBYApplicationW - 20;
    }
    return _photosViewWidth;
}

- (CGFloat)photoHeight {
    if (!_photoHeight) {
        _photoHeight = (self.photosViewWidth - 10 * 2) / 3;
    }
    return _photoHeight;
}

- (CGFloat)photosViewHeight {
    if (!_photosViewHeight) {
        _photosViewHeight = self.photoHeight + 20;
    }
    return _photosViewHeight;
}

- (UIView *)photosView {
    if (!_photosView) {
        _photosView = [UIView new];
        [self.contentView addSubview:_photosView];
        [_photosView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self.contentLabel.mas_bottom);
        }];
    }
    return _photosView;
}

- (void)setNameColor:(UIColor *)nameColor {
    _nameColor = nameColor;
    self.nameLabel.textColor = nameColor;
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.contentView.backgroundColor = bgColor;
}

- (void)setIsMinorReply:(BOOL)isMinorReply {
    _isMinorReply = isMinorReply;
//    self.nameColor = TXBYColor(58, 178, 255);
    self.bgColor = TXBYColor(245,245,245);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewClickAction:)];
    [self.avatarView addGestureRecognizer:tap];
    self.avatarView.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (IBAction)likeButtonClick:(CircleLikeButton *)btn {
    if (self.likeButtonBlock) {
        self.likeButtonBlock(btn);
    }
}
- (IBAction)replyButtonClick:(UIButton *)btn {
    if (self.replyButtonBlock) {
        self.replyButtonBlock(btn);
    }
}

- (void)setCircleReply:(TXBYCircleReply *)circleReply {
    _circleReply = circleReply;
    
    self.nameLabel.text = circleReply.user_name;
    self.timeLabel.text = [circleReply.create_time minutesAgo];
    self.contentLabel.text = circleReply.content;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[circleReply.avatar stringByURLEncode]] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    if (circleReply.type.integerValue == 200) {
        self.signView.hidden = NO;
        if (circleReply.user_role.integerValue == 2) {
            _signView.image = [UIImage imageNamed:@"Circle.bundle/secretary_sign"];
        } else {
            _signView.image = [UIImage imageNamed:self.isDoctorUser? @"Circle.bundle/doctor_sign":@"Circle.bundle/patient_sign"];
        }
    } else {
        self.signView.hidden = YES;
    }
    [self.likeButton setTitleColor:self.isDoctorUser?TXBYColor(252, 94, 129):TXBYColor(60, 132, 253) forState:UIControlStateSelected];
    if (self.isDoctorUser) {
        [self.likeButton setImage:[UIImage imageNamed:@"Circle.bundle/doctor_circle_like"] forState:UIControlStateSelected];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"Circle.bundle/patient_circle_like"] forState:UIControlStateSelected];
    }
    self.replyButton.comment = [NSString stringWithFormat:@"%zd",circleReply.sub.count];
    self.likeButton.likeNumberStr = circleReply.love;
    self.likeButton.selected = circleReply.is_loved.integerValue;
    if (circleReply.imgs.count) {
        [self addChildImage];
    } else {
        [self.photosView removeAllSubviews];
    }
    
    if (self.isMinorReply) {
        NSString *content = circleReply.content;
        
        if (circleReply.at_user_name.length) {
            content = [NSString stringWithFormat:@"回复%@：%@",circleReply.at_user_name,circleReply.content];
        }
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:content];
        [attrStr addAttribute:NSForegroundColorAttributeName value:self.normalColor range:NSMakeRange(0, circleReply.content.length)];
        if (circleReply.at_user_name.length) {
            [attrStr addAttribute:NSForegroundColorAttributeName value:TXBYMainColor range:NSMakeRange(2, circleReply.at_user_name.length)];
        }
        
        self.contentLabel.attributedText = attrStr;
    }
}

- (void)iconViewClickAction:(UIGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(detialViewCellClickAvatar:)]) {
        [self.delegate detialViewCellClickAvatar:self.circleReply];
    }
}

- (void)setCircleModel:(TXBYCircleModel *)circleModel {
    _circleModel = circleModel;
    
    self.nameLabel.text = circleModel.name;
    self.timeLabel.text = [circleModel.create_time minutesAgo];
    self.contentLabel.text = circleModel.content;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[circleModel.avatar stringByURLEncode]] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    if (circleModel.user_type.integerValue == 200) {
        self.signView.hidden = NO;
        if (circleModel.user_role.integerValue == 2) {
            _signView.image = [UIImage imageNamed:@"Circle.bundle/secretary_sign"];
        } else {
            _signView.image = [UIImage imageNamed:self.isDoctorUser? @"Circle.bundle/doctor_sign":@"Circle.bundle/patient_sign"];
        }
    } else {
        self.signView.hidden = YES;
    }
    self.replyButton.comment = circleModel.comment;
    self.likeButton.likeNumberStr = circleModel.love;
    self.likeButton.selected = circleModel.is_loved.integerValue;
    if (circleModel.imgs.count) {
        [self addChildImage];
    } else {
        [self.photosView removeAllSubviews];
    }
}

- (void)addChildImage{
    [self.photosView removeAllSubviews];
    self.photosViewArray = [NSMutableArray array];
    CGFloat margin = 2;
    CGFloat photosViewX = 10;
    NSArray *imageArray;
    if (self.circleModel) {
        imageArray = self.circleModel.imgs;
    } else {
        imageArray = self.circleReply.imgs;
        photosViewX = 61;
        self.photosViewWidth = TXBYApplicationW - 61 - 15;
        self.photoHeight = (self.photosViewWidth - margin * 2) / 3;
        self.photosViewHeight = self.photoHeight + margin * 2;
    }
    
    CGFloat photosViewHeight;
    if (imageArray.count) {
        photosViewHeight = self.photosViewHeight;
    } else {
        photosViewHeight = 0;
    }
    [self.photosView updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(photosViewX);
        make.height.equalTo(photosViewHeight);
    }];
    
    for (NSInteger i = 0; i < imageArray.count; i++) {
        UIImageView *image = [[UIImageView alloc] init];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        image.userInteractionEnabled = YES;
        CGFloat imageX = (self.photoHeight + margin) * i;
        
        if (i < 3) {
            CGFloat imageViewWidth = self.photoHeight;
            CGFloat imageViewHeight = self.photoHeight;
            
            // 只有一张图片的情况下，按图片比例显示
            if (imageArray.count == 1) {
                TXBYCircleImg *questionImage = imageArray[0];
                CGFloat imageViewMaxWH = TXBYApplicationW / 2.2;
                CGFloat imageWidth = questionImage.width;
                CGFloat imageHeight = questionImage.height;
                if (imageWidth > imageHeight) {
                    imageViewWidth = imageViewMaxWH;
                    imageViewHeight = MAX(imageViewMaxWH * imageHeight / imageWidth, imageViewMaxWH * 0.4);
                } else {
                    imageViewWidth = MAX(imageViewMaxWH * imageWidth / imageHeight, imageViewMaxWH * 0.4);
                    imageViewHeight = imageViewMaxWH * 0.8;
                }
                [self.photosView updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(imageViewHeight + 20);
                }];
            }
            
            image.frame = CGRectMake(imageX, 10, imageViewWidth, imageViewHeight);
            
            [self.photosView addSubview:image];
            [self.photosViewArray  addObject:image];
            
            TXBYCircleImg *questionImage = imageArray[i];
            [image sd_setImageWithURL:[NSURL URLWithString:questionImage.url] placeholderImage:[UIImage imageNamed:@"image_default"]];
            [image sd_setImageWithURL:[NSURL URLWithString:questionImage.url]];
            image.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigImage:)];
            [image addGestureRecognizer:tap];
        }
    }
}

- (void)bigImage:(UIGestureRecognizer *)tap {
    UIImageView *tapView = (UIImageView *)tap.view;
    int i= 0;
    NSMutableArray *tempArray = [NSMutableArray array];
    
    NSArray *imageArray;
    if (self.circleModel) {
        imageArray = self.circleModel.imgs;
    } else {
        imageArray = self.circleReply.imgs;
    }
    
    for (TXBYCircleImg *questionImage in imageArray) {
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        mjphoto.url = [NSURL URLWithString:[questionImage.url stringByURLEncode]];
        mjphoto.index = i;
        mjphoto.firstShow = YES;
        mjphoto.srcImageView = self.photosViewArray[i];
        [tempArray addObject:mjphoto];
        i++;
    }
    //创建图片浏览器对象
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    //MJPhoto
    browser.photos = tempArray;
    browser.currentPhotoIndex = tapView.tag;
    
    [browser show];
}


@end
