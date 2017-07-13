//
//  TXBYCommentHeaderToolBar.h
//  txzjPatient
//
//  Created by Limmy on 2017/4/25.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentHeaderCell.h"

@protocol TXBYCommentHeaderToolBarDelegate <NSObject>

- (void)commentHeaderToolClickAction:(UIButton *)btn;

@end

@interface TXBYCommentHeaderToolBar : UIView
/**
 *  model
 */
@property (nonatomic, strong) CommentHeaderModel *model;
/**
 *  delegate
 */
@property (nonatomic, weak) id<TXBYCommentHeaderToolBarDelegate> delegate;
/**
 *  likeBtn
 */
@property (nonatomic, weak) UIButton *likeBtn;
/**
 *  commonBtn
 */
@property (nonatomic, weak) UIButton *commonBtn;

@end
