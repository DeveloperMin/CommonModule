//
//  TXBYCommentHeaderToolBar.m
//  txzjPatient
//
//  Created by Limmy on 2017/4/25.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "TXBYCommentHeaderToolBar.h"

@interface TXBYCommentHeaderToolBar ()
/**
 *  tagView
 */
@property (nonatomic, weak) UIView *tagView;
/**
 *  currentBtn
 */
@property (nonatomic, weak) UIButton *currentBtn;


@end

@implementation TXBYCommentHeaderToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *tagView = [UIView new];
    self.tagView = tagView;
    tagView.frame = CGRectMake(10, self.txby_height - 2, 60, 2);
    tagView.backgroundColor = TXBYMainColor;
    [self addSubview:tagView];
    
    UIButton *commonBtn = [self setUpOneButtonWithTitle:@"评论"];
    commonBtn.selected = YES;
    self.commonBtn = commonBtn;
    self.currentBtn = commonBtn;
    commonBtn.tag = 0;
    commonBtn.frame = CGRectMake(10, 0, 60, self.txby_height - 2);
    [self clickBtn:commonBtn];
    
    UIButton *likeBtn = [self setUpOneButtonWithTitle:@"赞"];
    likeBtn.tag = 1;
    self.likeBtn = likeBtn;
    likeBtn.frame = CGRectMake(TXBYApplicationW - 70, 0, 60, self.txby_height - 2);
}

- (UIButton *)setUpOneButtonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
//    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self addSubview:btn];
    return btn;
}

- (void)setModel:(CommentHeaderModel *)model {
    _model = model;
    if (model.love.integerValue) {
        [self.likeBtn setTitle:[NSString stringWithFormat:@"赞 %zd", model.love.integerValue] forState:UIControlStateNormal];
    }
    if (model.comment.integerValue) {
        [self.commonBtn setTitle:[NSString stringWithFormat:@"评论 %zd", model.comment.integerValue] forState:UIControlStateNormal];
    }
}

- (void)clickBtn:(UIButton *)btn {
    if (self.currentBtn.tag != btn.tag) {
        btn.selected = !btn.selected;
        self.currentBtn.selected = NO;
        self.currentBtn = btn;
    }
    if (btn.selected) {
        [UIView animateWithDuration:0.2 animations:^{
            self.tagView.txby_centerX = btn.txby_centerX;
        }];
        if ([self.delegate respondsToSelector:@selector(commentHeaderToolClickAction:)]) {
            [self.delegate commentHeaderToolClickAction:btn];
        }
    }
}

@end
