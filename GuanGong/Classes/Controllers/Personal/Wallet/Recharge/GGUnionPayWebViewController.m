//
//  GGUnionPayWebViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/7/21.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGUnionPayWebViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface GGUnionPayWebViewController ()<WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)GGRetryView *retryView;
@property(nonatomic,copy) NSString *url;


@property(nonatomic,strong) GGUnionPayOpenModel *openModel;

@end

@implementation GGUnionPayWebViewController


- (instancetype)initWithUnionOpenModel:(GGUnionPayOpenModel *)model
{
    self = [super init];
    if (self) {
        _openModel = model;
        [GGUnionPayWebViewController progressWKContentViewCrash];
    }
    return self;
}

+ (void)progressWKContentViewCrash {
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)) {
        const char *className = @"WKContentView".UTF8String;
        Class WKContentViewClass = objc_getClass(className);
        SEL isSecureTextEntry = NSSelectorFromString(@"isSecureTextEntry");
        SEL secureTextEntry = NSSelectorFromString(@"secureTextEntry");
        BOOL addIsSecureTextEntry = class_replaceMethod(WKContentViewClass, isSecureTextEntry, (IMP)isSecureTextEntryIMP, "B@:");
        BOOL addSecureTextEntry = class_replaceMethod(WKContentViewClass, secureTextEntry, (IMP)secureTextEntryIMP, "B@:");
        if (!addIsSecureTextEntry || !addSecureTextEntry) {
//            NSLog(@"WKContentView-Crash->修复失败");
        }
    }
}

/**
 实现WKContentView对象isSecureTextEntry方法
 @return NO
 */
BOOL isSecureTextEntryIMP(id sender, SEL cmd) {
    return NO;
}

/**
 实现WKContentView对象secureTextEntry方法
 @return NO
 */
BOOL secureTextEntryIMP(id sender, SEL cmd) {
    return NO;
}


- (void)setupView
{
    self.navigationItem.title = @"添加银行卡";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self sendPostUnionPayRequest];
}

- (void)sendPostUnionPayRequest
{
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] init];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];

    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setValidatesDomainName:NO];
    httpManager.securityPolicy = securityPolicy;

    NSDictionary *dic = @{@"sign":self.openModel.sign,
                          @"NOTIFYURL":self.openModel.notifyurl,
                          @"returnurl":self.openModel.returnurl,
                          @"orig":self.openModel.orig};
    
    @weakify(self);
    
    [httpManager POST:self.openModel.unionUrl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        NSData *htmlData = responseObject;
        if ([htmlData isKindOfClass:[NSData class]]) {
            [self loadHTMLData:htmlData];
            NSString *result = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
            DLog(@"%@",result)
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    [MBProgressHUD showMessage:@"请稍后" toView:self.view];
}

- (void)loadHTMLData:(NSData *)htmlData
{
    NSURL *url = [NSURL URLWithString:self.openModel.unionUrl];
    NSString *baseURL = url.host;
    [self.webView loadData:htmlData MIMEType:@"text/html" characterEncodingName:@"utf-8" baseURL:[NSURL URLWithString:baseURL]];
//    [MBProgressHUD hideHUDForView:self.view];
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
        config.preferences = [[WKPreferences alloc]init];
        config.preferences.javaScriptEnabled = true;
        config.processPool = [[WKProcessPool alloc]init];
        
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
    if ([path hasPrefix:@"appfunc:khksCardList"]){
        decisionHandler(WKNavigationActionPolicyCancel);
        if (self.popHandler) {
            self.popHandler(nil);
        }
        [self pop];
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    completionHandler(NSURLSessionAuthChallengeUseCredential,[[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust]);
}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //    DLog(@"%@",[message.body valueForKey:@"phone"]);
}

@end
