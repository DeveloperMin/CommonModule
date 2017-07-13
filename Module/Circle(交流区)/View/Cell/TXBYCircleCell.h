//
//  TXBYCommunityCell.h
//  TXBYCommunity
//
//  Created by Limmy on 2017/4/13.
//  Copyright © 2017年 Limmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXBYCirclePhotoView.h"
#import "TXBYCircleToolBar.h"
@class TXBYCircleModel;

@protocol TXBYCircleCellDeleagte <NSObject>

- (void)toolBarClickBtn:(UIButton *)btn WithIndePath:(NSIndexPath *)indexPath;

- (void)iconViewClickAction:(TXBYCircleModel *)model;

@end

@interface TXBYCircleCell : UITableViewCell {
    UILabel *_user_title;
    UIImageView *_iconView;
    UIImageView *_signView;
    UILabel *_nameLable;
    UILabel *_titleLable;
    UILabel *_contentLabel;
    TXBYCirclePhotoView *_picContainerView;
    UILabel *_timeLabel;
    UIButton *_moreButton;
    TXBYCircleToolBar *_toolBarView;
}
/**
 * delegate
 */
@property (nonatomic, weak) id<TXBYCircleCellDeleagte> delegate;
/**
 *  model
 */
@property (nonatomic, strong) TXBYCircleModel *model;
/**
 * indexPath
 */
@property (nonatomic, strong) NSIndexPath *indexPath;
/**
 *  是否是医生端
 */
@property (nonatomic, assign) BOOL isDoctorUser;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);

@end
