//
//  QuestionMinorReplyCell.m
//  publicCommon
//
//  Created by hj on 17/2/21.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "CircleMinorReplyCell.h"
#import "TXBYCircleReply.h"
#import "TTTAttributedLabel.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "TXBYCircleImg.h"

@interface CircleMinorReplyCell ()<TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;

@property (nonatomic, strong) UIColor *atColor;
@property (nonatomic, strong) UIColor *normalColor;

@end

@implementation CircleMinorReplyCell

- (UIColor *)atColor {
    return TXBYColor(58,178,255);
}

- (UIColor *)normalColor {
    return TXBYColor(100,100,100);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLabel.font = [UIFont systemFontOfSize:13];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.contentLabel.backgroundColor = TXBYColor(221, 221, 221);
    } else {
        self.contentLabel.backgroundColor = TXBYColor(245, 245, 245);;
    }
}

- (void)setCircleReply:(TXBYCircleReply *)circleReply{
    _circleReply = circleReply;
    NSString *content;
    if (circleReply.at_user_name.length) {
        content = [NSString stringWithFormat:@"%@回复%@: %@",circleReply.user_name, circleReply.at_user_name,circleReply.content];
    } else {
        content = [NSString stringWithFormat:@"%@: %@",circleReply.user_name, circleReply.content];
    }
    if (circleReply.imgs.count) {
        // 如果有图片
        content = [NSString stringWithFormat:@"%@ 查看图片",content];
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:content];
    // 设置字体大小和颜色
    [attrStr addAttribute:NSForegroundColorAttributeName value:self.normalColor range:NSMakeRange(0, content.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, content.length)];
    // 设置用户名的颜色
    [attrStr addAttribute:NSForegroundColorAttributeName value:TXBYMainColor range:NSMakeRange(0, circleReply.user_name.length)];
    if (circleReply.at_user_name.length) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:TXBYMainColor range:NSMakeRange(circleReply.user_name.length + 2, circleReply.at_user_name.length)];
    }
    
    // 设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为10
    [paragraphStyle setLineSpacing:5];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    self.contentLabel.text = attrStr;
    self.contentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    self.contentLabel.delegate = self;
    
    NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionaryWithDictionary:self.contentLabel.linkAttributes];
    [linkAttributes setObject:TXBYMainColor forKey:(NSString *)kCTForegroundColorAttributeName];
    self.contentLabel.linkAttributes = linkAttributes;
    
    if (circleReply.imgs.count) {
        [self.contentLabel addLinkToTransitInformation:@{@"imgs":circleReply.imgs} withRange:NSMakeRange(attrStr.length - 4, 4)];
    }
}

- (void)setTotalReply:(NSString *)totalReply {
    _totalReply = [totalReply copy];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:totalReply];
    [attrStr addAttribute:NSForegroundColorAttributeName value:TXBYMainColor range:NSMakeRange(0, totalReply.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, attrStr.length)];
    self.contentLabel.text = attrStr;
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithTransitInformation:(NSDictionary *)components {
    
    NSArray *imgs = components[@"imgs"];
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
