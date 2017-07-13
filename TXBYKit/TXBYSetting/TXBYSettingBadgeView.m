//
//  TXBYSettingBadgeView.m
//  TXBYKit
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYSettingBadgeView.h"
#import "TXBYCategory.h"

@implementation TXBYSettingBadgeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置按钮字体
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        // 设置背景图片
        [self setBackgroundImage:[UIImage resizedImageWithName:@"TXBYSetting.bundle/main_badge"] forState:UIControlStateNormal];
        // 设置按钮高度为背景图片的高度
        self.txby_size = self.currentBackgroundImage.size;
        self.userInteractionEnabled = NO;
    }
    return self;
}

#pragma mark - setter方法
/**
 *  设置提醒数字
 */
- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = [badgeValue copy];
    
    int value = badgeValue.intValue;
    if (value == 0) { // 没有值可以显示
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
    
    // 设置按钮文字
    [self setTitle:badgeValue forState:UIControlStateNormal];
}

@end