//
//  GGWebViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGWebViewController.h"

@interface GGWebViewController ()<WKScriptMessageHandler>

@end

@implementation GGWebViewController

-(void)setupView{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    @weakify(self);
    [RACObserve(self, url) subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD showMessage:@"请稍后" toView:self.view];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [self.retryView show];
    [MBProgressHUD hideHUDForView:self.view];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self.retryView dismiss];
    [MBProgressHUD hideHUDForView:self.view];
}

-(WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.selectionGranularity = WKSelectionGranularityCharacter;
        
//        config.userContentController = [[WKUserContentController alloc] init];
//        WKUserScript *script = [[WKUserScript alloc] initWithSource:@"function guangong(){};guangong.callConsultPhone = function(phone){window.webkit.messageHandlers.GuanErYeCall.postMessage({'phone': phone});}" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//        [config.userContentController addUserScript:script];
//        [config.userContentController addScriptMessageHandler:self name:@"GuanErYeCall"];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}

-(GGRetryView *)retryView{
    if (!_retryView) {
        _retryView = [[GGRetryView alloc] initRetryInView:self.view ico:@"info _button_retry" title:@"您的网络连接有问题，请轻触重试" size:17 offsetY:0];
    }
    return _retryView;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *path = [navigationAction.request.URL absoluteString];
    NSString *newPath = [path lowercaseString];
    
    if ([newPath hasPrefix:@"tel:"]) {
        UIWebView *callWebview = [[UIWebView alloc] initWithFrame:CGRectZero];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newPath]]];
        [self.view insertSubview:callWebview aboveSubview:webView];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    completionHandler(NSURLSessionAuthChallengeUseCredential,[[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust]);
}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
//    DLog(@"%@",[message.body valueForKey:@"phone"]);
}

@end
