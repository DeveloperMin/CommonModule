//
//  TXBYInputGroup.h
//  TXBYKit
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXBYInputGroup : NSObject

/**
 *  组头
 */
@property (nonatomic, copy) NSString *header;

/**
 *  组尾
 */
@property (nonatomic, copy) NSString *footer;

/**
 *  这组的所有模型
 */
@property (nonatomic, strong) NSArray *items;

/**
 *  快速创建一个group对象
 */
+ (instancetype)group;

@end