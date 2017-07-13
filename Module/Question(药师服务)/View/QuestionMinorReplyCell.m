//
//  QuestionMinorReplyCell.m
//  publicCommon
//
//  Created by hj on 17/2/21.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "QuestionMinorReplyCell.h"
#import "QuestionReply.h"
#import "TTTAttributedLabel.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface QuestionMinorReplyCell ()<TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;

@property (nonatomic, strong) UIColor *atColor;
@property (nonatomic, strong) UIColor *normalColor;

@end

@implementation QuestionMinorReplyCell

- (UIColor *)atColor {
    return TXBYColor(58,178,255);
}

- (UIColor *)normalColor {
    return TXBYColor(100,100,100);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.contentLabel.backgroundColor = TXBYColor(221, 221, 221);
    } else {
        self.contentLabel.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setQuestionReply:(QuestionReply *)questionReply {
    
    NSString *content = questionReply.content;
    
    if (questionReply.at_user_name.length) {
        content = [NSString stringWithFormat:@"回复%@：%@",questionReply.at_user_name,questionReply.content];
    }
    if (questionReply.imgs.count) {
        // 如果有图片
        content = [NSString stringWithFormat:@"%@ 查看图片",content];
    }
    
    NSString *contentStr = [NSString stringWithFormat:@"%@：%@",questionReply.user_name,content];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:self.atColor range:NSMakeRange(0, questionReply.user_name.length + 1)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:self.normalColor range:NSMakeRange(questionReply.user_name.length + 1, content.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, contentStr.length)];
    
    self.contentLabel.font = [UIFont systemFontOfSize:20];
    self.contentLabel.text = attrStr;
    self.contentLabel.delegate = self;
    
    NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionaryWithDictionary:self.contentLabel.linkAttributes];
    [linkAttributes setObject:TXBYMainColor forKey:(NSString *)kCTForegroundColorAttributeName];
    self.contentLabel.linkAttributes = linkAttributes;
    
    
    if (questionReply.imgs.count) {
        [self.contentLabel addLinkToTransitInformation:@{@"imgs":questionReply.imgs} withRange:NSMakeRange(attrStr.length - 4, 4)];
    }
}

- (void)setTotalReply:(NSString *)totalReply {
    _totalReply = [totalReply copy];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:totalReply];
    [attrStr addAttribute:NSForegroundColorAttributeName value:self.atColor range:NSMakeRange(0, totalReply.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, attrStr.length)];
    self.contentLabel.text = attrStr;
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithTransitInformation:(NSDictionary *)components {
    
    NSArray *imgs = components[@"imgs"];
    int i= 0;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (QuestionImage *questionImage in imgs) {
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
