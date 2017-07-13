//
//  CommunityMainController.h
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/24.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityMainController : UIViewController
/**
 *  是否开启踩功能
 */
@property (nonatomic, assign) BOOL isTread;
/**
 *  是否开启搜索功能
 */
@property (nonatomic, assign) BOOL isSearch;
/**
 *  是否请求分组
 */
@property (nonatomic, assign) BOOL isRequestGroup;

@end
