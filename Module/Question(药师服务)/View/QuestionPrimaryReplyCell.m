//
//  QuestionPrimaryReplyCell.m
//  publicCommon
//
//  Created by hj on 17/2/21.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "QuestionPrimaryReplyCell.h"
#import "QuestionLikeButton.h"
#import "QuestionReplyButton.h"
#import "QuestionReply.h"
#import "Question.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface QuestionPrimaryReplyCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet QuestionLikeButton *likeButton;
@property (weak, nonatomic) IBOutlet QuestionReplyButton *replyButton;
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

@implementation QuestionPrimaryReplyCell

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
            make.right.equalTo(self.mas_right);
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
    self.nameColor = TXBYColor(58, 178, 255);
    self.bgColor = TXBYColor(245,245,245);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (IBAction)likeButtonClick:(id)sender {
    if (self.likeButtonBlock) {
        self.likeButtonBlock();
    }
}
- (IBAction)replyButtonClick:(id)sender {
    if (self.replyButtonBlock) {
        self.replyButtonBlock();
    }
}

- (void)setQuestionReply:(QuestionReply *)questionReply {
    _questionReply = questionReply;
    
    self.nameLabel.text = questionReply.user_name;
    self.timeLabel.text = [questionReply.create_time minutesAgo];
    self.contentLabel.text = questionReply.content;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[questionReply.avatar stringByURLEncode]] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    self.replyButton.comment = [NSString stringWithFormat:@"%lu",questionReply.sub.count];
    self.likeButton.likeNumberStr = questionReply.love;
    self.likeButton.liking = questionReply.is_loved.integerValue;
    [self addChildImage];
    
    if (self.isMinorReply) {
        NSString *content = questionReply.content;
        
        if (questionReply.at_user_name.length) {
            content = [NSString stringWithFormat:@"回复%@：%@",questionReply.at_user_name,questionReply.content];
        }
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:content];
        if (questionReply.at_user_name.length) {
            [attrStr addAttribute:NSForegroundColorAttributeName value:self.atColor range:NSMakeRange(0, questionReply.at_user_name.length + 3)];
            [attrStr addAttribute:NSForegroundColorAttributeName value:self.normalColor range:NSMakeRange(questionReply.at_user_name.length + 3, questionReply.content.length)];
        }
        
        self.contentLabel.attributedText = attrStr;
    }
}

- (void)setQuestion:(Question *)question {
    _question = question;
    
    self.nameLabel.text = question.user_name;
    self.timeLabel.text = [question.create_time minutesAgo];
    self.contentLabel.text = question.content;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[question
                                                              .avatar stringByURLEncode]] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.replyButton.comment = question.comment;
    self.likeButton.likeNumberStr = question.love;
    self.likeButton.liking = question.is_loved.integerValue;
    [self addChildImage];
}

- (void)addChildImage{
    [self.photosView removeAllSubviews];
    self.photosViewArray = [NSMutableArray array];
    
    CGFloat margin = 10;
    
    CGFloat photosViewX = 10;
    
    NSArray *imageArray;
    if (self.question) {
        imageArray = self.question.imgs;
    } else {
        imageArray = self.questionReply.imgs;
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
                QuestionImage *questionImage = imageArray[0];
                CGFloat imageViewMaxWH = TXBYApplicationW / 2.2;
                CGFloat imageWidth = questionImage.width.doubleValue;
                CGFloat imageHeight = questionImage.height.doubleValue;
                if (imageWidth > imageHeight) {
                    imageViewWidth = imageViewMaxWH;
                    imageViewHeight = MAX(imageViewMaxWH * imageHeight / imageWidth, imageViewMaxWH * 0.4);
                } else {
                    imageViewHeight = imageViewMaxWH;
                    imageViewWidth = MAX(imageViewMaxWH * imageWidth / imageHeight, imageViewMaxWH * 0.4);
                }
            }
            
            image.frame = CGRectMake(imageX, 10, imageViewWidth, imageViewHeight);
            
            [self.photosView addSubview:image];
            [self.photosViewArray  addObject:image];
            
            QuestionImage *questionImage = imageArray[i];
            
            [image sd_setImageWithURL:[NSURL URLWithString:[questionImage.url stringByURLEncode]]];
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
    if (self.question) {
        imageArray = self.question.imgs;
    } else {
        imageArray = self.questionReply.imgs;
    }
    
    for (QuestionImage *questionImage in imageArray) {
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
