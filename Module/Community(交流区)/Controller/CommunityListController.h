//
//  CommunityListController.h
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/24.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommunityGroup;

@interface CommunityListController : UITableViewController

@property (nonatomic, strong) CommunityGroup *group;
/**
 *  是否开启踩功能
 */
@property (nonatomic, assign) BOOL isTread;
/**
 *  搜索content
 */
@property (nonatomic, copy) NSString *content;
/**
 *  是否搜索
 */
@property (nonatomic, assign) BOOL isSearch;

@end
