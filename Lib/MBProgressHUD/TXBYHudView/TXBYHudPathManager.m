//
//  TXBYHudPathManager.m
//  TXBYHudView
//
//  Created by YandL on 16/7/1.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import "TXBYHudPathManager.h"

@implementation TXBYHudPathManager

/**
 *  绘制边框
 */
- (UIBezierPath *)pathForBox {
    UIBezierPath *path;
    CGFloat radius = self.size / 2;
    path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.size / 2, self.size / 2) radius: radius startAngle: - M_PI / 4 endAngle:  2 * M_PI - M_PI / 4 clockwise:YES];
    return path;
}

/**
 *  成功线路
 */
- (UIBezierPath *)pathForSucess {
    UIBezierPath *checkMarkPath = [UIBezierPath bezierPath];
    [checkMarkPath moveToPoint: CGPointMake(self.size * 0.25, self.size * 0.5)];
    [checkMarkPath addLineToPoint: CGPointMake(self.size * 0.45, self.size * 0.7)];
    [checkMarkPath addLineToPoint: CGPointMake(self.size * 0.8, self.size * 0.35)];
    return checkMarkPath;
}

/**
 *  提示线路1
 */
- (UIBezierPath *)pathForInfoOne {
    UIBezierPath *checkMarkPath = [UIBezierPath bezierPath];
    [checkMarkPath moveToPoint: CGPointMake(self.size * 0.5, self.size * 0.25)];
    [checkMarkPath addLineToPoint: CGPointMake(self.size * 0.5, self.size * 0.62)];
    return checkMarkPath;
}

/**
 *  提示线路2
 */
- (UIBezierPath *)pathForInfoTwo {
    UIBezierPath *path;
    CGFloat radius = 1;
    path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.size * 0.5, self.size * 0.77) radius: radius startAngle: - M_PI / 4 endAngle:  2 * M_PI - M_PI / 4 clockwise:YES];
    return path;
}

/**
 *  错误线路1
 */
- (UIBezierPath *)pathForErrorOne {
    UIBezierPath *checkMarkPath = [UIBezierPath bezierPath];
    [checkMarkPath moveToPoint: CGPointMake(self.size * 0.72, self.size * 0.28)];
    [checkMarkPath addLineToPoint: CGPointMake(self.size * 0.28, self.size * 0.72)];
    return checkMarkPath;
}

/**
 *  错误线路2
 */
- (UIBezierPath *)pathForErrorTwo {
    UIBezierPath *checkMarkPath = [UIBezierPath bezierPath];
    [checkMarkPath moveToPoint: CGPointMake(self.size * 0.28, self.size * 0.28)];
    [checkMarkPath addLineToPoint: CGPointMake(self.size * 0.72, self.size * 0.72)];
    return checkMarkPath;
}

/**
 *  加载
 */
- (UIBezierPath *)pathForLoading {
    UIBezierPath *path;
    CGFloat radius = self.size / 2;
    path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.size / 2, self.size / 2) radius: radius startAngle: -M_PI / 2 endAngle: -M_PI / 8 clockwise:YES];
    return path;
}

/**
 *  进度
 */
- (UIBezierPath *)pathForProgress {
    UIBezierPath *path;
    CGFloat radius = self.size / 2;
    path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.size / 2, self.size / 2) radius: radius startAngle: - M_PI / 4 endAngle: - M_PI / 4 clockwise:YES];
    return path;
}

@end
