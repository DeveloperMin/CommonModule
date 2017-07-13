//
//  TXBYTabBarButton.m
//  TXBYKit-master
//
//  Created by mac on 16/4/20.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYTabBarButton.h"
#import "TXBYSettingBadgeView.h"
#import "TXBYCategory.h"

// 图标的比例
CGFloat const TXBYTabBarButtonImageRatio = 0.6;

@interface TXBYTabBarButton ()

/**
 *  提醒数字view
 */
@property (nonatomic, weak) TXBYSettingBadgeView *badgeButton;

@end

@implementation TXBYTabBarButton

#pragma mark - getters
- (TXBYSettingBadgeView *)badgeButton {
    if (!_badgeButton) {
        // 添加提醒数字
        TXBYSettingBadgeView *badgeButton = [[TXBYSettingBadgeView alloc] init];
        _badgeButton = badgeButton;
        badgeButton.hidden = YES;
        [self addSubview:badgeButton];
    }
    return _badgeButton;
}

#pragma mark - setters
/**
 *  设置UITabBarItem
 */
- (void)setItem:(UITabBarItem *)item {
    _item = item;
    
    // KVO 监听属性改变
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    [item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

#pragma mark - init
/**
 *  根据frame初始化
 */
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - private
/**
 *  设置按钮的属性
 */
- (void)setup {
    // 1. 图标居中
    self.imageView.contentMode = UIViewContentModeCenter;
    // 2. 文字居中
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    // 3. 字体大小
    self.titleLabel.font = [UIFont systemFontOfSize:10];
}

/**
 *  监听到某个对象的属性改变了,就会调用
 *  @param keyPath 属性名
 *  @param object  哪个对象的属性被改变
 *  @param change  属性发生的改变
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // 设置文字
    [self setTitle:self.item.title forState:UIControlStateSelected];
    [self setTitle:self.item.title forState:UIControlStateNormal];
    
    // 设置图片
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
    
    // 提醒数字
    self.badgeButton.badgeValue = self.item.badgeValue;
}

#pragma mark - super
/**
 *  去掉高亮状态
 */
- (void)setHighlighted:(BOOL)highlighted {}

/**
 *  内部图片的frame
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * TXBYTabBarButtonImageRatio;
    return CGRectMake(0, 1, imageW, imageH);
}

/**
 *  内部文字的frame
 */
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleY = contentRect.size.height * TXBYTabBarButtonImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(0, titleY, titleW, titleH);
}

/**
 *  销毁时
 */
- (void)dealloc {
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
}

/**
 *  调整子视图
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置提醒数字的位置和尺寸
    self.badgeButton.txby_x = self.txby_width / 2 + 10;
    self.badgeButton.txby_y = 0;
}

@end