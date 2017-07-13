//
//  MyStepViewController.h
//  publicCommon
//
//  Created by Limmy on 2017/2/15.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepListModel.h"

@protocol StepViewUpdateDelegate <NSObject>

- (void)updateStepViewData;

@end
@interface MyStepViewController : UITableViewController

/**
 *  myModel
 */
@property (nonatomic, strong) StepListModel *myModel;
/**
 *  delegate
 */
@property (nonatomic, weak) id<StepViewUpdateDelegate> delegate;

@end
