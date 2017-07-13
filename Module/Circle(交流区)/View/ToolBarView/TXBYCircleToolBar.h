//
//  TXBYCircleToolBar.h
//  txzjPatient
//
//  Created by Limmy on 2017/4/24.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TXBYCircleModel;

@protocol TXBYCircleToolBarDelegate <NSObject>

- (void)circleToolBarClickBtn:(UIButton *)btn;

@end

@interface TXBYCircleToolBar : UIView
/**
 *  circleModel
 */
@property (nonatomic, strong) TXBYCircleModel *circleModel;

/**
 *  delegate
 */
@property (nonatomic, weak) id<TXBYCircleToolBarDelegate> delegate;
/**
 *  是否是医生端
 */
@property (nonatomic, assign) BOOL isDoctorUser;
@end
