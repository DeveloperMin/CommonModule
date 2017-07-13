//
//  UIImage+TXBY.h
//  TXBYCategory
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TXBY)

/**
 *  加载图片
 *  @param name 图片名
 */
+ (UIImage *)imageWithName:(NSString *)name;
/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;
/**
 *  根据颜色生成对应颜色的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
/**
 *  指定x y返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name xPos:(CGFloat)xPos yPos:(CGFloat)yPos;
/**
 *  获取指定点的图片颜色
 */
- (UIColor *)colorAtPixel:(CGPoint)point;

/**
 *  图片裁剪成圆形
 */
+ (instancetype)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  图片裁剪成圆形(有边框)
 *
 *  @param image          要裁剪的图片
 *  @param borderWidth    边框宽度
 *  @param borderColor    边框颜色
 *  @param imageViewWidth 图框宽度（默认为正方形，即长宽相等）
 *
 */
+ (UIImage *)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth imageViewWidth:(CGFloat)imageViewWidth borderColor:(UIColor *)borderColor;
/**
 *  等比缩放本图片大小
 *
 *  @param newImageWidth 缩放后图片宽度，像素为单位
 *
 *  @return self-->(image)
 */
+ (UIImage *)compressImage:(UIImage *)image newWidth:(CGFloat)newImageWidth;
/**
 *  图片裁剪成圆形(无边框)
 */
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;

/**
 解决相机图片旋转90度问题
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;
@end