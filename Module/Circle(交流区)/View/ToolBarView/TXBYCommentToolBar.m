//
//  TXBYCommentToolBar.m
//  txzjPatient
//
//  Created by Limmy on 2017/4/25.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "TXBYCommentToolBar.h"
#import "CommentHeaderCell.h"

@interface TXBYCommentToolBar ()
/**
 *  按钮
 */
@property (nonatomic, strong) NSMutableArray *buttons;
/**
 *  间隔线
 */
@property (nonatomic, strong) NSMutableArray *devides;
/**
 * 评论按钮
 */
@property (nonatomic, strong) UIButton *commentBtn;
/**
 * 赞按钮
 */
@property (nonatomic, strong) UIButton *likeBtn;
/**
 *  shareBtn
 */
@property (nonatomic, strong) UIButton *shareBtn;

@end

@implementation TXBYCommentToolBar
- (NSMutableArray *)buttons {
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (NSMutableArray *)devides {
    if (_devides == nil) {
        _devides = [NSMutableArray array];
    }
    return _devides;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TXBYColor(242, 242, 242);
        //添加所有子控件
        [self setUpAllChild];
    }
    return self;
}

- (void)setUpAllChild {
    UILabel *topLine = [UILabel new];
    topLine.backgroundColor = TXBYColor(245, 245, 245);
    [self addSubview:topLine];
    topLine.frame = CGRectMake(0, 0, TXBYApplicationW, 1);
    
    //分享
    UIButton *shareBtn = [self setUpOneButtonWithImage:[UIImage imageNamed:@"Circle.bundle/circle_share"] Title:@"分享"];
    shareBtn.tag = 1;
    [shareBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _shareBtn = shareBtn;
    
    //评论
    UIButton *commentBtn = [self setUpOneButtonWithImage:[UIImage imageNamed:@"Circle.bundle/circle_comment"] Title:@"评论"];
    commentBtn.tag = 2;
    [commentBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _commentBtn = commentBtn;
    
    //赞
    UIButton *likeBtn = [self setUpOneButtonWithImage:[UIImage imageNamed:@"Circle.bundle/circle_unlike"] Title:@"赞"];
    likeBtn.tag = 3;
    [likeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [likeBtn setImage:[UIImage imageNamed:self.isDoctorUser? @"Circle.bundle/doctor_circle_like":@"Circle.bundle/patient_circle_like"] forState:UIControlStateHighlighted];
    [likeBtn setImage:[UIImage imageNamed:self.isDoctorUser? @"Circle.bundle/doctor_circle_like":@"Circle.bundle/patient_circle_like"] forState:UIControlStateSelected];
    _likeBtn = likeBtn;
    
    //分割线
    for(int i = 0 ; i < 2; i++) {
        UIImageView *devide = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Circle.bundle/circle_line"]];
        [self addSubview:devide];
        [self.devides addObject:devide];
    }
}

- (UIButton *)setUpOneButtonWithImage:(UIImage *)image Title:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self addSubview:btn];
    [self.buttons addObject:btn];
    
    return btn;
}

/**
 * 点击btn的方法
 */
- (void)clickBtn:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(circleToolBarClickBtn:)]) {
        [self.delegate circleToolBarClickBtn:btn];
    }
}

- (void)layoutSubviews {
    CGFloat x = 0;
    NSUInteger count = self.buttons.count;
    
    CGFloat y = 1;
    CGFloat w = TXBYApplicationW / count;
    CGFloat h = self.txby_height - 2;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.buttons[i];
        x = w * i;
        btn.frame = CGRectMake(x, y, w, h);
    }
    int i = 1;
    for (UIImageView *devide in self.devides) {
        UIButton *btn = self.buttons[i];
        devide.txby_x = btn.txby_x;
        devide.txby_y = btn.txby_y + 3;
        i++;
    }
}

- (void)setModel:(CommentHeaderModel *)model {
    _model = model;
    if (model.is_loved.integerValue) {
        self.likeBtn.selected = YES;
    } else {
        self.likeBtn.selected = NO;
    }
}

@end
