//
//  TXBYCircleModel.m
//  txzjPatient
//
//  Created by Limmy on 2017/4/22.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "TXBYCircleModel.h"
#import "TXBYCircleImg.h"

extern const CGFloat contentLabelFontSize;
extern CGFloat maxContentLabelHeight;

@implementation TXBYCircleModel {
    CGFloat _lastContentWidth;
}

@synthesize content = _content;

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"imgs":[TXBYCircleImg class]};
}

- (void)setContent:(NSString *)content{
    _content = content;
}

- (NSString *)content {
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGRect textRect = [_content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
        if (textRect.size.height > maxContentLabelHeight) {
            _shouldShowMoreButton = YES;
        } else {
            _shouldShowMoreButton = NO;
        }
    }
    return _content;
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}

@end

@implementation TXBYTitleItem

@end
