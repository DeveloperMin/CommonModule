//
//  MyCircleCommentModel.h
//  txzjPatient
//
//  Created by Limmy on 2017/4/28.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXBYCircleModel.h"

@interface MyCircleCommentModel : NSObject
/**
 *  commnet
 */
@property (nonatomic, strong) TXBYCircleModel *comment;
/**
 *  quest
 */
@property (nonatomic, strong) TXBYCircleModel *quest;

@end
