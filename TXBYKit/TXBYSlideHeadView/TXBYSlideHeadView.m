//
//  TXBYSlideHeadView.m
//  slideNavDemo
//
//  Created by YandL on 16/3/31.
//  Copyright © 2016年 txby. All rights reserved.
//

#import "TXBYSlideHeadView.h"
#import "Masonry.h"
#import "UIColor+TXBY.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
// 文字高度
#define titleH 44
// 选中文字放大
#define MaxScale 1.2

@interface TXBYSlideHeadView ()
/**
 *  文字scrollView
 */
@property (nonatomic, strong) UIScrollView *titleScrollView;
/**
 *  控制器scrollView
 */
@property (nonatomic, strong) UIScrollView *contentScrollView;
/**
 *  标签按钮
 */
@property (nonatomic, strong) NSMutableArray *buttons;
/**
 *  选中的按钮
 */
@property (nonatomic ,strong) UIButton *selectedBtn;
/**
 *  选中的按钮背景图
 */
@property (nonatomic ,strong) UIImageView *imageBackView;
/**
 *  标签文字
 */
@property (nonatomic ,strong) NSMutableArray *titlesArr;
/**
 *  scrollview上的子视图
 */
@property (nonatomic, strong) UIView *contentView;
/**
 *  加载的形式
 */
@property (nonatomic, assign) ScrollViewloadMode loadMode;

@end

@implementation TXBYSlideHeadView

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (NSMutableArray *)titlesArr {
    if (!_titlesArr) {
        _titlesArr = [NSMutableArray array];
    }
    return _titlesArr;
}

/**
 *  创建包含所有控制器的view
 *
 *  @param controllerArr 所有控制器的数组
 *  @param mode          加载的模式
 */
- (void)setSlideHeadViewWithArr:(NSArray *)controllerArr andLoadMode:(ScrollViewloadMode)mode {
    self.loadMode = mode;
    // 注册屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    // 根据数组创建控制器
    UIViewController *superVC = [self superViewForViewController:self];
    // 移除之前添加的控制器
    for (UIViewController *obj in superVC.childViewControllers) {
        [obj removeFromParentViewController];
    }
    for (UIViewController *VC in controllerArr) {
        // 记录所有控制器的标题
        [self.titlesArr addObject:VC.title];
        [superVC addChildViewController:VC];
    }
    // 添加文字标签
    [self setTitleScrollView];
    // 添加scrollView
    [self setContentScrollView];
    // 设置标签按钮 文字 背景图
    [self setupTitleAndViews];
}

/**
 *  设备方向改变
 */
- (void)orientChange:(NSNotification *)noti {
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    if (orient) {
        // 改变方向后需要跳转到滚动前选择的view
        [self click:self.selectedBtn];
    }
}

/**
 *  view所属的控制器
 */
- (UIViewController *)superViewForViewController:(UIView *)sourceView {
    id target = sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

#pragma mark - PRIVATE
/**
 *  设置滚动的标题
 */
- (void)setTitleScrollView {
    UIViewController *superVC = [self superViewForViewController:self];
    self.titleScrollView = [[UIScrollView alloc] init];
    self.titleScrollView.backgroundColor = self.headBackViewColor;
    [superVC.view addSubview:self.titleScrollView];
    // 添加约束
    [self.titleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superVC.view.mas_top);
        make.left.equalTo(superVC.view.mas_left);
        make.right.equalTo(superVC.view.mas_right);
        make.height.equalTo((self.titlesArr.count == 1) ? @0 : [NSNumber numberWithFloat:titleH]);
    }];
}

/**
 *  设置所有滚动的控制器
 */
- (void)setContentScrollView {
    UIViewController *superVC = [self superViewForViewController:self];
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.contentSize = CGSizeMake(self.titlesArr.count * ScreenW, 0);
    [superVC.view addSubview:self.contentScrollView];
    // 添加约束
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleScrollView.mas_bottom);
        make.left.equalTo(superVC.view.mas_left);
        make.right.equalTo(superVC.view.mas_right);
        make.bottom.equalTo(superVC.view.mas_bottom);
    }];
    // 设置scrollview的属性
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator  = NO;
    self.contentScrollView.delegate = self;
    self.contentScrollView.bounces = NO;
    
    // 创建添加在scrollview的contentview中的子视图
    self.contentView = [[UIView alloc] init];
    [self.contentScrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentScrollView);
        make.height.equalTo(self.contentScrollView);
    }];
}

/**
 *  设置标题,子视图
 */
- (void)setupTitleAndViews {
    UIViewController *superVC = [self superViewForViewController:self];
    NSUInteger count = superVC.childViewControllers.count;
    // 点击的btn的宽度
    CGFloat w = 80;
    if (iPhone6p) {
        w = 100;
    }
    
    self.imageBackView  = [[UIImageView alloc] init];
    [self.titleScrollView addSubview:self.imageBackView];
    if (count <= 4) {
        w = ScreenW / count;
    }
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
    // 创建滚动条
    [self.imageBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (count <= 4) {
            make.centerX.equalTo(self.titleScrollView.centerX).multipliedBy(1.0 / count);
            make.width.equalTo(self.titleScrollView.mas_width).multipliedBy(1.0 / (count + 1));
        }
        else {
            make.left.equalTo(self.titleScrollView.mas_left).with.offset(10);
            make.width.equalTo(w - 20);
        }
        make.top.equalTo(self.titleScrollView.mas_top).with.offset(39);
        make.height.equalTo(@2);
    }];
    self.imageBackView.backgroundColor = self.backViewColor;
    self.imageBackView.userInteractionEnabled = YES;
    
    // 记录上一个视图
    UIView *lastView = nil;
    for (int i = 0; i < count; i++) {
        // 根据标题创建button
        UIViewController *vc = superVC.childViewControllers[i];
        UIButton *btn = [[UIButton alloc] init];
        [self.titleScrollView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleScrollView.mas_top);
            make.height.equalTo(titleH);
            // 总数小于4的时候
            if (count <= 4) {
                make.width.equalTo(self.titleScrollView.mas_width).multipliedBy(1.0 / count);
            }
            else {
                make.width.equalTo(w);
            }
            // 如果是第一个btn
            if (i == 0) {
                make.left.equalTo(self.titleScrollView.mas_left);
            }
            // 后续的btn依照前一个btn添加约束
            else {
                NSMutableArray *btnArr = [NSMutableArray array];
                for (id view in [self.titleScrollView subviews]) {
                    if ([view isKindOfClass:[UIButton class]]) {
                        UIButton *btn = view;
                        [btnArr addObject:btn];
                    }
                }
                UIButton *btn = btnArr[i - 1];
                make.left.equalTo(btn.mas_right);
            }
        }];
        
        btn.tag = i;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:self.titleDefaultColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        // 设置btn的点击事件
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
        
        [self.buttons addObject:btn];
        
        // 设置初始选中的btn
        if (i == self.selectedIndex) {
            self.selectedBtn = btn;
        }
        // 创建控制器视图
        UIView *tempView = nil;
        // 如果是预先加载
        if (self.loadMode == loadBeforeClick) {
            tempView = vc.view;
        }
        // 点击后加载
        else {
            tempView = [[UIView alloc] init];
        }
        [self.contentView addSubview:tempView];
        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                // 第一个view
                make.left.equalTo(lastView.mas_right);
            }
            else {
                // 后续的view
                make.left.equalTo(self.contentView.mas_left);
            }
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.width.equalTo(self.contentScrollView.mas_width);
        }];
        // 记录上一个添加的view
        lastView = tempView;
        
    }
    // 视图创建完成后 设置当前选中的btn为第一个
    if (!self.selectedAnimate) {
        [self click:self.selectedBtn];
    } else {
        [self clickWithNoAnimate:self.selectedBtn];
    }
    // 添加contentview的右侧约束
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_right);
    }];
    
    if (self.showBottomLine) {
        // 底部横线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = TXBYColor(222, 222, 222);
        if (self.bottomLineColor) {
            lineView.backgroundColor = self.bottomLineColor;
        }
        [self.titleScrollView addSubview:lineView];
        // 添加约束
        CGFloat lineViewH = 1;
        CGFloat lineViewW = TXBYApplicationW;
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleScrollView.mas_top).offset(titleH - lineViewH);
            make.left.equalTo(self.titleScrollView.mas_left);
            make.height.equalTo(lineViewH);
            make.width.equalTo(lineViewW);
        }];
    }
}

/**
 *  点击后的页面
 */
- (void)setupSelectedChildViewController:(NSInteger)index {
    if (self.titleBlock) {
        NSString *currentTitle = self.titlesArr[index];
        self.titleBlock(currentTitle);
    }
    UIViewController *superVC = [self superViewForViewController:self];
    // 取出需要显示的视图
    UIViewController *vc = superVC.childViewControllers[index];
    // 取出contentview上的空白视图
    UIView *tempView = [self.contentView subviews][index];
    // 如果该视图已经添加过 则不添加
    if (vc.view.superview) {
        return;
    }
    [tempView addSubview:vc.view];
    // 添加约束
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tempView.mas_left);
        make.right.equalTo(tempView.mas_right);
        make.top.equalTo(tempView.mas_top);
        make.bottom.equalTo(tempView.mas_bottom);
    }];
}

/**
 *  点击事件
 */
- (void)click:(UIButton *)sender {
    // 设置选中的btn
    [self selectSelectedTitleBtn:sender animate:YES];
    NSInteger i = sender.tag;
    CGFloat x  = i * ScreenW;
    // 设置scrollview的滚动
    [UIView animateWithDuration:0.4 animations:^{
        self.contentScrollView.contentOffset = CGPointMake(x, 0);
    }];
    
    // 如果是点击后加载
    if (self.loadMode == loadAfterClick) {
        // 设置子视图
        [self setupSelectedChildViewController:i];
    }
}

/**
 *  点击事件(动画)
 */
- (void)clickWithNoAnimate:(UIButton *)sender {
    // 设置选中的btn
    [self selectSelectedTitleBtn:sender animate:NO];
    NSInteger i = sender.tag;
    CGFloat x  = i * ScreenW;
    // 设置scrollview的滚动
    //    [UIView animateWithDuration:0.4 animations:^{
    //        self.contentScrollView.contentOffset = CGPointMake(x, 0);
    //    }];
    [self.contentScrollView setContentOffset:CGPointMake(x, 0) animated:NO];
    // 如果是点击后加载
    if (self.loadMode == loadAfterClick) {
        // 设置子视图
        [self setupSelectedChildViewController:i];
    }
}

/**
 *  选中的标题
 */
- (void)selectSelectedTitleBtn:(UIButton *)btn animate:(BOOL)animate {
    [self.selectedBtn setTitleColor:self.titleDefaultColor forState:UIControlStateNormal];
    self.selectedBtn.transform = CGAffineTransformIdentity;
    // 设置选中颜色
    [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
    btn.transform = CGAffineTransformMakeScale(MaxScale, MaxScale);
    self.selectedBtn = btn;
    // 将选中btn以外的btn设置成默认颜色
    for (UIButton *button in self.buttons) {
        if (button.tag != btn.tag) {
            [button setTitleColor:self.titleDefaultColor forState:UIControlStateNormal];
        }
    }
    // 如果长度大于4 就设定标题滚动到中央位置
    if (self.titlesArr.count > 4) {
        [self setupTitleCenter:btn animate:animate];
    }
}

/**
 *  设置标题的中心
 */
- (void)setupTitleCenter:(UIButton *)sender animate:(BOOL)animate {
    CGFloat offset = 0;
    if (self.titlesArr.count > 4) {
        CGFloat w = 80;
        if (iPhone6p) {
            w = 100;
        }
        offset = w * sender.tag + 40 - ScreenW * 0.5;
    } else {
        offset = sender.center.x - ScreenW * 0.5;
    }
    if (offset < 0) {
        offset = 0;
    }
    
    CGFloat maxOffset  = self.titleScrollView.contentSize.width - ScreenW;
    if (offset > maxOffset && maxOffset > 0) {
        offset = maxOffset;
    }
    
    // 需要将btn滚动到中央位置
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:animate];
}

#pragma mark - UIScrollView  delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger i  = self.contentScrollView.contentOffset.x / ScreenW;
    // 设置选中的btn
    [self selectSelectedTitleBtn:self.buttons[i] animate:YES];
    // 如果是点击后加载
    if (self.loadMode == loadAfterClick) {
        // 设置子视图
        [self setupSelectedChildViewController:i];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX  = scrollView.contentOffset.x;
    NSInteger leftIndex  = offsetX / ScreenW;
    NSInteger rightIdex  = leftIndex + 1;
    
    UIButton *leftButton = self.buttons[leftIndex];
    UIButton *rightButton  = nil;
    if (rightIdex < self.buttons.count) {
        rightButton  = self.buttons[rightIdex];
    }
    CGFloat scaleR  = offsetX / ScreenW - leftIndex;
    CGFloat scaleL  = 1 - scaleR;
    CGFloat transScale = MaxScale - 1;
    
    float scaleNum;
    if (self.titlesArr.count <= 4) {
        scaleNum = 1.0 / self.titlesArr.count;
    }
    else {
        scaleNum = self.titleScrollView.contentSize.width / self.contentScrollView.contentSize.width;
    }
    self.imageBackView.transform  = CGAffineTransformMakeTranslation((offsetX * scaleNum), 0);
    
    leftButton.transform = CGAffineTransformMakeScale(scaleL * transScale + 1, scaleL * transScale + 1);
    rightButton.transform = CGAffineTransformMakeScale(scaleR * transScale + 1, scaleR * transScale + 1);
    
    //设置滚动的时候的btn的字体颜色
    UIColor *rightColor = [UIColor colorWithRed:self.titleColor.red - (self.titleColor.red - self.titleDefaultColor.red) * scaleR green:self.titleColor.green - (self.titleColor.green - self.titleDefaultColor.green) * scaleR blue:self.titleColor.blue - (self.titleColor.blue - self.titleDefaultColor.blue) * scaleR alpha:1];
    
    UIColor *leftColor = [UIColor colorWithRed:self.titleColor.red - (self.titleColor.red - self.titleDefaultColor.red) * scaleL green:self.titleColor.green - (self.titleColor.green - self.titleDefaultColor.green) * scaleL blue:self.titleColor.blue - (self.titleColor.blue - self.titleDefaultColor.blue) * scaleL alpha:1];
    
    [leftButton setTitleColor:rightColor forState:UIControlStateNormal];
    [rightButton setTitleColor:leftColor forState:UIControlStateNormal];
}

@end
