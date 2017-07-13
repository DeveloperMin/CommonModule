//
//  TXBYCircleToolBar.m
//  txzjPatient
//
//  Created by Limmy on 2017/4/24.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "TXBYCircleToolBar.h"
#import "TXBYCircleModel.h"

@interface TXBYCircleToolBar ()
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

@end

@implementation TXBYCircleToolBar

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
    
    //评论
    UIButton *commentBtn = [self setUpOneButtonWithImage:[UIImage imageNamed:@"Circle.bundle/circle_comment"] Title:@"评论"];
    commentBtn.tag = 1;
    [commentBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _commentBtn = commentBtn;
    
    //赞
    UIButton *likeBtn = [self setUpOneButtonWithImage:[UIImage imageNamed:@"Circle.bundle/circle_unlike"] Title:@"赞"];
    likeBtn.tag = 2;
    [likeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _likeBtn = likeBtn;
    
    //分割线
    for(int i = 0 ; i < 1; i++) {
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
    CGFloat w = TXBYApplicationW /count;
    CGFloat h = self.txby_height - 2;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.buttons[i];
        x = w * i;
        btn.frame = CGRectMake(x, y, w, h);
    }
    int i= 1;
    for (UIImageView *devide in self.devides) {
        UIButton *btn = self.buttons[i];
        devide.txby_x = btn.txby_x;
        devide.txby_y = btn.txby_y + 3;
        i++;
    }
}

- (void)setCircleModel:(TXBYCircleModel *)circleModel {
    _circleModel = circleModel;
    //设置评论数
    if (circleModel.comment.integerValue) {
        [self setButton:_commentBtn withTilte:circleModel.comment.integerValue];
    } else {
        [_commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    }
    
    if (circleModel.is_loved.integerValue) {
        _likeBtn.selected = YES;
    } else {
        _likeBtn.selected = NO;
    }
    //设置赞数
    [_likeBtn setTitleColor:self.isDoctorUser?TXBYColor(252, 94, 129):TXBYColor(60, 132, 253) forState:UIControlStateSelected];
    [_likeBtn setImage:[UIImage imageNamed:self.isDoctorUser? @"Circle.bundle/doctor_circle_like":@"Circle.bundle/patient_circle_like"] forState:UIControlStateHighlighted];
    [_likeBtn setImage:[UIImage imageNamed:self.isDoctorUser? @"Circle.bundle/doctor_circle_like":@"Circle.bundle/patient_circle_like"] forState:UIControlStateSelected];
    if (circleModel.love.integerValue) {
        [self setButton:_likeBtn withTilte:circleModel.love.integerValue];
    } else {
        [_likeBtn setTitle:@"赞" forState:UIControlStateNormal];
    }
}

- (void)setButton:(UIButton *)btn withTilte:(NSInteger)count {
    NSString *title = nil;
    if (count) {
        if (count > 10000) {
            CGFloat floatCount = count/10000.0;
            title = [NSString stringWithFormat:@"%.1fW", floatCount];
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        } else {
            title = [NSString stringWithFormat:@"%zd", count];
        }
        [btn setTitle:title forState:UIControlStateNormal];
    }
}

@end
