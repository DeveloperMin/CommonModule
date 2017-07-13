//
//  NSObject+TXBY.h
//  TXBYCategory
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TXBY)

/**
 *  NSObject转JSON字符串(目前仅支持简单类型如NSArray)
 */
- (NSString *)toJsonString;

@end