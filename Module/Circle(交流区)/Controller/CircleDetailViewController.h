//
//  CircleDetailViewController.h
//  txzjPatient
//
//  Created by Limmy on 2017/4/25.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleDetailViewController : UIViewController
/**
 *  ID(问题id)
 */
@property (nonatomic, copy) NSString *circleID;
/**
 *  是否是医生端
 */
@property (nonatomic, assign) BOOL isDoctorUser;
// 更新数据
- (void)updateList;

@end
