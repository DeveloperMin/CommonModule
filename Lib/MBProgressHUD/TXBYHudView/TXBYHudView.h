//
//  TXBYHudView.h
//  TXBYHudView
//
//  Created by YandL on 16/7/1.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXBYHudPathManager.h"
@import UIKit;

typedef NS_ENUM(NSInteger, TXBYHudType) {
    /**
     *  success
     */
    TXBYHudTypeSuccess,
    /**
     *  info
     */
    TXBYHudTypeInfo,
    /**
     *  error
     */
    TXBYHudTypeError,
    /**
     *  loading
     */
    TXBYHudTypeLoading,
    /**
     *  progress
     */
    TXBYHudTypeProgress,
};

@interface TXBYHudView : UIView

/**
 *  尺寸大小
 */
@property (nonatomic, assign) float size;
/**
 *  是否动画形式
 */
@property (nonatomic, assign) BOOL animate;
/**
 *  颜色
 */
@property (nonatomic, strong) UIColor *hudColor;
/**
 *  颜色
 */
@property (nonatomic, strong) UIColor *loadingColor;
/**
 *  线的宽度
 */
@property (nonatomic, assign) float lineWidth;
/**
 *  绘制时间
 */
@property (nonatomic, assign) float duration;
/**
 *  进度
 */
@property (nonatomic, assign) float progress;

/**
 *  类型
 */
@property (nonatomic, assign) TXBYHudType hudType;

- (instancetype)initWithSize:(float)size;

- (void)createView;

- (void)stopHudView;

- (void)startHudView;

@end
