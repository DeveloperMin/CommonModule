//
//  Drug.h
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//  药价公示模型

#import <Foundation/Foundation.h>

@interface Drug : NSObject

/**
 *  ID
 */
@property (nonatomic, copy) NSString *ID;

/**
 *  产品名称
 */
@property (nonatomic, copy) NSString *cpm;

/**
 *  生产企业
 */
@property (nonatomic, copy) NSString *scs_desc;

/**
 *  中文通用名
 */
@property (nonatomic, copy) NSString *zwtym;

/**
 *  英文通用名
 */
@property (nonatomic, copy) NSString *ywtym;

/**
 *  产品名编码
 */
@property (nonatomic, copy) NSString *cpmbm;

/**
 *  商品名
 */
@property (nonatomic, copy) NSString *spm;

/**
 *  是否处方药
 */
@property (nonatomic, copy) NSString *cfy_desc;

/**
 *  规格
 */
@property (nonatomic, copy) NSString *gg;

/**
 *  标注剂型
 */
@property (nonatomic, copy) NSString *bzjx_desc;

/**
 *  包装材质
 */
@property (nonatomic, copy) NSString *bzcz_desc;

/**
 *  最高零售价
 */
@property (nonatomic, copy) NSString *zglsj;

/**
 *  中标价格
 */
@property (nonatomic, copy) NSString *zbj;

/**
 *  中标零售价
 */
@property (nonatomic, copy) NSString *zblsj;

/**
 *  药品批准文号
 */
@property (nonatomic, copy) NSString *yppzwh;

/**
 *  销售企业
 */
@property (nonatomic, copy) NSString *gys_desc;

@end