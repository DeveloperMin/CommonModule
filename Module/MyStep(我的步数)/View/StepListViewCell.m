//
//  StepListViewCell.m
//  publicCommon
//
//  Created by Limmy on 2017/2/14.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "StepListViewCell.h"

@implementation StepListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.image.layer.masksToBounds = YES;
    self.image.layer.cornerRadius = self.image.txby_width * 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(StepListModel *)model {
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    CGFloat stepW = [model.step sizeWithFont:[UIFont systemFontOfSize:20]].width + 5;
    self.stepWidth.constant = MAX(stepW, 35);
    self.name.text = model.name;
    self.step.text = model.step;
    // 重装mark
    [self.mark setImage:nil forState:UIControlStateNormal];
    [self.mark setTitle:nil forState:UIControlStateNormal];
    if (model.order.integerValue == 1) {
        [self.mark setImage:[UIImage imageNamed:@"myStep.bundle/gold"] forState:UIControlStateNormal];
    } else if (model.order.integerValue == 2) {
        [self.mark setImage:[UIImage imageNamed:@"myStep.bundle/sliver"] forState:UIControlStateNormal];
    } else if (model.order.integerValue == 3) {
        [self.mark setImage:[UIImage imageNamed:@"myStep.bundle/copper"] forState:UIControlStateNormal];
    } else {
        [self.mark setTitle:model.order forState:UIControlStateNormal];
    }
}

@end
