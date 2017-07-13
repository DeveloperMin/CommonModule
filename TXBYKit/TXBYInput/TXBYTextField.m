//
//  TXBYTextField.m
//  txzjExpert
//
//  Created by Limmy on 2017/6/6.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "TXBYTextField.h"

@implementation TXBYTextField
// 方法一
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    if (action == @selector(paste:)) { //禁止粘贴
//        return NO;
//    } else if (action == @selector(select:)) { // 禁止选择
//        return NO;
//    } else  if (action == @selector(selectAll:)) { // 禁止全选
//        return NO;
//    } else if (action == @selector(copy:)) { // 禁止全选
//        return NO;
//    } else if (action == @selector(cut:)) { // 禁止剪切
//        return NO;
//    }
//    return[super canPerformAction:action withSender:sender];
//}
// 方法二
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
