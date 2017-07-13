//
//  TXBYCircleLoveCell.m
//  txzjPatient
//
//  Created by Limmy on 2017/4/27.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "TXBYCircleLoveCell.h"

@implementation TXBYCircleLoveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(TXBYCircleLoveModel *)model {
    _model = model;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"mine_avatar"]];
    self.title.text = model.user_name;
}

@end
