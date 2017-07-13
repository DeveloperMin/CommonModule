//
//  NSTimer+addition.h
//
//  Created by Limmy on 2016/12/26.
//  Copyright © 2016年 eeesys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (addition)
/**
 *  停止
 */
- (void)pause;
/**
 *  重新开始
 */
- (void)resume;
/**
 *  重新从某个时间开始
 */
- (void)resumeWithTimeInterval:(NSTimeInterval)time;

@end
