//
//  MyCircleCommentCell.m
//  txzjPatient
//
//  Created by Limmy on 2017/4/28.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "MyCircleCommentCell.h"
#import "TTTAttributedLabel.h"
#import "TXBYCircleModel.h"
#import "TXBYCircleImg.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface MyCircleCommentCell()<TTTAttributedLabelDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *circleImg;
@property (strong, nonatomic) IBOutlet UILabel *circleTitle;
@property (strong, nonatomic) IBOutlet UILabel *circleContent;

@end

@implementation MyCircleCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.circleImg.contentMode = UIViewContentModeScaleAspectFill;
    self.circleImg.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MyCircleCommentModel *)model {
    _model = model;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.comment.avatar] placeholderImage:[UIImage imageNamed:@"mine_avatar"]];
    self.nameLab.text = model.comment.user_name;
    self.timeLab.text = [model.comment.create_time minutesAgo];
    NSString *content = model.comment.content;
    if (model.comment.imgs.count) {
        // 如果有图片
        content = [NSString stringWithFormat:@"%@ 查看图片",content];
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:content];
    
    // 设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为10
    [paragraphStyle setLineSpacing:5];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:TXBYColor(100,100,100) range:NSMakeRange(0, content.length)];
    
    NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionaryWithDictionary:self.contentLabel.linkAttributes];
    [linkAttributes setObject:TXBYMainColor forKey:(NSString *)kCTForegroundColorAttributeName];
    self.contentLabel.linkAttributes = linkAttributes;
    
    self.contentLabel.text = content;
    self.contentLabel.delegate = self;
    
    if (model.comment.imgs.count) {
        [self.contentLabel addLinkToTransitInformation:@{@"imags":model.comment.imgs} withRange:NSMakeRange(content.length - 4, 4)];
    }
    
    TXBYCircleImg *img = model.quest.imgs.lastObject;
    if (!img.url.length) {
        img = [TXBYCircleImg new];
        img.url = model.quest.avatar;
    }
    [self.circleImg sd_setImageWithURL:[NSURL URLWithString:img.url] placeholderImage:[UIImage imageNamed:@"image_default"]];
    self.circleTitle.text = model.quest.title;
    if (model.quest.user_type.integerValue == 100) {
        self.circleTitle.hidden = YES;
    } else {
        self.circleTitle.hidden = NO;
    }
    self.circleContent.text = model.quest.content;
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithTransitInformation:(NSDictionary *)components {
    
    NSArray *imgs = components[@"imags"];
    int i= 0;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (TXBYCircleImg *questionImage in imgs) {
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        mjphoto.url = [NSURL URLWithString:[questionImage.url stringByURLEncode]];
        mjphoto.index = i;
        mjphoto.firstShow = YES;
        [tempArray addObject:mjphoto];
        i++;
    }
    //创建图片浏览器对象
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    //MJPhoto
    browser.photos = tempArray;
    
    [browser show];
}

@end
