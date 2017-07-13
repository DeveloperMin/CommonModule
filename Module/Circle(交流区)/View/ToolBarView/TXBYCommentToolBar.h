//
//  TXBYCommentToolBar.h
//  txzjPatient
//
//  Created by Limmy on 2017/4/25.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentHeaderModel;

@protocol TXBYCommentToolBarDelegate <NSObject>

- (void)circleToolBarClickBtn:(UIButton *)btn;

@end
@interface TXBYCommentToolBar : UIView
/**
 *  是否是医生端
 */
@property (nonatomic, assign) BOOL isDoctorUser;
/**
 *  delegate
 */
@property (nonatomic, weak) id<TXBYCommentToolBarDelegate> delegate;
/**
 *  model
 */
@property (nonatomic, strong) CommentHeaderModel *model;

@end
