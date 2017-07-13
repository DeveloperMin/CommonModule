//
//  StepLoveCell.h
//  publicCommon
//
//  Created by Limmy on 2017/2/15.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLovePersonModel.h"

@interface StepLoveCell : UITableViewCell
// image
@property (strong, nonatomic) IBOutlet UIImageView *image;
// name
@property (strong, nonatomic) IBOutlet UILabel *name;
// time
@property (strong, nonatomic) IBOutlet UILabel *time;

/**
 *  model
 */
@property (nonatomic, strong) MyLovePersonModel *model;

@end
