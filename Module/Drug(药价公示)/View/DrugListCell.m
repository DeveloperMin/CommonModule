//
//  DrugListCell.m
//  publicCommon
//
//  Created by hj on 2017/6/28.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "DrugListCell.h"
#import "Drug.h"

@interface DrugListCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation DrugListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDrug:(Drug *)drug {
    self.titleLabel.text = drug.cpm;
    self.descLabel.text = drug.scs_desc;
}

@end
