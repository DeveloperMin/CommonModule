//
//  CommunityDetailController.h
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/25.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommunityCellFrame;

typedef void (^ClickLoveBtnBlock)(UIButton *loveBtn);
typedef void (^ClickUnLoveBtnBlock)(UIButton *unLoveBtn);

@interface CommunityDetailController : UIViewController

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, strong) CommunityCellFrame *communityFrame;

@property (nonatomic, assign) BOOL community;
/**
 *  是否添加踩功能
 */
@property (nonatomic, assign) BOOL isTread;

/**
 *  loveBtnBlock
 */
@property (nonatomic, copy) ClickLoveBtnBlock loveBtnBlock;
/**
 *  unLoveBtnBlock
 */
@property (nonatomic, copy) ClickUnLoveBtnBlock unLoveBtnBlock;

@end
