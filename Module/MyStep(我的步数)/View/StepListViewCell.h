//
//  StepListViewCell.h
//  publicCommon
//
//  Created by Limmy on 2017/2/14.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepListModel.h"

@interface StepListViewCell : UITableViewCell
// 排名
@property (strong, nonatomic) IBOutlet UIButton *mark;
// image
@property (strong, nonatomic) IBOutlet UIImageView *image;
// name
@property (strong, nonatomic) IBOutlet UILabel *name;
// 步数
@property (strong, nonatomic) IBOutlet UILabel *step;
/**
 *  model
 */
@property (nonatomic, strong) StepListModel *model;

@property (strong, nonatomic) IBOutlet UILabel *love;

@property (strong, nonatomic) IBOutlet UIButton *button;

@property (strong, nonatomic) IBOutlet UIImageView *loveImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *stepWidth;

@end
