//
//  QuestCell.m
//  smh
//
//  Created by yh on 14/9/19.
//  Copyright (c) 2014年 eeesys. All rights reserved.
//

#import "QuestCell.h"


@interface QuestCell()

@end

@implementation QuestCell

#pragma mark - super
/**
 *  设置frame
 */
- (void)setFrame:(CGRect)frame {
    frame.origin.y += TXBYCellMargin;
    frame.size.height -= TXBYCellMargin;
    
    [super setFrame:frame];
}

@end