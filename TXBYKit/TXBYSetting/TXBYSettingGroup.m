//
//  TXBYSettingGroup.m
//  TXBYKit
//
//  Created by mac on 16/2/24.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYSettingGroup.h"

@implementation TXBYSettingGroup

- (NSArray *)items {
    if (!_items) {
        _items =[NSArray array];
    }
    return _items;
}

+ (instancetype)group {
    return [[self alloc] init];
}

+ (instancetype)groupWithItems:(NSArray *)items {
    TXBYSettingGroup *group = [TXBYSettingGroup group];
    group.items = items;
    return group;
}

- (void)addItem:(TXBYSettingItem *)anItem {
    NSMutableArray *arrayM = [self.items mutableCopy];
    [arrayM addObject:anItem];
    self.items = [arrayM copy];
}

@end