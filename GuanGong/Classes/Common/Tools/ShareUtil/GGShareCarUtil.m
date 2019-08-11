//
//  GGShareCarUtil.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/25.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGShareCarUtil.h"
#import "WXApi.h"

@implementation GGShareCarUtil

+ (instancetype)sharedInstance{
    
    static GGShareCarUtil *util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[GGShareCarUtil alloc] init];
    });
    return util;
}

- (void)shareToWeixinSession:(UIImage *)image
{
    [self shareToWeixinBase:WXSceneSession andImage:image];
}

- (void)shareToWeixinTimeline:(UIImage *)image
{
    [self shareToWeixinBase:WXSceneTimeline andImage:image];
}

- (void)shareToWeixinBase:(enum WXScene)scene andImage:(UIImage *)image
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"关二爷";
    message.description = @"好车抢购";
    
    UIImage *thumbImage = [image imageByResizeToSize:CGSizeMake(192, 192) contentMode:UIViewContentModeScaleAspectFit];
    
    [message setThumbImage:thumbImage];

    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(image, 1);
    
    message.mediaObject = imageObject;
    message.mediaTagName = @"WECHAT_TAG_NEW_CAR";
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}

@end
