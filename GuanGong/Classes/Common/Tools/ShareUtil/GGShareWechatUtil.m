//
//  GGShareWechatUtil.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/15.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGShareWechatUtil.h"
#import "WXApi.h"

@implementation GGShareWechatUtil

- (void)shareToWeixinSession{
    
    [self shareToWeixinBase:WXSceneSession];
    
}

- (void)shareToWeixinTimeline{
    
    [self shareToWeixinBase:WXSceneTimeline];
    
}

- (void)shareToWeixinBase:(enum WXScene)scene{
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.shareTitle;
    message.description = self.shareText;
    [message setThumbImage:[UIImage imageNamed:@"ggLogo"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = self.shareUrl;
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
    
}


+ (instancetype)sharedInstance{
    
    static GGShareWechatUtil *util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        util = [[GGShareWechatUtil alloc] init];
        
    });
    return util;
    
}

- (instancetype)init{
    
    static id obj=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        obj = [super init];
        if (obj) {
            
        }
        
    });
    self=obj;
    return self;
}

@end
