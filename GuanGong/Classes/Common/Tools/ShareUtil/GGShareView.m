//
//  GGShareView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/15.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGShareView.h"
#import "GGVerticalUIButton.h"
#import "GGShareWechatUtil.h"

@interface GGShareView (){
    //  图片项
    NSMutableArray *iconList;
    //  文字项
    NSMutableArray *textList;
}

@end

//  每一项的宽度
static const CGFloat itemWidth = 60.0;

//  每一项的高度
static const CGFloat itemHeight = 60.0;

//  水平间隔
static const CGFloat itemHorPadding = 20.0;

//  垂直间隔
static const CGFloat itemVerPadding = 20.0;


//  每行显示数量
static const NSInteger numbersOfItemInLine = 3;

@implementation GGShareView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        [self configureData];
        [self initUI];
        
    }
    return self;
    
}

/**
 *  加载视图
 */
- (void)initUI{
    
    //  背景色黑色半透明
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    //  点击关闭
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(clickClose)];
    [self addGestureRecognizer:tap];
    

    
    self.userInteractionEnabled = YES;
    
    CGFloat startY = 0;
    CGFloat bgViewWidth = itemWidth * numbersOfItemInLine + itemHorPadding * (numbersOfItemInLine + 1) ;
    CGFloat bgViewHeight = itemHeight * 2 + itemVerPadding * 4;
    CGFloat bgViewX = (kScreenWidth - bgViewWidth) / 2;
    CGFloat bgViewY = (kScreenHeight - bgViewHeight) / 2;
    
    //  居中白色视图
    UIView *shareActionView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX,
                                                                       bgViewY,
                                                                       bgViewWidth,
                                                                       bgViewHeight)];

    shareActionView.layer.masksToBounds = YES;
    shareActionView.layer.cornerRadius = 2;
    shareActionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:shareActionView];
    
    for ( int i = 0; i < iconList.count; i ++ ) {
        
        GGVerticalUIButton *tempButton;
        UIImage *img = [UIImage imageNamed: iconList[i] ];
        
        int row = i / numbersOfItemInLine;
        
        int col = i % numbersOfItemInLine;
        
        CGFloat x =  (itemWidth + itemHorPadding) * col + itemHorPadding;
        
        CGFloat y = startY  + (itemHeight + itemVerPadding) * row + itemVerPadding;
        
        tempButton = [[GGVerticalUIButton alloc] initWithFrame:CGRectMake(x, y, itemWidth, itemHeight)];
        tempButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [tempButton setImage:img forState:UIControlStateNormal];
        [tempButton setTitle:textList[i] forState:UIControlStateNormal];
        [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tempButton addTarget:self action:@selector(clickActionButton:) forControlEvents:UIControlEventTouchUpInside];
        
        if([textList[i] isEqualToString:NSLocalizedString(@"微信好友", nil)]){
            
            tempButton.tag = SHARE_ITEM_WEIXIN_SESSION;
            
        }else if([textList[i] isEqualToString:NSLocalizedString(@"朋友圈", nil)]){
            
            tempButton.tag = SHARE_ITEM_WEIXIN_TIMELINE;
            
        }else if([textList[i] isEqualToString:NSLocalizedString(@"QQ", nil)]){
            
            tempButton.tag = SHARE_ITEM_QQ;
            
        }else if([textList[i] isEqualToString:NSLocalizedString(@"QQ空间", nil)]){
            
            tempButton.tag = SHARE_ITEM_QZONE;
            
        }else if([textList[i] isEqualToString:NSLocalizedString(@"微博", nil)]){
            
            tempButton.tag = SHARE_ITEM_WEIBO;
            
        }
        
        [shareActionView addSubview:tempButton];
    }
    
}


/**
 *  初始化数据
 */
- (void)configureData{
    
    /**
     *  判断应用是否安装，可用于是否显示
     *  QQ和Weibo分别有网页版登录与分享，微信目前不支持
     */
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    //    BOOL hadInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    //    BOOL hadInstalledWeibo = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibo://"]];
    
    iconList = [[NSMutableArray alloc] init];
    textList = [[NSMutableArray alloc] init];
    
    if(hadInstalledWeixin){
        
        [iconList addObject:@"icon_share_wechat"];
        [iconList addObject:@"icon_share_moment"];
        [textList addObject:NSLocalizedString(@"微信好友", nil)];
        [textList addObject:NSLocalizedString(@"朋友圈", nil)];
        
    }
    
}

- (void)clickActionButton:(GGVerticalUIButton *)sender{
    
    if ( sender.tag == SHARE_ITEM_WEIXIN_SESSION ) {
        
        [self shareToWeixinSession];
        
    }else if ( sender.tag == SHARE_ITEM_WEIXIN_TIMELINE ) {
        
        [self shareToWeixinTimeline];
        
    }else if ( sender.tag == SHARE_ITEM_QQ ) {
        
        [self shareToQQ];
        
    }else if ( sender.tag == SHARE_ITEM_QZONE ) {
        
        [self shareToQzone];
        
    }else if ( sender.tag == SHARE_ITEM_WEIBO ) {
        
        [self shareToWeibo];
        
    }
    
    [self clickClose];
    
}

- (void)shareToWeixinSession{
    
    GGShareWechatUtil *util = [GGShareWechatUtil sharedInstance];
    util.shareTitle = self.shareTitle;
    util.shareText = self.shareText;
    util.shareUrl = self.shareUrl;
    
    [util shareToWeixinSession];
    
}

- (void)shareToWeixinTimeline{
    
    GGShareWechatUtil *util = [GGShareWechatUtil sharedInstance];
    util.shareTitle = self.shareTitle;
    util.shareText = self.shareText;
    util.shareUrl = self.shareUrl;
    
    [util shareToWeixinTimeline];
    
}

- (void)shareToQQ{

}

- (void)shareToQzone{
}

- (void)shareToWeibo{
    
}

- (void)clickClose{
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 0.0;
    }];
    
    
}

@end
