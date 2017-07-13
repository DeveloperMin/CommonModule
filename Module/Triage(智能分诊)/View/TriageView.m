//
//  TriageView.m
//  smh
//
//  Created by yh on 15/3/20.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//

#import "TriageView.h"
#import "TriageParam.h"
#import "TXBYKitConst.h"

@interface TriageView ()

/**
 *  人像Image数组
 */
@property (nonatomic, strong) NSArray *peopleImages;

/**
 *  性别按钮Image数组
 */
@property (nonatomic, strong) NSArray *genderImages;

/**
 *  当前性别
 */
@property (nonatomic, assign) NSInteger currentGender;

/**
 *  当前方向
 */
@property (nonatomic, assign) NSInteger currentDirection;

/**
 *  头部按钮视图
 */
@property (weak, nonatomic) IBOutlet UIView *headPartView;

/**
 *  人体视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *bodyImageView;

/**
 *  性别按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *genderBtn;

/**
 *  转身按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *turnBtn;

/**
 *  生殖部位按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *reproductionBtn;

@end

@implementation TriageView

#pragma mark - getters
/**
 *  人像Image数组
 */
- (NSArray *)peopleImages {
    if (!_peopleImages) {
        UIImage *manFront = [UIImage imageNamed:@"Triage.bundle/body_male_front"];
        UIImage *womanFront = [UIImage imageNamed:@"Triage.bundle/body_female_front"];
        UIImage *manBack = [UIImage imageNamed:@"Triage.bundle/body_male_back"];
        UIImage *womanBack = [UIImage imageNamed:@"Triage.bundle/body_female_back"];
        _peopleImages = @[@[manFront, manBack], @[womanFront, womanBack]];
    }
    return _peopleImages;
}

/**
 *  性别按钮Image数组
 */
- (NSArray *)genderImages {
    if (!_genderImages) {
        _genderImages = @[[UIImage imageNamed:@"Triage.bundle/man"], [UIImage imageNamed:@"Triage.bundle/woman"]];
    }
    return _genderImages;
}

#pragma mark - private
/**
 *  头部按钮点击
 */
- (IBAction)headButtonClick:(id)sender {
    // 显示头部按钮视图
    self.headPartView.hidden = NO;
}

/**
 *  身体部位点击
 */
- (IBAction)bodyPartClick:(UIButton *)sender {
    // 隐藏头部按钮视图
    self.headPartView.hidden = YES;
    // 执行代理方法
    if ([self.delegate respondsToSelector:@selector(triageView:didClickWithBodyPart:param:)]) {
        TriageParam *param = [TriageParam param];
        param.sex = self.currentGender ? @"0" : @"1";
        [self.delegate triageView:self didClickWithBodyPart:sender.titleLabel.text param:param];
    }
    
}

/**
 *  性别按钮点击
 */
- (IBAction)gender:(UIButton *)button {
    // 隐藏头部按钮视图
    self.headPartView.hidden = YES;
    // 选中的性别取反
    self.currentGender = (++self.currentGender) % 2;
    // 设置生殖按钮标题
    NSDictionary *reproductionDict = @{@0 : @"男性生殖", @1 : @"女性生殖"};
    NSString *reproductionTitle = reproductionDict[@(self.currentGender)];
    [self.reproductionBtn setTitle:reproductionTitle forState:UIControlStateNormal];
    // 设置性别按钮图片
    [button setImage:self.genderImages[self.currentGender] forState:UIControlStateNormal];
    // 设置人像和轮廓图片
    self.bodyImageView.image = self.peopleImages[self.currentGender][self.currentDirection];
}

/**
 *  转身按钮点击
 */
- (IBAction)turnArround:(id)sender {
    // 隐藏头部按钮视图
    self.headPartView.hidden = YES;
    // 选中的方向取反
    self.currentDirection = (++self.currentDirection) % 2;
    // 设置人像图片
    self.bodyImageView.image = self.peopleImages[self.currentGender][self.currentDirection];
    // 设置部位按钮隐藏状态
    for (UIView *view in self.subviews) {
        for (UIButton *btn in view.subviews) {
            if (btn.tag == 10) {
                btn.hidden = self.currentDirection;
            } else if (btn.tag == 11) {
                btn.hidden = !self.currentDirection;
            }
        }
    }
}

#pragma mark - super
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 隐藏头部按钮视图
    self.headPartView.hidden = YES;
}

#pragma mark - init
- (void)awakeFromNib {
    // 设置性别按钮属性
    self.genderBtn.layer.borderWidth = 1;
    self.genderBtn.layer.borderColor = TXBYColor(117, 191, 79).CGColor;
    self.genderBtn.layer.cornerRadius = 5;
    // 设置转身按钮属性
    self.turnBtn.layer.borderWidth = 1;
    self.turnBtn.layer.borderColor = TXBYColor(117, 191, 79).CGColor;
    self.turnBtn.layer.cornerRadius = 5;
    
    // 如果是4.0屏幕，变更约束以适应屏幕
    if (iPhone4) {
        [self removeConstraints:self.constraints];
        // 顶部约束
        NSLayoutConstraint *viewTopConstraint = [NSLayoutConstraint constraintWithItem:self.subviews.lastObject attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:5];
        // 底部约束
        NSLayoutConstraint *viewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.subviews.lastObject attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5];
        // 水平约束
        NSLayoutConstraint *viewCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.subviews.lastObject attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        [self addConstraints:@[viewTopConstraint, viewBottomConstraint, viewCenterXConstraint]];
    }
}

@end