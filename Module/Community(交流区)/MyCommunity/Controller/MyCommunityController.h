//
//  MyQuestController.h
//  ydyl
//
//  Created by Limmy on 2016/9/22.
//  Copyright © 2016年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCommunityController : UITableViewController

@property (nonatomic, strong) NSArray *questFrames;

/**
 *  是否开启踩功能
 */
@property (nonatomic, assign) BOOL isTread;

@end
