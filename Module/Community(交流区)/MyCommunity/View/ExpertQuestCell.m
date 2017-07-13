//
//  ExpertQuestCell.m
//  ydyl
//
//  Created by Limmy on 2016/9/26.
//  Copyright © 2016年 txby. All rights reserved.
//

#import "ExpertQuestCell.h"

@implementation ExpertQuestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(CommunityListItem *)item {
    _item = item;
    [self.image sd_setImageWithURL:[NSURL URLWithString:item.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.title.text = item.title;
    self.quester.text = item.user_name;
    self.content.text = item.content;
    self.time.text = [item.create_time minutesAgo];
}

@end
