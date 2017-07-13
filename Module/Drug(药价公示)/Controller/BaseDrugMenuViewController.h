//
//  BaseDrugMenuViewController.h
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//  中成药、西药父类

#import <UIKit/UIKit.h>
@class BaseDrugMenuViewController;
@class DrugList;

@protocol BaseDrugMenuViewControllerDelegate <NSObject>

@optional
/**
 *  点击了某个条目
 */
- (void)drugMenuViewController:(BaseDrugMenuViewController *)vc didClickWithItem:(DrugList *)item;

/**
 *  UITableView滚动
 */
- (void)drugMenuViewControllerDidScroll:(BaseDrugMenuViewController *)vc;

@end

@interface BaseDrugMenuViewController : UITableViewController

/**
 *  药价列表目录数组
 */
@property (nonatomic, strong) NSArray *items;

/**
 *  代理
 */
@property (nonatomic, assign) id <BaseDrugMenuViewControllerDelegate> delegate;

@end