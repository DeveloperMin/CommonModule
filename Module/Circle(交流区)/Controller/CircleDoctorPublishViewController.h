//
//  CirclePublishViewController.h
//  txzjPatient
//
//  Created by Limmy on 2017/4/26.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CirclePublishPhotoView.h"
@class TXBYCircleModel, TXBYCircleReply, CircleTipsView;

typedef void(^CircleSuccess)(void);

@interface CircleDoctorPublishViewController : UITableViewController{
    NSMutableArray *_selectedAssets;
}
/**
 * photosView
 */
@property (strong, nonatomic) CirclePublishPhotoView *photosView;
/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *images;
/**
 *  photoBtn
 */
@property (nonatomic, strong) UIButton *photoBtn;
/**
 *  imgStr
 */
@property (nonatomic, copy) NSString *imgStr;
/**
 *  content
 */
@property (nonatomic, strong) UITextView *content;
/**
 *  placehold
 */
@property (nonatomic, weak) UILabel *placehold;
/**
 *  headerView
 */
@property (nonatomic, weak) UIView *headerView;
/**
 *  tipsView
 */
@property (nonatomic, weak) CircleTipsView *tipsView;

@property (nonatomic, strong) TXBYCircleModel *circleModel;
@property (nonatomic, strong) TXBYCircleReply *circleReply;
@property (nonatomic, assign) CirclePublishStyle circlePublishStyle;
/**
 *  是否是医生端
 */
@property (nonatomic, assign) BOOL isDoctorUser;

@property (nonatomic, copy) CircleSuccess replySuccessBlock;
@property (nonatomic, copy) CircleSuccess createSuccessBlock;
@end
