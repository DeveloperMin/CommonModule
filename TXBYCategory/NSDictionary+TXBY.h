//
//  NSDictionary+TXBY.h
//  TXBYCategory
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (TXBY)

/**
 *  NSDictionary中是否包含key
 */
- (BOOL)containsObjectForKey:(id)key;

/**
 *  加密所有参数后形成新的请求参数{@"json":@"加密后的参数"}
 */
- (NSDictionary *)encryptParameters;

@end