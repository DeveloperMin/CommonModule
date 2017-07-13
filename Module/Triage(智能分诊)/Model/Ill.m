//
//  Ill.m
//  smh
//
//  Created by yh on 15/3/21.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//

#import "Ill.h"

// 单位间隙
CGFloat cellMargin = 10;
// cell内容宽度
#define cellWidth [UIScreen mainScreen].bounds.size.width - 4 * cellMargin

@implementation Ill

#pragma mark - setter
/**
 *  名称font
 */
- (UIFont *)nameFont {
    if (!_nameFont) {
        _nameFont = [UIFont systemFontOfSize:16];
    }
    return _nameFont;
}

/**
 *  其余内容font
 */
- (UIFont *)detailFont {
    if (!_detailFont) {
        _detailFont = [UIFont systemFontOfSize:15];
    }
    return _detailFont;
}

/**
 *   疾病名称
 */
- (void)setDisease_name:(NSString *)disease_name {
    _disease_name = [disease_name copy];
    
    CGFloat nameX = cellMargin * 2;
    CGFloat nameY = cellMargin * 2;
    CGSize nameSize = [disease_name sizeWithFont:self.nameFont maxW:cellWidth];
    _nameFrame = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
}

/**
 *   所在部位
 */
- (void)setPart:(NSString *)part {
    if (part) {
        _part = [NSString stringWithFormat:@"%@%@", @"患病部位：", part];
    }
    CGFloat partX = cellMargin * 2;
    CGFloat partY = CGRectGetMaxY(_nameFrame) + cellMargin * 2;
    CGSize partSize = [_part sizeWithFont:self.detailFont maxW:cellWidth];
    _partFrame = CGRectMake(partX, partY, partSize.width, partSize.height);
}

/**
 *   就诊科室
 */
- (void)setMedical_dept:(NSString *)medical_dept {
    if (medical_dept) {
        _medical_dept = [NSString stringWithFormat:@"%@%@", @"就诊科室：", medical_dept];
    }
    CGFloat deptX = cellMargin * 2;
    CGFloat deptY = CGRectGetMaxY(_partFrame) + cellMargin;
    CGSize deptSize = [_medical_dept sizeWithFont:self.detailFont maxW:cellWidth];
    _deptFrame = CGRectMake(deptX, deptY, deptSize.width, deptSize.height);
    
}

/**
 *   疾病描述
 */
- (void)setContent:(NSString *)content {
    _content = [content copy];
    
    CGFloat descX = cellMargin * 2;
    CGFloat descY = CGRectGetMaxY(_deptFrame) + cellMargin ;
    CGSize descSize = [content  sizeWithFont:self.detailFont maxW:cellWidth];
    _descFrame = CGRectMake(descX, descY, descSize.width, descSize.height);
    // cell高度
    _cellHeight = CGRectGetMaxY(_descFrame) + cellMargin * 2;
}

#pragma mark - public
/**
 *  创建ill模型
 *
 *  @param name    疾病名称
 *  @param part    患病部位
 *  @param dept    就诊科室
 *  @param content 疾病描述
 */
- (instancetype)initWithDiseaseName:(NSString *)name part:(NSString *)part medicalDept:(NSString *)dept andContent:(NSString *)content {
    if (self = [super init]) {
        self.disease_name = name;
        self.part = part;
        self.medical_dept = dept;
        self.content = content;
    }
    return self;
}

/**
 *  创建ill模型
 *
 *  @param dict ill字典
 */
- (instancetype)initWithDict:(NSDictionary *)dict {
    return [self initWithDiseaseName:dict[@"disease_name"] part:dict[@"part"] medicalDept:dict[@"medical_dept"] andContent:dict[@"content"]];
}

/**
 *  创建ill模型
 *
 *  @param name    疾病名称
 *  @param part    患病部位
 *  @param dept    就诊科室
 *  @param content 疾病描述
 */
+ (instancetype)itemWithDiseaseName:(NSString *)name part:(NSString *)part medicalDept:(NSString *)dept andContent:(NSString *)content {
     return [[self alloc] initWithDiseaseName:name part:part medicalDept:dept andContent:content];
}

/**
 *  创建ill模型
 *
 *  @param dict ill字典
 */
+ (instancetype)itemWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end