//
//  TXBYActionSheet.m
//  TXBYKit
//
//  Created by mac on 16/2/22.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYActionSheet.h"
#import "TXBYActionSheetButton.h"
#import "TXBYKit.h"

// 动画时间
const CGFloat TXBYACTIONSHEET_DEFAULT_ANIMATION_DURATION = 0.25f;
// 背景透明度
const CGFloat TXBYACTIONSHEET_DEFAULT_BACKGROUND_OPACITY = 0.3f;
// 按钮高度
const CGFloat TXBYACTIONSHEET_BUTTON_H = 49.0f;
// 屏幕尺寸
#define TXBYACTIONSHEET_SCREEN_SIZE [UIScreen mainScreen].bounds.size

@interface TXBYActionSheet ()

/**
 *  背景遮罩view
 */
@property (nonatomic, strong) UIView *coverView;

/**
 *  TXBYActionSheet主窗口
 */
@property (nonatomic, strong) UIWindow *backWindow;

/**
 *  底部view
 */
@property (nonatomic, strong) UIView *bottomView;

/**
 *  按钮之间的分割线
 */
@property (nonatomic, strong) UIImage *lineImage;

/** 
 *  代理 
 */
@property (nonatomic, weak) id<TXBYActionSheetDelegate> delegate;

@end

@implementation TXBYActionSheet

#pragma mark - getters and setters
- (UIWindow *)backWindow {
    if (_backWindow == nil) {
        _backWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backWindow.windowLevel = UIWindowLevelStatusBar;
        _backWindow.backgroundColor = [UIColor clearColor];
        [self.backWindow addSubview:self];
    }
    return _backWindow;
}

- (UIView *)coverView {
    if (!_coverView) {
        UIView *coverView = [[UIView alloc] init];
        [coverView setAlpha:0];
        [coverView setUserInteractionEnabled:NO];
        [coverView setFrame:(CGRect){0, 0, [UIScreen mainScreen].bounds.size}];
        [coverView setBackgroundColor:TXBYColor(46, 49, 50)];
        _coverView = coverView;
        
        // 点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [coverView addGestureRecognizer:tap];
    }
    return _coverView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        UIView *bottomView = [[UIView alloc] init];
        [bottomView setBackgroundColor:TXBYColor(233, 233, 238)];
        _bottomView = bottomView;
        [self addSubview:bottomView];
    }
    return _bottomView;
}

- (UIImage *)lineImage {
    if (!_lineImage) {
        _lineImage = [UIImage imageWithName:@"TXBYActionSheet.bundle/cellLine"];
    }
    return _lineImage;
}

- (NSString *)cancelTitle {
    if (!_cancelTitle) {
        _cancelTitle = @"取消";
    }
    return _cancelTitle;
}

- (CGFloat)animationDuration {
    if (!_animationDuration) {
        _animationDuration = TXBYACTIONSHEET_DEFAULT_ANIMATION_DURATION;
    }
    return _animationDuration;
}

- (CGFloat)backgroundOpacity {
    if (!_backgroundOpacity) {
        _backgroundOpacity = TXBYACTIONSHEET_DEFAULT_BACKGROUND_OPACITY;
    }
    return _backgroundOpacity;
}

#pragma mark - methods
/**
 *  显示actionSheet
 */
- (void)show {
    [self setupSubviews];
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_coverView setAlpha:self.backgroundOpacity];
        [_coverView setUserInteractionEnabled:YES];
        
        CGRect frame = _bottomView.frame;
        frame.origin.y -= frame.size.height;
        [_bottomView setFrame:frame];
    } completion:nil];
}

/**
 *  actionSheet消失
 */
- (void)dismiss:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.coverView setAlpha:0];
        [self.coverView setUserInteractionEnabled:NO];
        
        CGRect frame = self.bottomView.frame;
        frame.origin.y += frame.size.height;
        [self.bottomView setFrame:frame];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.backWindow.hidden = YES;

        NSInteger tag = self.otherButtonItems.count;
        // 代理
        if ([_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
            [_delegate actionSheet:self didClickedButtonAtIndex:tag];
        }
        
        // 块代码
        if (self.operation) {
            self.operation(tag);
        }
    }];
}

/**
 *  添加子view
 */
- (void)setupSubviews {
    // 添加遮罩
    [self addSubview:self.coverView];
    
    // 添加标题
    [self setupTitleButton];
    
    // 添加按钮
    [self setupOtherButtons];
    
    // 取消按钮
    [self setupCancelButton];
    
    // 显示backwindow
    self.backWindow.hidden = NO;
}

/**
 *  添加标题按钮
 */
- (void)setupTitleButton {
    if (self.title) {
        CGFloat margin = 30.0f;
        CGFloat vSpace = 0;
        CGSize titleSize = [self.title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0f]}];
        if (titleSize.width > [UIScreen mainScreen].bounds.size.width - margin) {
            vSpace = margin / 2;
        }

        UIView *titleBgView = [[UIView alloc] init];
        titleBgView.backgroundColor = [UIColor whiteColor];
        titleBgView.frame = CGRectMake(0, -vSpace, [UIScreen mainScreen].bounds.size.width, TXBYACTIONSHEET_BUTTON_H + vSpace);
        [self.bottomView addSubview:titleBgView];

        // 标题
        UILabel *label = [[UILabel alloc] init];
        [label setText:self.title];
        [label setNumberOfLines:2.0f];
        [label setTextColor:TXBYColor(111, 111, 111)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:13.0f]];
        [label setBackgroundColor:[UIColor whiteColor]];
        [label setFrame:CGRectMake(margin / 2, 0, [UIScreen mainScreen].bounds.size.width - margin, titleBgView.frame.size.height)];
        [titleBgView addSubview:label];
    }
}

/**
 *  添加按钮
 */
- (void)setupOtherButtons {
    for (int i = 0; i < self.otherButtonItems.count; i++) {
        // 所有按钮
        TXBYActionSheetButton *button = [TXBYActionSheetButton buttonWithItem:self.otherButtonItems[i]];
        [button setTag:i];
        CGFloat buttonY = TXBYACTIONSHEET_BUTTON_H * (i + (self.title ? 1 : 0));
        [button setFrame:CGRectMake(0, buttonY, TXBYACTIONSHEET_SCREEN_SIZE.width, TXBYACTIONSHEET_BUTTON_H)];
        [self.bottomView addSubview:button];
        [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        // 所有线条
        UIImageView *line = [[UIImageView alloc] init];
        [line setImage:self.lineImage];
        [line setContentMode:UIViewContentModeTop];
        CGFloat lineY = (i + (self.title ? 1 : 0)) * TXBYACTIONSHEET_BUTTON_H;
        [line setFrame:CGRectMake(0, lineY, TXBYACTIONSHEET_SCREEN_SIZE.width, 1.0f)];
        [self.bottomView addSubview:line];
    }
}

/**
 *  按钮点击
 */
- (void)didClickButton:(UIButton *)button {
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.coverView setAlpha:0];
        [self.coverView setUserInteractionEnabled:NO];
        
        CGRect frame = _bottomView.frame;
        frame.origin.y += frame.size.height;
        [_bottomView setFrame:frame];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.backWindow.hidden = YES;
        
        NSInteger tag = button.tag;
        // 代理
        if ([_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
            [_delegate actionSheet:self didClickedButtonAtIndex:tag];
        }
        
        // 块代码
        if (self.operation) {
            self.operation(tag);
        }
        
        // item中的块代码
        TXBYActionSheetItem *item = self.otherButtonItems[tag];
        if (item.operation) {
            item.operation();
        }
    }];
}

/**
 *  添加取消按钮
 */
- (void)setupCancelButton {
    CGFloat margin = 5.0f;
    // 取消按钮
    TXBYActionSheetItem *cancelItem = [TXBYActionSheetItem itemWithTitle:self.cancelTitle operation:nil];
    TXBYActionSheetButton *cancelButton = [TXBYActionSheetButton buttonWithItem:cancelItem];
    cancelButton.tag = self.otherButtonItems.count;
    [cancelButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat btnY = TXBYACTIONSHEET_BUTTON_H * (self.otherButtonItems.count + (self.title ? 1 : 0)) + margin;
    [cancelButton setFrame:CGRectMake(0, btnY, [UIScreen mainScreen].bounds.size.width, TXBYACTIONSHEET_BUTTON_H)];
    [self.bottomView addSubview:cancelButton];
    
    CGFloat bottomH = (self.title ? TXBYACTIONSHEET_BUTTON_H : 0) + TXBYACTIONSHEET_BUTTON_H * self.otherButtonItems.count + TXBYACTIONSHEET_BUTTON_H + margin;
    [self.bottomView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, bottomH)];
    [self setFrame:(CGRect){0, 0, [UIScreen mainScreen].bounds.size}];
}

#pragma mark - init
#pragma mark 使用item模型中的块代码
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonItems:(NSArray *)otherButtonItems {
    if (self = [super init]) {
        self.title = title;
        self.cancelTitle = cancelButtonTitle;
        self.otherButtonItems = otherButtonItems;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle {
    return [self initWithTitle:title cancelButtonTitle:cancelButtonTitle otherButtonItems:nil];
}

- (instancetype)initWithTitle:(NSString *)title otherButtonItems:(NSArray *)otherButtonItems {
    return [self initWithTitle:title cancelButtonTitle:nil otherButtonItems:otherButtonItems];
}

- (instancetype)initWithTitle:(NSString *)title {
    return [self initWithTitle:title cancelButtonTitle:nil otherButtonItems:nil];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonItems:(NSArray *)otherButtonItems {
    return [[self alloc] initWithTitle:title cancelButtonTitle:cancelButtonTitle otherButtonItems:otherButtonItems];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle {
    return [self actionSheetWithTitle:title cancelButtonTitle:cancelButtonTitle otherButtonItems:nil];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title otherButtonItems:(NSArray *)otherButtonItems{
    return [self actionSheetWithTitle:title cancelButtonTitle:nil otherButtonItems:otherButtonItems];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title {
    return [self actionSheetWithTitle:title cancelButtonTitle:nil otherButtonItems:nil];
}

#pragma mark 使用代理方法
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonItems:(NSArray *)otherButtonItems delegate:(id<TXBYActionSheetDelegate>)delegate {
    if (self = [super init]) {
        self.title = title;
        self.cancelTitle = cancelButtonTitle;
        self.otherButtonItems = otherButtonItems;
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *) cancelButtonTitle delegate:(id<TXBYActionSheetDelegate>)delegate {
    return [self initWithTitle:title cancelButtonTitle:cancelButtonTitle otherButtonItems:nil delegate:delegate];
}

- (instancetype)initWithTitle:(NSString *)title otherButtonItems:(NSArray *)otherButtonItems delegate:(id<TXBYActionSheetDelegate>)delegate {
    return [self initWithTitle:title cancelButtonTitle:nil otherButtonItems:otherButtonItems delegate:delegate];
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<TXBYActionSheetDelegate>)delegate {
    return [self initWithTitle:title cancelButtonTitle:nil otherButtonItems:nil delegate:delegate];;
}

+ (instancetype)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonItems:(NSArray *)otherButtonItems delegate:(id<TXBYActionSheetDelegate>)delegate {
    return [[self alloc] initWithTitle:title cancelButtonTitle:cancelButtonTitle otherButtonItems:otherButtonItems delegate:delegate];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *) cancelButtonTitle delegate:(id<TXBYActionSheetDelegate>)delegate {
    return [self actionSheetWithTitle:title cancelButtonTitle:cancelButtonTitle otherButtonItems:nil delegate:delegate];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title otherButtonItems:(NSArray *)otherButtonItems delegate:(id<TXBYActionSheetDelegate>)delegate {
    return [self actionSheetWithTitle:title cancelButtonTitle:nil otherButtonItems:otherButtonItems delegate:delegate];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title delegate:(id<TXBYActionSheetDelegate>)delegate {
    return [self actionSheetWithTitle:title cancelButtonTitle:nil otherButtonItems:nil delegate:delegate];
}

#pragma mark 使用块代码
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonItems:(NSArray *)otherButtonItems clicked:(void (^)(NSInteger index))clicked {
    if (self = [super init]) {
        self.title = title;
        self.cancelTitle = cancelButtonTitle;
        self.otherButtonItems = otherButtonItems;
        self.operation = clicked;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *) cancelButtonTitle clicked:(void (^)(NSInteger index))clicked {
    return [self initWithTitle:title cancelButtonTitle:cancelButtonTitle otherButtonItems:nil clicked:clicked];
}

- (instancetype)initWithTitle:(NSString *)title otherButtonItems:(NSArray *)otherButtonItems clicked:(void (^)(NSInteger index))clicked {
    return [self initWithTitle:title cancelButtonTitle:nil otherButtonItems:otherButtonItems clicked:clicked];
}

- (instancetype)initWithTitle:(NSString *)title clicked:(void (^)(NSInteger index))clicked {
    return [self initWithTitle:title cancelButtonTitle:nil otherButtonItems:nil  clicked:clicked];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonItems:(NSArray *)otherButtonItems clicked:(void (^)(NSInteger index))clicked {
    return [[self alloc] initWithTitle:title cancelButtonTitle:cancelButtonTitle otherButtonItems:otherButtonItems clicked:clicked];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *) cancelButtonTitle clicked:(void (^)(NSInteger index))clicked {
    return [self actionSheetWithTitle:title cancelButtonTitle:cancelButtonTitle otherButtonItems:nil clicked:clicked];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title otherButtonItems:(NSArray *)otherButtonItems clicked:(void (^)(NSInteger index))clicked {
    return [self actionSheetWithTitle:title cancelButtonTitle:nil otherButtonItems:otherButtonItems clicked:clicked];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title clicked:(void (^)(NSInteger index))clicked {
    return [self actionSheetWithTitle:title cancelButtonTitle:nil otherButtonItems:nil clicked:clicked];
}

@end