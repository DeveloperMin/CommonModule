//
//  TXBYWebController.m
//
//  Created by Limmy on 2016/12/26.
//  Copyright © 2016年 eeesys. All rights reserved.
//

#import "TXBYWebController.h"

@interface TXBYWebController ()<UIWebViewDelegate>

@end

@implementation TXBYWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI {
    self.webView = [[UIWebView alloc] init];
    if (self.webFrame.size.height > 0) {
        self.webView.frame = self.webFrame;
    } else {
        self.webView.frame = CGRectMake(0, 0, TXBYApplicationW, TXBYApplicationH - 44);
    }
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    WeakSelf;
    progressLayer = [[TXBYWebProgressLayer alloc] init];
    progressLayer.frame = CGRectMake(0, -1.5, TXBYApplicationW, 3);
    progressLayer.progressColor = self.progressColor;
    progressLayer.completeProBlock = ^() {
        [selfWeak emptyViewWithText:@"网络有问题"];
    };
    
    [self.view addSubview:self.webView];
    [self.view.layer addSublayer:progressLayer];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [progressLayer startLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [progressLayer finishedLoad];
}

- (void)dealloc {
    [progressLayer closeTimer];
    [progressLayer removeFromSuperlayer];
    progressLayer = nil;
}

@end
