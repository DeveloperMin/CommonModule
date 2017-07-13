//
//  TXBYCircleLoveCell.h
//  txzjPatient
//
//  Created by Limmy on 2017/4/27.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXBYCircleLoveModel.h"

@interface TXBYCircleLoveCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *title;

/**
 *  model
 */
@property (nonatomic, strong) TXBYCircleLoveModel *model;

@end
