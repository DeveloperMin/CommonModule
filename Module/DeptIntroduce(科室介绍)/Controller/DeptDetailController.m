//
//  DeptDetailController.m
//  taicang
//
//  Created by txby on 16/1/6.
//  Copyright © 2016年 eeesys. All rights reserved.
//

#import "TXBYKit.h"
#import "DeptDetailController.h"
#import "DeptParam.h"
#import "DeptDetail.h"

@interface DeptDetailController ()
/**
 *  详情对象
 */
@property (nonatomic, retain) DeptDetail *detail;
@end

@implementation DeptDetailController

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    //网络请求
    [self request];
}
#pragma mark - private
/**
 *  网络请求
 */
- (void)request {
    // 请求参数
    DeptParam *param = [DeptParam param];
    param.ID = self.ID;
    // 发送请求
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    WeakSelf;
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYDeptIntroduceDetailAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id json) {
        [MBProgressHUD hideHUDForView:selfWeak.view animated:YES];
        if (![json[@"errcode"] isEqual:@0]) {
            // 提示信息
            [selfWeak emptyViewWithText:@"暂无相关介绍"];
        }
        else {
            [selfWeak showDeptIntro:json[@"dept"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:selfWeak.view animated:YES];
        NSLog(@"%@", error);
    }];
}

/**
 *  显示部门介绍
 */
- (void)showDeptIntro:(NSDictionary *)dept {
    // 1.取出网页内容
    NSString *body = dept[@"body"];
    // 2.取出图片
    NSArray *imgs = dept[@"imgs"];
    // 循环控制变量
    int i = 0;
    // 初始化js 变量
    NSString *js = [[NSString alloc] init];
    NSURL *localImg = [[NSBundle mainBundle] URLForResource:@"news_load@2x" withExtension:@"png"];
    //遍历科室
    for (NSDictionary *img in imgs) {
        js = [js stringByAppendingString:@"<script type=\"text/javascript\">\n"];
        
        js = [js stringByAppendingString:[NSString stringWithFormat:@"var obj%d = new Image();\n", i]];
        js = [js stringByAppendingString:[NSString stringWithFormat:@"obj%d.src=\"%@\";\n", i,img[@"src"]]];
        
        js = [js stringByAppendingString:[NSString stringWithFormat:@"obj%d.onload=function() {\n", i]];
        js = [js stringByAppendingString:[NSString stringWithFormat:@"document.getElementById(\"mypic%d\").src=this.src;\n",i]];
        js = [js stringByAppendingString:[NSString stringWithFormat:@"}\n"]];
        js = [js stringByAppendingString:[NSString stringWithFormat:@"</script>\n"]];
        
        NSArray *origin = [img[@"pixel"] componentsSeparatedByString:@"*"];
        if (origin.count == 1) {
            CGFloat width = TXBYApplicationW - 18;
            NSString *imgHTML = [NSString stringWithFormat:@"<img id=\"mypic%d\" src=\"%@\" width=\"%f\" height=\"%f\">", i++, localImg, width, width * 1.3];
            body = [body stringByReplacingOccurrencesOfString:img[@"ref"] withString:imgHTML];
        }
        else {
            CGFloat originW = [origin[0] floatValue];
            CGFloat originH = [origin[1] floatValue];
            CGFloat width = TXBYApplicationW - 18;
            CGFloat height = width / originW * originH;
            NSString *imgHTML = [NSString stringWithFormat:@"<img id=\"mypic%d\" src=\"%@\" width=\"%f\" height=\"%f\">", i++, localImg, width, height];
            body = [body stringByReplacingOccurrencesOfString:img[@"ref"] withString:imgHTML];
        }
    }
    // 3.取出科室名称
    NSString *title = dept[@"title"];
    self.navigationItem.title = title;
    // 头部内容
    NSString *header = [NSString stringWithFormat:@"<p class=\"title\">%@</p>", title];
    
    NSError *error = NULL;
    // 定义一个正则规则
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(width=)[^\"]+(px )+(height=)[^\"]+(px)" options:0 error:&error];
    
    // 根据规则替换body中对的字符串
    NSString *result = [regex stringByReplacingMatchesInString:body options:0 range:NSMakeRange(0, body.length) withTemplate:[NSString stringWithFormat:@"width=%fpx height=%fpx",TXBYApplicationW - 16, (TXBYApplicationW - 16) / 1.5]];
    
    body = [NSString stringWithFormat:@"%@%@", header, result];
    body = [body stringByAppendingString:js];
    
    // 链接mainBundle中的CSS文件
    NSURL *cssURL = [[NSBundle mainBundle] URLForResource:@"news" withExtension:@"css"];
    body = [NSString stringWithFormat:@"%@<link rel=\"stylesheet\" href=\"%@\">", body, cssURL];
    
    // 3.创建一个webView，显示网页
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    
    // 5.加载网页内容
    [webView loadHTMLString:body baseURL:nil];
    
}

@end
