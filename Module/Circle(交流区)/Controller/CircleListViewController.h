//
//  CircleListViewController.h
//  txzjPatient
//
//  Created by Limmy on 2017/4/22.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleListViewController : UITableViewController
/**
 *  range
 */
@property (nonatomic, copy) NSString *range;
/**
 *  是否是医生端
 */
@property (nonatomic, assign) BOOL isDoctorUser;

@end
