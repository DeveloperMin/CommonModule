//
//  TXBYTabMoreButton.m
//  txzjPatient
//
//  Created by Limmy on 2017/4/17.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "CircleTipsView.h"
#import "UIImage+ImageEffects.h"
#import "TXBYTabMoreItemView.h"
#import "TXBYTabMoreItemModel.h"

@interface CircleTipsView ()
/**
 *  moreItemViews
 */
@property (nonatomic, strong) NSMutableArray *moreItemViews;
/**
 *  addBtn
 */
@property (nonatomic, weak) UIButton *addBtn;
/**
 *  itemModels
 */
@property (nonatomic, strong) NSArray *itemModels;

@end

@implementation CircleTipsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self addGestureRecognizer:tap];
    //毛玻璃
    UIImageView *effectView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.effectView = effectView;
    effectView.userInteractionEnabled = YES;
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithRed:0.18 green:0.15 blue:0.20 alpha:0.3]];
    effectView.image = image;
//    effectView.image = [image applyLightEffect];
    [self addSubview:effectView];
    
    UIView *tipView = [UIView new];
    [self addSubview:tipView];
    tipView.layer.cornerRadius = 5;
    tipView.layer.masksToBounds = YES;
    tipView.backgroundColor = [UIColor whiteColor];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.centerY.equalTo(self.centerY);
        make.width.equalTo(self.mas_width).multipliedBy(0.75);
        make.height.equalTo(self.mas_width).multipliedBy(0.44);
    }];
    
    UILabel *titleLab = [UILabel new];
    self.titleLab = titleLab;
    [tipView addSubview:titleLab];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"请输入您的昵称";
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.backgroundColor = TXBYMainColor;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tipView.centerX);
        make.top.equalTo(tipView.top);
        make.width.equalTo(tipView.width);
        make.height.equalTo(40);
    }];
    
    UITextField *textField = [UITextField new];
    self.textField = textField;
    textField.backgroundColor = TXBYColor(240, 240, 240);
    textField.textColor = TXBYMainColor;
    textField.layer.cornerRadius = 5;
    textField.layer.masksToBounds = YES;
    textField.textAlignment= NSTextAlignmentCenter;
    [tipView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(tipView.width).multipliedBy(0.8);
        make.height.equalTo(35);
        make.centerY.equalTo(tipView.centerY);
        make.centerX.equalTo(tipView.centerX);
    }];
    
    UIView *btnView = [UIView new];
    [tipView addSubview:btnView];
    btnView.backgroundColor = TXBYColor(240, 240, 240);
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tipView.centerX);
        make.bottom.equalTo(tipView.bottom);
        make.width.equalTo(tipView.width);
        make.height.equalTo(40);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:TXBYMainColor forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [btnView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnView.left);
        make.bottom.equalTo(btnView.bottom);
        make.width.equalTo(btnView.width).multipliedBy(0.5);
        make.top.equalTo(btnView.top).offset(1);
    }];
    cancelBtn.tag = 0;
    [cancelBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confimBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confimBtn setTitleColor:TXBYMainColor forState:UIControlStateNormal];
    confimBtn.backgroundColor = [UIColor whiteColor];
    [confimBtn setTitle:@"确认" forState:UIControlStateNormal];
    [btnView addSubview:confimBtn];
    [confimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnView.top).mas_offset(1);
        make.left.equalTo(cancelBtn.right).offset(1);
        make.right.equalTo(btnView.right);
        make.bottom.equalTo(tipView.bottom);
    }];
    confimBtn.tag = 1;
    [confimBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)endEdit {
    [self.textField endEditing:YES];
}

- (void)clickBtn:(UIButton *)btn {
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(clickCircleTipsViewWithBtn:nickName:)]) {
        [self.delegate clickCircleTipsViewWithBtn:btn nickName:self.textField.text];
    }
}

@end
