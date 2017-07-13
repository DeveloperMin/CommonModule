//
//  TXBYWebProgressLayer.m
//
//  Created by Limmy on 2016/12/26.
//  Copyright © 2016年 eeesys. All rights reserved.
//

#import "TXBYWebProgressLayer.h"
#import "NSTimer+addition.h"
static NSTimeInterval const kFastTimeInterval = 0.05;

@implementation TXBYWebProgressLayer {
    CAShapeLayer *_layer;
    
    NSTimer *_timer;
    CGFloat _plusWidth; // 增加点
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.lineWidth = 3;
    if (self.progressColor) {
        self.strokeColor = self.progressColor.CGColor;
    } else {
        self.strokeColor = TXBYColor(19, 196, 80).CGColor;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:kFastTimeInterval target:self selector:@selector(pathChanged:) userInfo:nil repeats:YES];
    [_timer pause];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 3)];
    [path addLineToPoint:CGPointMake(TXBYApplicationW, 3)];
    
    self.path = path.CGPath;
    self.strokeEnd = 0;
    _plusWidth = 0.01;
}

- (void)pathChanged:(NSTimer *)timer {
    self.strokeEnd += _plusWidth;
    if (self.strokeEnd >= 1.0) {
        [self finishedLoad];
        if (self.completeProBlock) {
            self.completeProBlock();
        }
    } else if (self.strokeEnd > 0.92) {
        _plusWidth = 0.0001;
    } else if (self.strokeEnd > 0.85) {
        _plusWidth = 0.001;
    }
}

- (void)startLoad {
    [_timer resumeWithTimeInterval:kFastTimeInterval];
}

- (void)finishedLoad {
    [self closeTimer];
    
    self.strokeEnd = 1.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        [self removeFromSuperlayer];
    });
}

- (void)dealloc {
    [self closeTimer];
}

#pragma mark - private
- (void)closeTimer {
    [_timer invalidate];
    _timer = nil;
}

@end
