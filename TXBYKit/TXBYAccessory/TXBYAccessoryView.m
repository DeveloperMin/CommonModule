//
//  TXBYAccessoryView.m
//  TXBYKit
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYAccessoryView.h"
#import "TXBYKit.h"

// 按钮到边框的距离
const CGFloat TXBYAccessoryViewDictance = 8;
// 按钮宽度
const CGFloat TXBYAccessoryViewButtonW = 50;
// 选择框inputAccessoryView高度
const CGFloat TXBYAccessoryViewH = 40;

@interface TXBYAccessoryView ()

/**
 *  标题标签
 */
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation TXBYAccessoryView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

#pragma mark - 私有方法
- (void)setup {
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, TXBYAccessoryViewH);
    self.backgroundColor = TXBYColor(247, 247, 247);
}

#pragma mark - 公共方法
+ (instancetype)accessoryViewWithTarget:(id)target action:(SEL)action {
    TXBYAccessoryView *view = [[self alloc] init];
    
    // 1. 取消按钮
    UIButton *cancleButton = [UIButton buttonWithTitle:@"取消" target:target action:action];
    cancleButton.frame = CGRectMake(TXBYAccessoryViewDictance, 0, TXBYAccessoryViewButtonW, TXBYAccessoryViewH);
    [view addSubview:cancleButton];
    
    // 2. 标题
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(CGRectGetMaxX(cancleButton.frame), 0, view.frame.size.width - 2 *(CGRectGetMaxX(cancleButton.frame)), TXBYAccessoryViewH);
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor darkGrayColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    view.titleLabel = label;
    
    // 3. 确定按钮
    UIButton *okButton = [UIButton buttonWithTitle:@"确定" target:target action:action];
    okButton.frame = CGRectMake(view.frame.size.width - TXBYAccessoryViewDictance - TXBYAccessoryViewButtonW, 0, TXBYAccessoryViewButtonW, TXBYAccessoryViewH);
    [view addSubview:okButton];
    
    return view;
}

/**
 *  设置标题文字
 */
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

@end