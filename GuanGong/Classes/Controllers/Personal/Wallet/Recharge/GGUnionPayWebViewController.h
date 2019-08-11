//
//  GGUnionPayWebViewController.h
//  GuanGong
//
//  Created by CodingTom on 2017/7/21.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGBaseViewController.h"
#import "GGRetryView.h"
#import <WebKit/WebKit.h>

#import "GGUnionPayOpenModel.h"

@interface GGUnionPayWebViewController : GGBaseViewController<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>

- (instancetype)initWithUnionOpenModel:(GGUnionPayOpenModel *)model;

@end
