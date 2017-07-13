//
//  MyStepListCell.h
//  publicCommon
//
//  Created by Limmy on 2017/2/15.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepListModel.h"

@interface MyStepListCell : UITableViewCell
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
// myRank
@property (strong, nonatomic) IBOutlet UILabel *myRank;
// button
@property (strong, nonatomic) IBOutlet UIButton *button;
// love
@property (strong, nonatomic) IBOutlet UILabel *love;
// loveImage
@property (strong, nonatomic) IBOutlet UIImageView *loveImage;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *stepWidth;

@end
