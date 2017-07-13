//
//  QuestionTipsView.h
//  publicCommon
//
//  Created by hj on 2017/7/10.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuestionTipsViewDelegate <NSObject>

@optional

- (void)clickQuestionTipsViewWithBtn:(UIButton *)btn nickName:(NSString *)nickName;

@end

@interface QuestionTipsView : UIView
/**
 *  effectView
 */
@property (nonatomic, weak) UIImageView *effectView;
/**
 *  titleLab
 */
@property (nonatomic, weak) UILabel *titleLab;
/**
 *  textField
 */
@property (nonatomic, weak) UITextField *textField;
/**
 *  delegate
 */
@property (nonatomic, weak) id<QuestionTipsViewDelegate> delegate;
@end
