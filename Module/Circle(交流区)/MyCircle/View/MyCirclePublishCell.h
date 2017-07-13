//
//  MyCirclePublishCell.h
//  txzjPatient
//
//  Created by Limmy on 2017/4/28.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXBYCircleModel.h"

@interface MyCirclePublishCell : UITableViewCell
/**
 *  indexPath
 */
@property (nonatomic, strong) NSIndexPath *indexPath;
/**
 *  model
 */
@property (nonatomic, strong) TXBYCircleModel *model;

@end
