//
//  ReplyBar.m
//  smh
//
//  Created by eeesysdev3 on 15/3/31.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//

// 文本框的间距
CGFloat const ESTextFieldMargin = 5;
// 按钮的宽度
CGFloat const ESReplyW = 60;

#import "ReplyBar.h"

@interface ReplyBar () <UITextFieldDelegate>

/**
 *  回复文本框
 */
@property (nonatomic, weak) UITextField *textField;

/**
 *  回复按钮
 */
@property (nonatomic, weak) UIButton *reply;

@end

@implementation ReplyBar

#pragma mark - init
/**
 *  创建ReplyBar
 */
+ (instancetype)replyBar {
    return [[self alloc] init];
}

/**
 *  初始化
 */
- (instancetype)init {
    if (self = [super init]) {
        // 设置自身属性
        [self setup];
        
        // 添加回复文本框
        [self setupTextField];
        
        // 添加回复按钮
        [self setupReply];
    }
    return self;
}

#pragma mark - private
/**
 *  设置自身属性
 */
- (void)setup {
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Quest.bundle/quest_reply_bottom_bg"]];
}

/**
 *  添加回复文本框
 */
- (void)setupTextField {
    UITextField *textField = [[UITextField alloc] init];
    self.textField = textField;
    [self addSubview:textField];
    textField.delegate = self;
    // 设置背景颜色
    textField.background = [UIImage resizedImageWithName:@"Quest.bundle/quest_reply_bottom_textfield"];
    // 垂直居中
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.placeholder = @"我也说一句...";
    textField.font = [UIFont systemFontOfSize:16];
    
    // 文本框左边视图
    UIView *fieldLeft = [[UIView alloc] init];
    fieldLeft.frame = CGRectMake(0, 0, 8, 0);
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = fieldLeft;
    
    // return键类型
    textField.returnKeyType = UIReturnKeyDone;
    
    // 监听输入框文字变化
    [textField addTarget:self action:@selector(change) forControlEvents:UIControlEventEditingChanged];
}

/**
 *  文本框内容变化事件
 */
- (void)change {
    if (self.textField.text.length) {
        self.reply.enabled = YES;
    } else {
        self.reply.enabled = NO;
    }
}

/**
 *  添加回复按钮
 */
- (void)setupReply {
    UIButton *reply = [UIButton buttonWithTitle:@"发送" normalBg:@"Quest.bundle/userinfo_relationship_button_background" highlightedBg:@"Quest.bundle/userinfo_relationship_button_highlighted" target:self action:@selector(onClick)];
    self.reply = reply;
    [self addSubview:reply];
    [reply.titleLabel setFont:[UIFont systemFontOfSize:15]];
    reply.enabled = NO;
    [reply setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
}

/**
 *  按钮点击事件
 */
- (void)onClick {
    // 结束编辑
    [self endEditing:YES];
    
    // 调用代理方法
    if ([self.delegate respondsToSelector:@selector(replyBar:textField:)]) {
        [self.delegate replyBar:self textField:self.textField];
    }
}

#pragma mark - UITextFieldDelegate
/**
 *  按下return
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

#pragma mark - super
/**
 *  调整控件位置
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置文本框frame
    self.textField.frame = CGRectMake(ESTextFieldMargin, ESTextFieldMargin, TXBYApplicationW - ESReplyW - 3 * ESTextFieldMargin, self.txby_height - 2 * ESTextFieldMargin);
    
    // 设置按钮frame
    self.reply.frame = CGRectMake(TXBYApplicationW - ESReplyW - ESTextFieldMargin, ESTextFieldMargin, ESReplyW, self.textField.txby_height);
}

@end