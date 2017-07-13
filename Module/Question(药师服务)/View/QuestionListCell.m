//
//  QuestionListCell.m
//  publicCommon
//
//  Created by hj on 17/2/20.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "QuestionListCell.h"
#import "Question.h"
#import "QuestionLikeButton.h"
#import "QuestionReplyButton.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "QuestionImage.h"

@interface QuestionListCell ()

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
@property (assign, nonatomic) CGFloat photoHeight;

@end

@implementation QuestionListCell

- (CGFloat)photoHeight {
    if (!_photoHeight) {
        _photoHeight = (TXBYApplicationW - 10 * 4) / 3;
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
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.contentLabel.mas_bottom);
        }];
    }
    return _photosView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setQuestion:(Question *)question {
    _question = question;
    
    self.nameLabel.text = question.user_name;
    self.timeLabel.text = [question.create_time minutesAgo];
    self.contentLabel.text = question.content;
    
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[question.avatar stringByURLEncode]] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    self.likeButton.likeNumberStr = question.love;
    self.replyButton.comment = question.comment;
    
    self.likeButton.liking = question.is_loved.integerValue;
    [self addChildImage];
}

- (void)addChildImage{
    [self.photosView removeAllSubviews];
    self.photosViewArray = [NSMutableArray array];
    CGFloat margin = 10;
    
    NSArray *imageArray = self.question.imgs;
    
    CGFloat photosViewHeight;
    if (imageArray.count) {
        photosViewHeight = self.photosViewHeight;
    } else {
        photosViewHeight = 0;
    }
    [self.photosView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(photosViewHeight);
    }];
    
    for (NSInteger i = 0; i < imageArray.count; i++) {
        UIImageView *image = [[UIImageView alloc] init];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        image.userInteractionEnabled = YES;
        CGFloat imageX = (self.photoHeight + margin) * i +margin;
        
        if (i < 3) {
            CGFloat imageViewWidth = self.photoHeight;
            CGFloat imageViewHeight = self.photoHeight;
            
            // 只有一张图片的情况下，按图片比例显示
            if (self.question.imgs.count == 1) {
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
    for (QuestionImage *questionImage in self.question.imgs) {
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
