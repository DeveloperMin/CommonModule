//
//  NSDictionary+TXBY.m
//  TXBYCategory
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "NSDictionary+TXBY.h"
#import "TXBYCategory.h"

@implementation NSDictionary (TXBY)

- (BOOL)containsObjectForKey:(id)key {
    return self[key] != nil;
}

- (NSDictionary *)encryptParameters {
    NSString *json = [self toJsonString];
    json = [json stringByReplacingOccurrencesOfString:@"\"ID\"" withString:@"\"id\""];
    return @{@"json" : json.encrypt};
}

@end