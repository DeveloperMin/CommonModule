//
//  TXBYWebProgressLayer.h
//
//  Created by Limmy on 2016/12/26.
//  Copyright © 2016年 eeesys. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


typedef void(^CompleteWebProgress)();

@interface TXBYWebProgressLayer : CAShapeLayer
/**
 *  完成加载
 */
- (void)finishedLoad;
/**
 *  开始加载
 */
- (void)startLoad;
/**
 *  停止定时器
 */
- (void)closeTimer;
/**
 *  进度条的颜色
 */
@property (nonatomic, weak) UIColor *progressColor;
/**
 *  completeProBlock
 */
@property (nonatomic, copy) CompleteWebProgress completeProBlock;

@end
