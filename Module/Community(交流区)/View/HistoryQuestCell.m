//
//  HistoryQuestCell.m
//  ydyl
//
//  Created by Limmy on 16/9/9.
//  Copyright © 2016年 txby. All rights reserved.
//

#import "HistoryQuestCell.h"

@interface HistoryQuestCell ()

@property (nonatomic, strong) UIImageView *historyImage;

@end

@implementation HistoryQuestCell

- (UIImageView *)historyImage {
    if (!_historyImage) {
        _historyImage = [[UIImageView alloc] init];
        _historyImage.image = [UIImage imageNamed:@"community.bundle/history"];
        [self.contentView addSubview:_historyImage];
        [_historyImage makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(8);
            make.width.equalTo(25);
            make.height.equalTo(25);
        }];
    }
    return _historyImage;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"×" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:25];
//        _deleteBtn.backgroundColor = [UIColor redColor];
        _deleteBtn.userInteractionEnabled = YES;
        [self.contentView addSubview:_deleteBtn];
        [_deleteBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-8);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(40);
            make.height.equalTo(40);
        }];
    }
    return _deleteBtn;
}

- (UILabel *)title {
    if (!_title) {
        _title = [UILabel new];
//        _title.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_title];
        [_title makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.historyImage.mas_right).offset(8);
            make.right.equalTo(self.deleteBtn.mas_left).offset(-8);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
    return _title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
