//
//  TXBYTabMoreButton.h
//  txzjPatient
//
//  Created by Limmy on 2017/4/17.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TXBYTabMoreItemModel;

@protocol CircleTipsViewDelegate <NSObject>

@optional

- (void)clickCircleTipsViewWithBtn:(UIButton *)btn nickName:(NSString *)nickName;

@end

@interface CircleTipsView: UIView
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
@property (nonatomic, weak) id<CircleTipsViewDelegate> delegate;


@end
