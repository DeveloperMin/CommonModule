//
//  NSArray+TXBY.h
//  TXBYCategory
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (TXBY)

/**
 *  从数组中返回一个随机元素
 *  如果数组为空则返回nil
 */
- (id)randomObject;

/**
 *  mainBundle中取plist
 */
+ (NSArray *)arrayWithName:(NSString *)name;

/**
 *  其它Bundle中取plist
 */
+ (NSArray *)arrayWithName:(NSString *)name bundleName:(NSString *)bundleName;

@end


@interface NSMutableArray (TXBY)

/**
 *  取出数组第一个元素
 *  如果数组为空则返回nil，不为空返回对应的元素
 */
- (id)popFirstObject;

/**
 *  取出数组最后一个元素
 *  如果数组为空则返回nil，不为空返回对应的元素
 */
- (id)popLastObject;

/**
 *  取出数组指定位置的元素
 *  如果对应的元素不存在则返回nil
 *  @param index 指定的位置索引
 */
- (id)popObjectAtIndexSafely:(NSUInteger)index;

/**
 *  删除数组指定位置的元素
 *  如果对应的元素不存在则返回nil
 *  @param index 指定的位置索引
 */
- (id)removeObjectAtIndexSafely:(NSUInteger)index;

/**
 *  向数组尾部添加一个元素
 *  @param anObject 待添加的元素
 */
- (void)appendObject:(id)anObject;

/**
 *  向数组尾部添加一个数组
 *  @param anObject 待添加的数组
 */
- (void)appendObjects:(NSArray *)objects;

/**
 *  向数组头部添加一个元素
 *  @param anObject 待添加的元素
 */
- (void)prependObject:(id)anObject;

/**
 *  向数组头部添加一个数组
 *  @param anObject 待添加的数组
 */
- (void)prependObjects:(NSArray *)objects;

/**
 *  数组反转
 */
- (NSArray *)reverse;

/**
 *  随机打乱数组元素
 */
- (NSArray *)shuffle;

@end