//
//  PushViewController.m
//  TestJava
//
//  Created by 流诗语 on 2017/7/3.
//  Copyright © 2017年 刘世玉. All rights reserved.
//

#import "PushViewController.h"
#import <WebKit/WebKit.h>
#import <WebKit/WKWebView.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface PushViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView * webView;
@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.view addSubview:self.webView];
    
    
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    JSContext * context = [webView valueForKey:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"request"] = ^(){
        
        NSLog(@"你点击我了");
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIWebView *)webView
{
    if (!_webView) {
        _webView= [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate =self;
        
    }
    return _webView;
}

@end
