//
//  DrugItemCell.h
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//  展开后的药价目录列表

// cell中放几个按钮
extern NSInteger const ESDrugItemCount;
// cell高度
extern CGFloat const ESDrugItemCellH;

#import <UIKit/UIKit.h>
@class DrugItemCell;
@class DrugList;

@protocol DrugItemCellDelegate <NSObject>

@optional
/**
 *  点击了cell中的目录
 */
- (void)drugItemCell:(DrugItemCell *)cell didClickButtonWithDrugMenuItem:(DrugList *)item;

@end

@interface DrugItemCell : UITableViewCell

/**
 *  cell中药价目录模型数组
 */
@property (nonatomic, strong) NSArray *drugMenuItems;

/**
 *  代理
 */
@property (nonatomic, weak) id<DrugItemCellDelegate> delegate;

@end