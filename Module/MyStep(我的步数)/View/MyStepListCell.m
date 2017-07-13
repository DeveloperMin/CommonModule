//
//  MyStepListCell.m
//  publicCommon
//
//  Created by Limmy on 2017/2/15.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "MyStepListCell.h"
#import "AccountTool.h"

@implementation MyStepListCell

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
    if (model.avatar.length) {
        [self.image sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    } else {
        [self.image sd_setImageWithURL:[NSURL URLWithString:[AccountTool account].avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    }
    self.name.text = model.name.length?model.name:[AccountTool account].user_name;
    CGFloat stepW = [model.step sizeWithFont:[UIFont systemFontOfSize:20]].width + 5;
    self.stepWidth.constant = MAX(stepW, 35);
    self.step.text = model.step.length?model.step:@"0";
    if (model.order.integerValue) {
        self.myRank.text = [NSString stringWithFormat:@"第%@名", model.order];
    } else {
        self.myRank.text = @"无排名";
    }
    
}

@end
