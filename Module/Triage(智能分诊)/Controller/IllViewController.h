//
//  IllViewController.h
//  smh
//
//  Created by yh on 15/3/21.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  疾病

#import <UIKit/UIKit.h>
@class TriageParam;

@interface IllViewController : UITableViewController

/**
 *  请求参数对象
 */
@property (nonatomic, strong) TriageParam *param;

@end