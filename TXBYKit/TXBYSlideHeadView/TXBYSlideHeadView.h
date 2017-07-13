//
//  TXBYSlideHeadView.h
//  slideNavDemo
//
//  Created by YandL on 16/3/31.
//  Copyright © 2016年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>

// 加载的模式
typedef enum {
    // 点击前全部加载
    loadBeforeClick = 1,
    // 点击后加载
    loadAfterClick
}ScrollViewloadMode;

typedef void(^CurrentTitleBlock)(NSString *title);

@interface TXBYSlideHeadView : UIView <UIScrollViewDelegate>
/**
 *  顶部标题选中的颜色
 */
@property (nonatomic, strong) UIColor *titleColor;
/**
 *  顶部标题默认的颜色
 */
@property (nonatomic, strong) UIColor *titleDefaultColor;
/**
 *  文字下方的横条的颜色
 */
@property (nonatomic, strong) UIColor *backViewColor;
/**
 *  顶部的颜色
 */
@property (nonatomic, strong) UIColor *headBackViewColor;
/**
 *  是否显示底部分隔横线
 */
@property (nonatomic ,assign) BOOL showBottomLine;
/**
 *  是否显示底部分隔横线
 */
@property (nonatomic ,strong) UIColor *bottomLineColor;
/**
 *  选中的标签序号
 */
@property (nonatomic ,assign) NSInteger selectedIndex;
/**
 *  默认选中是否有动画 (默认yes)
 */
@property (nonatomic ,assign) BOOL selectedAnimate;
/**
 *  根据当前title, 来做后续操作
 */
@property (nonatomic, copy) CurrentTitleBlock titleBlock;
/**
 *  初始化所有控制器
 *
 *  @param controllerArr 存放控制器的数组
 *  @param mode          加载的模式
 */
- (void)setSlideHeadViewWithArr:(NSArray *)controllerArr andLoadMode:(ScrollViewloadMode)mode;

@end
