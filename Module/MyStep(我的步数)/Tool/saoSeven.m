//
//  saoSeven.m
//  saoSeven
//

//


/*************************************************************
 
 
      更多IOS问题可以加群138240252咨询交流学习
 
                                   ------- saoSeven
 **************************************************************/

#import "saoSeven.h"

@interface saoSeven ()
/**
 *  tipLab
 */
@property (nonatomic, strong) UILabel *tipLab;
@end

@implementation saoSeven
@synthesize array;
@synthesize array2;
@synthesize number;
@synthesize count;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        array = [[NSMutableArray alloc]init]; //初始化数组
        array2 = [[NSMutableArray alloc]init]; //初始化数组;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGFloat max = [number floatValue];
    int todayHour = [count intValue];
    if (array.count) {
        float pointW = (self.bounds.size.width - 20) / (self.count.floatValue - 1) - 2; // 每个点的距离 30 为 底部 0 0 相加w
        //阴影
        //CGContextRef context2 = UIGraphicsGetCurrentContext();
        //CGContextMoveToPoint(context2, 10, self.frame.size.height - 45);
        //for (int i = 0; i < todayHour; i++) {
            //int cc =[array[i] intValue];
            //CGContextAddLineToPoint(context2, 10+i*pointW+pointW, self.frame.size.height - (self.frame.size.height-80)/ max*cc - 45);// 同上
        //}
        //CGContextAddLineToPoint(context2, 10+todayHour*pointW, self.frame.size.height-45);// 阴影是要填充的，最后 一个点 构成不规则矩形。
        //// [[UIColor greenColor]setFill];
        //[[UIColor colorWithRed:1 green:1 blue:1 alpha:.5] setFill];
        //CGContextFillPath(context2);//填充路径
        
        // 阴影2
        //if (array2.count) {
            //CGContextRef context4 = UIGraphicsGetCurrentContext();
            //CGContextMoveToPoint(context4, 10, self.frame.size.height - 45);
            //for (int i = 0; i < todayHour; i++) {
                //int cc =[array[i] intValue];
                //CGContextAddLineToPoint(context4, 10+i*pointW+pointW, self.frame.size.height - (self.frame.size.height-80)/ max*cc - 45);// 同上
            //}
            //CGContextAddLineToPoint(context4, 10+todayHour*pointW, self.frame.size.height-45);// 阴影是要填充的，最后 一个点 构成不规则矩形。
            //[[UIColor colorWithRed:26/255.0 green:131/255.0 blue:211/255.0 alpha:.8] setFill];
            //CGContextFillPath(context4);//填充路径
        //}
        
        // 折线1
        CGContextRef context1 = UIGraphicsGetCurrentContext();
        [[UIColor whiteColor] setStroke];
        // 折线
        CGContextSetLineWidth(context1, 1.0);//线粗细
        //CGContextMoveToPoint(context1, 10,self.frame.size.height - 45); // 0点数据
        for (int i = 0, j = 0; i < todayHour; i++) { // 1-当前时间数据
            float ez = [array[i] floatValue];
//            if (ez > 0) {
                if (j == 0) {
                    CGContextMoveToPoint(context1, 10+i*pointW + 5, self.frame.size.height-  (self.frame.size.height-80)/max*ez-40);
                    j++;
                } else {
                    CGContextAddLineToPoint(context1, 10+i*pointW + 5, self.frame.size.height- (self.frame.size.height-80)/max*ez-40);
                }
//            }
        }
        CGContextStrokePath(context1);
        
        //todayCount = -1;
        //画圆点
        [[UIColor whiteColor] setFill];
        
        //CGContextFillEllipseInRect(context1,CGRectMake(10, self.frame.size.height-48, 5, 5));
        //[[UIColor orangeColor]setFill];
        //CGContextFillEllipseInRect(context1,CGRectMake(10.8, self.frame.size.height-47.5, 3, 3));
        
        for (int i = 0; i < todayHour; i++) {
            float vn = [array[i] floatValue];
//            if (vn > 0) {
                [[UIColor whiteColor]setFill];
                CGRect rect = CGRectMake(10 + i*pointW, self.frame.size.height-44-(self.frame.size.height-80)/max*vn, 8, 8);
                [self setUpDotButttonWithRect:rect index:i];
                CGContextFillEllipseInRect(context1, rect);// 大圆点 背景为白色
                [[UIColor whiteColor] setFill];
                CGContextFillEllipseInRect(context1, CGRectMake(11+i*pointW, self.frame.size.height-44-  (self.frame.size.height-80)/max*vn + 1, 3, 3));//小圆点颜色和背景色一样  叠加后出现 空心圆效果
//            }
        }
    }
    
    //    上下白线
    CGContextRef context7= UIGraphicsGetCurrentContext();
    //        CGContextSetLineDash(context7, 0, lenghts, 2);//虚线模式
    CGContextMoveToPoint(context7, 5, 40);
    CGContextAddLineToPoint(context7, self.bounds.size.width-5, 40);
    //    [[UIColor orangeColor]setStroke];
    CGContextSetStrokeColorWithColor(context7, [UIColor whiteColor].CGColor);
    
    CGContextMoveToPoint(context7, 5, self.bounds.size.height-40);
    CGContextAddLineToPoint(context7, self.bounds.size.width-5, self.bounds.size.height-40);
    
    CGContextStrokePath(context7);
    
    //虚线
    if (array.count) {
        CGFloat lenghts[]={5,5};//虚线的长度
        CGContextRef ctx2 = UIGraphicsGetCurrentContext();
        CGContextSetLineDash(ctx2, 0, lenghts, 2);//虚线模式
//        CGFloat commonY1H = ((1-self.commonY1/number.doubleValue) * (self.bounds.size.height - 80)) + 40;
        CGFloat commonY1H = (self.bounds.size.height - 80) / 2 + 40;
        CGContextMoveToPoint(ctx2, 5, commonY1H);
        CGContextAddLineToPoint(ctx2, self.bounds.size.width-5, commonY1H);
        CGContextStrokePath(ctx2);
        NSString *strY1 = [NSString stringWithFormat:@"%ld", (long)self.number.integerValue / 2];
        [strY1 drawInRect:CGRectMake(self.bounds.size.width - 40, commonY1H - 15, 40, 20) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:10.0], NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        CGContextRef ctx3 = UIGraphicsGetCurrentContext();
        CGContextSetLineDash(ctx3, 0, lenghts, 2);//虚线模式
        CGFloat commonY2H = ((1-self.commonY2/number.doubleValue) * (self.bounds.size.height - 80) + 40);
        CGContextMoveToPoint(ctx3, 5, commonY2H);
        CGContextAddLineToPoint(ctx3, self.bounds.size.width-5, commonY2H);
        CGContextStrokePath(ctx3);
        NSString *strY2 = [NSString stringWithFormat:@"%.1f", self.commonY2];
        [strY2 drawInRect:CGRectMake(8, commonY2H, 25, 20) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:10.0], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    } else {
        [@"没有相关数据" drawInRect:CGRectMake((TXBYApplicationW - 120)/2, self.txby_height/2 - 10, 120, 20) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    
    //文字
    CGContextRef ctxW = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctxW, 1, 1, 1, 1.0);//设置填充颜色
    UIFont *font12 = [UIFont boldSystemFontOfSize:10.0];//设置
    UIFont *font20 = [UIFont boldSystemFontOfSize:18.0];
    UIFont *font14 =[UIFont boldSystemFontOfSize:16.0];
    [self.title drawInRect:CGRectMake(15, 8, 120, 23) withAttributes:@{NSFontAttributeName:font20, NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.rightTitle drawInRect:CGRectMake(self.txby_width - 100, 12, 100, 20) withAttributes:@{NSFontAttributeName:font14, NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // x轴数据
    float textW = (self.bounds.size.width - 20) / (self.dataX.count - 1);
    for (NSInteger i = 0; i < self.dataX.count; i++) {
        CGFloat textX = textW * i;
        if (i == 0) {
            textX = 10;
        }
        [self.dataX[i] drawInRect:CGRectMake(textX, self.bounds.size.height - 30, 80, 20) withAttributes:@{NSFontAttributeName:font12, NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    
    [@"0" drawInRect:CGRectMake(self.bounds.size.width - 8, self.bounds.size.height - 55, 20, 20) withAttributes:@{NSFontAttributeName:font12, NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self setUpTipLab];
}

- (void)setUpTipLab {
    self.tipLab = [UILabel new];
    [self addSubview:self.tipLab];
    self.tipLab.backgroundColor = [UIColor clearColor];
    self.tipLab.textColor = [UIColor whiteColor];
    self.tipLab.font = [UIFont systemFontOfSize:12];
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(25);
    }];
}

- (void)setUpDotButttonWithRect:(CGRect)rect index:(NSInteger)index {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(rect.origin.x - 3, rect.origin.y - 3, 14, 14);
    btn.tag = index;
    [self addSubview:btn];
    [btn addTarget:self action:@selector(clickDotButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickDotButton:(UIButton *)btn {
    NSString *str = [NSString stringWithFormat:@"%@", array[btn.tag]];
    self.tipLab.text = str;
    [self.tipLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn.txby_x);
    }];
}

@end
