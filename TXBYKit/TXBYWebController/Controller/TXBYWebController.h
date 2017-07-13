//
//  TXBYWebController.h
//
//  Created by Limmy on 2016/12/26.
//  Copyright © 2016年 eeesys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXBYWebProgressLayer.h"

@interface TXBYWebController : UIViewController{
    TXBYWebProgressLayer *progressLayer; // 网页加载进度条
}
/**
 *  url
 */
@property (nonatomic, copy) NSString *url;
/**
 *  webView
 */
@property (nonatomic, strong) UIWebView *webView;
/**
 *  webFrame
 */
@property (nonatomic, assign) CGRect webFrame;
/**
 *  进度条的颜色
 */
@property (nonatomic, weak) UIColor *progressColor;

@end
