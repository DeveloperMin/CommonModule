//
//  CommunitySelectView.h
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/26.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommunityGroup;

typedef void(^CommitBlock)(CommunityGroup *group);

typedef void(^CancelBlock)();

@interface CommunitySelectView : UIView
/**
 *  确定回调
 */
@property (nonatomic, copy) CommitBlock commitBlock;
/**
 *  取消回调
 */
@property (nonatomic, copy) CancelBlock cancelBlock;
/**
 *  已经选中的group
 */
@property (nonatomic, strong) CommunityGroup *defaultGroup;
/**
 *  groups
 */
@property (nonatomic, strong) NSArray *groups;

@end
