//
//  NSObject+TXBY.m
//  TXBYCategory
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "NSObject+TXBY.h"

@implementation NSObject (TXBY)

/**
 *  NSArray转JSON字符串
 */
- (NSString *)toJsonStringWithArray {
    NSArray *array = (NSArray *)self;
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [valueObj toJsonString];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

/**
 *  NSDictionary转JSON字符串
 */
- (NSString *)toJsonStringWithDictionary {
    NSDictionary *dictionary = (NSDictionary *)self;
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i = 0; i < [keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [valueObj toJsonString];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

/**
 *  NSString转JSON字符串
 */
- (NSString *)toJsonStringWithString {
    NSString *selfString = (NSString *)self;
    return [NSString stringWithFormat:@"\"%@\"", [[selfString stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]];
}

/**
 *  NSNumber转JSON字符串
 */
- (NSString *)toJsonStringWithNumber {
    NSNumber *number = (NSNumber *)self;
    NSString *selfString = [number stringValue];
    return [NSString stringWithFormat:@"\"%@\"", [[selfString stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]];
}

/**
 *  NSObject转JSON字符串
 */
- (NSString *)toJsonString {
    NSString *value = nil;
    if (!self) return nil;
    if ([self isKindOfClass:[NSString class]]) {
        value = [self toJsonStringWithString];
    } else if([self isKindOfClass:[NSDictionary class]]) {
        value = [self toJsonStringWithDictionary];
    } else if([self isKindOfClass:[NSArray class]]) {
        value = [self toJsonStringWithArray];
    } else if([self isKindOfClass:[NSNumber class]]) {
        value = [self toJsonStringWithNumber];
    }
    return value;
}

@end