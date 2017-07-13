//
//  Ill.h
//  smh
//
//  Created by yh on 15/3/21.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  疾病

#import <Foundation/Foundation.h>

@interface Ill : NSObject

/**
 *  疾病名称
 */
@property (nonatomic, copy) NSString *disease_name;

/**
 *  名称font
 */
@property (nonatomic, strong) UIFont *nameFont;

/**
 *  其余内容font
 */
@property (nonatomic, strong) UIFont *detailFont;

/**
 *  所在部位
 */
@property (nonatomic, copy) NSString *part;

/**
 *  就诊科室
 */
@property (nonatomic, copy) NSString *medical_dept;

/**
 *  疾病描述
 */
@property (nonatomic, copy) NSString *content;

/**
 *  cell高度
 */
@property (nonatomic, readonly) CGFloat cellHeight;

/**
 *  疾病名称frame
 */
@property (nonatomic, readonly) CGRect nameFrame;

/**
 *  患病部位frame
 */
@property (nonatomic, readonly) CGRect partFrame;

/**
 *  就诊科室frame
 */
@property (nonatomic, readonly) CGRect deptFrame;

/**
 *  疾病描述frame
 */
@property (nonatomic, readonly) CGRect descFrame;

/**
 *  创建ill模型
 *
 *  @param name    疾病名称
 *  @param part    患病部位
 *  @param dept    就诊科室
 *  @param content 疾病描述
 */
- (instancetype)initWithDiseaseName:(NSString *)name part:(NSString *)part medicalDept:(NSString *)dept andContent:(NSString *)content;

/**
 *  创建ill模型
 *
 *  @param dict ill字典
 */
- (instancetype)initWithDict:(NSDictionary *)dict;

/**
 *  创建ill模型
 *
 *  @param name    疾病名称
 *  @param part    患病部位
 *  @param dept    就诊科室
 *  @param content 疾病描述
 */
+ (instancetype)itemWithDiseaseName:(NSString *)name part:(NSString *)part medicalDept:(NSString *)dept andContent:(NSString *)content;

/**
 *  创建ill模型
 *
 *  @param dict ill字典
 */
+ (instancetype)itemWithDict:(NSDictionary *)dict;

@end