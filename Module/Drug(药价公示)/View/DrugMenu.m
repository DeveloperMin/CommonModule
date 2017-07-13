//
//  DrugMenu.m
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//

#import "DrugMenu.h"

@interface DrugMenu ()

/**
 *  指示箭头
 */
@property (nonatomic, strong) UIImage *arrowView;

@end

@implementation DrugMenu

#pragma mark - getters
/**
 *  指示箭头
 */
- (UIImage *)arrowView
{
    if (!_arrowView) {
        _arrowView = [UIImage imageNamed:@"drug.bundle/buddy_header_arrow"];
    }
    return _arrowView;
}

#pragma mark - setters
/**
 *  设置打开状态
 */
- (void)setOpen:(BOOL)open
{
    _open = open;
    
    if (open)
    {
        self.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    else
    {
        self.imageView.transform = CGAffineTransformIdentity;
    }
}

#pragma mark - init
/**
 *  根据frame创建
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 1. 设置属性
        [self setup];
    }
    return self;
}

#pragma mark - private
/**
 *  设置属性
 */
- (void)setup
{
    // 1.1 文字颜色
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // 1.2 图片
    [self setImage:self.arrowView forState:UIControlStateNormal];
    // 1.3 禁止高亮
    self.adjustsImageWhenHighlighted = NO;
    // 1.4 图片模式
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark - public
/**
 *  设置背景
 *
 *  @param indexPath  按钮在在第几个section
 *  @param count      一共有几个section
 */
- (void)setBgInSection:(NSInteger)section count:(NSInteger)count
{
    // 1. 计算出文件名
    NSString *name = nil;
    if (section == 0) // 顶部
    {
        name = @"common_card_top_background";
    }
    else if (section == count - 1) // 底部
    {
        name = @"common_card_bottom_background";
    }
    else // 中间
    {
        name = @"common_card_middle_background";
    }
    
    // 2. 设置背景图片
    UIImage *nomal = [UIImage resizedImageWithName:name];
    UIImage *highlighted = [UIImage resizedImageWithName:[name stringByAppendingString:@"_highlighted"]];
    [self setBackgroundImage:nomal forState:UIControlStateNormal];
    [self setBackgroundImage:highlighted forState:UIControlStateHighlighted];
}

#pragma mark - super
/**
 *  图片位置
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat w = 10;
    CGFloat x = (contentRect.size.height - w) / 2;
    return CGRectMake(25, x, w, w);
}

/**
 *  文字位置
 */
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(55, 0, contentRect.size.width, contentRect.size.height);
}

@end