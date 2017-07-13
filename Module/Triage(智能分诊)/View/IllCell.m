//
//  IllCell.m
//  smh
//
//  Created by yh on 15/3/21.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//

#import "IllCell.h"
#import "Ill.h"

@interface IllCell ()
/**
 *  名称
 */
@property (nonatomic, weak) UILabel *nameLabel;
/**
 *  患病部位
 */
@property (nonatomic, weak) UILabel *partLabel;
/**
 *  科室
 */
@property (nonatomic, weak) UILabel *deptLabel;
/**
 *  描述
 */
@property (nonatomic, weak) UILabel *descLabel;

@end

@implementation IllCell

#pragma mark - setter
- (void)setIll:(Ill *)ill {
    _ill = ill;
    
    // 名称
    self.nameLabel.text = ill.disease_name;
    self.nameLabel.frame = ill.nameFrame;
    self.nameLabel.font = ill.nameFont;
    
    // 部位
    self.partLabel.text = ill.part;
    self.partLabel.frame = ill.partFrame;
    self.partLabel.font = ill.detailFont;
    
    // 就诊科室
    self.deptLabel.text = ill.medical_dept;
    self.deptLabel.frame = ill.deptFrame;
    self.deptLabel.font = ill.detailFont;
    
    // 描述
    self.descLabel.text = ill.content;
    self.descLabel.frame = ill.descFrame;
    self.descLabel.font = ill.detailFont;
}

#pragma mark - init
/**
 *  创建
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置cell属性
        [self setupCell];
        
        // 添加子视图
        [self setupSubViews];
    }
    return self;
}

#pragma mark - parivate
/**
 *  设置cell属性
 */
- (void)setupCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

/**
 *  添加子视图
 */
- (void)setupSubViews {
    // 名称
    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:nameLabel];
    
    // 部位
    UILabel *partLabel = [[UILabel alloc] init];
    self.partLabel = partLabel;
    self.partLabel.textColor = [UIColor blackColor];
    self.partLabel.numberOfLines = 0;
    self.partLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:partLabel];
    
    // 部门
    UILabel *deptLabel = [[UILabel alloc] init];
    self.deptLabel = deptLabel;
    self.deptLabel.textColor = [UIColor blackColor];
    self.deptLabel.numberOfLines = 0;
    self.deptLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:deptLabel];
    
    // 描述
    UILabel *descLabel = [[UILabel alloc] init];
    self.descLabel = descLabel;
    self.descLabel.textColor = [UIColor blackColor];
    self.descLabel.numberOfLines = 0;
    self.descLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:descLabel];
}

@end