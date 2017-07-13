//
//  saoSeven.h
//  saoSeven
//

#import <UIKit/UIKit.h>

@interface saoSeven : UIView
/**
 *  显示数组
 */
@property(retain,nonatomic) NSMutableArray *array;
/**
 *  第二组数据
 */
@property (nonatomic, strong) NSMutableArray *array2;
/**
 *  最大值
 */
@property(retain,nonatomic) NSString *number;
/**
 *  分多少组
 */
@property(retain,nonatomic) NSString *count;
/**
 *  title
 */
@property (nonatomic, copy) NSString *title;
/**
 *  x轴要显示的内容
 */
@property (nonatomic, strong) NSArray *dataX;
/**
 *  正常值 低
 */
@property (nonatomic, assign) CGFloat commonY1;
/**
 *  正常值 高
 */
@property (nonatomic, assign) CGFloat commonY2;
/**
 *  rightTitle
 */
@property (nonatomic, copy) NSString *rightTitle;

@end
