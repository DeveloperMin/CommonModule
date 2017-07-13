//
//  DrugItemCell.m
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//

// 初始tag
NSInteger const ESDrugItemTagStart = 100;
// 两边空出的距离
CGFloat const ESDrugItemSpaceBoder = 55;
// cell中放几个按钮
NSInteger const ESDrugItemCount = 2;
// cell高度
CGFloat const ESDrugItemCellH = 40;

#import "DrugItemCell.h"
#import "DrugList.h"

@implementation DrugItemCell

#pragma mark - init
/**
 *  根据reuseIdentifier创建
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // 1. 设置cell属性
        [self setup];
        
        // 2. 添加按钮
        [self addButtons];
    }
    return self;
}

#pragma mark - private
/**
 *  设置cell属性
 */
- (void)setup
{
    // 1. 禁止点击
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // 2. cell背景
    self.backgroundColor = TXBYColor(236, 236, 236);
}

/**
 *  添加按钮
 */
- (void)addButtons
{
    // 根据列数添加按钮
    for (int i = 0; i < ESDrugItemCount; i++)
    {
        // 1.1 创建按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 1.2 设置按钮的宽高和位置
        CGFloat btnW = (self.txby_width - ESDrugItemSpaceBoder * (ESDrugItemCount + 1)) / ESDrugItemCount;
        CGFloat btnX =  i * btnW + (i + 1) * ESDrugItemSpaceBoder;
        CGFloat btnY = 0;
        CGFloat btnH = ESDrugItemCellH;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        // 1.3 设置按钮的tag
        btn.tag = i + ESDrugItemTagStart;
        // 1.4 添加按钮到cell的contentView中
        [self.contentView addSubview:btn];
        // 1.5 设置点击事件
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        // 1.6 设置文字颜色
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 1.7 设置字体
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
}

/**
 *  按钮点击事件
 */
- (void)click:(UIButton *)button
{
    // 调用代理方法
    if ([self.delegate respondsToSelector:@selector(drugItemCell:didClickButtonWithDrugMenuItem:)])
    {
        DrugList *item = self.drugMenuItems[button.tag - ESDrugItemTagStart];
        [self.delegate drugItemCell:self didClickButtonWithDrugMenuItem:item];
    }
}

#pragma mark - public
/**
 *  设置模型数组
 */
- (void)setDrugMenuItems:(NSArray *)drugMenuItems
{
    _drugMenuItems = drugMenuItems;
    
    // 遍历所有的按钮
    for (int i = 0; i < ESDrugItemCount; i++)
    {
        // 按钮的tag
        int tag = i + ESDrugItemTagStart;
        // 取出对应的按钮
        UIButton *btn = (UIButton *)[self.contentView viewWithTag:tag];
        
        if (i > drugMenuItems.count - 1) // 如果这个按钮没有对应的数据
        {
            // 隐藏
            btn.hidden = YES;
        }
        else // 如果这个按钮有对应的数据
        {
            // 显示
            btn.hidden = NO;
            
            // 获得这个按钮对应的数据
            DrugList *list = drugMenuItems[i];
            // 设置按钮的名称
            [btn setTitle:list.name forState:UIControlStateNormal];
            // 设置frame
            CGSize realSize = [list.name sizeWithFont:btn.titleLabel.font];
            CGRect frame = btn.frame;
            frame.size.width = realSize.width;
            btn.frame = frame;
        }
    }
}

@end