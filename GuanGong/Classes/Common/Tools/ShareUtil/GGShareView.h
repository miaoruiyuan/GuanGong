//
//  GGShareView.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/15.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

//  分享类型
typedef NS_ENUM(NSInteger, SHARE_ITEM){
    //  微信会话
    SHARE_ITEM_WEIXIN_SESSION,
    
    //  微信朋友圈
    SHARE_ITEM_WEIXIN_TIMELINE,
    
    //  QQ会话
    SHARE_ITEM_QQ,
    
    //  QQ空间
    SHARE_ITEM_QZONE,
    
    //  微博
    SHARE_ITEM_WEIBO
    
};


@interface GGShareView : UIView

//  分享标题
@property (nonatomic, strong) NSString *shareTitle;

//  分享文本
@property (nonatomic, strong) NSString *shareText;

//  分享链接
@property (nonatomic, strong) NSString *shareUrl;


@end
