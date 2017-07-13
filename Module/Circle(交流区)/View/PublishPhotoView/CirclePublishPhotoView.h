//
//  CirclePublishPhotoView.h
//  txzjPatient
//
//  Created by Limmy on 2017/4/26.
//  Copyright © 2017年 txby. All rights reserved.
//


typedef NS_ENUM(NSInteger, CirclePublishStyle) {
    CirclePublishStyleReply,
    CirclePublishStyleCircle
};

#import <UIKit/UIKit.h>

@protocol CirclePublishPhotoViewDelegate <NSObject>

- (void)photoViewClickCancelImage:(UIButton *)btn;

@end
@interface CirclePublishPhotoView : UIView
/**
 *  images
 */
@property (nonatomic, strong) NSArray *images;
/**
 * CirclePublishStyle
 */
@property (nonatomic, assign) CirclePublishStyle circlePublishStyle;
/**
 *  delegate
 */
@property (nonatomic, weak) id<CirclePublishPhotoViewDelegate> delegate;

@end
