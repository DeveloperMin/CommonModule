//
//  NSArray+TXBY.m
//  TXBYCategory
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "NSArray+TXBY.h"
#import "NSString+TXBY.h"

@implementation NSArray (TXBY)

- (id)randomObject {
    if (!self.count) return nil;
    return self[arc4random_uniform((u_int32_t)self.count)];
}

+ (NSArray *)arrayWithName:(NSString *)name {
    return [self arrayWithName:name bundleName:nil];
}

+ (NSArray *)arrayWithName:(NSString *)name bundleName:(NSString *)bundleName {
    if (![name hasSuffix:@".plist"])
    {
         name = [name stringByAppendingString:@".plist"];
    }
    NSString *path = [NSString bundlePathWithName:bundleName];
    NSString *file = [[NSBundle bundleWithPath:path] pathForResource:name ofType:nil];
    return [NSArray arrayWithContentsOfFile:file];
}

@end


@implementation NSMutableArray (TXBY)

- (id)popFirstObject {
    return [self popObjectAtIndexSafely:0];
}

- (id)popLastObject {
    return [self popObjectAtIndexSafely:self.count - 1];
}

- (id)popObjectAtIndexSafely:(NSUInteger)index {
    if (index >= self.count) return nil;
    return self[index];
}

- (id)removeObjectAtIndexSafely:(NSUInteger)index {
    id obj = [self popObjectAtIndexSafely:index];
    if (obj) {
        [self removeObjectAtIndex:index];
    }
    return obj;
}

- (void)appendObject:(id)anObject {
    [self addObject:anObject];
}

- (void)appendObjects:(NSArray *)objects {
    [self addObjectsFromArray:objects];
}

- (void)prependObject:(id)anObject {
    [self insertObject:anObject atIndex:0];
}

- (void)prependObjects:(NSArray *)objects {
    NSArray *reverseArray = [[objects mutableCopy] reverse];
    for (id obj in reverseArray) {
        [self prependObject:obj];
    }
}

- (NSArray *)reverse {
    NSUInteger count = self.count;
    NSUInteger mid = count / 2;
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
    return self;
}

- (NSArray *)shuffle {
    for (NSInteger i = 0; i < self.count; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
    return self;
}

@end