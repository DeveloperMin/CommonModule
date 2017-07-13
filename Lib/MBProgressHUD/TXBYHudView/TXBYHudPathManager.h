//
//  TXBYHudPathManager.h
//  TXBYHudView
//
//  Created by YandL on 16/7/1.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface TXBYHudPathManager : NSObject

/**
 *  尺寸大小
 */
@property (nonatomic, assign) float size;
/**
 *  绘制边框
 *
 */
- (UIBezierPath *)pathForBox;
/**
 *  成功线路
 */
- (UIBezierPath *)pathForSucess;

/**
 *  提示线路1
 */
- (UIBezierPath *)pathForInfoOne;

/**
 *  提示线路2
 */
- (UIBezierPath *)pathForInfoTwo;

/**
 *  错误线路1
 */
- (UIBezierPath *)pathForErrorOne;

/**
 *  错误线路2
 */
- (UIBezierPath *)pathForErrorTwo;

/**
 *  加载
 */
- (UIBezierPath *)pathForLoading;

/**
 *  进度
 */
- (UIBezierPath *)pathForProgress;
@end
