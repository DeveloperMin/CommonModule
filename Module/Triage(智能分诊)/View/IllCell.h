//
//  IllCell.h
//  smh
//
//  Created by yh on 15/3/21.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  疾病控制器cell

#import <UIKit/UIKit.h>
@class Ill;

@interface IllCell : UITableViewCell

/**
 *  ill模型
 */
@property (nonatomic, strong) Ill *ill;

@end