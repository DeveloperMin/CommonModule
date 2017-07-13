//
//  CommentHeaderView.h
//  txzjPatient
//
//  Created by Limmy on 2017/4/25.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXBYCirclePhotoView.h"
@class CommentHeaderModel;

@protocol CommentHeaderCellDeleagte <NSObject>

- (void)iconViewClickAction:(CommentHeaderModel *)model;

@end
@interface CommentHeaderCell : UITableViewCell {
    UIImageView *_iconView;
    UIImageView *_signView;
    UILabel *_user_title;
    UILabel *_nameLable;
    UILabel *_titleLable;
    UILabel *_contentLabel;
    TXBYCirclePhotoView *_picContainerView;
    UILabel *_timeLabel;
}
/**
 *  是否是医生端
 */
@property (nonatomic, assign) BOOL isDoctorUser;
/**
 *  model
 */
@property (nonatomic, strong) CommentHeaderModel *model;
/**
 * delegate
 */
@property (nonatomic, weak) id<CommentHeaderCellDeleagte> delegate;

@end

@interface CommentHeaderModel : NSObject
/**
 *  ID
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  uid
 */
@property (nonatomic, copy) NSString *uid;
/**
 *  avatar
 */
@property (nonatomic, copy) NSString *avatar;
/**
 *  user_title
 */
@property (nonatomic, copy) NSString *user_title;
/**
 *  content
 */
@property (nonatomic, copy) NSString *content;
/**
 *  imgs
 */
@property (nonatomic, strong) NSArray *imgs;
/**
 *  title
 */
@property (nonatomic, copy) NSString *title;
/**
 *  name
 */
@property (nonatomic, copy) NSString *name;
/**
 *  user_name
 */
@property (nonatomic, copy) NSString *user_name;
/**
 *  create_time
 */
@property (nonatomic, copy) NSString *create_time;
/**
 *  comment
 */
@property (nonatomic, copy) NSString *comment;
/**
 *  is_loved
 */
@property (nonatomic, copy) NSString *is_loved;
/**
 *  love
 */
@property (nonatomic, copy) NSString *love;
/**
 *  loved_id
 */
@property (nonatomic, copy) NSString *loved_id;
/**
 *  is_attentioned
 */
@property (nonatomic, copy) NSString *is_attentioned;
/**
 *  user_type
 */
@property (nonatomic, copy) NSString *user_type;
/**
 *  user_role
 */
@property (nonatomic, copy) NSString *user_role;
@end
