//
//  CommunityToolBar.h
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/24.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityListItem.h"

@protocol CommunityToolBarDelegate <NSObject>

- (void)clickCommunityToolBarBtn:(UIButton *)btn;

@end

@interface CommunityToolBar : UIView
/**
 *  item
 */
@property (nonatomic, strong) CommunityListItem *communityItem;

@property (nonatomic, weak) id<CommunityToolBarDelegate> barDelegate;
/**
 *  是否开启踩功能
 */
@property (nonatomic, assign) BOOL isTread;

@end
