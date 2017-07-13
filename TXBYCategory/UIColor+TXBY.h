//
//  UIColor+TXBY.h
//  TXBYCategory
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (TXBY)


- (CGColorSpaceModel) colorSpaceModel;
/**
 *  red值
 */
- (CGFloat)red;
/**
 *  green值
 */
- (CGFloat)green;
/**
 *   blue值
 */
- (CGFloat)blue;
/**
 *  透明度值
 */
- (CGFloat)alpha;

/**
 *  十六进制转化成RGB
 */
+ (UIColor *) colorWithHexString:(NSString *)color;
@end
