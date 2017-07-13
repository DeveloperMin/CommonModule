//
//  TriageView.h
//  smh
//
//  Created by yh on 15/3/20.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//  智能分诊首页View

#import <UIKit/UIKit.h>
@class TriageView;
@class TriageParam;

@protocol TriageViewDelegate <NSObject>

@optional

/**
 *  点击了某个部位
 *
 *  @param part  部位名称
 *  @param param 请求参数(男还是女)
 */
- (void)triageView:(TriageView *)view didClickWithBodyPart:(NSString *)partName param:(TriageParam *)param;

@end

@interface TriageView : UIView

/**
 *  代理
 */
@property (nonatomic, assign) id <TriageViewDelegate> delegate;

@end