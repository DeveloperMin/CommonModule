//
//  StepLoveCell.m
//  publicCommon
//
//  Created by Limmy on 2017/2/15.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "StepLoveCell.h"

@implementation StepLoveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.image.layer.masksToBounds = YES;
    self.image.layer.cornerRadius = self.image.txby_width * 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MyLovePersonModel *)model {
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.name.text = model.user_name;
    self.time.text = model.create_time.minutesAgo;
}

@end
