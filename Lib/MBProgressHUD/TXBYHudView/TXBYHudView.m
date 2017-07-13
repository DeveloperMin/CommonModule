//
//  TXBYHudView.m
//  TXBYHudView
//
//  Created by YandL on 16/7/1.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import "TXBYHudView.h"

@interface TXBYHudView () {
    __block double angle;
}

@property (strong, nonatomic) CAShapeLayer *boxLayer;

@property (strong, nonatomic) CAShapeLayer *progressLayer;

@property (strong, nonatomic) CAShapeLayer *secondLayer;

@property (strong, nonatomic) CAShapeLayer *firstLayer;

@property (assign, nonatomic) BOOL hudStop;

@property (strong, strong) TXBYHudPathManager *pathManager;

@end

@implementation TXBYHudView
@synthesize pathManager = _pathManager;

- (instancetype)initWithSize:(float)size {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, size, size);
        self.size = size;
        self.backgroundColor = [UIColor whiteColor];
        _pathManager = [[TXBYHudPathManager alloc] init];
        _pathManager.size = self.size;
        angle = M_PI / 180.0;
    }
    return self;
}

- (void)setProgress:(float)progress {
    _progress = progress;
    UIBezierPath *path1;
    CGFloat radius = self.size / 2;
    path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.size / 2, self.size / 2) radius: radius startAngle: - M_PI / 2 endAngle: progress * (M_PI * 1.5) + (- M_PI / 2) clockwise:YES];
    self.boxLayer.path = path1.CGPath;
    [self.layer replaceSublayer:self.boxLayer with:self.boxLayer];
}

- (void)createView {
    [self createBoxView];
    if (self.hudType != TXBYHudTypeProgress) {
        [self createHudView];
    }
}

- (void)showHudView {
    
}

- (void)createBoxView {
    self.backgroundColor = [UIColor clearColor];
    self.hudStop = NO;
    self.boxLayer = [CAShapeLayer layer];
    self.boxLayer.frame = self.bounds;
    if (self.hudType == TXBYHudTypeProgress) {
        self.boxLayer.path = [self.pathManager pathForProgress].CGPath;
    }
    else {
        self.boxLayer.path = [self.pathManager pathForBox].CGPath;
    }
    self.boxLayer.lineWidth = self.lineWidth;
    self.boxLayer.fillColor = [UIColor clearColor].CGColor;
    self.boxLayer.strokeColor = self.hudColor.CGColor;
    self.boxLayer.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
    self.boxLayer.shouldRasterize = YES;
    self.boxLayer.lineCap = kCALineCapRound;
    if (self.animate && self.hudType != TXBYHudTypeLoading) {
        self.boxLayer = [self addAnimation:self.boxLayer isBox:YES];
    }
    [self.layer addSublayer:self.boxLayer];
    
    if (self.hudType == TXBYHudTypeProgress) {
        self.progressLayer = [CAShapeLayer layer];
        self.progressLayer.frame = self.bounds;
        self.progressLayer.path = [self.pathManager pathForProgress].CGPath;
        self.progressLayer.lineWidth = self.lineWidth;
        self.progressLayer.fillColor = [UIColor blackColor].CGColor;
        self.progressLayer.strokeColor = [UIColor blackColor].CGColor;
        self.progressLayer.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
        self.progressLayer.shouldRasterize = YES;
        self.progressLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:self.progressLayer];
    }
}

- (void)createHudView {
    self.firstLayer = [CAShapeLayer layer];
    self.firstLayer.frame = self.bounds;
    self.firstLayer.lineWidth = self.lineWidth;
    self.firstLayer.fillColor = [UIColor clearColor].CGColor;
    self.firstLayer.strokeColor = self.hudColor.CGColor;
    if (self.hudType == TXBYHudTypeLoading) {
        self.firstLayer.strokeColor = self.loadingColor.CGColor;
        self.firstLayer.lineWidth = self.lineWidth * 1.3;
    }
    self.firstLayer.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
    self.firstLayer.shouldRasterize = YES;
    self.firstLayer.lineCap = kCALineCapRound;
    
    switch (self.hudType) {
        case TXBYHudTypeInfo: {
            self.firstLayer.path = [self.pathManager pathForInfoOne].CGPath;
            self.firstLayer.lineWidth = self.lineWidth * 1.5;
            break;
        }
            
        case TXBYHudTypeError: {
            self.firstLayer.path = [self.pathManager pathForErrorOne].CGPath;
            break;
        }
            
        case TXBYHudTypeLoading: {
            self.firstLayer.path = [self.pathManager pathForLoading].CGPath;
            break;
        }
            
        default: {
            self.firstLayer.path = [self.pathManager pathForSucess].CGPath;
            break;
        }
    }
    if (self.animate && self.hudType != TXBYHudTypeLoading) {
        self.firstLayer = [self addAnimation:self.firstLayer isBox:NO];
    }
    [self.layer addSublayer:self.firstLayer];
    if (self.hudType == TXBYHudTypeError || self.hudType == TXBYHudTypeInfo) {
        if (self.animate) {
            [self performSelector:@selector(showSecondLayer) withObject:nil afterDelay:(self.hudType == TXBYHudTypeError)? self.duration * 0.5: self.duration * 0.8];
        }
        else {
            [self showSecondLayer];
        }
    }
    else if (self.hudType == TXBYHudTypeLoading) {
        [self performSelector:@selector(showLoadingAnimation) withObject:nil afterDelay:0.001];
    }
}

- (void)stopHudView {
    self.hudStop = YES;
}

- (void)startHudView {
    self.hudStop = NO;
    [self showLoadingAnimation];
}

- (void)showLoadingAnimation {
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle);
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = endAngle;
    } completion:^(BOOL finished) {
        if (!self.hudStop) {
            angle += M_PI / 4.0f;
            [self showLoadingAnimation];
        }
    }];
}

- (void)showSecondLayer {
    self.secondLayer = [CAShapeLayer layer];
    self.secondLayer.frame = self.bounds;
    self.secondLayer.lineWidth = self.lineWidth;
    self.secondLayer.fillColor = [UIColor clearColor].CGColor;
    self.secondLayer.strokeColor = self.hudColor.CGColor;
    self.secondLayer.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
    self.secondLayer.shouldRasterize = YES;
    self.secondLayer.lineCap = kCALineCapRound;
    
    switch (self.hudType) {
            
        case TXBYHudTypeError: {
            self.secondLayer.path = [self.pathManager pathForErrorTwo].CGPath;
            if (self.animate) {
                self.secondLayer = [self addAnimation:self.secondLayer isBox:NO];
            }
            break;
        }
        
        default:{
            self.secondLayer.path = [self.pathManager pathForInfoTwo].CGPath;
            self.secondLayer.lineWidth = self.lineWidth * 1.5;
            break;
        }
            
    }
    [self.layer addSublayer:self.secondLayer];
}

- (CAShapeLayer *)addAnimation:(CAShapeLayer *)layer isBox:(BOOL)isBox {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0;
    animation.toValue = @1;
    if (isBox) {
        animation.duration = self.duration;
    }
    else {
        switch (self.hudType) {
            case TXBYHudTypeInfo:
                animation.duration = self.duration * 0.8;
                break;
                
            case TXBYHudTypeError:
                animation.duration = self.duration * 0.5;
                break;
                
            default:
                animation.duration = self.duration;
                break;
        }
    }
    [layer addAnimation :animation forKey:NSStringFromSelector(@selector (strokeEnd))];
    return layer;
}

@end
